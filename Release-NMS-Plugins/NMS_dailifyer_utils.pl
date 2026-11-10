# NMS: Dailifyer challenges - Carles Seregwyn <The Dailifyer> in the Bazaar (bazaar/Carles_Seregwyn.pl).
#
# Three solo challenges in a Non-Respawning instance:
# - Carles explains the rules on hail and opens the challenge window (zone/nms_dailifyer.cpp). Its
#   buttons reach his EVENT_SAY as "dailifyer-challenge <id>" / "dailifyer-plunder <id>", so every rule
#   is checked here, whichever way the request arrives.
# - Starting a challenge or plundering puts the zone's Non-Respawning lockout on the character for 23
#   hours. It is the very lockout the normal Non-Respawning entry sets for 14 hours (same expedition
#   name, event "Replay Timer"), so each one blocks the other and different zones never interfere.
# - A challenge is lost when the challenger leaves the zone (zone line, gate, death, camp, link death)
#   or anyone else enters it. Kills and loot keep working as in any Non-Respawning instance.
# - A completed challenge cannot be repeated but can be plundered: the final foe's reward lootdrops are
#   rolled on Carles with the server's own loot code (same chances and tier upgrades as a kill) and
#   handed over without entering the zone.

# Mirror DailifyerStatus in Release-NMS-Server/common/eq_packet_structs.h.
my $DAILIFYER_STATUS_AVAILABLE   = 0;
my $DAILIFYER_STATUS_COMPLETED   = 1;
my $DAILIFYER_STATUS_LOCKED_OUT  = 2;
my $DAILIFYER_STATUS_IN_PROGRESS = 3;

my $DAILIFYER_LOCKOUT_SECONDS = 23 * 60 * 60;		# a normal Non-Respawning entry locks for 14 hours
my $DAILIFYER_DZ_SECONDS      = 7 * 24 * 60 * 60;	# lifetime of a Non-Respawning instance (NMS_instance_utils.pl)
my $DAILIFYER_REPLAY_EVENT    = "Replay Timer";		# the lockout event AddReplayLockout sets

# State of a challenge instance, kept in the data bucket dailifyer-run-<instance id>.
my $RUN_PENDING   = "pending";		# created, the challenger has not entered yet
my $RUN_ACTIVE    = "active";
my $RUN_FAILED    = "failed";
my $RUN_COMPLETED = "completed";

#:: NPCs
my $KERAFYRM_NPC_ID             = 128089;	#:: #Kerafyrm (sleeper)
my $LORD_INQUISITOR_SERU_NPC_ID = 159691;	#:: #Lord_Inquisitor_Seru_ (sseru), the version that fights and carries the loot
my @PRAESERTUM_NPC_IDS          = (
	159112,		#:: #Praesertum_Rhugol
	159113,		#:: #Praesertum_Vantorus
	159114,		#:: #Praesertum_Matpa
	159115,		#:: #Praesertum_Bikun
);
my $ZEBUXORUK_NPC_ID            = 223238;	#:: Zebuxoruk_ The Forsaken (potimeb)
my $ZEBUXORUK_CAGE_NPC_ID       = 223214;	#:: Zebuxoruk's cage (potimeb), spawns Zebuxoruk_ when it dies

#:: Loot tables (custom manifest v26)
my $SERU_PRAESERTUM_REWARD_LOOTTABLE = 794331;	#:: Lord_Inquisitor_Seru_Praesertum_Reward: Fragments of Truth

my %DAILIFYER_CHALLENGES = (
	1 => {
		key		=> "sleeper",
		name		=> "Sleeper's Tomb",
		zone		=> "sleeper",
		# The challenge's own instance; the lockout below is the one Echo of the Past sets
		# (NMS_instance_utils.pl: "<zone long name> (Non-Respawning)").
		expedition	=> "Sleeper's Tomb (Dailifyer Challenge)",
		lockout		=> "The Sleeper's Tomb (Non-Respawning)",
		objective	=> "Slay Kerafyrm alone in a Non-Respawning Sleeper's Tomb, without leaving the zone. Once completed, plunder it instead to receive Kerafyrm's Prismatic Scales.",
		boss_npc_id	=> $KERAFYRM_NPC_ID,
		plunder_loottable => 794332,		#:: Dailifyer_Plunder_Kerafyrm
		plunder_items	=> [ 1801, 1802, 9600 .. 9612 ],	#:: Prismatic Scales of Kerafyrm
	},
	2 => {
		key		=> "sseru",
		name		=> "Sanctus Seru",
		zone		=> "sseru",
		expedition	=> "Sanctus Seru (Dailifyer Challenge)",
		lockout		=> "Sanctus Seru (Non-Respawning)",
		objective	=> "Slay Lord Inquisitor Seru while the Praesertums Rhugol, Vantorus, Matpa and Bikun still live, alone in a Non-Respawning Sanctus Seru. Once completed, plunder it for the Fragments of Truth and the Sword of Truth glamour.",
		boss_npc_id	=> $LORD_INQUISITOR_SERU_NPC_ID,
		requires_praesertums => 1,
		plunder_loottable => 794333,		#:: Dailifyer_Plunder_Lord_Inquisitor_Seru
		plunder_items	=> [ 9536 .. 9548 ],	#:: Fragments of Truth and 9546 Glamour - 'Sword of Truth'
	},
	3 => {
		key		=> "potimeb",
		name		=> "Plane of Time B",
		zone		=> "potimeb",
		# Same lockout as the portal in potimea/player.lua
		expedition	=> "Plane of Time B (Dailifyer Challenge)",
		lockout		=> "The Prison of the Forsaken",
		zonein		=> { x => 851, y => -141, z => 396.06, h => 0 },	# where the potimea portal lands
		objective	=> "Free and slay Zebuxoruk alone in a Non-Respawning Plane of Time B. Once completed, plunder it for the Splinters of Time, the Whip of the Forsaken One glamour and the Vortex of the Past.",
		boss_npc_id	=> $ZEBUXORUK_NPC_ID,
		# 223238 is also spawned by potimeb/phase_one_earth.lua when the Earth trial repeats: only a
		# Zebuxoruk_ released from the cage counts.
		gate_npc_id	=> $ZEBUXORUK_CAGE_NPC_ID,
		plunder_loottable => 794334,		#:: Dailifyer_Plunder_Zebuxoruk
		plunder_items	=> [
			17732, 17733, 17845, 17846, 17847, 18374 .. 18377, 18639, 19053, 24130,	#:: Splinters of Time
			17724,	#:: Glamour - 'Whip of the Forsaken One'
			19101,	#:: Vortex of the Past
		],
	},
);

# EVENT_SAY of the Dailifyer NPC.
sub DailifyerSay {
	my $client = plugin::val('$client');
	my $npc    = plugin::val('$npc');
	my $text   = plugin::val('$text');

	if (quest::get_rule("Custom:DailifyerEnabled") ne "true") {
		plugin::NPCTell("My ledger is closed for now. Come back another day.") if ($text =~ /hail/i);
		return;
	}

	if ($text =~ /^dailifyer-challenge (\d+)$/) {
		DailifyerStartChallenge($client, $npc, $1);
	} elsif ($text =~ /^dailifyer-plunder (\d+)$/) {
		DailifyerPlunder($client, $npc, $1);
	} elsif ($text =~ /^ready$/i) {
		DailifyerEnterChallenge($client);
	} elsif ($text =~ /hail/i) {
		DailifyerExplainRules($client);
		if (DailifyerCurrentChallenge($client)) {
			my $ready_link = quest::silent_saylink("ready");
			plugin::NPCTell("When you are [$ready_link], proceed into the portal.");
		}
		DailifyerSendWindow($client, $npc);
	} elsif ($text =~ /^challenges$/i) {
		DailifyerSendWindow($client, $npc);
	}
}

# The challenge whose expedition the player holds, or undef.
sub DailifyerCurrentChallenge {
	my $client = shift;
	my $dz     = $client->GetExpedition();
	return undef if (!$dz);

	foreach my $challenge (values %DAILIFYER_CHALLENGES) {
		return $challenge if ($dz->GetName() eq $challenge->{expedition});
	}

	return undef;
}

# Same offer as the Non-Respawning entry (NMS_instance_utils.pl): the move waits for the [ready] click,
# by when the new expedition is registered with the player (MovePCDynamicZone right after
# CreateExpedition finds no dynamic zone yet and moves nobody).
sub DailifyerOfferEntry {
	my $ready_link = quest::silent_saylink("ready");
	plugin::YellowText("The instance is [$ready_link].");
}

sub DailifyerEnterChallenge {
	my $client    = shift;
	my $challenge = DailifyerCurrentChallenge($client);
	return if (!$challenge);

	my $dz      = $client->GetExpedition();
	my $zone_id = $dz->GetZoneID();
	my $zonein  = $challenge->{zonein};

	# Without a zone-in, the zone's safe point, as NMS_instance_utils.pl does.
	my ($x, $y, $z, $heading) = $zonein ?
		($zonein->{x}, $zonein->{y}, $zonein->{z}, $zonein->{h}) :
		(
			quest::GetZoneSafeX($zone_id),
			quest::GetZoneSafeY($zone_id),
			quest::GetZoneSafeZ($zone_id),
			quest::GetZoneSafeHeading($zone_id)
		);

	$client->MovePCInstance($zone_id, $dz->GetInstanceID(), $x, $y, $z, $heading);
}

sub DailifyerExplainRules {
	my $client = shift;
	my $name   = $client->GetCleanName();
	my $ledger = quest::silent_saylink("challenges");

	plugin::NPCTell("Greetings, $name. Many claim to be heroes; few prove it alone. I keep a ledger of three challenges: the Sleeper's Tomb, Sanctus Seru and the Plane of Time.");
	plugin::YellowText("Each challenge takes you, alone, into a Non-Respawning version of its zone. You cannot bring a group or a raid, and nobody can join you.");
	plugin::YellowText("Sleeper's Tomb: slay Kerafyrm. Sanctus Seru: slay Lord Inquisitor Seru while the four Praesertums still live. Plane of Time B: free and slay Zebuxoruk.");
	plugin::YellowText("Leaving the zone for any reason (zoning, gating, dying, camping) or anyone else entering it voids the challenge. You can still hunt and loot there as usual.");
	plugin::YellowText("A completed challenge cannot be attempted again, but you may plunder it: I hand you the rewards of its final foe without you setting foot inside.");
	plugin::YellowText("Starting a challenge or plundering locks you out of that zone's Non-Respawning instance for 23 hours. A normal Non-Respawning lockout blocks both as well. Lockouts of different zones never interfere.");
	plugin::YellowText("Say [$ledger] to open the ledger again.");
}

sub DailifyerSendWindow {
	my ($client, $npc) = @_;
	my $dz = $client->GetExpedition();

	my @rows;
	foreach my $id (sort { $a <=> $b } keys %DAILIFYER_CHALLENGES) {
		my $challenge = $DAILIFYER_CHALLENGES{$id};
		my $completed = DailifyerIsCompleted($client, $challenge);
		my $lockout   = DailifyerLockoutSeconds($client, $challenge);

		my $status = $DAILIFYER_STATUS_AVAILABLE;
		if ($dz && $dz->GetName() eq $challenge->{expedition}) {
			$status = $DAILIFYER_STATUS_IN_PROGRESS;
		} elsif ($lockout > 0) {
			$status = $DAILIFYER_STATUS_LOCKED_OUT;
		} elsif ($completed) {
			$status = $DAILIFYER_STATUS_COMPLETED;
		}

		push @rows, {
			id		=> $id,
			name		=> $challenge->{name},
			objective	=> $challenge->{objective},
			status		=> $status,
			completed	=> $completed ? 1 : 0,
			lockout		=> $lockout,
		};
	}

	$client->SendDailifyerWindow($npc->GetID(), \@rows);
}

sub DailifyerStartChallenge {
	my ($client, $npc, $id) = @_;
	my $challenge = $DAILIFYER_CHALLENGES{$id};
	return if (!$challenge);

	# A challenge already under way: let the challenger back in (a corpse to recover, say). Having
	# left, the run already counts as lost.
	my $current_dz = $client->GetExpedition();
	if ($current_dz && $current_dz->GetName() eq $challenge->{expedition}) {
		DailifyerOfferEntry();
		return;
	}

	if (DailifyerIsCompleted($client, $challenge)) {
		plugin::NPCTell("You have already conquered the $challenge->{name}. You may plunder it instead.");
		return;
	}

	if (!DailifyerCheckLockout($client, $challenge)) {
		return;
	}

	if ($client->IsGrouped() || $client->IsRaidGrouped()) {
		plugin::NPCTell("A challenge is faced alone. Leave your group or raid first.");
		return;
	}

	if ($current_dz) {
		plugin::NPCTell("You are still bound to another expedition (" . $current_dz->GetName() . "). Leave it first.");
		return;
	}

	my %expedition_info = (
		expedition => { name => $challenge->{expedition}, min_players => 1, max_players => 1 },
		instance   => {
			zone     => $challenge->{zone},
			version  => (quest::get_rule("Custom:StaticInstanceVersion") || 255),
			duration => $DAILIFYER_DZ_SECONDS,
		},
		safereturn => {
			zone => plugin::val('$zonesn'),
			x    => $client->GetX(),
			y    => $client->GetY(),
			z    => $client->GetZ(),
			h    => $client->GetHeading(),
		},
	);
	$expedition_info{zonein} = $challenge->{zonein} if ($challenge->{zonein});

	# CreateExpedition explains its own refusals (lockouts, expedition already held, ...).
	my $dz = $client->CreateExpedition(\%expedition_info);
	return if (!$dz);

	$client->AddExpeditionLockout($challenge->{lockout}, $DAILIFYER_REPLAY_EVENT, $DAILIFYER_LOCKOUT_SECONDS);
	DailifyerSaveRun($dz->GetInstanceID(), {
		dz		=> $dz->GetID(),
		challenge	=> $id,
		character	=> $client->CharacterID(),
		state		=> $RUN_PENDING,
	}, $DAILIFYER_DZ_SECONDS);

	plugin::NPCTell("So be it. The $challenge->{name} awaits you. Do not leave it until the deed is done.");
	DailifyerOfferEntry();
}

sub DailifyerPlunder {
	my ($client, $npc, $id) = @_;
	my $challenge = $DAILIFYER_CHALLENGES{$id};
	return if (!$challenge);

	if (!DailifyerIsCompleted($client, $challenge)) {
		plugin::NPCTell("Only those who have completed the $challenge->{name} challenge may plunder it.");
		return;
	}

	if (!DailifyerCheckLockout($client, $challenge)) {
		return;
	}

	# The lockout first: nothing below can then be repeated before it expires.
	$client->AddExpeditionLockout($challenge->{lockout}, $DAILIFYER_REPLAY_EVENT, $DAILIFYER_LOCKOUT_SECONDS);

	# ReturnItem hands over the exact item: the roll already applied a kill's tier chances, and
	# SummonItem (Client::SummonApocItem) would raise every item at least one tier more.
	my @rewards = DailifyerRollPlunder($npc, $challenge);
	foreach my $item_id (@rewards) {
		$client->ReturnItem($item_id, 1);
	}

	if (@rewards) {
		my $links = join(", ", map { quest::varlink($_) } @rewards);
		plugin::NPCTell("The spoils of the $challenge->{name} are yours: $links.");
	} else {
		plugin::NPCTell("You search the $challenge->{name}, but fortune does not smile on you today.");
	}
}

# Rolls the challenge's plunder loot table on the Dailifyer NPC, the same code path as a kill (chances,
# droplimit and tier upgrades), and keeps only the reward items. Carles carries no loot of his own.
sub DailifyerRollPlunder {
	my ($npc, $challenge) = @_;
	my %allowed = map { $_ => 1 } @{$challenge->{plunder_items}};

	$npc->ClearItemList();
	$npc->AddLootTable($challenge->{plunder_loottable});

	my @rewards;
	foreach my $item_id ($npc->GetLootList()) {
		next if (!$allowed{plugin::GetBaseID($item_id)});
		push @rewards, ($item_id) x $npc->CountItem($item_id);
	}

	$npc->ClearItemList();
	return @rewards;
}

sub DailifyerIsCompleted {
	my ($client, $challenge) = @_;
	return $client->GetBucket("dailifyer-$challenge->{key}-completed") ? 1 : 0;
}

sub DailifyerLockoutSeconds {
	my ($client, $challenge) = @_;
	my $events = $client->GetExpeditionLockouts($challenge->{lockout});
	return ($events && $events->{$DAILIFYER_REPLAY_EVENT}) ? $events->{$DAILIFYER_REPLAY_EVENT} : 0;
}

# Tells the player when they are locked out of the challenge's zone and returns 0; 1 when free.
sub DailifyerCheckLockout {
	my ($client, $challenge) = @_;
	my $seconds = DailifyerLockoutSeconds($client, $challenge);
	return 1 if ($seconds <= 0);

	my ($hours, $minutes) = plugin::convert_seconds($seconds);
	plugin::NPCTell("You are still locked out of the Non-Respawning $challenge->{name} for $hours hours and $minutes minutes.");
	return 0;
}

sub DailifyerGetRun {
	my $instance_id = plugin::val('$instanceid');
	return () if (!$instance_id);

	my $data = quest::get_data("dailifyer-run-$instance_id");
	return () if (!$data);

	# Instance ids are reused: only trust the run inside the expedition that created it.
	my %run = plugin::DeserializeHash($data);
	my $dz  = quest::get_expedition();
	return () if (!$dz || $dz->GetID() != $run{dz});

	return %run;
}

sub DailifyerSaveRun {
	my ($instance_id, $run, $seconds) = @_;
	my $key = "dailifyer-run-$instance_id";

	$seconds = quest::get_data_remaining($key) if (!$seconds);
	quest::set_data($key, plugin::SerializeHash(%$run), $seconds > 0 ? $seconds : $DAILIFYER_DZ_SECONDS);
}

sub DailifyerFailRun {
	my ($run, $reason) = @_;
	my $instance_id = plugin::val('$instanceid');
	my $challenge   = $DAILIFYER_CHALLENGES{$run->{challenge}};

	$run->{state} = $RUN_FAILED;
	DailifyerSaveRun($instance_id, $run);

	my $entity_list = plugin::val('$entity_list');
	my $challenger  = $entity_list->GetClientByCharID($run->{character});
	plugin::RedText("Your $challenge->{name} challenge has failed: $reason. You may still hunt here as usual.", $challenger) if ($challenger);
}

# global_player.pl EVENT_ENTERZONE: the challenger's first entry starts the run; any other entry ends it.
sub DailifyerOnEnterZone {
	my $client = plugin::val('$client');
	my %run    = DailifyerGetRun();
	return if (!%run || ($run{state} ne $RUN_PENDING && $run{state} ne $RUN_ACTIVE));

	my $challenge = $DAILIFYER_CHALLENGES{$run{challenge}};

	if ($client->CharacterID() != $run{character}) {
		DailifyerFailRun(\%run, "someone else entered the zone");
		return;
	}

	if ($run{state} eq $RUN_ACTIVE) {
		DailifyerFailRun(\%run, "you left the zone");
		return;
	}

	$run{state} = $RUN_ACTIVE;
	DailifyerSaveRun(plugin::val('$instanceid'), \%run);
	plugin::YellowText("Your $challenge->{name} challenge has begun. $challenge->{objective}", $client);
}

# global_player.pl EVENT_ZONE and EVENT_DISCONNECT: the challenger leaving ends the run.
sub DailifyerOnLeaveZone {
	my $client = plugin::val('$client');
	my %run    = DailifyerGetRun();
	return if (!%run || $run{state} ne $RUN_ACTIVE || $client->CharacterID() != $run{character});

	DailifyerFailRun(\%run, "you left the zone");
}

# global_npc.pl EVENT_DEATH_COMPLETE: the final foe dying under the challenge's terms completes it.
sub DailifyerOnNPCDeath {
	my $npc = shift;
	my %run = DailifyerGetRun();
	return if (!%run || $run{state} ne $RUN_ACTIVE);

	my $challenge   = $DAILIFYER_CHALLENGES{$run{challenge}};
	my $npc_type_id = $npc->GetNPCTypeID();

	if ($challenge->{gate_npc_id} && $npc_type_id == $challenge->{gate_npc_id}) {
		$run{gate_open} = 1;
		DailifyerSaveRun(plugin::val('$instanceid'), \%run);
		return;
	}

	return if ($npc_type_id != $challenge->{boss_npc_id});
	return if ($challenge->{gate_npc_id} && !$run{gate_open});

	if ($challenge->{requires_praesertums} && !SeruPraesertumsAlive()) {
		DailifyerFailRun(\%run, "Lord Inquisitor Seru fell after a Praesertum");
		return;
	}

	my $entity_list = plugin::val('$entity_list');
	my $challenger  = $entity_list->GetClientByCharID($run{character});
	if (!$challenger) {
		DailifyerFailRun(\%run, "you were not in the zone");
		return;
	}

	$challenger->SetBucket("dailifyer-$challenge->{key}-completed", "1");
	$run{state} = $RUN_COMPLETED;
	DailifyerSaveRun(plugin::val('$instanceid'), \%run);

	plugin::YellowText("You have completed the $challenge->{name} challenge! From now on, the Dailifyer will let you plunder it.", $challenger);
}

# True while the four Praesertums of Sanctus Seru are alive in the current zone.
sub SeruPraesertumsAlive {
	my $entity_list = plugin::val('$entity_list');
	foreach my $npc_type_id (@PRAESERTUM_NPC_IDS) {
		return 0 if (!$entity_list->GetNPCByNPCTypeID($npc_type_id));
	}

	return 1;
}

# sseru/#Lord_Inquisitor_Seru_.pl EVENT_DEATH: the Fragments of Truth drop only while the four
# Praesertums live. EVENT_DEATH runs before the corpse is made, so the loot lands on it.
sub AddSeruPraesertumReward {
	my $npc = shift;
	return if (!SeruPraesertumsAlive());

	$npc->AddLootTable($SERU_PRAESERTUM_REWARD_LOOTTABLE);
}

1;
