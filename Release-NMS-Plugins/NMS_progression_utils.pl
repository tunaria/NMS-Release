# Breakpoints for original flagging system:
# Kunark: 2
# Velious: 3
# Luclin: 14
# Planes of Power: 19
# 'Fabled Classic'/Quarm-Kill: 20

#Some Constants
my $BERSERKER = 16;
my $BEASTLORD = 15;
my $IKSAR     = 128;
my $VAH_SHIR  = 130;
my $DRAKKIN   = 522;
my $GUKTAN    = 330;

my %atlas = (
#    'cabeast'        => 'RoK',
#    'cabwest'        => 'RoK',
    'burningwood'    => 'RoK',
    'dreadlands'     => 'RoK',
    'emeraldjungle'  => 'RoK',
#    'fieldofbone'    => 'RoK',
    'firiona'        => 'RoK',
    'overthere'      => 'RoK',
    'frontiermtns'   => 'RoK',
#    'lakeofillomen'  => 'RoK',
#    'swampofnohope'  => 'RoK',
    'timorous'       => 'RoK',
    'trakanon'       => 'RoK',
#    'warslikswood'   => 'RoK',
    'chardok'        => 'RoK',
    'citymist'       => 'RoK',
    'dalnir'         => 'RoK',
    'charasis'       => 'RoK',
    'kaesora'        => 'RoK',
    'karnor'         => 'RoK', # NMS: was missing, so it was open in every expansion
#    'kurn'           => 'RoK',
    'nurga'          => 'RoK',
    'droga'          => 'RoK',
    'sebilis'        => 'RoK',
    'skyfire'        => 'RoK',
    'veksar'         => 'RoK', # Out of Era
    'chardokb'       => 'RoK', # Out of Era
    'veeshan'        => 'RoK', # Out of Era
    'cobaltscar'     => 'SoV',
    'crystal'        => 'SoV',
    'necropolis'     => 'SoV',
    'eastwastes'     => 'SoV',
    'greatdivide'    => 'SoV',
    'iceclad'        => 'SoV',
    'kael'           => 'SoV',
    'sleeper'        => 'SoV',
    'growthplane'    => 'SoV',
    'sirens'         => 'SoV',
    'templeveeshan'  => 'SoV',
    'thurgadina'     => 'SoV',
    'thurgadinb'     => 'SoV',
    'frozenshadow'   => 'SoV',
    'wakening'       => 'SoV',
    'westwastes'     => 'SoV',
    'velketor'       => 'SoV',
    'skyshrine'      => 'SoV',
    'eastwastes'     => 'SoV',
    'stonebrunt'     => 'RoK',    
    'gunthak'        => 'RoK',
    'nadox'          => 'RoK',
    'dulak'          => 'RoK',
    'hatesfury'      => 'RoK',
    'torgiran'       => 'RoK',
    'mischiefplane'  => 'SoV',
    'grimling'       => 'SoL',
    'acrylia'        => 'SoL',
    'akheva'         => 'SoL',
    'dawnshroud'     => 'SoL',
    'echo'           => 'SoL',
    'fungusgrove'    => 'SoL',
    'griegsend'      => 'SoL',
#    'hollowshade'    => 'SoL',
    'netherbian'     => 'SoL',
#    'paludal'        => 'SoL',
    'sseru'          => 'SoL',
    'scarlet'        => 'SoL',
#    'shadeweaver'    => 'SoL',
    'shadowhaven'    => 'SoL',
#    'sharvahl'       => 'SoL',
    'ssratemple'     => 'SoL',
    'katta'          => 'SoL',
    'mseru'          => 'SoL',
    'letalis'        => 'SoL', # NMS: was missing, so it was open in every expansion
    'maiden'         => 'SoL', # NMS: was missing, so it was open in every expansion
    'thedeep'        => 'SoL',
    'thegrey'        => 'SoL',
    'tenebrous'      => 'SoL',
    'twilight'       => 'SoL',
    'umbral'         => 'SoL',
    'vexthal'        => 'SoL',
    'nexus'          => 'SoL',
    'jaggedpine'     => 'RoK',    
    'soldungc'       => 'PoP', # Out of Era
    'poknowledge'    => 'PoP',
    'potranquility'  => 'PoP',
    'ponightmare'    => 'PoP',
    'nightmareb'     => 'PoP',
    'podisease'      => 'PoP',
    'poinnovation'   => 'PoP',
    'pojustice'      => 'PoP',
    'postorms'       => 'PoP',
    'povalor'        => 'PoP',
    'potorment'      => 'PoP',
    'codecay'        => 'PoP',
    'hohonora'       => 'PoP',
    'hohonorb'       => 'PoP',
    'bothunder'      => 'PoP',
    'potactics'      => 'PoP',
    'solrotower'     => 'PoP',
    'pofire'         => 'PoP',
    'poair'          => 'PoP',
    'powater'        => 'PoP',
    'poeartha'       => 'PoP',
    'poearthb'       => 'PoP',
    'potimea'        => 'PoP',
    'potimeb'        => 'PoP',
    'powar'          => 'PoP', # NMS: was missing, so it was open in every expansion

    'barindu'        => 'GoD',
    'ferubi'         => 'GoD',
    'ikkinz'         => 'GoD',
    'kodtaz'         => 'GoD',
    'natimbi'        => 'GoD',
    'qinimi'         => 'GoD',
    'qvic'           => 'GoD',
    'riwwi'          => 'GoD',
    'snlair'         => 'GoD',
    'snpool'         => 'GoD',
    'snplant'        => 'GoD',
    'sncrematory'    => 'GoD',
    'tacvi'          => 'GoD',
    'tipt'           => 'GoD',
    'txevu'          => 'GoD',
    'uqua'           => 'GoD',
    'vxed'           => 'GoD',
    'yxtta'          => 'GoD',
    'nedaria'        => 'GoD',

    'anguish'        => 'OoW',
    'harbingers'     => 'OoW',
    'provinggrounds' => 'OoW',
    'causeway'       => 'OoW',
    'dranik'         => 'OoW',
    'draniksscar'    => 'OoW',
  'dranikcatacombsa' => 'OoW',
  'dranikcatacombsb' => 'OoW',
  'dranikcatacombsc' => 'OoW',
    'dranikhollowsa' => 'OoW',
    'dranikhollowsc' => 'OoW',
    'dranikhollowsd' => 'OoW',
    'draniksewersa'  => 'OoW',
    'draniksewersc'  => 'OoW',
    'draniksewersd'  => 'OoW',
    'riftseekers'    => 'OoW',
    'bloodfields'    => 'OoW',
    'wallofslaughter'=> 'OoW',

    'thenest'        => 'DoN',
    'delvea'         => 'DoN',
    'stillmoona'     => 'DoN',
    'stillmoonb'     => 'DoN',
    'broodlands'     => 'DoN',
    'thundercrest'   => 'DoN',
    'delveb'         => 'DoN',
);

# Global hash of valid stages
my @STAGES = qw(RoK SoV SoL PoP GoD OoW DoN FNagafen);
my %VALID_STAGES = map { $_ => 1 } @STAGES;

# Global hash of stage prerequisites
my %STAGE_PREREQUISITES = (
    'RoK' => ['Lord Nagafen', 'Lady Vox'],  
    'SoV' => ['Trakanon', 'Gorenaire', 'Severilous', 'Talendor'],
    'SoL' => ['Klandicar', 'Zlandicar', 'Wuoshi', 'Dozekar the Cursed', 'Kelorek`Dar'],
    'PoP' => ['Thought Horror Overfiend', 'The Insanity Crawler', 'Grieg Veneficus', 'Xerkizh the Creator', 'Emperor Ssraeshza'],
    'GoD' => ['Saryrn'],
    'OoW' => ['Disabled'],
    'DoN' => ['Disabled'],
    'FNagafen' => ['Quarm'],
    # ... and so on for each stage
);

foreach my $key (keys %STAGE_PREREQUISITES) {
    @{$STAGE_PREREQUISITES{$key}} = map { lc } @{$STAGE_PREREQUISITES{$key}};
}

# Normalize the objectives to lowercase for case-insensitive handling
foreach my $stage (keys %STAGE_PREREQUISITES) {
    next if $STAGE_PREREQUISITES{$stage}[0] eq 'Disabled';  # Skip normalization if stage is disabled
    @{$STAGE_PREREQUISITES{$stage}} = map { lc } @{$STAGE_PREREQUISITES{$stage}};
}

my %STAGE_DESCRIPTIONS = (
    'RoK' => "Ruins of Kunark",
    'SoV' => "Scars of Velious",
    'SoL' => "Shadows of Luclin",
    'PoP' => "Planes of Power",
    'GoD' => "Gates of Discord",
    'OoW' => "Omens of War",
    'DoN' => "Dragons of Norrath",
    'FNagafen' => "Fabled Nagafen's Lair",
);

# NMS: EQEmu expansion number of each stage, the numbering of zone.expansion and of rule
# Custom:MaxProgressionExpansion. FNagafen is not an expansion and stays out of it.
my %STAGE_EXPANSIONS = (
    'RoK' => 1,
    'SoV' => 2,
    'SoL' => 3,
    'PoP' => 4,
    'GoD' => 7,
    'OoW' => 8,
    'DoN' => 9,
);

# NMS: the server-wide expansion cap is a rule, so changing it needs no script edit
sub GetMaxProgressionExpansion {
    return int(quest::get_rule("Custom:MaxProgressionExpansion") || 0);
}

# NMS: name of the highest expansion players can reach, for player-facing text
sub GetMaxProgressionExpansionName {
    my $max_expansion = GetMaxProgressionExpansion();
    my @open_stages   = sort { $STAGE_EXPANSIONS{$b} <=> $STAGE_EXPANSIONS{$a} }
        grep { $STAGE_EXPANSIONS{$_} <= $max_expansion } keys %STAGE_EXPANSIONS;

    return @open_stages ? $STAGE_DESCRIPTIONS{$open_stages[0]} : "Classic";
}

# Convert to a direct lookup hash
our %DIRECT_LOOKUP;
foreach my $stage (keys %STAGE_PREREQUISITES) {
    foreach my $objective (@{$STAGE_PREREQUISITES{$stage}}) {
        $DIRECT_LOOKUP{$objective} = 1;
    }
}

sub list_unlock_progress {
    my $client = shift;
    foreach my $stage (keys %STAGE_DESCRIPTIONS) {
        if (is_stage_complete($client, $STAGE_DESCRIPTIONS{$stage})) {
            plugin::YellowText("You have unlocked access to $STAGE_DESCRIPTIONS{$stage}.");
        } else {
            plugin::YellowText("You have NOT unlocked access to $STAGE_DESCRIPTIONS{$stage}.");
        }
    }
}

sub list_stage_prereq {
    my ($client, $target_stage) = @_;

    if (exists $STAGE_PREREQUISITES{$target_stage}) {
        my $prereqs = $STAGE_PREREQUISITES{$target_stage};
        
        if ($prereqs && @$prereqs ne 'Disabled') {
            foreach my $objective (@$prereqs) {
                my $completed = GetSubflag($client, $target_stage, $objective) ? "Completed" : "Not Completed";
                $objective =~ s/\b(\w)/\U$1/g;
                plugin::YellowText("$objective: $completed");
            }
        }
    }
}

sub get_subflag_stage {
    my ($subflag_name) = @_;
    $subflag_name = lc($subflag_name);  # Normalize the subflag name

    foreach my $stage (keys %STAGE_PREREQUISITES) {
        if (grep { lc($_) eq $subflag_name } @{$STAGE_PREREQUISITES{$stage}}) {
            return $stage;  # Return the stage name if found
        }
    }
    return undef;  # Return undefined if the subflag name is not found in any stage
}

sub subflag_exists {
    my ($search_term) = @_;
    $search_term = lc($search_term);  # Normalize the search term
    return $DIRECT_LOOKUP{$search_term} // 0;  # Returns 1 if present, 0 otherwise
}

# Subroutine to find the next stage
sub get_next_stage {
    my ($current_stage) = @_;

    # Find the index of the current stage
    my ($index) = grep { $STAGES[$_] eq $current_stage } 0..$#STAGES;

    # If the current stage is not the last one, return the next stage
    if (defined $index && $index < $#STAGES) {
        return $STAGES[$index + 1];
    }

    # Return undefined if the current stage is the last one or not found
    return;
}

# Breakpoints for original flagging system:
# Kunark: 2
# Velious: 3
# Luclin: 14
# Planes of Power: 19
# 'Fabled Classic'/Quarm-Kill: 20

# The new data structure will be independent flag variables for each stage, ie AccountID-progress-flag-RoK
# This is stored as a serialized hash using plugin::SerializeHash and plugin::DeserializeHash
# set_subflag does all the heavy lifting of setting flags

sub GetSubflag {
    my ($client, $stage, $objective) = @_;
    $objective = lc($objective);  # Normalize the objective to lowercase

    my $progress_flag = GetProgressFlag($client, $stage);

    # Deserialize the flag into a hash
    my %original_flag = plugin::DeserializeHash($progress_flag);

    # Create a new hash with all keys normalized to lowercase
    my %normalized_flag;
    foreach my $key (keys %original_flag) {
        $normalized_flag{lc($key)} = $original_flag{$key};
    }

    # Return the value using the normalized objective key
    return $normalized_flag{$objective};
}

sub SetSubflag {
    my ($client, $stage, $objective, $value) = @_;
    $value //= 1;  # Default value is 1 if not otherwise defined
    $objective = lc($objective);  # Normalize the objective

    quest::debug($objective);

    # Check if the stage is valid
    return 0 unless exists $VALID_STAGES{$stage};

    quest::debug($objective);

    # Get the current progress flag using the new getter
    my $progress_flag = GetProgressFlag($client, $stage);

    # Deserialize the current account progress into a hash
    my %account_progress = plugin::DeserializeHash($progress_flag);

    # Update the progress for the specific objective
    $account_progress{$objective} = $value;

    # Set the updated flag using the new setter
    SetProgressFlag($client, $stage, plugin::SerializeHash(%account_progress));

    quest::debug("Check 3 : $stage - " . GetProgressFlag($client, $stage));

    if ($stage eq 'RoK') {
        plugin::BlueText("Your mind flashes with recollections of savage lands; dense jungles, desolate swamps, and fiery wastes.");
    }
    elsif ($stage eq 'SoV') {
        plugin::BlueText("You almost feel a chill in your bones as your mind fills with visions of endless ice plains, and fortresses filled with Giants and Dragons alike.");
    }
    elsif ($stage eq 'SoL') {
        plugin::BlueText("Your mind recoils at the eldritch horror; dark shadows whisper to you of rites and mysteries alike.");
    }
    elsif ($stage eq 'PoP') {
        plugin::BlueText("You sense a disturbance in the planes; a power grows near... again.");
    }
    elsif ($stage eq 'GoD') {
        plugin::BlueText("You remember an island lost to the mists, conquered and shattered, yet its people's will remains unbroken.");
    }
    elsif ($stage eq 'OoW') {
        plugin::BlueText("You recall the Overlord of the invasion, sitting in his throne as he surveys the worlds he regards as prey.");
    }
    elsif ($stage eq 'DoN') {
        plugin::BlueText("You recall the ancient dragons, and grow fearful at the prospect of them stirring once more.");
    }

    # Check if the objective value has changed
    if ((!exists $account_progress{$objective} || $account_progress{$objective} != $value)) {

        # Send messages only if there was a change
        plugin::YellowText("You have gained a progression flag!");
        plugin::BlueText("Your memories become more clear, you see the way forward drawing closer.");

        # Check if the stage is now complete
        if (is_stage_complete($client, $stage)) {       
            plugin::YellowText("You have completed a progression stage!");
            plugin::BlueText("Your memories gain sudden, sharp focus. You see the path forward.");

            if (plugin::IsSeasonal($client)) {
                quest::set_data($client->AccountID() . "-progression-title-$stage", 1);
            }
            
            # NMS: moved to GrantStageRewards so #progression grants the same rewards
            GrantStageRewards($client, $stage);

            UpdateCharMaxLevel($client);
            UpdateRaceClassLocks($client);
        }
    }

    return 1;
}

# Returns 1 if the client has completed all objectives needed to unlock the indicated stage
# Optional final parameter is used to inform player if they fail the check
# Example; is_stage_complete($client, 'SoL') == 1 indicates that the player has unlocked access to Luclin.
sub is_stage_complete {
    my ($client, $stage, $inform) = @_;
    $inform //= 0; # Set to 0 if not defined

    # Return false if the stage is not valid
    unless (exists $VALID_STAGES{$stage}) {
        quest::debug("ERROR: Invalid stage: $stage for " . $client->GetCleanName());
        return 0;
    }

    if (plugin::IsSeasonal($client) || plugin::MultiClassingEnabled()) {
        if (is_time_locked($stage)) {
            return 0;
        }
    }

    # Get the current progress flag using the new getter
    my $progress_flag = GetProgressFlag($client, $stage);

    # Deserialize and then convert keys to lowercase
    my %raw_objective_progress = plugin::DeserializeHash($progress_flag);
    my %objective_progress = map { lc($_) => $raw_objective_progress{$_} } keys %raw_objective_progress;

    # Check prerequisites
    foreach my $prerequisite (@{$STAGE_PREREQUISITES{$stage}}) {
        my $lc_prerequisite = lc($prerequisite);

        unless ($objective_progress{$lc_prerequisite}) {
            #quest::debug("Prerequisite not met: $lc_prerequisite");
            if ($inform) {
                $client->Message(263, "You are not yet ready to experience that memory.");
            }
            return 0;
        }
        #quest::debug("Prerequisite met: $lc_prerequisite");
    }

    # If all prerequisites are met
    #quest::debug("All prerequisites for stage $stage have been met");
    return 1;
}

# This one ignores time-lock
sub is_stage_complete_2 {
    my ($client, $stage, $inform) = @_;
    $inform //= 0; # Set to 0 if not defined

    # Return false if the stage is not valid
    unless (exists $VALID_STAGES{$stage}) {
        quest::debug("ERROR: Invalid stage: $stage for " . $client->GetCleanName());
        return 0;
    }

    # Get the current progress flag using the new getter
    my $progress_flag = GetProgressFlag($client, $stage);

    # Deserialize and then convert keys to lowercase
    my %raw_objective_progress = plugin::DeserializeHash($progress_flag);
    my %objective_progress = map { lc($_) => $raw_objective_progress{$_} } keys %raw_objective_progress;

    # Check prerequisites
    foreach my $prerequisite (@{$STAGE_PREREQUISITES{$stage}}) {
        my $lc_prerequisite = lc($prerequisite);

        unless ($objective_progress{$lc_prerequisite}) {
            quest::debug("Prerequisite not met: $lc_prerequisite");
            if ($inform) {
                $client->Message(263, "You are not yet ready to experience that memory.");
            }
            return 0;
        }
        quest::debug("Prerequisite met: $lc_prerequisite");
    }

    # If all prerequisites are met
    #quest::debug("All prerequisites for stage $stage have been met");
    return 1;
}

sub is_time_locked {
    # Return 1 if locked, 0 if unlocked
    my $stage = shift;
    my $client = plugin::val('client');

    # NMS: stages above rule Custom:MaxProgressionExpansion are locked; FNagafen stays locked
    if (plugin::IsNMS()) {
        return 1 unless exists $STAGE_EXPANSIONS{$stage};
        return $STAGE_EXPANSIONS{$stage} > GetMaxProgressionExpansion() ? 1 : 0;
    }

    if ($stage eq 'RoK') {       
        return 0;
    }

    if ($stage eq 'SoV') {
        return 0;
    }

    if ($stage eq 'SoL') {
        return 0;
    }

    if ($stage eq 'PoP') {
        return 0;
    }

    if ($stage eq 'FNagafen') {
        return 0;
    }

    if ($stage eq 'GoD') {
        return 1;
    }

    # .. etc

    return !(quest::get_data("season-$stage-unlocked"));

    return 1;
}

sub is_eligible_for_race {
    my $client = shift;
    my $race   = shift // $client->GetRace();

    # Iksar
    if ($race == $IKSAR && !is_stage_complete($client, 'RoK')) {
        return 0;
    }

    # Vah Shir
    if ($race == $VAH_SHIR && !is_stage_complete($client, 'SoL')) {
        return 0;
    }

    # Drakkin
    if ($race == $DRAKKIN) {
        return 0;
    }

    # Guktan
    if ($race == $GUKTAN) {
        return 0;
    }

    return 1;
}

sub is_eligible_for_class {
    my $client = shift;
    my $class  = shift // $client->GetClass();

    if ($class == $BEASTLORD && !is_stage_complete($client, 'PoP')) {
        return 0;
    }

    # Vah Shir
    if ($class == $BERSERKER && !is_stage_complete($client, 'SoL')) {
        return 0;
    }

    return 1;
}

sub is_eligible_for_zone {
    my ($client, $zone_name, $inform) = @_;
    $inform //= 0; # Set to 0 if not defined

    if ($client->GetGM()) {
        return 1;
    }

    # Check if the zone exists in the atlas
    if (exists $atlas{$zone_name}) {
        # Use is_stage_complete to check if the client has completed the required stage
        
        return is_stage_complete($client, $atlas{$zone_name}, $inform);
    } else {
        # If the zone is not in the atlas, assume it's accessible or handle as needed
        #quest::debug("ERROR: Zone $zone_name not found in Atlas");
        return 1;
    }
}

sub is_valid_stage {
    my $stage_name = shift;
    if (exists $VALID_STAGES{$stage_name}) {
        return 1;
    } else {
        quest::debug("ERROR: NON-VALID PROGRESSION STAGE WAS CHECKED!");
        return 0;
    }
}

# Returns the destination zone of a specified door
sub get_target_door_zone {
    my ($zonesn, $doorid, $version) = @_;
    my $return_value = "";

    my $dbh = plugin::LoadMysql();
    my $sth = $dbh->prepare('SELECT * FROM doors WHERE zone = ? AND doorid = ? AND version = ?');

    $sth->execute($zonesn, $doorid, $version);

    if (my $row = $sth->fetchrow_hashref()) {
       $return_value = $row->{dest_zone};
    }

    $sth->finish();
    $dbh->disconnect();

    return $return_value;
}

sub UpdateCharMaxLevel
{
    my $client = shift;
    my $update = 0;
    # NMS: start from the base cap, not the stored one, so going back to classic (#progression) lowers it
    my $CharMaxLevel = 51;

    if (plugin::IsNMS()) {
        $CharMaxLevel = 50;
    }

    if (plugin::IsSeasonal($client)) {
        $CharMaxLevel = 51;

        if (plugin::IsNMS()) {
            $CharMaxLevel = 50;
        }

        if (is_stage_complete($client, 'RoK') && !is_time_locked('RoK')) {
            $CharMaxLevel = 60;
        }
        if (is_stage_complete($client, 'PoP')&& !is_time_locked('PoP')) {
            $CharMaxLevel = 65;
        } 
        if (is_stage_complete($client, 'GoD')&& !is_time_locked('GoD')) {
            $CharMaxLevel = 70;
        } 
    } else {
        if (is_stage_complete($client, 'RoK')) {
            $CharMaxLevel = 60;
        }
        if (is_stage_complete($client, 'PoP')) {
            $CharMaxLevel = 65;
        } 
        if (is_stage_complete($client, 'GoD')) {
            $CharMaxLevel = 70;
        } 
    }

    my $old_max = $client->GetBucket("CharMaxLevel");
    if (($old_max || 0) != $CharMaxLevel) {
        $client->SetBucket("CharMaxLevel", $CharMaxLevel);        
        if (defined $old_max) {
            # NMS: tell the character whose cap changed, not whoever ran the event (#progression)
            plugin::YellowText("Your Level Cap has been set to $CharMaxLevel.", $client);
        }
    }
}

sub ConvertFlags {
    my $client = shift;
    
    # Old Flag Data
    $expansion = quest::get_data($client->AccountID() . "-kunark-flag") || 0;

    if ($expansion && !plugin::IsSeasonal($client)) {
        # Kunark
        if (!is_stage_complete($client, 'RoK')) {
            if ($expansion > 2 || quest::get_data($client->AccountID() . "nag")) {
                SetSubflag($client, 'RoK', 'Lord Nagafen', 1);
            }

            if ($expansion > 2 || quest::get_data($client->AccountID() . "vox")) {
                SetSubflag($client, 'RoK', 'Lady Vox', 1);
            }
        }
        
        # Velious
        if (!is_stage_complete($client, 'SoV')) {
            if ($expansion > 3 || quest::get_data($client->AccountID() . "trak")) {
                SetSubflag($client, 'SoV', 'Trakanon', 1);
            }

            if ($expansion > 3 || quest::get_data($client->AccountID() . "tal")) {
                SetSubflag($client, 'SoV', 'Talendor', 1);
            }

            if ($expansion > 3 || quest::get_data($client->AccountID() . "goren")) {
                SetSubflag($client, 'SoV', 'Gorenaire', 1);
            }

            if ($expansion > 3 || quest::get_data($client->AccountID() . "sev")) {
                SetSubflag($client, 'SoV', 'Severilous', 1);
            }
        }

        # Luclin
        if (!is_stage_complete($client, 'SoL')) {
            if ($expansion > 14 || quest::get_data($client->AccountID() . "sky")) {
                SetSubflag($client, 'SoL', 'Lord Yelinak', 1);
            }

            if ($expansion > 14 || quest::get_data($client->AccountID() . "sleepers")) {
                SetSubflag($client, 'SoL', 'Tukaarak the Warder', 1);
            }

            if ($expansion > 14 || quest::get_data($client->AccountID() . "sle")) {
                SetSubflag($client, 'SoL', 'Nanzata the Warder', 1);
            }

            if ($expansion > 14 || quest::get_data($client->AccountID() . "slee")) {
                SetSubflag($client, 'SoL', 'Ventani the Warder', 1);
            }

            if ($expansion > 14 || quest::get_data($client->AccountID() . "sleep")) {
                SetSubflag($client, 'SoL', 'Hraashna the Warder', 1);
            }

            if ($expansion > 14 || quest::get_data($client->AccountID() . "wuo")) {
                SetSubflag($client, 'SoL', 'Wuoshi', 1);
            }

            if ($expansion > 14 || quest::get_data($client->AccountID() . "kla")) {
                SetSubflag($client, 'SoL', 'Klandicar', 1);
            }

            if ($expansion > 14 || quest::get_data($client->AccountID() . "zla")) {
                SetSubflag($client, 'SoL', 'Zlandicar', 1);
            }
        }

        # Planes of Power
        if (!is_stage_complete($client, 'PoP')) {
            if ($expansion > 19 || quest::get_data($client->AccountID() . "deep")) {
                SetSubflag($client, 'PoP', 'Thought Horror Overfiend', 1);
            }

            if ($expansion > 19 || quest::get_data($client->AccountID() . "akh")) {
                SetSubflag($client, 'PoP', 'The Insanity Crawler', 1);
            }

            if ($expansion > 19 || quest::get_data($client->AccountID() . "griegs")) {
                SetSubflag($client, 'PoP', 'Grieg Veneficus', 1);
            }

            if ($expansion > 19 || quest::get_data($client->AccountID() . "ssraone")) {
                SetSubflag($client, 'PoP', 'Xerkizh the Creator', 1);
            }

            if ($expansion > 19 || quest::get_data($client->AccountID() . "ssratwo")) {
                SetSubflag($client, 'PoP', 'Emperor Ssraeshza', 1);
            }
        }

        # Gates of Discord
        if (!is_stage_complete($client, 'GoD')) {
            if ($expansion >= 20 || quest::get_data($client->AccountID() . "-saryrn-flag") || quest::get_data($client->AccountID() . "-quarm-kill")) {
                SetSubflag($client, 'GoD', 'Saryrn', 1);
            }
        }

        # Fabled Nagafen
        if (!is_stage_complete($client, 'FNagafen') && $expansion >= 20) {
            SetSubflag($client, 'FNagafen', 'Quarm', 1);
        }

        UpdateRaceClassLocks($client);
    }    
}

sub delete_all_flags {
    my $client = shift;

    # List all stages and their specific subflags used in ConvertFlags
    my %flags_to_delete = (
        "kunark-flag" => 1,
        "nag" => 1,
        "vox" => 1,
        "trak" => 1,
        "tal" => 1,
        "goren" => 1,
        "sev" => 1,
        "sky" => 1,
        "sleepers" => 1,
        "sle" => 1,
        "slee" => 1,
        "sleep" => 1,
        "wuo" => 1,
        "kla" => 1,
        "zla" => 1,
        "deep" => 1,
        "akh" => 1,
        "griegs" => 1,
        "ssraone" => 1,
        "ssratwo" => 1,
        "saryrn-flag" => 1,
        "quarm-kill" => 1
    );

    # Go through each flag and delete it
    foreach my $flag_suffix (keys %flags_to_delete) {
        my $key = $client->AccountID() . $flag_suffix;
        quest::delete_data($key);  # Assuming quest::delete_data is the correct method to remove data
    }
}


sub UpdateRaceClassLocks {
    my $client = shift;
    my $account_progression = quest::get_data($client->AccountID() . "-account-progression") || 0;

    if ($account_progression < 1 && is_stage_complete($client, 'RoK')) {
        quest::set_data($client->AccountID() . "-account-progression", 1);
    }

    if ($account_progression < 2 && is_stage_complete($client, 'SoV')) {
        quest::set_data($client->AccountID() . "-account-progression", 2);
    }

    if ($account_progression < 3 && is_stage_complete($client, 'SoL')) {
        quest::set_data($client->AccountID() . "-account-progression", 3);
    }

    if ($account_progression < 4 && is_stage_complete($client, 'PoP')) {
        quest::set_data($client->AccountID() . "-account-progression", 4);
    }

    if ($account_progression < 5 && is_stage_complete($client, 'GoD')) {
        quest::set_data($client->AccountID() . "-account-progression", 5);
    }

    if ($account_progression < 6 && is_stage_complete($client, 'OoW')) {
        quest::set_data($client->AccountID() . "-account-progression", 6);
    }

    if ($account_progression < 7 && is_stage_complete($client, 'DoN')) {
        quest::set_data($client->AccountID() . "-account-progression", 7);
    }
}

sub ValidProgInstance {
    my ($zoneid, $instanceid, $instanceversion) = @_;

    if ($instanceversion || $instanceid) {
        return 1;
    } else {
        return 0;
    }
}

sub handle_death {
    my ($npc, $x, $y, $z, $entity_list) = @_;

    if (plugin::MultiClassingEnabled()) {
        my $zoneid          = plugin::val('$zoneid');
        my $instanceid      = plugin::val('$instanceid');
        my $instanceversion = plugin::val('$instanceversion');

        if (!plugin::ValidProgInstance($zoneid, $instanceid, $instanceversion)) {
            return;
        }
    }

    my $npc_name = lc($npc->GetCleanName());

    quest::debug("CleanName: $npc_name");

    $npc_name =~ s/^[#\s]+|[#\s]+$//g;

    if (plugin::subflag_exists($npc_name)) {        
        my $flag_mob = quest::spawn2(26000, 0, 0, $x, $y, ($z + 10), 0); # Spawn a flag mob
        my $new_npc = $entity_list->GetNPCByID($flag_mob);       
        
        $new_npc->SetEntityVariable("Flag-Name", $npc_name);
        $new_npc->SetEntityVariable("Stage-Name", plugin::get_subflag_stage($npc_name));
    }    
}

sub handle_killed_merit {
    # No-Op this. All flagging handled through hail mob (Gross tbh)
}

sub GetProgressFlag {
    my $client    = shift || plugin::val('$client');
    my $stage     = shift;
    my $season_id = plugin::GetSeasonID();
    my $seasonal  = plugin::IsSeasonal($client);

    if ($seasonal && $season_id) {
        # Get the Serialized account flag
        my $account_flag = quest::get_data($client->AccountID() . "-season-$season_id-progress-flag-$stage");
        my $character_flag = $client->GetBucket("progress-flag-$stage");

        if (length($character_flag) > length($account_flag)) {  
            quest::debug("Adapting Character Seasonal flag.");
            $account_flag = $character_flag;
            quest::set_data($client->AccountID() . "-season-$season_id-progress-flag-$stage", $character_flag);           
        }


        return $account_flag;        
    } else {
        return quest::get_data($client->AccountID() . "-progress-flag-$stage");
    }
}

sub SetProgressFlag {
    my ($client, $stage, $flag_value) = @_;
    my $season_id = plugin::GetSeasonID();
    my $seasonal  = plugin::IsSeasonal($client);

    if ($seasonal && $season_id) {
        # Set the Serialized account flag for the current season
        quest::set_data($client->AccountID() . "-season-$season_id-progress-flag-$stage", $flag_value);

        my $regular_flag = quest::get_data($client->AccountID() . "-progress-flag-$stage");

        if (length($flag_value) > length ($regular_flag)) {
            # also set the regular flag
            quest::set_data($client->AccountID() . "-progress-flag-$stage", $flag_value);
        }
    } else {
        # Set the regular progress flag
        quest::set_data($client->AccountID() . "-progress-flag-$stage", $flag_value);
    }
}

# NMS: #progression GM command. Sets the account progression to an exact stage, up or down.

# NMS: expansion stages in unlock order. A progression level is how many of them are unlocked
# (0 = classic), the same number UpdateRaceClassLocks stores in the account-progression bucket.
my @EXPANSION_STAGES = qw(RoK SoV SoL PoP GoD OoW DoN);

# NMS: #progression arguments in the order the usage lists them, with the same expansion names
# as #map, and the progression level each one sets
my @PROGRESSION_ARGUMENTS = (
    [ 'classic' => 0 ],
    [ 'kunark'  => 1 ],
    [ 'rok'     => 1 ],
    [ 'velious' => 2 ],
    [ 'sov'     => 2 ],
    [ 'luclin'  => 3 ],
    [ 'sol'     => 3 ],
    [ 'power'   => 4 ],
    [ 'pop'     => 4 ],
    [ 'discord' => 5 ],
    [ 'god'     => 5 ],
    [ 'omens'   => 6 ],
    [ 'oow'     => 6 ],
);
my %PROGRESSION_LEVELS = map { $_->[0] => $_->[1] } @PROGRESSION_ARGUMENTS;

# NMS: explorer-path items each bazaar stage NPC collects, one account bucket "<item id>-flag" per item.
# Same ids as bazaar/A_Lost_Iksar.pl, Coldain_Messenger.pl, A_Knight_of_Luclin.pl and A_Planar_Projection.pl.
my %STAGE_EXPLORER_ITEMS = (
    'RoK' => [
        2028043, # item: Elemental Binder (Legendary)
        2010366, # item: Djarn's Amethyst Ring (Legendary)
        2010142, # item: Crown of the Froglok Kings (Legendary)
        2026997, # item: Scalp of the Ghoul Lord (Legendary)
    ],
    'SoV' => [
        2005772, # item: Mask of Secrets (Legendary)
        2003201, # item: Sebilite Scale Mask (Legendary)
        2001414, # item: Helot Skull Helm (Legendary)
        2004578, # item: Helm of Rile (Legendary)
    ],
    'SoL' => [
        2027200, # item: Stronghorn's Horn (Legendary)
        2004189, # item: Shackle of Auctoritias (Legendary)
        2025319, # item: Sword of Pain (Legendary)
        2024741, # item: Siren Hair Earring (Legendary)
    ],
    'PoP' => [
        2008121, # item: Burning Ring (Legendary)
        2028708, # item: Shadel Bandit Ring (Legendary)
        2026826, # item: Zekhas' Katar (Legendary)
        2061227, # item: Blade of Insanity (Legendary)
    ],
);

# NMS: keys GrantStageRewards puts on the keyring when a stage is completed
my $KEY_OF_VEESHAN     = 20884; # item: Key of Veeshan (Veeshan's Peak), granted by SoV
my $SCEPTER_OF_SHADOWS = 22198; # item: The Scepter of Shadows (Vex Thal), granted by PoP
my %STAGE_KEYS = (
    'SoV' => $KEY_OF_VEESHAN,
    'PoP' => $SCEPTER_OF_SHADOWS,
);

# NMS: zone flag the key quest sets together with the key, proof the character earned it
my %KEY_QUEST_ZONE_FLAGS = (
    $KEY_OF_VEESHAN => 108, # zone: veeshan, flagged by Emperor Ganak (trakanon)
);

# NMS: rewards for completing a stage, shared by SetSubflag and #progression
sub GrantStageRewards {
    my ($client, $stage) = @_;

    if ($stage eq 'RoK') {
        $client->UnlockWaypoint("dreadlands");
    }

    if ($stage eq 'SoV') {
        $client->KeyRingAdd($KEY_OF_VEESHAN);
        $client->UnlockWaypoint("iceclad");
    }

    if ($stage eq 'PoP') {
        $client->KeyRingAdd($SCEPTER_OF_SHADOWS);
    }
}

# NMS: highest stage the account has unlocked without gaps, as a progression level (0 = classic)
sub GetAccountProgressionLevel {
    my $client = shift;
    my $level  = 0;

    foreach my $stage (@EXPANSION_STAGES) {
        last unless is_stage_complete($client, $stage);
        $level++;
    }

    return $level;
}

# NMS: readable name of a progression level for the #progression messages
sub DescribeProgressionLevel {
    my $level = shift;

    return "Classic (no expansion unlocked)" if $level == 0;
    return $STAGE_DESCRIPTIONS{$EXPANSION_STAGES[$level - 1]};
}

# NMS: a progression level is locked when its highest stage is time-locked, which on NMS means
# above rule Custom:MaxProgressionExpansion. Setting it would leave that stage closed anyway.
sub IsProgressionLevelLocked {
    my $level = shift;

    return 0 if $level == 0;
    return is_time_locked($EXPANSION_STAGES[$level - 1]) ? 1 : 0;
}

# NMS: #progression usage with one saylink per argument the server allows; clicking one runs
# "#progression <argument>". Bracketed text would become a single saylink
# (Chat:AutoInjectSaylinksToClientMessage), so no brackets.
sub GetProgressionUsage {
    my @links = map { quest::saylink("#progression $_->[0]", 0, $_->[0]) }
        grep { !IsProgressionLevelLocked($_->[1]) } @PROGRESSION_ARGUMENTS;

    return "Usage: #progression " . join(" | ", @links)
        . " - Sets the account progression of your target (or yourself). Without an argument it shows the current one.";
}

# NMS: sets the account progression to exactly $level stages (0 = classic), raising or lowering it.
# Stages up to $level get every boss flag and their rewards; the stages above it are cleared.
# Returns 0 when the other characters of the account could not be updated.
sub SetAccountProgression {
    my ($client, $level) = @_;
    my $complete = 1;

    foreach my $index (0 .. $#EXPANSION_STAGES) {
        my $stage = $EXPANSION_STAGES[$index];

        if ($index < $level) {
            my %objectives = map { $_ => 1 } @{$STAGE_PREREQUISITES{$stage}};
            SetProgressFlag($client, $stage, plugin::SerializeHash(%objectives));
            GrantStageRewards($client, $stage);
        } elsif (!ClearStageProgress($client, $stage)) {
            $complete = 0;
        }
    }

    quest::set_data($client->AccountID() . "-account-progression", $level);
    UpdateCharMaxLevel($client);

    # NMS: the server reads CharMaxLevel only when the character zones in, so apply it now
    if (
        quest::get_rule("Character:PerCharacterQglobalMaxLevel") ne "true"
        && quest::get_rule("Character:PerCharacterBucketMaxLevel") eq "true"
    ) {
        $client->SetClientMaxLevel(int($client->GetBucket("CharMaxLevel")));
    }

    return $complete;
}

# NMS: forgets a stage for the whole account: boss flags, explorer items and the key it grants.
# Returns 0 when the other characters of the account could not be updated.
sub ClearStageProgress {
    my ($client, $stage) = @_;
    my $account_id = $client->AccountID();
    my $season_id  = plugin::GetSeasonID();

    # NMS: the same keys GetProgressFlag reads; it also adopts a seasonal character's own flag
    if (plugin::IsSeasonal($client) && $season_id) {
        quest::delete_data("$account_id-season-$season_id-progress-flag-$stage");
        $client->DeleteBucket("progress-flag-$stage");
    } else {
        quest::delete_data("$account_id-progress-flag-$stage");
    }

    foreach my $item_id (@{$STAGE_EXPLORER_ITEMS{$stage} || []}) {
        $client->DeleteAccountBucket("$item_id-flag");
    }

    return 1 unless exists $STAGE_KEYS{$stage};
    return RemoveAccountKey($client, $STAGE_KEYS{$stage});
}

# NMS: takes a key off the keyring of every character of the account. A character keeps it while it
# still holds the item (using the door would put it back) or has the zone flag of the key quest.
# Returns 0 when the other characters of the account could not be updated.
sub RemoveAccountKey {
    my ($client, $item_id) = @_;
    my $base_item_id  = plugin::GetBaseID($item_id);
    my $quest_zone_id = $KEY_QUEST_ZONE_FLAGS{$item_id} || 0;

    # NMS: check first: KeyRingRemove on a key that is not there erases end() and can crash the zone
    if (
        $client->KeyRingCheck($item_id)
        && !plugin::check_hasitem($client, $item_id)
        && !($quest_zone_id && $client->HasZoneFlag($quest_zone_id))
    ) {
        $client->KeyRingRemove($item_id);
    }

    # NMS: an account has at most one character online, so the others are offline and nothing holds
    # their keyring in memory. Same places as check_hasitem, matching any tier of the item.
    my $dbh = plugin::LoadMysqlServer();
    return 0 unless $dbh;

    my $sth = $dbh->prepare(
        'DELETE k FROM keyring k'
        . ' INNER JOIN character_data c ON c.id = k.char_id'
        . ' WHERE c.account_id = ? AND c.id <> ? AND k.item_id = ?'
        . ' AND NOT EXISTS (SELECT 1 FROM inventory i'
        . ' WHERE i.character_id = c.id AND i.item_id % 1000000 = ?)'
        . ' AND NOT EXISTS (SELECT 1 FROM sharedbank s'
        . ' WHERE s.account_id = c.account_id AND s.item_id % 1000000 = ?)'
        . ' AND NOT EXISTS (SELECT 1 FROM character_corpses cc'
        . ' INNER JOIN character_corpse_items ci ON ci.corpse_id = cc.id'
        . ' WHERE cc.charid = c.id AND ci.item_id % 1000000 = ?)'
        . ' AND NOT EXISTS (SELECT 1 FROM zone_flags z WHERE z.charID = c.id AND z.zoneID = ?)'
    );

    my $rows;
    if ($sth) {
        $rows = $sth->execute(
            $client->AccountID(),
            $client->CharacterID(),
            $item_id,
            $base_item_id,
            $base_item_id,
            $base_item_id,
            $quest_zone_id
        );
        $sth->finish();
    }

    $dbh->disconnect();

    return defined $rows ? 1 : 0;
}

# NMS: #progression [stage]. Acts on the targeted player, or on the GM when no player is targeted.
# global_player.pl checks GM mode and account status before calling it.
sub ProgressionCommand {
    my ($gm, $argument) = @_;
    my $target = $gm->GetTarget();
    $target = ($target && $target->IsClient()) ? $target->CastToClient() : $gm;

    $argument = lc($argument // '');
    $argument =~ s/^\s+|\s+$//g;

    my $name = $target->GetCleanName();

    if ($argument eq '') {
        my $current = DescribeProgressionLevel(GetAccountProgressionLevel($target));
        plugin::YellowText("Account progression of $name: $current.", $gm);
        plugin::YellowText(GetProgressionUsage(), $gm);
        return;
    }

    if (!exists $PROGRESSION_LEVELS{$argument}) {
        plugin::YellowText("Unknown progression '$argument'.", $gm);
        plugin::YellowText(GetProgressionUsage(), $gm);
        return;
    }

    my $level = $PROGRESSION_LEVELS{$argument};

    if (IsProgressionLevelLocked($level)) {
        plugin::YellowText(
            "'$argument' is locked on this server. The highest progression is " . GetMaxProgressionExpansionName() . ".",
            $gm
        );
        return;
    }

    my $complete    = SetAccountProgression($target, $level);
    my $description = DescribeProgressionLevel($level);

    plugin::YellowText("Account progression of $name set to $description.", $gm);

    if (!$complete) {
        plugin::YellowText("Could not reach the database: the other characters of the account keep their keys.", $gm);
    }

    if ($target->CharacterID() != $gm->CharacterID()) {
        plugin::YellowText("Your account progression has been set to $description.", $target);
    }
}