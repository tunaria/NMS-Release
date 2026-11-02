use List::Util 'min';
sub EVENT_SAY {
    if (plugin::CustomEventSayEntry()) {
        return;
    }
    
    if (plugin::MultiClassingEnabled() && $npc->GetClass() >= 20 && $npc->GetClass() <= 35) {
        my $classes = $client->GetClassesBitmask();
        my $player_class_id = $npc->GetClass() - 19;
        my $class_name = quest::getclassname($player_class_id);

        if ($text=~/hail/i) {
            my $select_string = quest::saylink("class_select", 1, "become a $class_name");
            my %class_greetings = (
                1 => "Ah, a courageous soul approaches. Are you here to embrace the discipline and strength required to [$select_string]?",
                2 => "Blessings upon you, child. The light guides you to me; is it your wish to [$select_string] and serve the divine?",
                3 => "Honor and valor shine from your eyes. Are you destined to [$select_string], a righteous defender of the light?",
                4 => "The winds whisper of a new guardian. Is your heart called to the wilds, to [$select_string], protector of nature?",
                5 => "A shadow looms near. Is it your fate to command the darkness and [$select_string]?",
                6 => "The essence of nature surrounds you. Are you ready to [$select_string], guardian of the balance?",
                7 => "Discipline and inner strength are your allies. Do you seek the path to [$select_string], master of martial arts?",
                8 => "A melody accompanies your steps. Do you feel the rhythm calling you to [$select_string], the voice of inspiration?",
                9 => "Cunning and silence are your markers. Are you prepared to [$select_string], master of stealth and treachery?",
                10 => "The spirits whisper of a new journey. Is it time for you to [$select_string], a conduit of the spirit world?",
                11 => "A chill of the grave precedes you. Will you embrace the dark arts and [$select_string]?",
                12 => "Arcane energies pulse around you. Is your destiny to [$select_string], master of the elements?",
                13 => "Creation's essence swirls around you. Are you called to [$select_string], summoner of the arcane?",
                14 => "Your presence bends reality. Are you ready to [$select_string], weaver of illusions and mind control?",
                15 => "The call of the wild strengthens. Will you heed the call and [$select_string], melding the power of beasts and combat?",
                16 => "Rage burns within your spirit. Do you wish to unleash this power and [$select_string], a warrior of frenzy?"
            );
            
            my $greeting = $class_greetings{$player_class_id} // "Greetings, traveler. Are you seeking guidance or knowledge?";
            # NMS: class limit from rule Custom:MaxPlayerClasses
            if (!($classes & plugin::GetClassBitmask($player_class_id)) && plugin::GetClassesCount($client) < plugin::GetMaxClasses()) {
                plugin::NPCTell($greeting);
            }
        }        

        if ($text eq "class_select") {
            my $class_name = quest::getclassname($npc->GetClass() - 19);
            my $confirm_link = quest::saylink("class_confirm", 1, "Are you ready to commit to the path of the $class_name?");

            my %class_specific_messages = (
                1 => "The path of the Warrior is arduous and demanding, requiring unwavering courage and strength. " . 
                    "Once chosen, this path is your destiny, only to be reversed at the whims of the gods. [" . $confirm_link . "]",
                2 => "Embracing the Cleric's way means dedicating your life to the divine, serving as a beacon of light and healing. " .
                    "This sacred commitment is binding, revered by the gods themselves. [" . $confirm_link . "]",
                3 => "The Paladin stands as a beacon of hope, blending the might of arms with the purity of faith. " .
                    "Are you prepared to defend the light and uphold justice, knowing such a choice is guided by the gods? [" . $confirm_link . "]",
                4 => "Rangers protect the balance of nature, a path filled with peril and beauty. " .
                    "If your heart is true to the wild, confirm your dedication to become one with nature and its guardians. [" . $confirm_link . "]",
                5 => "Shadow Knights wield the power of darkness and fear. " .
                    "This path is fraught with danger and moral ambiguity. Only the most resolute may walk it, and once chosen, it is rarely abandoned. [" . $confirm_link . "]",
                6 => "Druids are the guardians of nature, harmonizing the forces of life and growth. " .
                    "To walk this path is to become one with the earth itself. Are you ready to embrace this eternal bond? [" . $confirm_link . "]",
                7 => "The Monk's discipline is forged from inner strength and relentless training. " .
                    "Embrace this path with the understanding that it demands complete devotion, a devotion that is recognized by the gods. [" . $confirm_link . "]",
                8 => "Bards are the heart of any fellowship, weaving magic and music into powerful symphonies. " .
                    "If you feel the song within your soul, affirm your desire to live a life of melody and adventure. [" . $confirm_link . "]",
                9 => "Rogues thrive in the shadows, where cunning and agility are the keys to survival. " .
                    "Is your spirit attuned to the silent whispers of the dark? Confirm your path and step into the world unseen. [" . $confirm_link . "]",
                10 => "Shamans act as intermediaries between the physical and spirit worlds. " .
                    "If you are called to bridge these realms, affirm your commitment to the spiritual journey ahead. [" . $confirm_link . "]",
                11 => "Necromancers command the forces of death and decay. " .
                    "This dark path is not chosen lightly, for its course is irrevocable, shadowed by the oversight of the gods themselves. [" . $confirm_link . "]",
                12 => "Wizards master the arcane, wielding the raw forces of magic. " .
                    "If you seek to harness these elemental powers, confirm your resolve to tread a path fraught with danger and discovery. [" . $confirm_link . "]",
                13 => "Magicians shape reality, summoning creatures and objects from the ether. " .
                    "Are you prepared to command the very fabric of existence, knowing such power is watched closely by the divine? [" . $confirm_link . "]",
                14 => "Enchanters twist the minds and reality itself, with wisdom and subtlety. " .
                    "If you choose to weave the strands of fate, know that this path is as binding as the spells you will cast. [" . $confirm_link . "]",
                15 => "Beastlords bond with the spirits of animals, embodying their primal essence. " .
                    "This sacred pact with nature is eternal, guided by the spirits and overseen by the gods. Are you ready to accept this union? [" . $confirm_link . "]",
                16 => "Berserkers unleash their inner fury, a force of pure, unbridled power. " .
                    "This path of rage is relentless and all-consuming. Confirm if you are ready to embrace the storm within, under the gaze of the gods. [" . $confirm_link . "]"
            );

            my $class_message = $class_specific_messages{$player_class_id} // "The path before you is significant, a choice that once made, is not easily undone. The gods watch over your decision. " . $confirm_link;
            plugin::NPCTell($class_message);
        }

        if ($text eq "class_confirm") {
            # NMS: class limit from rule Custom:MaxPlayerClasses
            if (plugin::GetClassesCount($client) < plugin::GetMaxClasses()) {
                plugin::AddClass($player_class_id);
                plugin::NPCTell("Welcome, $class_name, and be known!");
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    plugin::CustomEventNPCDeathEntry($killer_id);

    if (defined($killed_corpse_id)) {
        my $corpse = $entity_list->GetCorpseByID($killed_corpse_id);
        if ($corpse) {        
            my %item_drops = (
                11703 => { #Box of Abu Kar 11703
                    'drop_chance' => 0.0001, # 1/1000% chance to drop
                    'min_level'   => 35, # Minimum level to drop from
                    'max_level'   => 99, # Maximum level to drop from
                },
                #2827 => { # Christmas Event
                #    'drop_chance' => 0.01,
                #    'min_level'   => 1, # Minimum level to drop from
                #    'max_level'   => 99, # Maximum level to drop from
                #},
                #56064 => { 
                #    'drop_chance' => 0.0005, # 5/1000% chance to drop
                #    'min_level'   => 1, # Minimum level to drop from
                #    'max_level'   => 99, # Maximum level to drop from
                #},
                #36013 => { 
                #    'drop_chance' => 0.0005, # 5/1000% chance to drop
                #    'min_level'   => 1, # Minimum level to drop from
                #    'max_level'   => 99, # Maximum level to drop from
                #}
                # ... more items and their attributes
            );

            for my $item_id (keys %item_drops) {
                if ($npc->GetLevel() >= $item_drops{$item_id}{'min_level'} && 
                    $npc->GetLevel() <= $item_drops{$item_id}{'max_level'}) {                    
                    if (rand() < $item_drops{$item_id}{'drop_chance'}) {
                        $corpse->AddItem($item_id, 1);
                        $corpse->SetDecayTimer(1500000);
                        quest::ding();
                    }
                }
            }
        }
    }
}

sub EVENT_AGGRO {
    if (plugin::IsNMS() && $instanceid) {
        my $expedition = quest::get_expedition();
        if ($expedition) {
            plugin::ScaleInstanceNPC($npc, $expedition->GetMemberCount());
        }
    }
}

sub EVENT_SIGNAL {
    if ($signal == 66666) {
        my $expedition = quest::get_expedition();
        if ($expedition) {
            plugin::ScaleInstanceNPC($npc, $expedition->GetMemberCount());
        }
    }
}

sub EVENT_ITEM {
    if (plugin::CustomEventHandinEntry()) {
        return 1;
    }
}

sub EVENT_SPAWN {
    if (plugin::CustomEventNPCSpawnEntry($npc)) {
        return;
    }

    
    if ($instanceversion > 0) {        
        if ($npc->GetName() =~ /Echo_of_the_Past/) {
            $npc->Depop(0);
        }
    }

    if (plugin::IsNMS() && $instanceid) {
        my $expedition = quest::get_expedition();
        if ($expedition) {
            plugin::ScaleInstanceNPC($npc, $expedition->GetMemberCount());
        }
    }
}

sub EVENT_DAMAGE_GIVEN 
{
    # Special aggro events for player pets; if they are not taunting then add their owner to any
    # mob that they attack's aggro list. If they are taunting, then give them some bonus aggro.
    if ($npc->IsPet() && $npc->GetOwner()->IsClient()) {
       
        if ($npc->IsTaunting()) {
            my $ent = $entity_list->GetMobByID($entity_id);
            if ($ent) {
                $ent->AddToHateList($npc->GetOwner())
            }
        } else {
            my $ent = $entity_list->GetMobByID($entity_id);
            if ($ent) {
                $ent->AddToHateList($npc, 100);
            }
        }
    }
}

sub EVENT_KILLED_MERIT {
    plugin::ProcessSlayerCredit($client, $npc, $entity_list);
}
