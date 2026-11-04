#:: A Mischievous Halfling (npc_types 1120001081), the "Platinum Arcade" in the Bazaar.
#:: Hail offers a turn at a random prize, paid with Echo of Memory or platinum.
#:: Prizes and odds mirror Crow's Casino (cshome/Crows_Casino.pl, npc_types 1120001077); its 1%
#:: fallback roll, which also gives food, is folded into the food tier.

#:: Echo of Memory per turn (alternate currency 6, item 46779), spent through SpendEOM.pl.
#:: Two Echoes match the platinum price at the 2500pp per Echo rate used in bazaar/151061.pl.
my $turn_cost_eom	= 2;
#:: Platinum per turn, the same price as Crow's Casino.
my $turn_cost_pp	= 5000;
my $copper_per_pp	= 1000;

my $link_pay_eom	= "arcade-pay-eom";
my $link_pay_pp		= "arcade-pay-pp";

#:: Each tier: weight out of the table total, what the halfling says, and the prize item ids.
my @prize_tiers = (
	{
		weight	=> 26,
		message	=> "Snacks! Not the shiniest prize, but nobody ever regretted a good meal.",
		items	=> [
			36995,	#:: Item: Quarken Xired's Timeless Trail Rations
			57825,	#:: Item: Rilgor's Prime Number Ribs
			64489,	#:: Item: Lunanyn's Feast
			57819,	#:: Item: Solferino Sublime
			57818,	#:: Item: Hazenfranze
			37538,	#:: Item: Oriaas Nostrum
		],
	},
	{
		weight	=> 25,
		message	=> "A potion! Better luck next time, but drink up all the same.",
		items	=> [
			56942,	#:: Item: Distillate of Celestial Healing
			56940,	#:: Item: Distillate of Clarity
			56938,	#:: Item: Distillate of Comprehension
			56934,	#:: Item: Distillate of Antidote
			56935,	#:: Item: Distillate of Immunization
			56944,	#:: Item: Distillate of Replenishment
			56937,	#:: Item: Distillate of Skinspikes
		],
	},
	{
		weight	=> 21,
		message	=> "Ooh, a bottle of adventure! Let the experience flow!",
		items	=> [
			41961,	#:: Item: Bottle of Adventure I
			48083,	#:: Item: Bottle of Shared Adventure I
		],
	},
	{
		weight	=> 11,
		message	=> "Nicely done! Your pet will never look the same again.",
		items	=> [
			67923,	#:: Item: Petamorph Wand - Amethyst Crystalline Trichordont
			56052,	#:: Item: Petamorph Wand - Aviak
			61036,	#:: Item: Petamorph Wand - Brownie
			62774,	#:: Item: Petamorph Wand - Cliknar
			66783,	#:: Item: Petamorph Wand - Domain Prowler
			64711,	#:: Item: Petamorph Wand - Gnomework
			66431,	#:: Item: Petamorph Wand - Goo
			66449,	#:: Item: Petamorph Wand - Kirin
			67953,	#:: Item: Petamorph Wand - Mad Jester
			67883,	#:: Item: Petamorph Wand - Nightmare Skull
			52193,	#:: Item: Petamorph Wand - Scarecrow
			66598,	#:: Item: Petamorph Wand - Snow Spider
			61979,	#:: Item: Petamorph Wand - Sporali
			67145,	#:: Item: Petamorph Wand - Steamwork Soldier
			66564,	#:: Item: Petamorph Wand - Worg
		],
	},
	{
		weight	=> 6,
		message	=> "Epic! A brand new face, and nobody will ever know it's you!",
		items	=> [
			37954,	#:: Item: Mask of the Grumpy Goblin
			67008,	#:: Item: Froglok Stone
			43993,	#:: Item: Visage of Bragnar Noox
			37999,	#:: Item: Mask of the Mighty Minotaur
			40638,	#:: Item: Visage of the Ice Golem
			50872,	#:: Item: Visage of the War Pirate
			40714,	#:: Item: Visage of the Siren Enticer
			40686,	#:: Item: Visage of the Stone Gargoyle
			50854,	#:: Item: Visage of the Dark Arachnids
			40656,	#:: Item: Visage of the Brownie Noble
			31861,	#:: Item: Da Oogly Stick
		],
	},
	{
		weight	=> 3,
		message	=> "Epic! Something to ride! Mind you don't trample my stall on the way out.",
		items	=> [
			59508,	#:: Item: Giant Black Drum
			59513,	#:: Item: Giant Green Drum
			43970,	#:: Item: Onyx Hydra Saddle
			57798,	#:: Item: Golden Wurm Saddle
			54983,	#:: Item: Frost Wurm Saddle
			60437,	#:: Item: Forest Jaguar Saddle
			52098,	#:: Item: Fleshless Rotdog Saddle
			64560,	#:: Item: Tiger Raptor Saddle
			54934,	#:: Item: War Bear Saddle
			66317,	#:: Item: White Wolf Saddle
		],
	},
	{
		weight	=> 2,
		message	=> "Epic! I've been trying to win that one back for years.",
		items	=> [
			52024,	#:: Item: Urthron's Ultimate Unattuner
		],
	},
	{
		weight	=> 3,
		message	=> "Epic! Now you can carry the bank in your backpack!",
		items	=> [
			976008,	#:: Item: Clockwork Banker Tools
		],
	},
	{
		weight	=> 3,
		message	=> "Epic! Now you can open a shop of your very own!",
		items	=> [
			976009,	#:: Item: Clockwork Merchant Tools
		],
	},
);

sub EVENT_SAY {
	if ($text =~ /hail/i) {
		plugin::NPCTell(
			"Psst! Over here, $name! Welcome to the Platinum Arcade. Every turn pulls a prize from my sack: " .
			"snacks, potions, illusions, even a mount if Bristlebane smiles on you. A turn costs " .
			plugin::num2en($turn_cost_eom) . " [" . plugin::EOMLink() . "] or " .
			plugin::commify($turn_cost_pp) . " platinum."
		);
		plugin::NPCTell(payment_options());
	}
	elsif ($text eq $link_pay_eom) {
		take_turn(1);
	}
	elsif ($text eq $link_pay_pp) {
		take_turn(0);
	}
}

sub payment_options {
	return "Do you want to [" . quest::saylink($link_pay_eom, 1, "pay with Echo of Memory") . "] " .
		"or with [" . quest::saylink($link_pay_pp, 1, "Platinum") . "]?";
}

#:: The currency calls check the balance and only charge when it is enough.
sub take_turn {
	my ($pay_with_eom) = @_;

	my $paid = $pay_with_eom
		? plugin::SpendEOM($client, $turn_cost_eom)
		: $client->TakeMoneyFromPP($turn_cost_pp * $copper_per_pp, 1);

	if (!$paid) {
		plugin::NPCTell("Nice try, $name, but your pockets are lighter than mine. Come back when you can pay for a turn.");
		return;
	}

	my $tier    = roll_prize_tier();
	my @items   = @{$tier->{items}};
	my $item_id = $items[int(rand(@items))];

	$client->SummonFixedItem($item_id);
	plugin::NPCTell("*rummages through a lumpy sack* " . $tier->{message});
	plugin::YellowText("You won " . quest::varlink($item_id) . "!");
	plugin::NPCTell("Another turn? " . payment_options());
}

sub roll_prize_tier {
	my $total_weight = 0;
	$total_weight += $_->{weight} for @prize_tiers;

	my $roll = int(rand($total_weight));
	foreach my $tier (@prize_tiers) {
		return $tier if $roll < $tier->{weight};
		$roll -= $tier->{weight};
	}

	return $prize_tiers[0];
}
