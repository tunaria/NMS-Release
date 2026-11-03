# Library for spawning tutorial popups
# popups have an ID which is 628<three digit ID>0
# popup button IDs use the least significant digit of the ID as 0 for default button (popup_id in Popup2 definition) and 9 is for negative_id
# three hashes define them. %popups is friendly name to ID, %popups_text is ID => text, %popups_title is ID=>title

sub GetMaxExpansionName {
    return "Kunark";
}

my $color_end = "</font>";
my $color_legendary = "<font color='#FF8000'>";
my $color_enchanted = "<font color='#007BFF'>";
my $color_normal = "<font color='#00FF00'>";
my $color_object = "<font color='#FFFF00'>";

my %popups = (
    "power_source" => 6280010,
    "welcome" => 6280020,
    "self_buff" => 6280030,
    "symp_tutorial" => 6280040,
);

my %popups_title = (
    6280010 => "Power Source Tutorial",
    6280020 => "Welcome to New Multiclass Server",
    6280030 => "Suspended Buffs Tutorial",
    6280040 => "Sympathetic Strike Tutorial",
);

my %popups_text = (
    6280010 => "You've equipped an item in your Power Source slot! It won’t grant stat bonuses while equipped there, but it will gain power as you earn experience. "
               ."With enough experience, it will upgrade to $color_enchanted Enchanted$color_end quality, and later to $color_legendary Legendary$color_end.<br><br>"
               ."The first time you gain experience with the item equipped, it will become $color_object NO DROP$color_end, even if it isn’t $color_object ATTUNABLE$color_end. "
               
               ."<br><br>Upgrade speed depends on the $color_object Tier$color_end ($color_normal"."Normal$color_end or $color_enchanted Enchanted$color_end), "
               ."the item, your $color_object Level$color_end, the $color_object Con Color$color_end of the kill, and the total $color_object Stats$color_end of the item. "
               ."Upgrading a $color_normal Normal$color_end item to $color_enchanted Enchanted$color_end will be <b>MUCH</b> faster than upgrading to $color_legendary Legendary$color_end. It is recommended to not try "
               ."to max out a slot until you are sure you are going to use that for a long time.<br><br>"
               ."You may also use your $color_object Consume Item$color_end AA Ability to speed up this process by consuming identical items to accelerate its growth. "
               ."Once an item has gained any experience, it can no longer be consumed!<br><br>"
               ."You may freely remove or exchange items from the Power Source slot without losing any progress.",
    
    6280020 => "Welcome to $color_legendary New Multiclass Server$color_end.<br><br>"
               ."You've arrived on the best $color_object Multiclass$color_end, $color_object Solo/Duo$color_end,  $color_object Single-Box$color_end, $color_object Progression$color_end EQEmu server in the world.<br><br>"
               ."$color_normal Features & Information" . $color_end . "<br>"
               ."* $color_object Multiclassing$color_end - Choose up to {max_classes} classes, and gain access to all of the skills, abilities, spells, equipment, and alternate advancement of those classes.<br>"
               ."* $color_object Solo/Duo$color_end - 'Group' content is fully soloable by any class combo. 'Raid' content may need a friend or two, but well-optimized and skilled players will be able to solo.<br>"
               ."* $color_object Single-Box$color_end - Multi-Boxing is NOT allowed on this server, nor is usage of ANY third-party software, such as MQ2. The character limit per IP is not enforced in $color_normal The Bazaar$color_end"
               .", our hub zone, so you may run traders and buyers if you desire!<br>"
               ."* $color_object Alternate Advancement$color_end - All classes start with selected class-defining AAs. Most other abilities, including out of era through TBS, available at level 51.<br>"
               ."* $color_object Tiered Items$color_end - Items can be found in three qualities; $color_normal Normal$color_end, $color_enchanted Enchanted$color_end, and$color_legendary Legendary$color_end with increasing rarity in drops. "
               ."You can also upgrade your items over time by equipping them in your $color_normal Power Source$color_end slot.<br>"
               ."* $color_object Progression$color_end - Progression by expansion is unlocked per-account, rather than per-character. Right now, the maximum available expansion is " . GetMaxExpansionName() . ".<br>"
               ."* $color_object Fast Travel$color_end - $color_normal Magus Tearel$color_end in $color_normal The Bazaar$color_end can use his Magic Map to transport you to various locations. You start with a number of common locations unlocked, "
               ."and you can unlock more by visiting $color_normal Rune Circles$color_end scattered throughout the world.<br>"
               ."* $color_object Large Bags$color_end - Bags greater than size 10 are available, Find $color_enchanted Enchanted$color_end or $color_legendary Legendary$color_end from mobs!<br>"
               ."* $color_object Multi-Pet$color_end - Class combinations with more than one pet class can have more than one pet! You can have one per per class (including charm pets). Switch between them by targeting them! <br>",

    6280030 => "You have cast a buff on yourself!$color_legendary New Multiclass Server$color_end has special mechanics to improve quality-of-life around buffs! <br><br>"
               ."$color_object Self Buffs$color_end - Any buffs which you cast on yourself, or your pet,$color_normal from a memorized spell$color_end will never naturally expire. The timer will count down one tick, and then reset. "
               ."These buffs are generally permanent, though they can still be dispelled.<br><br>"
               ."$color_object Group Buffs$color_end - When you buff a group member (or are buffed by them), these buffs will also never naturally expire for as long as you remain both grouped and in the same zone. This also applies to buffs toward "
               ."pets.<br><br>"
               ."$color_object Clicky Buffs$color_end - Clicky buffs are a special category. These will be 'suspended' like other buffs only for as long as the caster has the item which has that spell equipped, or the caster otherwise has it in "
               ."their spellbook.<br><br>"
               ."$color_object Bard Songs$color_end - Bard Songs are also a little bit different on NMS! Beneficial songs will automatically repeat, without twisting, for as long as they remain memorized. Instrument bonuses are applied whenever "
               ."the next pulse occurs. Detrimental songs must be used as normal. /melody does work, but has some awkward interactions with normal spells.<br><br>"
               ."$color_object AA Abilities$color_end - Many AA Abilities which have recast times shorter than their durations will also never expire naturally.<br><br>"
               ."$color_object Short-Duration Buffs$color_end - Several buffs and AA abilities have been moved to the Short Buff\\Song window. These buffs are never suspended (unless they are Songs which meet the criteria above).<br>",

    6280040 => "You have found an item which either has (or has the ability to be upgraded to have) a$color_object Sympathetic Proc$color_end."
               ."These are some of the most critical gear you can obtain on $color_legendary New Multiclass Server$color_end, vastly enhancing your overall power.<br><br>"
               ."These effects are generally only available on $color_legendary Legendary$color_end items, and you may need to upgrade this item using your Power Source slot to gain this effect.<br><br>"
               ."$color_object Sympathetic Strike$color_end - These abilities will deal additional damage whenever you $color_normal cast a damaging spell from a spell gem$color_end. Your $color_normal Spell Damage$color_end will also be applied.<br><br>"
               ."$color_object Sympathetic Healing$color_end - On the other hand, these abilities will add a healing component to $color_normal every beneficial spell you cast from a spell gem$color_end. Your $color_normal Heal Amount$color_end will also be applied.<br><br>"    
               ."It is important to note that these are, for the most part, $color_object Click Effects$color_end, not worn buffs, and each type will stack with each other.",
);

sub get_popup_config {
    my $popup_id = shift;
    my $client   = shift || plugin::val('$client');

    if (!popup_exists($popup_id)) {
        return 0;
    }

    return $client->GetBucket("popup-$popup_id-disabled");
}

sub set_popup_config {
    my $popup_id = shift;
    my $value    = shift;
    my $client   = shift || plugin::val('$client');    

    if (!popup_exists($popup_id)) {
        return 0;
    }

    $client->SetBucket("popup-$popup_id-disabled", $value);
}

sub popup_enabled {
    my $popup_id = shift;
    my $client   = shift || plugin::val('$client');

    if (!popup_exists($popup_id)) {
        return 0;
    }
    
    if (plugin::MultiClassingEnabled() && !get_popup_config($popup_id, $config)) {
        return 1;
    } else {
        return 0;
    }
};

sub disable_tutorial_popup {
    my $popup_id = shift;
    my $client   = shift || plugin::val('$client');

    if (!popup_exists($popup_id)) {
        return 0;
    }

    if ($client) {
        set_popup_config($popup_id, "true", $client);
        return 1;
    }

    return 0;
}

sub popup_exists {
    my $popup_id = shift;

    my $exists_in_popups = grep { $_ == $popup_id } values %popups;

    if ($exists_in_popups && exists $popups_text{$popup_id} && exists $popups_title{$popup_id}) {
        return 1;
    }
    
    return 0;
}

sub dispatch_popup {
    my $popup_identifier = shift;
    my $client = shift || plugin::val('$client');
    my $popup_id = exists $popups{$popup_identifier} ? $popups{$popup_identifier} : $popup_identifier;

    if (!popup_exists($popup_id)) {
        return 0;
    }

    if (!popup_enabled($popup_id, $client)) {
        return 0;
    }

    if (!$client) {
        return 0;
    }

    if (!exists $popups_title{$popup_id} || !exists $popups_text{$popup_id}) {
        quest::debug($client->GetCleanName() . " tried to invoke an invalid popup: $popup_id");
        return 0;  
    }

    my $title = $popups_title{$popup_id};
    my $text = $popups_text{$popup_id};
    # NMS: filled in on display; the limit is a server rule and other plugins may not be loaded yet when this file is
    $text =~ s/\{max_classes\}/plugin::GetMaxClasses()/ge;
    my $negative_id = $popup_id + 9;
    my $buttons = 2;
    my $duration = -1;
    my $button_1 = "Remind Me Later";
    my $button_2 = "Never Show Again";

    $client->Popup2($title, $text, $popup_id, $negative_id, $buttons, $duration, $button_1, $button_2);
    return 1;  
}

sub check_tutorial_popup_response {
    my $response_identifier = shift;
    my $client = shift || plugin::val('$client');

    if (!$client) {        
        return;
    }

    my $popup_id = $response_identifier - 9;

    if (popup_exists($popup_id)) {
        disable_tutorial_popup($popup_id, $client);
    }
}