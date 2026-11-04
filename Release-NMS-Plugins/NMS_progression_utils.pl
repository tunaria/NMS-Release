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
            
            if ($stage eq 'RoK') {
                $client->UnlockWaypoint("dreadlands");
            }

            if ($stage eq 'SoV') {
                $client->KeyRingAdd(20884);
                $client->UnlockWaypoint("iceclad");
            }

            if ($stage eq 'PoP') {     
                $client->KeyRingAdd(22198);
            }

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
    my $CharMaxLevel = $client->GetBucket("CharMaxLevel") || 51;

    if (plugin::IsNMS()) {
        $CharMaxLevel = $client->GetBucket("CharMaxLevel") || 50;
    }

    if (plugin::IsSeasonal($client)) {
        $CharMaxLevel = 51;

        if (plugin::IsNMS()) {
            $CharMaxLevel = $client->GetBucket("CharMaxLevel") || 50;
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
            plugin::YellowText("Your Level Cap has been set to $CharMaxLevel.");
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