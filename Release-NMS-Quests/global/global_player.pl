# NMS: AccountStatus::GMAdmin, the account status #progression requires (the same as #map)
my $GM_ADMIN_STATUS = 100;

sub EVENT_SIGNAL {
    if ($signal == 666) {
        plugin::UpdateEoMAward($client);
        return;
    }

    if ($signal == 100) {
        # This needs to be refactored into a source method
        my $semaphore_title = $client->GetBucket('flag-semaphore');
        if ($semaphore_title) {
            plugin::AddTitleFlag($semaphore_title, $client);
            $client->DeleteBucket('flag-semaphore');
        }
        plugin::EnableTitles($client);
    } 
}

sub EVENT_ENTERZONE {
    # NMS: Fabled Season Synchronization. Automatically turns on/off 100% Fabled spawns based on rule.
    my $fabled_active = quest::get_rule("Custom:EnableFabledMobs") eq "true" ? 2 : 1;
    quest::spawn_condition($zonesn, $instanceid, 99, $fabled_active);

    my $default_size = $client->GetDefaultRaceSize();
    $client->ChangeSize($default_size);

	plugin::CommonCharacterUpdate($client);

	if (!plugin::is_eligible_for_zone($client, $zonesn)) {
		$client->Message(4, "Your vision blurs. You lose conciousness and wake up in a familiar place.");
		$client->MovePC(151, 185, -835, 4, 390); # Bazaar Safe Location.
    }

    if (!$client->IsTaskCompleted(3) && !$client->IsTaskActive(3)) {
        $client->AssignTask(3);
    } elsif ($client->IsTaskCompleted(3) && (!$client->IsTaskCompleted(4) && !$client->IsTaskActive(4))) {
        $client->AssignTask(4);
    }

    my $entity_list = plugin::val('$entity_list');
    my @npcs = $entity_list->GetNPCList();
    if (plugin::IsNMS() && $instanceid) {
        foreach my $npc (@npcs) {
            my $expedition = quest::get_expedition();
            if ($expedition) {
                plugin::ScaleInstanceNPC($npc, $expedition->GetMemberCount());
            }
        }
    }

    if (IsDayNightZone($zonesn)) {
        UpdateDayNightCycle($zonesn, $instanceid, $zonetime);
        quest::settimer("DayNightTimer", 30);
    }
}

sub EVENT_EXP_GAIN {
    plugin::CustomEventExpGainEntry();
}

sub EVENT_AA_EXP_GAIN {
    plugin::CustomEventAAExpGainEntry();
}

sub EVENT_EQUIP_ITEM_CLIENT {
    plugin::CustomEventItemEquipEntry();

    if ($slot_id == 21) {
        # Simple Ring of the Hero, for Tutorial Quest 2
        if ($client->IsTaskActivityActive(4, 0) && $item_id == 150000) {
            $client->UpdateTaskActivity(4, 0, 1);
            return;
        }
        if ($client->IsTaskActivityActive(4, 1) && $item_id == 1150000) {
            $client->UpdateTaskActivity(4, 01, 1);
            return;
        }
        if ($client->IsTaskActivityActive(4, 2) && $item_id == 2150000) {
            $client->UpdateTaskActivity(4, 2, 1);
            return;
        }
        if ($item_id == 2150000) {
            plugin::dispatch_popup("symp_tutorial");
        } {
            plugin::dispatch_popup("power_source");
        }
    }

    symp_proc_tutorial_helper($item_id, $client);
}

sub EVENT_UNEQUIP_ITEM_CLIENT {
    plugin::CustomEventItemUnequipEntry();
}

sub EVENT_DESTROY_ITEM_CLIENT {
    if ($item_id == 2827) {
        my $account_key 	= $client->AccountID() . "-ess-items-destroyed";
        quest::set_data($account_key, (quest::get_data($account_key) || 0) + 1);
    }

    plugin::CustomEventDestroyEntry($item, $quantity);
}

sub EVENT_CONNECT {
    if (plugin::GetSoulmark($client)) {
        plugin::DisplayWarning($client);
    }
   
    plugin::CommonCharacterUpdate($client);
    plugin::OnLoginUpdate($client);

    if (!$client->GetBucket("First-Login")) {
        $client->SetBucket("First-Login", 1);
		$client->SummonItemIntoInventory({ item_id => 18471, charges => -1 }); #A Faded Writ
        $client->Message(263, "You find a small note in your pocket.");
		$client->SetBucket('FirstLogin', 1);

        my $name = $client->GetCleanName();
        my $full_class_name = plugin::GetPrettyClassString($client);

        plugin::WorldAnnounce("$name ($full_class_name) has logged in for the first time.");        
        plugin::AwardSeasonalItems($client);
    }

    if (plugin::MultiClassingEnabled()) {
        if (!$client->IsTaskCompleted(3) && !$client->IsTaskActive(3)) {
            $client->AssignTask(3);
        } elsif ($client->IsTaskCompleted(3) && (!$client->IsTaskCompleted(4) && !$client->IsTaskActive(4))) {
            $client->AssignTask(4);
        }

        plugin::dispatch_popup("welcome");
    }

    if (!plugin::is_eligible_for_zone($client, $zonesn)) {
		$client->Message(4, "Your vision blurs. You lose conciousness and wake up in a familiar place.");
		$client->MovePC(151, 185, -835, 4, 390); # Bazaar Safe Location.
	}

}

sub EVENT_DISCONNECT {
    # Removes invulnerability effects when disconnecting from the server.
    $client->BuffFadeByEffect(40);
}

sub EVENT_POPUPRESPONSE {
    plugin::check_tutorial_popup_response($popupid, $client);  
       
    if ($popupid == 58240) {        
        my $x = $client->GetEntityVariable("bazaar_x") + int(rand(11)) - 5;
        my $y = $client->GetEntityVariable("bazaar_y") + int(rand(11)) - 5;
        my $z = $client->GetEntityVariable("bazaar_z");
        my $h = $client->GetEntityVariable("bazaar_h");
        my $bind_loc = $client->GetEntityVariable("bazaar_zone");

        $client->SetBucket("Return-X", $client->GetX());
        $client->SetBucket("Return-Y", $client->GetY());
        $client->SetBucket("Return-Z", $client->GetZ());
        $client->SetBucket("Return-H", $client->GetHeading());
        $client->SetBucket("Return-Zone", $zoneid);
        $client->SetBucket("Return-Instance", $instanceid);

        $client->SpellEffect(218,1);
        $client->MovePC($bind_loc, $x, $y, $z, rand(512));
    }
}

sub EVENT_TASK_COMPLETE {
    if ($task_id == 3 && !$client->IsTaskCompleted(4)) {
        $client->AssignTask(4);
    }
}

sub EVENT_LEVEL_UP {
    plugin::CommonCharacterUpdate($client);

    if ($client->GetGM()) {
        return;
    }
    
    my $new_level = $client->GetLevel();
    my $char_max_level = $client->GetBucket("CharMaxLevel");
    
    if ($new_level == $char_max_level) {
        my $name = $client->GetCleanName();
        my $full_class_name = plugin::GetPrettyClassString($client);

        plugin::WorldAnnounce("$name ($full_class_name) has reached Level $new_level.");
    }
}

sub EVENT_CLICKDOOR {
	my $target_zone = plugin::get_target_door_zone($zonesn, $doorid, $version);

    if (!plugin::is_eligible_for_zone($client, $target_zone, 1)) {		
		return 1;
    }
}

sub EVENT_WARP {
    my $name = $client->GetCleanName();
    my $current_x = $client->GetX();
    my $current_y = $client->GetY();
    my $current_z = $client->GetZ();
    my $distance = sqrt(($current_x - $from_x) ** 2 + ($current_y - $from_y) ** 2 + ($current_z - $from_z) ** 2);
    my $account_key = $client->AccountID() . "-WarpCount";
    my $soulmark = quest::get_data($client->AccountID() . "-CheaterFlag");

    my @warp_events = plugin::DeserializeList(quest::get_data($account_key));

    # Enqueue the current warp event with timestamp
    push @warp_events, time();

    # Clean up array elements older than 30 days
    my $thirty_days_in_seconds = 30 * 24 * 60 * 60;
    @warp_events = grep { time() - $_ <= $thirty_days_in_seconds } @warp_events;

    # Count recent warp events
    my $recent_warp_count = scalar(@warp_events);

    my $enforcement = 0;

    quest::set_data($account_key, plugin::SerializeList(@warp_events));

    if ($distance > 100 || $soulmark) {
        my $admin_message = "Large Warp Detected. Character: $name Zone: $zonesn From: $from_x, $from_y, $from_z To: $current_x, $current_y, $current_z Distance: $distance";

        if ($soulmark) {
            $admin_message .= "\nAccount has Soulmark. Reason: $soulmark";            
        }

        if ($recent_warp_count) {
            $admin_message .= "\nPrevious 30-day Warp Count: $recent_warp_count";
        }

        if ($soulmark && $recent_warp_count > 10) {
            $admin_message .= "\nHigh 30-day Warp Count. Enforcement Engaged.";
            $enforcement = 1;
        }

        # Send the admin message
        quest::discordsend("monitor", $admin_message);
        quest::debug($admin_message);

        if ($enforcement) {
            $client->WorldKick();
        }
    }
}

sub EVENT_ALT_CURRENCY_MERCHANT_BUY {

    if ($item_id == 24151) {
        $client->AddAlternateCurrencyValue(1, 10);
        $client->RemoveAlternateCurrencyValue($currency_id, $item_cost);
        $client->RemoveItem(24151);
        plugin::YellowText("You unpack the bundle of Delivery Vouchers");
        return 1;
    }
}

sub EVENT_DISCOVER_ITEM {
    my $name = $client->GetCleanName();
    
    # Only announce upgraded items
    if ($itemid >= 700000) {        
        plugin::WorldAnnounceItem("$name has discovered: {item}.",$itemid);  
    }  
}

sub symp_proc_tutorial_helper {
    my $item_id = shift;
    my $client = shift;

    if ($item_id) {
        #pre-computed list of symp proc item ID bases
        my @sym_clicks = (
            6307, 6309, 6313, 7305, 900012, 900014, 1113, 1117, 1156, 1173, 
            1904, 2404, 5203, 5214, 5730, 5764, 6017, 6020, 6024, 6036, 
            6310, 6315, 6323, 6324, 6332, 6335, 6343, 6350, 6359, 6382, 
            6383, 6402, 6404, 6408, 6616, 6626, 7036, 7318, 7372, 7405, 
            10333, 10383, 10404, 10994, 11028, 11906, 11973, 12375, 13168, 
            13380, 13400, 13500, 13743, 13744, 13815, 13987, 13988, 13991, 
            14338, 14746, 14762, 20627, 21798, 21863, 21885, 21886, 21892, 
            22819, 22890, 23498, 24745, 24779, 24789, 24793, 25566, 25577, 
            25980, 25998, 26000, 26001, 26009, 26553, 27280, 27717, 28812, 
            28813, 28814, 28815, 28817, 28908, 29248, 29430, 29442, 30511, 
            31210, 31212, 31373, 62269, 68444, 68744, 68775, 68837, 69044, 
            69047, 69049, 69051, 69054, 69055, 69095, 69112, 69113, 69116, 
            69155
        );

        my $item_root = ($item_id % 1000000);

        if (grep { $_ == $item_root } @sym_clicks) {
            plugin::dispatch_popup("symp_tutorial", $client);
        }
    }
}

sub EVENT_COMBINE_VALIDATE {
	if ($recipe_id == 10344) {
		if ($validate_type =~/check_zone/i) {
			if ($zone_id != 289 && $zone_id != 290) {
				return 1;
			}
		}
	}

    if ($recipe_id == 927863) {
        my $name = $client->GetCleanName();
        plugin::WorldAnnounceItem("$name has forged the {item} within the Crucible of the Elements! Hail the Prismatic Conquerer!", 2017730);
        plugin::AddTitleFlag(678, $client);
    }

    if ($recipe_id == 927864) {
        my $name = $client->GetCleanName();
        plugin::WorldAnnounceItem("$name has claimed the {item} from the grasp of history! Hail the Truthbearer!", 2017731);
        plugin::AddTitleFlag(679, $client);
    }
	
	return 0;
}

sub EVENT_COMBINE_SUCCESS {
    if ($recipe_id =~ /^1090[4-7]$/) {
        $client->Message(1,
            "The gem resonates with power as the shards placed within glow unlocking some of the stone's power. ".
            "You were successful in assembling most of the stone but there are four slots left to fill, ".
            "where could those four pieces be?"
        );
    }
    elsif ($recipe_id =~ /^10(903|346|334)$/) {
        my %reward = (
            melee  => {
                10903 => 67665,
                10346 => 67660,
                10334 => 67653
            },
            hybrid => {
                10903 => 67666,
                10346 => 67661,
                10334 => 67654
            },
            priest => {
                10903 => 67667,
                10346 => 67662,
                10334 => 67655
            },
            caster => {
                10903 => 67668,
                10346 => 67663,
                10334 => 67656
            }
        );
        my $type = plugin::ClassType($class);
        quest::summonfixeditem($reward{$type}{$recipe_id});
        quest::summonfixeditem(67704); # Item: Vaifan's Clockwork Gemcutter Tools
        $client->Message(1,"Success");
    }
}

our %SWAP_ITEM_MAP = (
    # Gauntlet and Hammer swaps
    11668 => 11669,
    11669 => 11668,
    
    # Epic swaps
    14383 => 800000,
    10099 => 800001,
    800000 => 14383,
    800001 => 10099,
);

our %CYCLE_ITEM_MAP = (
    2017731 => 2017734,
    2017734 => 2017735,
    2017735 => 2017815,
    2017815 => 2017816,
    2017816 => 2017817,
    2017817 => 2017818,
    2017818 => 2017731,
);

sub check_map {
    my ($spell_map_ref, $ret_item) = @_;
    my $playerClassBitmask = $client->GetClassesBitmask();
    foreach my $array_ref (@$spell_map_ref) {
         if ($playerClassBitmask & $array_ref->[0]) {
	     if (!$client->HasSpellScribed($array_ref->[2]) && !$client->HasDisciplineLearned($array_ref->[2])) {
	         push(@task_ids, $array_ref->[1]);
	     }
         }
    }
    if (scalar @task_ids > 0) {
        $client->TaskSelectorNoCooldown(@task_ids);
    } else {
        $client->SummonItem($ret_item);
	$client->Message(15, "You have already learned everything you can from this rune.");
    }
}

sub EVENT_ITEM_CLICK_CAST_CLIENT {
    if (plugin::CustomEventItemClickCastEntry()) {
        return;
    }

    if ($spell_id == 36878) {
        if (plugin::HasTitle($item_id)) {
            $client->Message(289, "You already have that title, and cannot claim it again.");
        } else {
            plugin::AddTitleFlag($item_id, $client);
        }
	}

    if ($spell_id == 1823 || $spell_id == 1824 || $spell_id == 26508) {
        plugin::transform_item($client, $item_id, $slot_id, \%SWAP_ITEM_MAP, 0);
    }
    
    if ($spell_id == 36874) {
        plugin::transform_item($client, $item_id, $slot_id, \%CYCLE_ITEM_MAP, 1);    	
    }

    if ($spell_id == 36936) {
        @task_ids = ();
	my @spell_map = ([128, 78, 4872],
			 [16384, 79, 4875],
			 [32768, 80, 5031],
			 [2, 81, 4882],
			 [32, 82, 4884],
			 [8192, 83, 4878],
			 [4096, 84, 4886],
			 [64, 85, 5019],
			 [1024, 86, 4889],
			 [4, 87, 4893],
			 [8, 88, 4897],
			 [256, 89, 5017],
			 [16, 90, 4903],
			 [512, 91, 4899],
			 [1, 92, 5015],
			 [2048, 93, 4906]);
        $ret_id = 59906;
        check_map(\@spell_map, $ret_id); 
    }
    elsif ($spell_id == 36937) {
        @task_ids = ();
	my @spell_map = ([128, 94, 4873],
			 [16384, 95, 4876],
			 [2, 96, 4881],
			 [32, 97, 4885],
			 [8192, 110, 4879],
			 [4096, 111, 4888],
			 [1024, 112, 4891],
			 [4, 113, 4895],
			 [8, 114, 4898],
			 [16, 115, 4904],
			 [512, 116, 4901],
			 [2048, 117, 4907]);
	$ret_id = 59975;
        check_map(\@spell_map, $ret_id);
    }
    elsif ($spell_id == 36938) {
        @task_ids = ();
	my @spell_map = ([128, 118, 4871],
			 [16384, 119, 4874],
			 [2, 120, 4880],
			 [32, 121, 4883],
			 [8192, 122, 4877],
			 [4096, 123, 4887],
			 [1024, 124, 4890],
			 [4, 125, 4894],
			 [8, 126, 4896],
			 [16, 127, 4902],
			 [512, 128, 4900],
			 [2048, 129, 4905]);
	$ret_id = 59974;
        check_map(\@spell_map, $ret_id);
    }
    elsif ($spell_id == 36939) {
        @task_ids = ();
	my @spell_map = ([128, 130, 4971],
			 [16384, 131, 4972],
			 [32768, 132, 5032],
			 [2, 133, 4973],
			 [32, 134, 4974],
			 [8192, 135, 4975],
			 [4096, 136, 4976],
			 [64, 137, 5020],
			 [1024, 138, 4978],
			 [4, 139, 4977],
			 [8, 140, 4980],
			 [256, 157, 5018],
			 [16, 141, 4982],
			 [512, 142, 4979],
			 [1, 155, 5016],
			 [2048, 156, 5018]);
	$ret_id = 59907;
        check_map(\@spell_map, $ret_id);
    }
}

sub EVENT_TASKACCEPTED {
    my @god_spell_tasks = (78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97,
	    		   110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125,
			   126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141,
			   142, 155, 156, 157);
    if (grep { $_ == $task_id } @god_spell_tasks) {
        $client->UpdateTaskActivity($task_id, 0, 1);
    }
}

sub EVENT_CAST_ON {
    # Define groups of mutually exclusive spells
    my %exclusive_groups = (
        'elemental_forms' => [
            2789, 2790, 2791, 2792, 2793, 2794, 2795, 2796, 2797, 2798, 2799, 2800,
            38329, 38330, 38331, 38333, 38334, 38335, 38336, 38337, 38338, 38340, 38341, 38342
        ],
        'pyromancy' => [8406, 8407, 8408],
        'cryomancy' => [11103, 11104, 11105]
    );
    
    foreach my $group_name (keys %exclusive_groups) {
        my $spell_group = $exclusive_groups{$group_name};
        
        if (grep { $_ == $spell_id } @$spell_group) {
            foreach my $id (@$spell_group) {
                next if $id == $spell_id; 
                $client->BuffFadeBySpellID($id);
            }
            last;
        }
    }

    if ($caster_id && $spell) {
        my @global_buffs = (43002, 43003, 43004, 43005, 43006, 43007, 43008, 17779, 36845, 36853, 36856, 36883, 36884);
        
        if (!(grep { $_ == $spell_id } @global_buffs) && 
            $caster_id == $client->GetID() && 
            $spell->GetBuffDuration() > 0) {
            
            plugin::dispatch_popup("self_buff", $client);
        }
    }
}

sub EVENT_CAST_BEGIN {
    if ($spell_id == 2931 && $zoneid != 159) {
        $client->Message(289, "This may only be used inside Sanctus Seru.");
        $client->InterruptSpell();
        return 1;
    }
}

sub EVENT_SAY {
    if ($client->GetGM()) {
        # NMS: #progression needs GM mode and GM Admin status. Returning 0 shows everyone else the
        # usual "Command not recognized", as for a command that does not exist.
        if ($text =~ /^#progression\b(.*)$/i) {
            return 0 if $client->Admin() < $GM_ADMIN_STATUS;
            plugin::ProgressionCommand($client, $1);
            return 1;
        }

        if ($text=~/#awardtitle\s*(.*)/i) {
            $client->Message(13, "Disregard the command not recognized error.");
            my $arguments = $1; # Captures everything after #awardtitle
            
            my $tar_client = $client->GetTarget();
            if ($tar_client && $tar_client->IsClient()) {
                $tar_client = $tar_client->CastToClient();
            } else {
                return;
            }

            # Validate that there is exactly one argument which is a number
            if ($arguments =~ /^\s*(\d+)\s*$/) {
                my $number = $1; # Captures the number
                # Proceed with awarding the title using $number
                    
                $client->Message(13, "Awarding TitleSet $number to " . $tar_client->GetName());
                plugin::AddTitleFlag($number, $tar_client->CastToClient());
                plugin::CommonCharacterUpdate($tar_client->CastToClient());
                $tar_client->Signal(1);
            } else {
                $client->Message(13, "Invalid input. Please provide a single numeric argument.");
            }
          } elsif ($text=~/#setbucket\s+(\S+)(?:\s+(\d))?/i) {
            my ($flag, $number) = ($1, $2 // 1);  # Default $number to 1 if not provided
            my $tar_client = $client->GetTarget();
            if ($tar_client && $tar_client->IsClient()) {
               $tar_client = $tar_client->CastToClient();
            } else {
                return;
            }
            if ($number >= 0 && $number <= 9) {
                my $client_name = $tar_client->GetCleanName();
                $tar_client->SetBucket("$flag", "$number");
                $tar_client->Message(4, "You completed a quest!");
                $client->Message(4, "Writing to acct ID=".$tar_client->AccountID());
                $client->Message(4, "Writing to char ID=".$tar_client->CharacterID());
                $client->Message(4, "'$flag' bucket set to '$number' for $client_name.");
            } else {
                $client->Message(13, "Invalid number. Please provide a number between 0 and 9.");
            }
        } elsif ($text=~/#setpopflag\s+(\S+)(?:\s+(\d))?/i) {
            my ($flag, $number) = ($1, $2 // 1);  # Default $number to 1 if not provided

            my $tar_client = $client->GetTarget();
            if ($tar_client && $tar_client->IsClient()) {
                $tar_client = $tar_client->CastToClient();
            } else {
                return;
            }

            if ($number >= 0 && $number <= 9) {
                my $client_name = $tar_client->GetCleanName();
                $tar_client->SetAccountBucket("pop.flags.$flag", "$number");
                $tar_client->Message(4, "You receive a character flag!");
                $client->Message(4, "'$flag' flag set to '$number' for $client_name.");
            } else {
                $client->Message(13, "Invalid number. Please provide a number between 0 and 9.");
            }
        } elsif ($text=~/#resetpopflags/i) {
            my $tar_client = $client->GetTarget();
            if ($tar_client && $tar_client->IsClient()) {
                $tar_client = $tar_client->CastToClient();
            } else {
                return;
            }

            my @zoneflags = POPZoneFlags();
            foreach my $zoneflag (@zoneflags) {
                $tar_client->ClearZoneFlag($zoneflag);
            }
    
            my $client_name = $tar_client->GetCleanName();
            $tar_client->DeleteAccountBucket("pop");
            $tar_client->Message(4, "Your Planes of Power flags have been reset.");
            $client->Message(4, "Planes of Power flags reset for $client_name.");
        } elsif ($text=~/#pop/i) {
            my @flags = POPFlags();
            my $tar_client = $client->GetTarget() ? $client->GetTarget() : $client;
	    my $client_name = $tar_client->GetCleanName();
            if ($tar_client && $tar_client->IsClient()) {
                $tar_client = $tar_client->CastToClient();
            } else {
                return;
            }
            quest::message(315, "Target's Planes of Power flags are as follows:");

            foreach my $flag (sort {$a cmp $b} @flags) {
                my $current_value = $tar_client->GetAccountBucket("pop.flags.$flag");
                if ($current_value eq "") {
                    $current_value = 0;
                    #resetpopf
                }

                $flag =~ s/pop\.flags\.//ig;

                quest::message(315, "Flag: $flag Current: $current_value");
            }
        }
    }
}


sub POPFlags {
	my @flags = (
		"aerin",
		"adler",
		"agnarr",
		"arbitor",
		"arlyxir",
		"askr",
		"behemoth",
		"bertox",
		"codecay",
		"coirnav",
		"construct",
		"dresolik",
		"elder",
		"faye",
		"fennin",
		"garn",
		"grummus",
		"hedge",
		"jiva",
		"karana",
		"librarian",
		"maelin",
		"marr",
		"mavuin",
		"newleaf",
		"poxbourne",
		"rallos",
		"rathe",
		"saryrn",
		"shadyglade",
		"story",
		"tallon",
		"terris",
	 	"tribunal",
		"trell",
		"vallon",
	  	"valor",
		"xanamech"
	);

 	return @flags;
}

sub POPZoneFlags {
    my @zoneflags = (
        200,
        207,
        208,
        209,
        210,
        211,
        212,
        214,
        215,
        216,
        217,
        218,
        219,
        220,
        221,
        222,
        223
    );

    return @zoneflags;
}

sub EVENT_TIMER {
    if ($timer eq "DayNightTimer") {
        UpdateDayNightCycle($zonesn, $instanceid, $zonetime);
    }
}

sub IsDayNightZone {
    my $zone = shift;
    return ($zone eq 'commons' || $zone eq 'everfrost' || $zone eq 'kithicor' || 
            $zone eq 'lakerathe' || $zone eq 'lfaydark' || $zone eq 'northkarana' || 
            $zone eq 'qey2hh1' || $zone eq 'rathemtn' || $zone eq 'highpass' || 
            $zone eq 'southkarana' || $zone eq 'eastwastes' || $zone eq 'burningwood' || 
            $zone eq 'oggok');
}

sub UpdateDayNightCycle {
    my ($zone, $instance, $time) = @_;
    if ($zone eq 'commons' || $zone eq 'everfrost' || $zone eq 'kithicor' || 
        $zone eq 'lakerathe' || $zone eq 'lfaydark' || $zone eq 'northkarana' || 
        $zone eq 'qey2hh1' || $zone eq 'rathemtn' || $zone eq 'highpass' || 
        $zone eq 'southkarana' || $zone eq 'eastwastes')
    {
        if ($time < 600 || $time > 1999) {
            quest::spawn_condition($zone, $instance, 2, 0);
            quest::spawn_condition($zone, $instance, 1, 1);
        } else {
            quest::spawn_condition($zone, $instance, 2, 1);
            quest::spawn_condition($zone, $instance, 1, 0);
        }
    }
    elsif ($zone eq 'burningwood')
    {
        if ($time < 100 || $time > 1299) {
            quest::spawn_condition($zone, $instance, 2, 0);
        } else {
            quest::spawn_condition($zone, $instance, 2, 1);
        }
    }
    elsif ($zone eq 'oggok')
    {
        if ($time < 800 || $time > 1199) {
            quest::spawn_condition($zone, $instance, 2, 0);
            quest::spawn_condition($zone, $instance, 1, 1);
        } else {
            quest::spawn_condition($zone, $instance, 2, 1);
            quest::spawn_condition($zone, $instance, 1, 0);
        }
    }
}
