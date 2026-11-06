$change_amount = 0;

sub EVENT_SPAWN {
	my $min = 1;
	my $range = 4;
	my $randomspawn = int(rand($range)) + $min;
	plugin::RandomRoam(250, 250);
	quest::settimer("move",$randomspawn);
	#:: Spawn ding_bat too!
	quest::spawn2(2160, 0, 0, $x, $y, $z, 0);
}

sub EVENT_TIMER {
	if ($timer eq "move") {
		plugin::RandomRoam(250, 250);
	}
}

sub EVENT_ITEM {
	#:: Match 1 platinum
	if (plugin::takeCoin(0, 0, 0, 1)) {
		$change_amount = 500;
		quest::say("Now your faction will be adjusted by $change_amount points.");
	}
	#:: Match 1 gold
	if (plugin::takeCoin(0, 0, 1, 0)) {
		$change_amount = 100;
		quest::say("Now your faction will be adjusted by $change_amount points.");
	}
	#:: Match 1 silver
	if (plugin::takeCoin(0, 1, 0, 0)) {
		$change_amount = -100;
		quest::say("Now your faction will be adjusted by $change_amount points.");
	}
	#:: Match 1 copper
	if (plugin::takeCoin(1, 0, 0, 0)) {
		$change_amount = -500;
		quest::say("Now your faction will be adjusted by $change_amount points.");
	}
	#:: Match a 66615 - Gold Ticket
	if (plugin::check_handin(\%itemcount, 66615 => 1)) {
		my @prizes = (11668, 59509);
		foreach $prizes (@prizes) {
			next if (plugin::check_hasitem($client, $prizes));
			# NMS: was "1$prizes", a syntax error that kept the whole script from loading
			quest::summonitem($prizes);
			last;
		}
	}
}

sub Train {
	# NMS: was "$status => 80" (fat comma, always true), so any player passed the GM status check
	if ($status >= 80) {
		$client->Message( 15, "Your experiences across the realm have infused you with increased power and knowledge..." );
		#:: Set all available skills to maximum for race/class at current level
		foreach my $skill ( 0 .. 74 ) {
			next unless $client->CanHaveSkill($skill);
			my $maxSkill = $client->MaxSkill( $skill, $client->GetClass(), $ulevel );
			next unless $maxSkill > $client->GetRawSkill($skill);
			$client->SetSkill( $skill, $maxSkill );
		}
		#:: Clear out all old spells just in case
		quest::unscribespells();
		#:: Scribe all spells up to current level
		quest::scribespells($ulevel,1);
	}
}

sub EVENT_SAY {
	if ($text=~/train/i) {
		Train();
	}
	elsif ($text=~/hail/i) {
		quest::say("Hello $name! Don't let my little friend fool you--he is quite powerful!");
	}
	# NMS: was "$status => 80" (fat comma, always true), so any player passed the GM status check
	if ($status >= 80) {
		if ($text=~/faction/i) {
			quest::say("I can adjust your faction.  Hand me 1 copper to lose 500, 1 silver to lose 100, 1 gold to gain 100, and 1 platinum to gain 500--then speak the faction number, or the faction name.");
		}
		elsif (!$client->GetGM()) {
			if ($text=~/\bGrobb Merchants\b/) {	#:: 376
				quest::faction(376, $change_amount);
			}
			elsif ($text=~/\bDeath Fist Orcs (good)\b/) {	#:: 375
				quest::faction(375, $change_amount);
			}
			elsif ($text=~/\bOggok Resident\b/) {	#:: 374
				quest::faction(374, $change_amount);
			}
			elsif ($text=~/\bMucktail Gnolls\b/) {	#:: 373
				quest::faction(373, $change_amount);
			}
			elsif ($text=~/\bAnti-mage\b/) {	#:: 5001
				quest::faction(5001, $change_amount);
			}
			elsif ($text=~/\bNajena\b/) {	#:: 372
				quest::faction(372, $change_amount);
			}
			elsif ($text=~/\bNeriak Ghoul\b/) {	#:: 371
				quest::faction(371, $change_amount);
			}
			elsif ($text=~/\bDreadguard Inner\b/) {	#:: 370
				quest::faction(370, $change_amount);
			}
			elsif ($text=~/\bTimmerain Darkbrow\b/) {	#:: 369
				quest::faction(369, $change_amount);
			}
			elsif ($text=~/\bBanker\b/) {	#:: 5002
				quest::faction(5002, $change_amount);
			}
			elsif ($text=~/\bDervish Cutthroats\b/) {	#:: 368
				quest::faction(368, $change_amount);
			}
			elsif ($text=~/\bDonovon\b/) {	#:: 367
				quest::faction(367, $change_amount);
			}
			elsif ($text=~/\bKarana Bandits\b/) {	#:: 366
				quest::faction(366, $change_amount);
			}
			elsif ($text=~/\bPickclaw Goblins\b/) {	#:: 365
				quest::faction(365, $change_amount);
			}
			elsif ($text=~/\bShralok Orcs\b/) {	#:: 364
				quest::faction(364, $change_amount);
			}
			elsif ($text=~/\bThe Spurned\b/) {	#:: 363
				quest::faction(363, $change_amount);
			}
			elsif ($text=~/\bPriests of Marr\b/) {	#:: 362
				quest::faction(362, $change_amount);
			}
			elsif ($text=~/\bAshen Order\b/) {	#:: 361
				quest::faction(361, $change_amount);
			}
			elsif ($text=~/\bIskar\b/) {	#:: 360
				quest::faction(360, $change_amount);
			}
			elsif ($text=~/\bDefenders of Luclin\b/) {	#:: 359
				quest::faction(359, $change_amount);
			}
			elsif ($text=~/\bCorrupt Akhevan\b/) {	#:: 358
				quest::faction(358, $change_amount);
			}
			elsif ($text=~/\bAkhevan (Plane of Shadow)\b/) {	#:: 357
				quest::faction(357, $change_amount);
			}
			elsif ($text=~/\bDiseased Animal\b/) {	#:: 356
				quest::faction(356, $change_amount);
			}
			elsif ($text=~/\bStorm Reapers\b/) {	#:: 355
				quest::faction(355, $change_amount);
			}
			elsif ($text=~/\bNeriak Troll\b/) {	#:: 354
				quest::faction(354, $change_amount);
			}
			elsif ($text=~/\bNeriak Ogre\b/) {	#:: 353
				quest::faction(353, $change_amount);
			}
			elsif ($text=~/\bNeriak Inner\b/) {	#:: 352
				quest::faction(352, $change_amount);
			}
			elsif ($text=~/\bNeriak Outer\b/) {	#:: 351
				quest::faction(351, $change_amount);
			}
			elsif ($text=~/\bRunnyeye C\b/) {	#:: 350
				quest::faction(350, $change_amount);
			}
			elsif ($text=~/\bRunnyeye B\b/) {	#:: 349
				quest::faction(349, $change_amount);
			}
			elsif ($text=~/\bRunnyeye A\b/) {	#:: 348
				quest::faction(348, $change_amount);
			}
			elsif ($text=~/\bShark\b/) {	#:: 347
				quest::faction(347, $change_amount);
			}
			elsif ($text=~/\bCommons Residents\b/) {	#:: 346
				quest::faction(346, $change_amount);
			}
			elsif ($text=~/\bKarana Residents\b/) {	#:: 345
				quest::faction(345, $change_amount);
			}
			elsif ($text=~/\bBeta Neutral\b/) {	#:: 344
				quest::faction(344, $change_amount);
			}
			elsif ($text=~/\bSurefall Protected Animals\b/) {	#:: 343
				quest::faction(343, $change_amount);
			}
			elsif ($text=~/\bOrder of Three\b/) {	#:: 342
				quest::faction(342, $change_amount);
			}
			elsif ($text=~/\bPriests of Life\b/) {	#:: 341
				quest::faction(341, $change_amount);
			}
			elsif ($text=~/\bPriests of Innoruuk\b/) {	#:: 340
				quest::faction(340, $change_amount);
			}
			elsif ($text=~/\bBonethrowers\b/) {	#:: 339
				quest::faction(339, $change_amount);
			}
			elsif ($text=~/\bMerchants of Oggok\b/) {	#:: 338
				quest::faction(338, $change_amount);
			}
			elsif ($text=~/\bOggok Guards\b/) {	#:: 337
				quest::faction(337, $change_amount);
			}
			elsif ($text=~/\bCoalition of Tradefolk Underground\b/) {	#:: 336
				quest::faction(336, $change_amount);
			}
			elsif ($text=~/\bThoughtbleeders of Fear\b/) {	#:: 335
				quest::faction(335, $change_amount);
			}
			elsif ($text=~/\bDreadguard Outer\b/) {	#:: 334
				quest::faction(334, $change_amount);
			}
			elsif ($text=~/\bKing Ak`Anon\b/) {	#:: 333
				quest::faction(333, $change_amount);
			}
			elsif ($text=~/\bHighpass Guards\b/) {	#:: 332
				quest::faction(332, $change_amount);
			}
			elsif ($text=~/\bMerchants of Highpass\b/) {	#:: 331
				quest::faction(331, $change_amount);
			}
			elsif ($text=~/\bThe Freeport Militia\b/) {	#:: 330
				quest::faction(330, $change_amount);
			}
			elsif ($text=~/\bCarson McCabe\b/) {	#:: 329
				quest::faction(329, $change_amount);
			}
			elsif ($text=~/\bMerchants of Halas\b/) {	#:: 328
				quest::faction(328, $change_amount);
			}
			elsif ($text=~/\bShamen of Justice\b/) {	#:: 327
				quest::faction(327, $change_amount);
			}
			elsif ($text=~/\bEmerald Warriors\b/) {	#:: 326
				quest::faction(326, $change_amount);
			}
			elsif ($text=~/\bMerchants of Felwithe\b/) {	#:: 325
				quest::faction(325, $change_amount);
			}
			elsif ($text=~/\bUnkempt Druids\b/) {	#:: 324
				quest::faction(324, $change_amount);
			}
			elsif ($text=~/\bSolusek Mining Co.\b/) {	#:: 323
				quest::faction(323, $change_amount);
			}
			elsif ($text=~/\bMiners Guild 628\b/) {	#:: 322
				quest::faction(322, $change_amount);
			}
			elsif ($text=~/\bSplit Paw Clan\b/) {	#:: 321
				quest::faction(321, $change_amount);
			}
			elsif ($text=~/\bDefenders of the Haven\b/) {	#:: 5003
				quest::faction(5003, $change_amount);
			}
			elsif ($text=~/\bDenizens of Fear\b/) {	#:: 5004
				quest::faction(5004, $change_amount);
			}
			elsif ($text=~/\bWolves of the North\b/) {	#:: 320
				quest::faction(320, $change_amount);
			}
			elsif ($text=~/\bVox\b/) {	#:: 319
				quest::faction(319, $change_amount);
			}
			elsif ($text=~/\bVenril Sathir\b/) {	#:: 318
				quest::faction(318, $change_amount);
			}
			elsif ($text=~/\bUndead Frogloks of Guk\b/) {	#:: 317
				quest::faction(317, $change_amount);
			}
			elsif ($text=~/\bTunare's Scouts\b/) {	#:: 316
				quest::faction(316, $change_amount);
			}
			elsif ($text=~/\bTrakanon\b/) {	#:: 315
				quest::faction(315, $change_amount);
			}
			elsif ($text=~/\bSyth of Permafrost\b/) {	#:: 314
				quest::faction(314, $change_amount);
			}
			elsif ($text=~/\bPirates of Gunthak\b/) {	#:: 313
				quest::faction(313, $change_amount);
			}
			elsif ($text=~/\bStorm Guard\b/) {	#:: 312
				quest::faction(312, $change_amount);
			}
			elsif ($text=~/\bSteel Warriors\b/) {	#:: 311
				quest::faction(311, $change_amount);
			}
			elsif ($text=~/\bSoldiers of Tunare\b/) {	#:: 310
				quest::faction(310, $change_amount);
			}
			elsif ($text=~/\bSilent Fist Clan\b/) {	#:: 309
				quest::faction(309, $change_amount);
			}
			elsif ($text=~/\bFizzlethorpe\b/) {	#:: 5005
				quest::faction(5005, $change_amount);
			}
			elsif ($text=~/\bShadowknights of Night Keep\b/) {	#:: 308
				quest::faction(308, $change_amount);
			}
			elsif ($text=~/\bSarnak Collective\b/) {	#:: 307
				quest::faction(307, $change_amount);
			}
			elsif ($text=~/\bSabertooths of Blackburrow\b/) {	#:: 306
				quest::faction(306, $change_amount);
			}
			elsif ($text=~/\bRogues of the White Rose\b/) {	#:: 305
				quest::faction(305, $change_amount);
			}
			elsif ($text=~/\bRing of Scale\b/) {	#:: 304
				quest::faction(304, $change_amount);
			}
			elsif ($text=~/\bQueen Cristanos Thex\b/) {	#:: 303
				quest::faction(303, $change_amount);
			}
			elsif ($text=~/\bProtectors of Pine\b/) {	#:: 302
				quest::faction(302, $change_amount);
			}
			elsif ($text=~/\bPriests of Nagafen\b/) {	#:: 301
				quest::faction(301, $change_amount);
			}
			elsif ($text=~/\bPriests of Mischief\b/) {	#:: 300
				quest::faction(300, $change_amount);
			}
			elsif ($text=~/\bPhinigel Autropos\b/) {	#:: 299
				quest::faction(299, $change_amount);
			}
			elsif ($text=~/\bPeace Keepers\b/) {	#:: 298
				quest::faction(298, $change_amount);
			}
			elsif ($text=~/\bPaladins of Underfoot\b/) {	#:: 297
				quest::faction(297, $change_amount);
			}
			elsif ($text=~/\bOpal Darkbriar\b/) {	#:: 296
				quest::faction(296, $change_amount);
			}
			elsif ($text=~/\bThe Kromdek\b/) {	#:: 295
				quest::faction(295, $change_amount);
			}
			elsif ($text=~/\bMiragul\b/) {	#:: 294
				quest::faction(294, $change_amount);
			}
			elsif ($text=~/\bMiners Guild 249\b/) {	#:: 293
				quest::faction(293, $change_amount);
			}
			elsif ($text=~/\bMerchants of Rivervale\b/) {	#:: 292
				quest::faction(292, $change_amount);
			}
			elsif ($text=~/\bMerchants of Qeynos\b/) {	#:: 291
				quest::faction(291, $change_amount);
			}
			elsif ($text=~/\bMerchants of Kaladim\b/) {	#:: 290
				quest::faction(290, $change_amount);
			}
			elsif ($text=~/\bMerchants of Erudin\b/) {	#:: 289
				quest::faction(289, $change_amount);
			}
			elsif ($text=~/\bMerchants of Ak`Anon\b/) {	#:: 288
				quest::faction(288, $change_amount);
			}
			elsif ($text=~/\bMeldrath\b/) {	#:: 287
				quest::faction(287, $change_amount);
			}
			elsif ($text=~/\bMayor Gubbin\b/) {	#:: 286
				quest::faction(286, $change_amount);
			}
			elsif ($text=~/\bMayong Mistmoore\b/) {	#:: 285
				quest::faction(285, $change_amount);
			}
			elsif ($text=~/\bLeague of Antonican Bards\b/) {	#:: 284
				quest::faction(284, $change_amount);
			}
			elsif ($text=~/\bPack of Tomar\b/) {	#:: 283
				quest::faction(283, $change_amount);
			}
			elsif ($text=~/\bHall of the Ebon Mask\b/) {	#:: 5006
				quest::faction(5006, $change_amount);
			}
			elsif ($text=~/\bKobolds of Fire Pit\b/) {	#:: 282
				quest::faction(282, $change_amount);
			}
			elsif ($text=~/\bKnights of Truth\b/) {	#:: 281
				quest::faction(281, $change_amount);
			}
			elsif ($text=~/\bKnights of Thunder\b/) {	#:: 280
				quest::faction(280, $change_amount);
			}
			elsif ($text=~/\bKing Tearis Thex\b/) {	#:: 279
				quest::faction(279, $change_amount);
			}
			elsif ($text=~/\bKing Naythox Thex\b/) {	#:: 278
				quest::faction(278, $change_amount);
			}
			elsif ($text=~/\bKerra of Barren Coast\b/) {	#:: 277
				quest::faction(277, $change_amount);
			}
			elsif ($text=~/\bKelethin Merchants\b/) {	#:: 276
				quest::faction(276, $change_amount);
			}
			elsif ($text=~/\bKeepers of the Art\b/) {	#:: 275
				quest::faction(275, $change_amount);
			}
			elsif ($text=~/\bKazon Stormhammer\b/) {	#:: 274
				quest::faction(274, $change_amount);
			}
			elsif ($text=~/\bKane Bayle\b/) {	#:: 273
				quest::faction(273, $change_amount);
			}
			elsif ($text=~/\bJaggedpine Treefolk\b/) {	#:: 272
				quest::faction(272, $change_amount);
			}
			elsif ($text=~/\bDismal Rage\b/) {	#:: 271
				quest::faction(271, $change_amount);
			}
			elsif ($text=~/\bIndigo Brotherhood\b/) {	#:: 270
				quest::faction(270, $change_amount);
			}
			elsif ($text=~/\bKithicor Residents\b/) {	#:: 269
				quest::faction(269, $change_amount);
			}
			elsif ($text=~/\bCombine Empire\b/) {	#:: 268
				quest::faction(268, $change_amount);
			}
			elsif ($text=~/\bHigh Guard of Erudin\b/) {	#:: 267
				quest::faction(267, $change_amount);
			}
			elsif ($text=~/\bHigh Council of Erudin\b/) {	#:: 266
				quest::faction(266, $change_amount);
			}
			elsif ($text=~/\bHeretics\b/) {	#:: 265
				quest::faction(265, $change_amount);
			}
			elsif ($text=~/\bWhistling Fist Brotherhood\b/) {	#:: 264
				quest::faction(264, $change_amount);
			}
			elsif ($text=~/\bGuardians of the Vale\b/) {	#:: 263
				quest::faction(263, $change_amount);
			}
			elsif ($text=~/\bGuards of Qeynos\b/) {	#:: 262
				quest::faction(262, $change_amount);
			}
			elsif ($text=~/\bGreen Blood Knights\b/) {	#:: 261
				quest::faction(261, $change_amount);
			}
			elsif ($text=~/\bGnarled Fist\b/) {	#:: 260
				quest::faction(260, $change_amount);
			}
			elsif ($text=~/\bGoblins of Mountain Death\b/) {	#:: 259
				quest::faction(259, $change_amount);
			}
			elsif ($text=~/\bGoblins of Fire Peak\b/) {	#:: 258
				quest::faction(258, $change_amount);
			}
			elsif ($text=~/\bKeepers of the Claw\b/) {	#:: 5007
				quest::faction(5007, $change_amount);
			}
			elsif ($text=~/\bKejekan\b/) {	#:: 5008
				quest::faction(5008, $change_amount);
			}
			elsif ($text=~/\bGoblins of Cleaving Tooth\b/) {	#:: 257
				quest::faction(257, $change_amount);
			}
			elsif ($text=~/\bBloodgills\b/) {	#:: 256
				quest::faction(256, $change_amount);
			}
			elsif ($text=~/\bGem Choppers\b/) {	#:: 255
				quest::faction(255, $change_amount);
			}
			elsif ($text=~/\bGate Callers\b/) {	#:: 254
				quest::faction(254, $change_amount);
			}
			elsif ($text=~/\bBurynai Legion\b/) {	#:: 253
				quest::faction(253, $change_amount);
			}
			elsif ($text=~/\bFrogloks of Kunark\b/) {	#:: 252
				quest::faction(252, $change_amount);
			}
			elsif ($text=~/\bFrogloks of Guk\b/) {	#:: 251
				quest::faction(251, $change_amount);
			}
			elsif ($text=~/\bThe Kromdul\b/) {	#:: 250
				quest::faction(250, $change_amount);
			}
			elsif ($text=~/\bNagafen\b/) {	#:: 249
				quest::faction(249, $change_amount);
			}
			elsif ($text=~/\bInhabitants of Firiona Vie\b/) {	#:: 248
				quest::faction(248, $change_amount);
			}
			elsif ($text=~/\bHorde of Xalgoz\b/) {	#:: 247
				quest::faction(247, $change_amount);
			}
			elsif ($text=~/\bFaydarks Champions\b/) {	#:: 246
				quest::faction(246, $change_amount);
			}
			elsif ($text=~/\bKunark Fire Giants\b/) {	#:: 5009
				quest::faction(5009, $change_amount);
			}
			elsif ($text=~/\bEldritch Collective\b/) {	#:: 245
				quest::faction(245, $change_amount);
			}
			elsif ($text=~/\bEbon Mask\b/) {	#:: 244
				quest::faction(244, $change_amount);
			}
			elsif ($text=~/\bDrafling\b/) {	#:: 243
				quest::faction(243, $change_amount);
			}
			elsif ($text=~/\bDeepwater Knights\b/) {	#:: 242
				quest::faction(242, $change_amount);
			}
			elsif ($text=~/\bDeeppockets\b/) {	#:: 241
				quest::faction(241, $change_amount);
			}
			elsif ($text=~/\bDeepmuses\b/) {	#:: 240
				quest::faction(240, $change_amount);
			}
			elsif ($text=~/\bThe Dead\b/) {	#:: 239
				quest::faction(239, $change_amount);
			}
			elsif ($text=~/\bDark Reflection\b/) {	#:: 238
				quest::faction(238, $change_amount);
			}
			elsif ($text=~/\bDark Ones\b/) {	#:: 237
				quest::faction(237, $change_amount);
			}
			elsif ($text=~/\bDark Bargainers\b/) {	#:: 236
				quest::faction(236, $change_amount);
			}
			elsif ($text=~/\bDaBashers\b/) {	#:: 235
				quest::faction(235, $change_amount);
			}
			elsif ($text=~/\bCrushbone Orcs\b/) {	#:: 234
				quest::faction(234, $change_amount);
			}
			elsif ($text=~/\bCrimson Hands\b/) {	#:: 233
				quest::faction(233, $change_amount);
			}
			elsif ($text=~/\bCraknek Warriors\b/) {	#:: 232
				quest::faction(232, $change_amount);
			}
			elsif ($text=~/\bCraftkeepers\b/) {	#:: 231
				quest::faction(231, $change_amount);
			}
			elsif ($text=~/\bCorrupt Qeynos Guards\b/) {	#:: 230
				quest::faction(230, $change_amount);
			}
			elsif ($text=~/\bCoalition of Tradefolk\b/) {	#:: 229
				quest::faction(229, $change_amount);
			}
			elsif ($text=~/\bClurg\b/) {	#:: 228
				quest::faction(228, $change_amount);
			}
			elsif ($text=~/\bClerics of Underfoot\b/) {	#:: 227
				quest::faction(227, $change_amount);
			}
			elsif ($text=~/\bClerics of Tunare\b/) {	#:: 226
				quest::faction(226, $change_amount);
			}
			elsif ($text=~/\bClan Runnyeye\b/) {	#:: 225
				quest::faction(225, $change_amount);
			}
			elsif ($text=~/\bClan Drippycan\b/) {	#:: 224
				quest::faction(224, $change_amount);
			}
			elsif ($text=~/\bCircle of Unseen Hands\b/) {	#:: 223
				quest::faction(223, $change_amount);
			}
			elsif ($text=~/\bBroken Skull Clan\b/) {	#:: 222
				quest::faction(222, $change_amount);
			}
			elsif ($text=~/\bBloodsabers\b/) {	#:: 221
				quest::faction(221, $change_amount);
			}
			elsif ($text=~/\bArcane Scientists\b/) {	#:: 220
				quest::faction(220, $change_amount);
			}
			elsif ($text=~/\bAntonius Bayle\b/) {	#:: 219
				quest::faction(219, $change_amount);
			}
			elsif ($text=~/\bAllize Taeew\b/) {	#:: 218
				quest::faction(218, $change_amount);
			}
			elsif ($text=~/\bAllize Volew\b/) {	#:: 217
				quest::faction(217, $change_amount);
			}
			elsif ($text=~/\bVeeshan\b/) {	#:: 216
				quest::faction(216, $change_amount);
			}
			elsif ($text=~/\bTunare\b/) {	#:: 215
				quest::faction(215, $change_amount);
			}
			elsif ($text=~/\bTribunal\b/) {	#:: 214
				quest::faction(214, $change_amount);
			}
			elsif ($text=~/\bSolusek Ro\b/) {	#:: 213
				quest::faction(213, $change_amount);
			}
			elsif ($text=~/\bRodcet Nife\b/) {	#:: 212
				quest::faction(212, $change_amount);
			}
			elsif ($text=~/\bRallos Zek\b/) {	#:: 211
				quest::faction(211, $change_amount);
			}
			elsif ($text=~/\bQuellious\b/) {	#:: 210
				quest::faction(210, $change_amount);
			}
			elsif ($text=~/\bPrexus\b/) {	#:: 209
				quest::faction(209, $change_amount);
			}
			elsif ($text=~/\bMithaniel Marr\b/) {	#:: 208
				quest::faction(208, $change_amount);
			}
			elsif ($text=~/\bKarana\b/) {	#:: 207
				quest::faction(207, $change_amount);
			}
			elsif ($text=~/\bOgre Warriors\b/) {	#:: 5010
				quest::faction(5010, $change_amount);
			}
			elsif ($text=~/\bInnoruuk\b/) {	#:: 206
				quest::faction(206, $change_amount);
			}
			elsif ($text=~/\bFizzlethorp\b/) {	#:: 205
				quest::faction(205, $change_amount);
			}
			elsif ($text=~/\bErollisi Marr\b/) {	#:: 204
				quest::faction(204, $change_amount);
			}
			elsif ($text=~/\bCazic-Thule\b/) {	#:: 203
				quest::faction(203, $change_amount);
			}
			elsif ($text=~/\bBrell Serilis\b/) {	#:: 202
				quest::faction(202, $change_amount);
			}
			elsif ($text=~/\bBertoxxulous\b/) {	#:: 201
				quest::faction(201, $change_amount);
			}
			elsif ($text=~/\bErollisi Marr (Race)\b/) {	#:: 200
				quest::faction(200, $change_amount);
			}
			elsif ($text=~/\bIksar Scorpion\b/) {	#:: 199
				quest::faction(199, $change_amount);
			}
			elsif ($text=~/\bKunark Fish\b/) {	#:: 198
				quest::faction(198, $change_amount);
			}
			elsif ($text=~/\bSpectral Iksar\b/) {	#:: 197
				quest::faction(197, $change_amount);
			}
			elsif ($text=~/\bSpectral Sarnak\b/) {	#:: 196
				quest::faction(196, $change_amount);
			}
			elsif ($text=~/\bGoo\b/) {	#:: 195
				quest::faction(195, $change_amount);
			}
			elsif ($text=~/\bBurynai\b/) {	#:: 194
				quest::faction(194, $change_amount);
			}
			elsif ($text=~/\bRace Faction (193)\b/) {	#:: 193
				quest::faction(193, $change_amount);
			}
			elsif ($text=~/\bRace Faction (192)\b/) {	#:: 192
				quest::faction(192, $change_amount);
			}
			elsif ($text=~/\bBoat\b/) {	#:: 191
				quest::faction(191, $change_amount);
			}
			elsif ($text=~/\bForest Giant\b/) {	#:: 190
				quest::faction(190, $change_amount);
			}
			elsif ($text=~/\bIksar Citizen\b/) {	#:: 189
				quest::faction(189, $change_amount);
			}
			elsif ($text=~/\bYeti\b/) {	#:: 188
				quest::faction(188, $change_amount);
			}
			elsif ($text=~/\bKunark Goblin\b/) {	#:: 187
				quest::faction(187, $change_amount);
			}
			elsif ($text=~/\bXalgoz Race\b/) {	#:: 186
				quest::faction(186, $change_amount);
			}
			elsif ($text=~/\bRhino\b/) {	#:: 185
				quest::faction(185, $change_amount);
			}
			elsif ($text=~/\bMosquito\b/) {	#:: 184
				quest::faction(184, $change_amount);
			}
			elsif ($text=~/\bLycanthrope\b/) {	#:: 183
				quest::faction(183, $change_amount);
			}
			elsif ($text=~/\bDraglok Invalid Race\b/) {	#:: 182
				quest::faction(182, $change_amount);
			}
			elsif ($text=~/\bSarnak\b/) {	#:: 181
				quest::faction(181, $change_amount);
			}
			elsif ($text=~/\bVah Shir\b/) {	#:: 180
				quest::faction(180, $change_amount);
			}
			elsif ($text=~/\bScorpion\b/) {	#:: 179
				quest::faction(179, $change_amount);
			}
			elsif ($text=~/\bIksar\b/) {	#:: 178
				quest::faction(178, $change_amount);
			}
			elsif ($text=~/\bInvisible Man\b/) {	#:: 177
				quest::faction(177, $change_amount);
			}
			elsif ($text=~/\bDjinn (Race)\b/) {	#:: 176
				quest::faction(176, $change_amount);
			}
			elsif ($text=~/\bPegasus\b/) {	#:: 175
				quest::faction(175, $change_amount);
			}
			elsif ($text=~/\bResidents of Karanas\b/) {	#:: 5011
				quest::faction(5011, $change_amount);
			}
			elsif ($text=~/\bUnicorn Nightmare\b/) {	#:: 174
				quest::faction(174, $change_amount);
			}
			elsif ($text=~/\bInnoruuk (Race)\b/) {	#:: 173
				quest::faction(173, $change_amount);
			}
			elsif ($text=~/\bDragon Skeleton\b/) {	#:: 172
				quest::faction(172, $change_amount);
			}
			elsif ($text=~/\bRoot of Innuruuk\b/) {	#:: 5012
				quest::faction(5012, $change_amount);
			}
			elsif ($text=~/\bGorgon\b/) {	#:: 171
				quest::faction(171, $change_amount);
			}
			elsif ($text=~/\bSpiritWolf\b/) {	#:: 170
				quest::faction(170, $change_amount);
			}
			elsif ($text=~/\bSaber-toothed Cat\b/) {	#:: 169
				quest::faction(169, $change_amount);
			}
			elsif ($text=~/\bErudite Ghost\b/) {	#:: 168
				quest::faction(168, $change_amount);
			}
			elsif ($text=~/\bGhost Dwarf\b/) {	#:: 167
				quest::faction(167, $change_amount);
			}
			elsif ($text=~/\bSea Horse\b/) {	#:: 166
				quest::faction(166, $change_amount);
			}
			elsif ($text=~/\bClam\b/) {	#:: 165
				quest::faction(165, $change_amount);
			}
			elsif ($text=~/\bGhost Ship\b/) {	#:: 164
				quest::faction(164, $change_amount);
			}
			elsif ($text=~/\bDrixie\b/) {	#:: 163
				quest::faction(163, $change_amount);
			}
			elsif ($text=~/\bFayguard\b/) {	#:: 162
				quest::faction(162, $change_amount);
			}
			elsif ($text=~/\bHarpie\b/) {	#:: 161
				quest::faction(161, $change_amount);
			}
			elsif ($text=~/\bMermaid\b/) {	#:: 160
				quest::faction(160, $change_amount);
			}
			elsif ($text=~/\bWasp\b/) {	#:: 159
				quest::faction(159, $change_amount);
			}
			elsif ($text=~/\bEye of Zomm\b/) {	#:: 158
				quest::faction(158, $change_amount);
			}
			elsif ($text=~/\bMammoth\b/) {	#:: 157
				quest::faction(157, $change_amount);
			}
			elsif ($text=~/\bFel Guard\b/) {	#:: 156
				quest::faction(156, $change_amount);
			}
			elsif ($text=~/\bSword Fish\b/) {	#:: 155
				quest::faction(155, $change_amount);
			}
			elsif ($text=~/\bLeech\b/) {	#:: 154
				quest::faction(154, $change_amount);
			}
			elsif ($text=~/\bKedge\b/) {	#:: 153
				quest::faction(153, $change_amount);
			}
			elsif ($text=~/\bFroglok Tadpole\b/) {	#:: 152
				quest::faction(152, $change_amount);
			}
			elsif ($text=~/\bEfreeti\b/) {	#:: 151
				quest::faction(151, $change_amount);
			}
			elsif ($text=~/\bDervish\b/) {	#:: 150
				quest::faction(150, $change_amount);
			}
			elsif ($text=~/\bAmygdalan\b/) {	#:: 149
				quest::faction(149, $change_amount);
			}
			elsif ($text=~/\bElf Vampire\b/) {	#:: 148
				quest::faction(148, $change_amount);
			}
			elsif ($text=~/\bDiasy Men\b/) {	#:: 147
				quest::faction(147, $change_amount);
			}
			elsif ($text=~/\bCockatrice\b/) {	#:: 146
				quest::faction(146, $change_amount);
			}
			elsif ($text=~/\bCazic-Thule (Race)\b/) {	#:: 145
				quest::faction(145, $change_amount);
			}
			elsif ($text=~/\bKaladim Citizens\b/) {	#:: 144
				quest::faction(144, $change_amount);
			}
			elsif ($text=~/\bOggok Citizen\b/) {	#:: 143
				quest::faction(143, $change_amount);
			}
			elsif ($text=~/\bGrobb Citizen\b/) {	#:: 142
				quest::faction(142, $change_amount);
			}
			elsif ($text=~/\bAlligator\b/) {	#:: 141
				quest::faction(141, $change_amount);
			}
			elsif ($text=~/\bHalas Citizen\b/) {	#:: 140
				quest::faction(140, $change_amount);
			}
			elsif ($text=~/\bDrake\b/) {	#:: 139
				quest::faction(139, $change_amount);
			}
			elsif ($text=~/\bClockworks of Ak`Anon\b/) {	#:: 138
				quest::faction(138, $change_amount);
			}
			elsif ($text=~/\bArmadillo\b/) {	#:: 137
				quest::faction(137, $change_amount);
			}
			elsif ($text=~/\bSphinx\b/) {	#:: 136
				quest::faction(136, $change_amount);
			}
			elsif ($text=~/\bSpectre\b/) {	#:: 135
				quest::faction(135, $change_amount);
			}
			elsif ($text=~/\bSnake Elemental\b/) {	#:: 134
				quest::faction(134, $change_amount);
			}
			elsif ($text=~/\bSkunk\b/) {	#:: 133
				quest::faction(133, $change_amount);
			}
			elsif ($text=~/\bScarecrow\b/) {	#:: 132
				quest::faction(132, $change_amount);
			}
			elsif ($text=~/\bRivervale Guard\b/) {	#:: 131
				quest::faction(131, $change_amount);
			}
			elsif ($text=~/\bReanimated Hand\b/) {	#:: 130
				quest::faction(130, $change_amount);
			}
			elsif ($text=~/\bBixie\b/) {	#:: 129
				quest::faction(129, $change_amount);
			}
			elsif ($text=~/\bErudin Citizens\b/) {	#:: 128
				quest::faction(128, $change_amount);
			}
			elsif ($text=~/\bNeriak Citizen\b/) {	#:: 127
				quest::faction(127, $change_amount);
			}
			elsif ($text=~/\bPuma\b/) {	#:: 126
				quest::faction(126, $change_amount);
			}
			elsif ($text=~/\bElemental\b/) {	#:: 125
				quest::faction(125, $change_amount);
			}
			elsif ($text=~/\bPiranha\b/) {	#:: 124
				quest::faction(124, $change_amount);
			}
			elsif ($text=~/\bLaunch\b/) {	#:: 123
				quest::faction(123, $change_amount);
			}
			elsif ($text=~/\bShip\b/) {	#:: 122
				quest::faction(122, $change_amount);
			}
			elsif ($text=~/\bQeynos Citizens\b/) {	#:: 121
				quest::faction(121, $change_amount);
			}
			elsif ($text=~/\bZombie\b/) {	#:: 120
				quest::faction(120, $change_amount);
			}
			elsif ($text=~/\bWill-O-Wisp\b/) {	#:: 119
				quest::faction(119, $change_amount);
			}
			elsif ($text=~/\bTentacle\b/) {	#:: 118
				quest::faction(118, $change_amount);
			}
			elsif ($text=~/\bHigh Hold Citizen\b/) {	#:: 117
				quest::faction(117, $change_amount);
			}
			elsif ($text=~/\bRallos Zek (Race)\b/) {	#:: 116
				quest::faction(116, $change_amount);
			}
			elsif ($text=~/\bVampire\b/) {	#:: 115
				quest::faction(115, $change_amount);
			}
			elsif ($text=~/\bTreant\b/) {	#:: 114
				quest::faction(114, $change_amount);
			}
			elsif ($text=~/\bTiger\b/) {	#:: 113
				quest::faction(113, $change_amount);
			}
			elsif ($text=~/\bTunare (Race)\b/) {	#:: 112
				quest::faction(112, $change_amount);
			}
			elsif ($text=~/\bShark (Race)\b/) {	#:: 111
				quest::faction(111, $change_amount);
			}
			elsif ($text=~/\bSkeleton\b/) {	#:: 110
				quest::faction(110, $change_amount);
			}
			elsif ($text=~/\bKunark Goblin (Race)\b/) {	#:: 109
				quest::faction(109, $change_amount);
			}
			elsif ($text=~/\bSolusek Ro (Race)\b/) {	#:: 108
				quest::faction(108, $change_amount);
			}
			elsif ($text=~/\bDrachnid (Race)\b/) {	#:: 107
				quest::faction(107, $change_amount);
			}
			elsif ($text=~/\bPixies of Faydwer\b/) {	#:: 106
				quest::faction(106, $change_amount);
			}
			elsif ($text=~/\bHuman Beggar\b/) {	#:: 105
				quest::faction(105, $change_amount);
			}
			elsif ($text=~/\bOrc\b/) {	#:: 104
				quest::faction(104, $change_amount);
			}
			elsif ($text=~/\bMinotaur\b/) {	#:: 103
				quest::faction(103, $change_amount);
			}
			elsif ($text=~/\bMimic\b/) {	#:: 102
				quest::faction(102, $change_amount);
			}
			elsif ($text=~/\bLizard Man\b/) {	#:: 101
				quest::faction(101, $change_amount);
			}
			elsif ($text=~/\bLion\b/) {	#:: 100
				quest::faction(100, $change_amount);
			}
			elsif ($text=~/\bLava Dragon\b/) {	#:: 99
				quest::faction(99, $change_amount);
			}
			elsif ($text=~/\bKobold\b/) {	#:: 98
				quest::faction(98, $change_amount);
			}
			elsif ($text=~/\bGriffon\b/) {	#:: 97
				quest::faction(97, $change_amount);
			}
			elsif ($text=~/\bImp\b/) {	#:: 96
				quest::faction(96, $change_amount);
			}
			elsif ($text=~/\bDemi Lich (Race)\b/) {	#:: 95
				quest::faction(95, $change_amount);
			}
			elsif ($text=~/\bHuman Guard (Race)\b/) {	#:: 94
				quest::faction(94, $change_amount);
			}
			elsif ($text=~/\bBear\b/) {	#:: 93
				quest::faction(93, $change_amount);
			}
			elsif ($text=~/\bWolf\b/) {	#:: 92
				quest::faction(92, $change_amount);
			}
			elsif ($text=~/\bGorilla\b/) {	#:: 91
				quest::faction(91, $change_amount);
			}
			elsif ($text=~/\bGoblin\b/) {	#:: 90
				quest::faction(90, $change_amount);
			}
			elsif ($text=~/\bGnoll\b/) {	#:: 89
				quest::faction(89, $change_amount);
			}
			elsif ($text=~/\bKOS\b/) {	#:: 5013
				quest::faction(5013, $change_amount);
			}
			elsif ($text=~/\bKOS_animal\b/) {	#:: 5014
				quest::faction(5014, $change_amount);
			}
			elsif ($text=~/\bCoalition of TradeFolk III\b/) {	#:: 5015
				quest::faction(5015, $change_amount);
			}
			elsif ($text=~/\bSwamp Giants of Kunark\b/) {	#:: 5016
				quest::faction(5016, $change_amount);
			}
			elsif ($text=~/\bGiant Spider\b/) {	#:: 88
				quest::faction(88, $change_amount);
			}
			elsif ($text=~/\bMurrissa Sandwhisper\b/) {	#:: 5017
				quest::faction(5017, $change_amount);
			}
			elsif ($text=~/\bGiant Snake\b/) {	#:: 87
				quest::faction(87, $change_amount);
			}
			elsif ($text=~/\bGiant Rat\b/) {	#:: 86
				quest::faction(86, $change_amount);
			}
			elsif ($text=~/\bMermaids\b/) {	#:: 5018
				quest::faction(5018, $change_amount);
			}
			elsif ($text=~/\bBeta KOS Copy 9\b/) {	#:: 85
				quest::faction(85, $change_amount);
			}
			elsif ($text=~/\bGiant Bat\b/) {	#:: 84
				quest::faction(84, $change_amount);
			}
			elsif ($text=~/\bKing Aythox Thex\b/) {	#:: 5019
				quest::faction(5019, $change_amount);
			}
			elsif ($text=~/\bGhoul\b/) {	#:: 83
				quest::faction(83, $change_amount);
			}
			elsif ($text=~/\bUndead Residents of Kithicor\b/) {	#:: 5020
				quest::faction(5020, $change_amount);
			}
			elsif ($text=~/\bGhost\b/) {	#:: 82
				quest::faction(82, $change_amount);
			}
			elsif ($text=~/\bCleaving Tooth Clan\b/) {	#:: 5021
				quest::faction(5021, $change_amount);
			}
			elsif ($text=~/\bMountain Death Clan\b/) {	#:: 5022
				quest::faction(5022, $change_amount);
			}
			elsif ($text=~/\bGelatinous Cube\b/) {	#:: 81
				quest::faction(81, $change_amount);
			}
			elsif ($text=~/\bRace Faction (80)\b/) {	#:: 80
				quest::faction(80, $change_amount);
			}
			elsif ($text=~/\bGargoyle\b/) {	#:: 79
				quest::faction(79, $change_amount);
			}
			elsif ($text=~/\bFungus Man\b/) {	#:: 78
				quest::faction(78, $change_amount);
			}
			elsif ($text=~/\bFroglok Ghoul\b/) {	#:: 77
				quest::faction(77, $change_amount);
			}
			elsif ($text=~/\bFroglok\b/) {	#:: 76
				quest::faction(76, $change_amount);
			}
			elsif ($text=~/\bFairy (Race)\b/) {	#:: 75
				quest::faction(75, $change_amount);
			}
			elsif ($text=~/\bNoobie Monsters KOS to Guards\b/) {	#:: 5023
				quest::faction(5023, $change_amount);
			}
			elsif ($text=~/\bFish\b/) {	#:: 74
				quest::faction(74, $change_amount);
			}
			elsif ($text=~/\bKerran (Race)\b/) {	#:: 73
				quest::faction(73, $change_amount);
			}
			elsif ($text=~/\bFire Beetle\b/) {	#:: 72
				quest::faction(72, $change_amount);
			}
			elsif ($text=~/\bEvil Eye\b/) {	#:: 71
				quest::faction(71, $change_amount);
			}
			elsif ($text=~/\bVenril Sathir (Race)\b/) {	#:: 70
				quest::faction(70, $change_amount);
			}
			elsif ($text=~/\bTrakanon (Race)\b/) {	#:: 69
				quest::faction(69, $change_amount);
			}
			elsif ($text=~/\bCyclops\b/) {	#:: 68
				quest::faction(68, $change_amount);
			}
			elsif ($text=~/\bClay Golem\b/) {	#:: 67
				quest::faction(67, $change_amount);
			}
			elsif ($text=~/\bCentaur\b/) {	#:: 66
				quest::faction(66, $change_amount);
			}
			elsif ($text=~/\bDeath Fist Orcs\b/) {	#:: 5024
				quest::faction(5024, $change_amount);
			}
			elsif ($text=~/\bBrownies of Faydwer\b/) {	#:: 65
				quest::faction(65, $change_amount);
			}
			elsif ($text=~/\bWerewolf\b/) {	#:: 64
				quest::faction(64, $change_amount);
			}
			elsif ($text=~/\bAviak\b/) {	#:: 63
				quest::faction(63, $change_amount);
			}
			elsif ($text=~/\bGnome\b/) {	#:: 62
				quest::faction(62, $change_amount);
			}
			elsif ($text=~/\bHalfling\b/) {	#:: 61
				quest::faction(61, $change_amount);
			}
			elsif ($text=~/\bOgre\b/) {	#:: 60
				quest::faction(60, $change_amount);
			}
			elsif ($text=~/\bTroll\b/) {	#:: 59
				quest::faction(59, $change_amount);
			}
			elsif ($text=~/\bDwarf\b/) {	#:: 58
				quest::faction(58, $change_amount);
			}
			elsif ($text=~/\bHalf Elf\b/) {	#:: 57
				quest::faction(57, $change_amount);
			}
			elsif ($text=~/\bDark Elf\b/) {	#:: 56
				quest::faction(56, $change_amount);
			}
			elsif ($text=~/\bHigh Elf\b/) {	#:: 55
				quest::faction(55, $change_amount);
			}
			elsif ($text=~/\bWood Elf\b/) {	#:: 54
				quest::faction(54, $change_amount);
			}
			elsif ($text=~/\bKaladim Merchants\b/) {	#:: 5025
				quest::faction(5025, $change_amount);
			}
			elsif ($text=~/\bErudite\b/) {	#:: 53
				quest::faction(53, $change_amount);
			}
			elsif ($text=~/\bBarbarian\b/) {	#:: 52
				quest::faction(52, $change_amount);
			}
			elsif ($text=~/\bHuman\b/) {	#:: 51
				quest::faction(51, $change_amount);
			}
			elsif ($text=~/\bClass50\b/) {	#:: 50
				quest::faction(50, $change_amount);
			}
			elsif ($text=~/\bClass49\b/) {	#:: 49
				quest::faction(49, $change_amount);
			}
			elsif ($text=~/\bClass48\b/) {	#:: 48
				quest::faction(48, $change_amount);
			}
			elsif ($text=~/\bClass47\b/) {	#:: 47
				quest::faction(47, $change_amount);
			}
			elsif ($text=~/\bClass46\b/) {	#:: 46
				quest::faction(46, $change_amount);
			}
			elsif ($text=~/\bClass45\b/) {	#:: 45
				quest::faction(45, $change_amount);
			}
			elsif ($text=~/\bClass44\b/) {	#:: 44
				quest::faction(44, $change_amount);
			}
			elsif ($text=~/\bOgguk Residents\b/) {	#:: 5026
				quest::faction(5026, $change_amount);
			}
			elsif ($text=~/\bClass43\b/) {	#:: 43
				quest::faction(43, $change_amount);
			}
			elsif ($text=~/\bClass42\b/) {	#:: 42
				quest::faction(42, $change_amount);
			}
			elsif ($text=~/\bPhingel Autropos\b/) {	#:: 5027
				quest::faction(5027, $change_amount);
			}
			elsif ($text=~/\bClass41\b/) {	#:: 41
				quest::faction(41, $change_amount);
			}
			elsif ($text=~/\bClass40\b/) {	#:: 40
				quest::faction(40, $change_amount);
			}
			elsif ($text=~/\bClass39\b/) {	#:: 39
				quest::faction(39, $change_amount);
			}
			elsif ($text=~/\bClass38\b/) {	#:: 38
				quest::faction(38, $change_amount);
			}
			elsif ($text=~/\bClass37\b/) {	#:: 37
				quest::faction(37, $change_amount);
			}
			elsif ($text=~/\bSky Talons\b/) {	#:: 5028
				quest::faction(5028, $change_amount);
			}
			elsif ($text=~/\bClass36\b/) {	#:: 36
				quest::faction(36, $change_amount);
			}
			elsif ($text=~/\bClass35\b/) {	#:: 35
				quest::faction(35, $change_amount);
			}
			elsif ($text=~/\bTemple Of Sol Ro\b/) {	#:: 5029
				quest::faction(5029, $change_amount);
			}
			elsif ($text=~/\bClass34\b/) {	#:: 34
				quest::faction(34, $change_amount);
			}
			elsif ($text=~/\bClass33\b/) {	#:: 33
				quest::faction(33, $change_amount);
			}
			elsif ($text=~/\bMerchant\b/) {	#:: 32
				quest::faction(32, $change_amount);
			}
			elsif ($text=~/\bClass31\b/) {	#:: 31
				quest::faction(31, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERENCHANTER\b/) {	#:: 30
				quest::faction(30, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERMAGICIAN\b/) {	#:: 29
				quest::faction(29, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERWIZARD\b/) {	#:: 28
				quest::faction(28, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERNECRO\b/) {	#:: 27
				quest::faction(27, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERSHAMAN\b/) {	#:: 26
				quest::faction(26, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERROGUE\b/) {	#:: 25
				quest::faction(25, $change_amount);
			}
			elsif ($text=~/\bDulaks Clan\b/) {	#:: 5030
				quest::faction(5030, $change_amount);
			}
			elsif ($text=~/\bNeedlite\b/) {	#:: 5031
				quest::faction(5031, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERBARD\b/) {	#:: 24
				quest::faction(24, $change_amount);
			}
			elsif ($text=~/\bIndifferent\b/) {	#:: 5032
				quest::faction(5032, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERMONK\b/) {	#:: 23
				quest::faction(23, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERDRUID\b/) {	#:: 22
				quest::faction(22, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERSK\b/) {	#:: 21
				quest::faction(21, $change_amount);
			}
			elsif ($text=~/\bKOS Plane of Nightmare\b/) {	#:: 5033
				quest::faction(5033, $change_amount);
			}
			elsif ($text=~/\bKOS Plane of Innovation\b/) {	#:: 5034
				quest::faction(5034, $change_amount);
			}
			elsif ($text=~/\bWehateThelin\b/) {	#:: 5035
				quest::faction(5035, $change_amount);
			}
			elsif ($text=~/\bHoHMaiden\b/) {	#:: 5036
				quest::faction(5036, $change_amount);
			}
			elsif ($text=~/\bNadox Clan\b/) {	#:: 5037
				quest::faction(5037, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERRANGER\b/) {	#:: 20
				quest::faction(20, $change_amount);
			}
			elsif ($text=~/\bNitram\b/) {	#:: 5038
				quest::faction(5038, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERPALADIN\b/) {	#:: 19
				quest::faction(19, $change_amount);
			}
			elsif ($text=~/\bResidents of Gloomingdeep\b/) {	#:: 5039
				quest::faction(5039, $change_amount);
			}
			elsif ($text=~/\bMadmen\b/) {	#:: 5040
				quest::faction(5040, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERCLERIC\b/) {	#:: 18
				quest::faction(18, $change_amount);
			}
			elsif ($text=~/\bVillagerRoom\b/) {	#:: 5041
				quest::faction(5041, $change_amount);
			}
			elsif ($text=~/\bGUILDMASTERWARRIOR\b/) {	#:: 17
				quest::faction(17, $change_amount);
			}
			elsif ($text=~/\bBerserker\b/) {	#:: 16
				quest::faction(16, $change_amount);
			}
			elsif ($text=~/\bOmensBatRat\b/) {	#:: 5042
				quest::faction(5042, $change_amount);
			}
			elsif ($text=~/\bNeriak Merchants\b/) {	#:: 5043
				quest::faction(5043, $change_amount);
			}
			elsif ($text=~/\bBeastlord\b/) {	#:: 15
				quest::faction(15, $change_amount);
			}
			elsif ($text=~/\bPlanes_Neutral\b/) {	#:: 5044
				quest::faction(5044, $change_amount);
			}
			elsif ($text=~/\bKOS Plane of Storms\b/) {	#:: 5045
				quest::faction(5045, $change_amount);
			}
			elsif ($text=~/\bPaludal_Mushrooms\b/) {	#:: 5046
				quest::faction(5046, $change_amount);
			}
			elsif ($text=~/\bPaludal_Underbulk\b/) {	#:: 5047
				quest::faction(5047, $change_amount);
			}
			elsif ($text=~/\bThe_Angry_Sambata\b/) {	#:: 5048
				quest::faction(5048, $change_amount);
			}
			elsif ($text=~/\bCrescent Guards\b/) {	#:: 5049
				quest::faction(5049, $change_amount);
			}
			elsif ($text=~/\bEnchanter\b/) {	#:: 14
				quest::faction(14, $change_amount);
			}
			elsif ($text=~/\bMagician\b/) {	#:: 13
				quest::faction(13, $change_amount);
			}
			elsif ($text=~/\bWizard\b/) {	#:: 12
				quest::faction(12, $change_amount);
			}
			elsif ($text=~/\bNecromancer\b/) {	#:: 11
				quest::faction(11, $change_amount);
			}
			elsif ($text=~/\bShaman\b/) {	#:: 10
				quest::faction(10, $change_amount);
			}
			elsif ($text=~/\bRogue\b/) {	#:: 9
				quest::faction(9, $change_amount);
			}
			elsif ($text=~/\bBard\b/) {	#:: 8
				quest::faction(8, $change_amount);
			}
			elsif ($text=~/\bMonk\b/) {	#:: 7
				quest::faction(7, $change_amount);
			}
			elsif ($text=~/\bInvaders of the Moor\b/) {	#:: 5050
				quest::faction(5050, $change_amount);
			}
			elsif ($text=~/\bDruid\b/) {	#:: 6
				quest::faction(6, $change_amount);
			}
			elsif ($text=~/\bShadowKnight\b/) {	#:: 5
				quest::faction(5, $change_amount);
			}
			elsif ($text=~/\bRanger\b/) {	#:: 4
				quest::faction(4, $change_amount);
			}
			elsif ($text=~/\bPaladin\b/) {	#:: 3
				quest::faction(3, $change_amount);
			}
			elsif ($text=~/\bCleric\b/) {	#:: 2
				quest::faction(2, $change_amount);
			}
			elsif ($text=~/\bAsylum of Anguish\b/) {	#:: 5051
				quest::faction(5051, $change_amount);
			}
			elsif ($text=~/\bdubious\b/) {	#:: 5052
				quest::faction(5052, $change_amount);
			}
			elsif ($text=~/\bdubious-storms\b/) {	#:: 5053
				quest::faction(5053, $change_amount);
			}
			elsif ($text=~/\bWarrior\b/) {	#:: 1
				quest::faction(1, $change_amount);
			}
			elsif ($text=~/\bScout_Guke\b/) {	#:: 5054
				quest::faction(5054, $change_amount);
			}
			elsif ($text=~/\bDark_Reign_Guard\b/) {	#:: 5055
				quest::faction(5055, $change_amount);
			}
			elsif ($text=~/\bNoFaction\b/) {	#:: 0
				quest::faction(0, $change_amount);
			}
			elsif ($text=~/\bGrobb Guard\b/) {	#:: 377
				quest::faction(377, $change_amount);
			}
			elsif ($text=~/\bStone Hive Bixies\b/) {	#:: 378
				quest::faction(378, $change_amount);
			}
			elsif ($text=~/\bButcherblock Bandits\b/) {	#:: 379
				quest::faction(379, $change_amount);
			}
			elsif ($text=~/\bWood Elf Bards\b/) {	#:: 380
				quest::faction(380, $change_amount);
			}
			elsif ($text=~/\bTunare's Martyrs 2\b/) {	#:: 381
				quest::faction(381, $change_amount);
			}
			elsif ($text=~/\bKerra Isle\b/) {	#:: 382
				quest::faction(382, $change_amount);
			}
			elsif ($text=~/\bThunder Hooves\b/) {	#:: 383
				quest::faction(383, $change_amount);
			}
			elsif ($text=~/\bFay Scout\b/) {	#:: 384
				quest::faction(384, $change_amount);
			}
			elsif ($text=~/\bDefective Clockwork\b/) {	#:: 385
				quest::faction(385, $change_amount);
			}
			elsif ($text=~/\bUnrest Inhabitants\b/) {	#:: 386
				quest::faction(386, $change_amount);
			}
			elsif ($text=~/\bBefallen Inhabitants\b/) {	#:: 387
				quest::faction(387, $change_amount);
			}
			elsif ($text=~/\bFairie\b/) {	#:: 388
				quest::faction(388, $change_amount);
			}
			elsif ($text=~/\bGolem\b/) {	#:: 389
				quest::faction(389, $change_amount);
			}
			elsif ($text=~/\bNew Combine Guards\b/) {	#:: 390
				quest::faction(390, $change_amount);
			}
			elsif ($text=~/\bNew Combine\b/) {	#:: 391
				quest::faction(391, $change_amount);
			}
			elsif ($text=~/\bFaction392\b/) {	#:: 392
				quest::faction(392, $change_amount);
			}
			elsif ($text=~/\bDjinn\b/) {	#:: 393
				quest::faction(393, $change_amount);
			}
			elsif ($text=~/\bShamen of War\b/) {	#:: 394
				quest::faction(394, $change_amount);
			}
			elsif ($text=~/\bMorawk\b/) {	#:: 395
				quest::faction(395, $change_amount);
			}
			elsif ($text=~/\bAgnostic\b/) {	#:: 396
				quest::faction(396, $change_amount);
			}
			elsif ($text=~/\bSky Talons (good)\b/) {	#:: 397
				quest::faction(397, $change_amount);
			}
			elsif ($text=~/\bRiptide Goblins\b/) {	#:: 398
				quest::faction(398, $change_amount);
			}
			elsif ($text=~/\bSea Furies\b/) {	#:: 399
				quest::faction(399, $change_amount);
			}
			elsif ($text=~/\bCult of Fear\b/) {	#:: 400
				quest::faction(400, $change_amount);
			}
			elsif ($text=~/\bSong Weavers\b/) {	#:: 401
				quest::faction(401, $change_amount);
			}
			elsif ($text=~/\bOracle of K`Arnon\b/) {	#:: 402
				quest::faction(402, $change_amount);
			}
			elsif ($text=~/\bOracle of Marud\b/) {	#:: 403
				quest::faction(403, $change_amount);
			}
			elsif ($text=~/\bTruespirit\b/) {	#:: 404
				quest::faction(404, $change_amount);
			}
			elsif ($text=~/\bDain Frostreaver IV\b/) {	#:: 405
				quest::faction(405, $change_amount);
			}
			elsif ($text=~/\bColdain\b/) {	#:: 406
				quest::faction(406, $change_amount);
			}
			elsif ($text=~/\bRy`Gorr Clan Snow Orcs\b/) {	#:: 407
				quest::faction(407, $change_amount);
			}
			elsif ($text=~/\bFaction408\b/) {	#:: 408
				quest::faction(408, $change_amount);
			}
			elsif ($text=~/\bTserrina Syl`Tor\b/) {	#:: 409
				quest::faction(409, $change_amount);
			}
			elsif ($text=~/\bGuide1\b/) {	#:: 410
				quest::faction(410, $change_amount);
			}
			elsif ($text=~/\bGuide2\b/) {	#:: 411
				quest::faction(411, $change_amount);
			}
			elsif ($text=~/\bKrag\b/) {	#:: 412
				quest::faction(412, $change_amount);
			}
			elsif ($text=~/\bGuide3\b/) {	#:: 413
				quest::faction(413, $change_amount);
			}
			elsif ($text=~/\bResidents of Fear\b/) {	#:: 414
				quest::faction(414, $change_amount);
			}
			elsif ($text=~/\bTemple of Solusek Ro\b/) {	#:: 415
				quest::faction(415, $change_amount);
			}
			elsif ($text=~/\bShadowed Men\b/) {	#:: 416
				quest::faction(416, $change_amount);
			}
			elsif ($text=~/\bAnkhefenmut\b/) {	#:: 417
				quest::faction(417, $change_amount);
			}
			elsif ($text=~/\bZazamoukh\b/) {	#:: 418
				quest::faction(418, $change_amount);
			}
			elsif ($text=~/\bKromrif\b/) {	#:: 419
				quest::faction(419, $change_amount);
			}
			elsif ($text=~/\bFallen of Bloody Kithicor\b/) {	#:: 420
				quest::faction(420, $change_amount);
			}
			elsif ($text=~/\bAggressors of Kithicor\b/) {	#:: 421
				quest::faction(421, $change_amount);
			}
			elsif ($text=~/\bDefenders of Kithicor\b/) {	#:: 422
				quest::faction(422, $change_amount);
			}
			elsif ($text=~/\bVerish Mal\b/) {	#:: 423
				quest::faction(423, $change_amount);
			}
			elsif ($text=~/\bInhabitants of Sky\b/) {	#:: 424
				quest::faction(424, $change_amount);
			}
			elsif ($text=~/\bInhabitants of Hate\b/) {	#:: 425
				quest::faction(425, $change_amount);
			}
			elsif ($text=~/\bAgents of Mistmoore\b/) {	#:: 426
				quest::faction(426, $change_amount);
			}
			elsif ($text=~/\bSpirocs of Timorous\b/) {	#:: 427
				quest::faction(427, $change_amount);
			}
			elsif ($text=~/\bMinions of Underfoot\b/) {	#:: 428
				quest::faction(428, $change_amount);
			}
			elsif ($text=~/\bKing Tormax\b/) {	#:: 429
				quest::faction(429, $change_amount);
			}
			elsif ($text=~/\bClaws of Veeshan\b/) {	#:: 430
				quest::faction(430, $change_amount);
			}
			elsif ($text=~/\bUlthork\b/) {	#:: 431
				quest::faction(431, $change_amount);
			}
			elsif ($text=~/\bOthmir\b/) {	#:: 432
				quest::faction(432, $change_amount);
			}
			elsif ($text=~/\bJaled Dar\b/) {	#:: 433
				quest::faction(433, $change_amount);
			}
			elsif ($text=~/\bSirens of the Grotto\b/) {	#:: 434
				quest::faction(434, $change_amount);
			}
			elsif ($text=~/\bVelketor\b/) {	#:: 435
				quest::faction(435, $change_amount);
			}
			elsif ($text=~/\bYelinak\b/) {	#:: 436
				quest::faction(436, $change_amount);
			}
			elsif ($text=~/\bDenizens of Mischief\b/) {	#:: 437
				quest::faction(437, $change_amount);
			}
			elsif ($text=~/\bServants of Tunare\b/) {	#:: 438
				quest::faction(438, $change_amount);
			}
			elsif ($text=~/\bSnowfang Gnolls\b/) {	#:: 439
				quest::faction(439, $change_amount);
			}
			elsif ($text=~/\bCabilis Residents\b/) {	#:: 440
				quest::faction(440, $change_amount);
			}
			elsif ($text=~/\bLegion of Cabilis\b/) {	#:: 441
				quest::faction(441, $change_amount);
			}
			elsif ($text=~/\bCrusaders of Greenmist\b/) {	#:: 442
				quest::faction(442, $change_amount);
			}
			elsif ($text=~/\bBrood of Kotiz\b/) {	#:: 443
				quest::faction(443, $change_amount);
			}
			elsif ($text=~/\bSwift Tails\b/) {	#:: 444
				quest::faction(444, $change_amount);
			}
			elsif ($text=~/\bScaled Mystics\b/) {	#:: 445
				quest::faction(445, $change_amount);
			}
			elsif ($text=~/\bThe Forsaken\b/) {	#:: 446
				quest::faction(446, $change_amount);
			}
			elsif ($text=~/\bPirates of Iceclad\b/) {	#:: 447
				quest::faction(447, $change_amount);
			}
			elsif ($text=~/\bKromzek\b/) {	#:: 448
				quest::faction(448, $change_amount);
			}
			elsif ($text=~/\bTunarean Court\b/) {	#:: 449
				quest::faction(449, $change_amount);
			}
			elsif ($text=~/\bThrall of Kly\b/) {	#:: 450
				quest::faction(450, $change_amount);
			}
			elsif ($text=~/\bBrood of Di`Zok\b/) {	#:: 451
				quest::faction(451, $change_amount);
			}
			elsif ($text=~/\bThe Hotwingz\b/) {	#:: 452
				quest::faction(452, $change_amount);
			}
			elsif ($text=~/\bCitizens of Torsis\b/) {	#:: 453
				quest::faction(453, $change_amount);
			}
			elsif ($text=~/\bDrusella Sathir\b/) {	#:: 454
				quest::faction(454, $change_amount);
			}
			elsif ($text=~/\bMinions of Scale\b/) {	#:: 455
				quest::faction(455, $change_amount);
			}
			elsif ($text=~/\bGelistial\b/) {	#:: 456
				quest::faction(456, $change_amount);
			}
			elsif ($text=~/\bHolgresh\b/) {	#:: 457
				quest::faction(457, $change_amount);
			}
			elsif ($text=~/\bGeonid Collective\b/) {	#:: 458
				quest::faction(458, $change_amount);
			}
			elsif ($text=~/\bLithiniath\b/) {	#:: 459
				quest::faction(459, $change_amount);
			}
			elsif ($text=~/\bCitizens of Froststone\b/) {	#:: 460
				quest::faction(460, $change_amount);
			}
			elsif ($text=~/\bCrystal Denizens\b/) {	#:: 461
				quest::faction(461, $change_amount);
			}
			elsif ($text=~/\bChetari\b/) {	#:: 462
				quest::faction(462, $change_amount);
			}
			elsif ($text=~/\bPaebala\b/) {	#:: 463
				quest::faction(463, $change_amount);
			}
			elsif ($text=~/\bZlandicar\b/) {	#:: 464
				quest::faction(464, $change_amount);
			}
			elsif ($text=~/\bTizmak Clan\b/) {	#:: 465
				quest::faction(465, $change_amount);
			}
			elsif ($text=~/\bGuardians of the Shrine\b/) {	#:: 466
				quest::faction(466, $change_amount);
			}
			elsif ($text=~/\bGuardians of Veeshan\b/) {	#:: 467
				quest::faction(467, $change_amount);
			}
			elsif ($text=~/\bThe Sleeper\b/) {	#:: 468
				quest::faction(468, $change_amount);
			}
			elsif ($text=~/\bProtectors of Growth\b/) {	#:: 469
				quest::faction(469, $change_amount);
			}
			elsif ($text=~/\bPeoples Republic of Thurgadin\b/) {	#:: 470
				quest::faction(470, $change_amount);
			}
			elsif ($text=~/\bClan Kolbok\b/) {	#:: 471
				quest::faction(471, $change_amount);
			}
			elsif ($text=~/\bWarders of The Claw\b/) {	#:: 472
				quest::faction(472, $change_amount);
			}
			elsif ($text=~/\bKejek Village\b/) {	#:: 473
				quest::faction(473, $change_amount);
			}
			elsif ($text=~/\bSporali\b/) {	#:: 474
				quest::faction(474, $change_amount);
			}
			elsif ($text=~/\bKing Xorbb\b/) {	#:: 475
				quest::faction(475, $change_amount);
			}
			elsif ($text=~/\bBeta Good\b/) {	#:: 476
				quest::faction(476, $change_amount);
			}
			elsif ($text=~/\bBeta Evil\b/) {	#:: 477
				quest::faction(477, $change_amount);
			}
			elsif ($text=~/\bBeta Warmly\b/) {	#:: 478
				quest::faction(478, $change_amount);
			}
			elsif ($text=~/\bBeta KOS\b/) {	#:: 479
				quest::faction(479, $change_amount);
			}
			elsif ($text=~/\bFaction480\b/) {	#:: 480
				quest::faction(480, $change_amount);
			}
			elsif ($text=~/\bFaction481\b/) {	#:: 481
				quest::faction(481, $change_amount);
			}
			elsif ($text=~/\bTribunal (Race)\b/) {	#:: 482
				quest::faction(482, $change_amount);
			}
			elsif ($text=~/\bBertoxxulous (Race)\b/) {	#:: 483
				quest::faction(483, $change_amount);
			}
			elsif ($text=~/\bBristlebane (Race)\b/) {	#:: 484
				quest::faction(484, $change_amount);
			}
			elsif ($text=~/\bFaydrake\b/) {	#:: 485
				quest::faction(485, $change_amount);
			}
			elsif ($text=~/\bSarnak Skeleton\b/) {	#:: 486
				quest::faction(486, $change_amount);
			}
			elsif ($text=~/\bRatman\b/) {	#:: 487
				quest::faction(487, $change_amount);
			}
			elsif ($text=~/\bWyvern\b/) {	#:: 488
				quest::faction(488, $change_amount);
			}
			elsif ($text=~/\bWurm\b/) {	#:: 489
				quest::faction(489, $change_amount);
			}
			elsif ($text=~/\bDevourer\b/) {	#:: 490
				quest::faction(490, $change_amount);
			}
			elsif ($text=~/\bIksar Golem\b/) {	#:: 491
				quest::faction(491, $change_amount);
			}
			elsif ($text=~/\bIksar Skeleton\b/) {	#:: 492
				quest::faction(492, $change_amount);
			}
			elsif ($text=~/\bMan-Eating Plant\b/) {	#:: 493
				quest::faction(493, $change_amount);
			}
			elsif ($text=~/\bRaptor\b/) {	#:: 494
				quest::faction(494, $change_amount);
			}
			elsif ($text=~/\bSarnak Golem\b/) {	#:: 495
				quest::faction(495, $change_amount);
			}
			elsif ($text=~/\bWater Dragon\b/) {	#:: 496
				quest::faction(496, $change_amount);
			}
			elsif ($text=~/\bIksar Hand\b/) {	#:: 497
				quest::faction(497, $change_amount);
			}
			elsif ($text=~/\bCactus Man\b/) {	#:: 498
				quest::faction(498, $change_amount);
			}
			elsif ($text=~/\bFlying Monkey\b/) {	#:: 499
				quest::faction(499, $change_amount);
			}
			elsif ($text=~/\bBrontotherium\b/) {	#:: 500
				quest::faction(500, $change_amount);
			}
			elsif ($text=~/\bSnow Dervish\b/) {	#:: 501
				quest::faction(501, $change_amount);
			}
			elsif ($text=~/\bDire Wolf\b/) {	#:: 502
				quest::faction(502, $change_amount);
			}
			elsif ($text=~/\bManticore\b/) {	#:: 503
				quest::faction(503, $change_amount);
			}
			elsif ($text=~/\bTotem Man\b/) {	#:: 504
				quest::faction(504, $change_amount);
			}
			elsif ($text=~/\bCold Spectre\b/) {	#:: 505
				quest::faction(505, $change_amount);
			}
			elsif ($text=~/\bEnchanted Armor\b/) {	#:: 506
				quest::faction(506, $change_amount);
			}
			elsif ($text=~/\bSnow Bunny\b/) {	#:: 507
				quest::faction(507, $change_amount);
			}
			elsif ($text=~/\bWalrus\b/) {	#:: 508
				quest::faction(508, $change_amount);
			}
			elsif ($text=~/\bRock Gem Man\b/) {	#:: 509
				quest::faction(509, $change_amount);
			}
			elsif ($text=~/\bRace Faction (510)\b/) {	#:: 510
				quest::faction(510, $change_amount);
			}
			elsif ($text=~/\bRace Faction (511)\b/) {	#:: 511
				quest::faction(511, $change_amount);
			}
			elsif ($text=~/\bYakman\b/) {	#:: 512
				quest::faction(512, $change_amount);
			}
			elsif ($text=~/\bFaun\b/) {	#:: 513
				quest::faction(513, $change_amount);
			}
			elsif ($text=~/\bColdain (Race)\b/) {	#:: 514
				quest::faction(514, $change_amount);
			}
			elsif ($text=~/\bVelious Dragon\b/) {	#:: 515
				quest::faction(515, $change_amount);
			}
			elsif ($text=~/\bHag\b/) {	#:: 516
				quest::faction(516, $change_amount);
			}
			elsif ($text=~/\bHippogriff\b/) {	#:: 517
				quest::faction(517, $change_amount);
			}
			elsif ($text=~/\bSiren\b/) {	#:: 518
				quest::faction(518, $change_amount);
			}
			elsif ($text=~/\bFrost Giant\b/) {	#:: 519
				quest::faction(519, $change_amount);
			}
			elsif ($text=~/\bStorm Giant\b/) {	#:: 520
				quest::faction(520, $change_amount);
			}
			elsif ($text=~/\bOtter Man\b/) {	#:: 521
				quest::faction(521, $change_amount);
			}
			elsif ($text=~/\bWalrus Man\b/) {	#:: 522
				quest::faction(522, $change_amount);
			}
			elsif ($text=~/\bClockwork Dragon\b/) {	#:: 523
				quest::faction(523, $change_amount);
			}
			elsif ($text=~/\bAbhorrent\b/) {	#:: 524
				quest::faction(524, $change_amount);
			}
			elsif ($text=~/\bSea Turtle\b/) {	#:: 525
				quest::faction(525, $change_amount);
			}
			elsif ($text=~/\bBandWdragons\b/) {	#:: 526
				quest::faction(526, $change_amount);
			}
			elsif ($text=~/\bGhost Dragon\b/) {	#:: 527
				quest::faction(527, $change_amount);
			}
			elsif ($text=~/\bRace Faction (528)\b/) {	#:: 528
				quest::faction(528, $change_amount);
			}
			elsif ($text=~/\bPrismatic Dragon\b/) {	#:: 529
				quest::faction(529, $change_amount);
			}
			elsif ($text=~/\bShik Nar of Fungus Grove\b/) {	#:: 530
				quest::faction(530, $change_amount);
			}
			elsif ($text=~/\bRockhopper\b/) {	#:: 531
				quest::faction(531, $change_amount);
			}
			elsif ($text=~/\bUnderbulk\b/) {	#:: 532
				quest::faction(532, $change_amount);
			}
			elsif ($text=~/\bGrimling\b/) {	#:: 533
				quest::faction(533, $change_amount);
			}
			elsif ($text=~/\bVacuum Worm\b/) {	#:: 534
				quest::faction(534, $change_amount);
			}
			elsif ($text=~/\bRace Faction (535)\b/) {	#:: 535
				quest::faction(535, $change_amount);
			}
			elsif ($text=~/\bKahli Shah\b/) {	#:: 536
				quest::faction(536, $change_amount);
			}
			elsif ($text=~/\bOwlbear\b/) {	#:: 537
				quest::faction(537, $change_amount);
			}
			elsif ($text=~/\bRhino Beetle\b/) {	#:: 538
				quest::faction(538, $change_amount);
			}
			elsif ($text=~/\bVampyre\b/) {	#:: 539
				quest::faction(539, $change_amount);
			}
			elsif ($text=~/\bEarth Elemental (Race)\b/) {	#:: 540
				quest::faction(540, $change_amount);
			}
			elsif ($text=~/\bAir Elemental (Race)\b/) {	#:: 541
				quest::faction(541, $change_amount);
			}
			elsif ($text=~/\bWater Elemental (Race)\b/) {	#:: 542
				quest::faction(542, $change_amount);
			}
			elsif ($text=~/\bFire Elemental (Race)\b/) {	#:: 543
				quest::faction(543, $change_amount);
			}
			elsif ($text=~/\bWetfang Minnow\b/) {	#:: 544
				quest::faction(544, $change_amount);
			}
			elsif ($text=~/\bThought Horror\b/) {	#:: 545
				quest::faction(545, $change_amount);
			}
			elsif ($text=~/\bTegi\b/) {	#:: 546
				quest::faction(546, $change_amount);
			}
			elsif ($text=~/\bHorse\b/) {	#:: 547
				quest::faction(547, $change_amount);
			}
			elsif ($text=~/\bShissar of Chelsith\b/) {	#:: 548
				quest::faction(548, $change_amount);
			}
			elsif ($text=~/\bFungal Fiend\b/) {	#:: 549
				quest::faction(549, $change_amount);
			}
			elsif ($text=~/\bVampire Volatalis\b/) {	#:: 550
				quest::faction(550, $change_amount);
			}
			elsif ($text=~/\bStonegrabber\b/) {	#:: 551
				quest::faction(551, $change_amount);
			}
			elsif ($text=~/\bScarlet Cheetah\b/) {	#:: 552
				quest::faction(552, $change_amount);
			}
			elsif ($text=~/\bZelniak\b/) {	#:: 553
				quest::faction(553, $change_amount);
			}
			elsif ($text=~/\bLightcrawler\b/) {	#:: 554
				quest::faction(554, $change_amount);
			}
			elsif ($text=~/\bShade\b/) {	#:: 555
				quest::faction(555, $change_amount);
			}
			elsif ($text=~/\bSunflower\b/) {	#:: 556
				quest::faction(556, $change_amount);
			}
			elsif ($text=~/\bSun Revenant\b/) {	#:: 557
				quest::faction(557, $change_amount);
			}
			elsif ($text=~/\bShrieker\b/) {	#:: 558
				quest::faction(558, $change_amount);
			}
			elsif ($text=~/\bGalorian\b/) {	#:: 559
				quest::faction(559, $change_amount);
			}
			elsif ($text=~/\bNetherbian\b/) {	#:: 560
				quest::faction(560, $change_amount);
			}
			elsif ($text=~/\bAkheva (Race Type)\b/) {	#:: 561
				quest::faction(561, $change_amount);
			}
			elsif ($text=~/\bSpire Spirit\b/) {	#:: 562
				quest::faction(562, $change_amount);
			}
			elsif ($text=~/\bSonic Wolf\b/) {	#:: 563
				quest::faction(563, $change_amount);
			}
			elsif ($text=~/\bGround Shaker\b/) {	#:: 564
				quest::faction(564, $change_amount);
			}
			elsif ($text=~/\bVah Shir Skeleton\b/) {	#:: 565
				quest::faction(565, $change_amount);
			}
			elsif ($text=~/\bMutant Humanoid\b/) {	#:: 566
				quest::faction(566, $change_amount);
			}
			elsif ($text=~/\bSeru Race\b/) {	#:: 567
				quest::faction(567, $change_amount);
			}
			elsif ($text=~/\bRecuso\b/) {	#:: 568
				quest::faction(568, $change_amount);
			}
			elsif ($text=~/\bVah Shir King (Race)\b/) {	#:: 569
				quest::faction(569, $change_amount);
			}
			elsif ($text=~/\bVah Shir Guard (Race)\b/) {	#:: 570
				quest::faction(570, $change_amount);
			}
			elsif ($text=~/\bPortal Man (Race)\b/) {	#:: 571
				quest::faction(571, $change_amount);
			}
			elsif ($text=~/\bLujein\b/) {	#:: 572
				quest::faction(572, $change_amount);
			}
			elsif ($text=~/\bPotamide\b/) {	#:: 573
				quest::faction(573, $change_amount);
			}
			elsif ($text=~/\bDryad\b/) {	#:: 574
				quest::faction(574, $change_amount);
			}
			elsif ($text=~/\bEvil Treant\b/) {	#:: 575
				quest::faction(575, $change_amount);
			}
			elsif ($text=~/\bMutant Fly\b/) {	#:: 576
				quest::faction(576, $change_amount);
			}
			elsif ($text=~/\bTarew Marr\b/) {	#:: 577
				quest::faction(577, $change_amount);
			}
			elsif ($text=~/\bSolusek Ro New\b/) {	#:: 578
				quest::faction(578, $change_amount);
			}
			elsif ($text=~/\bClockwork Golem\b/) {	#:: 579
				quest::faction(579, $change_amount);
			}
			elsif ($text=~/\bClockwork Brain\b/) {	#:: 580
				quest::faction(580, $change_amount);
			}
			elsif ($text=~/\bSpectral Banshee\b/) {	#:: 581
				quest::faction(581, $change_amount);
			}
			elsif ($text=~/\bGuard of Justice Race\b/) {	#:: 582
				quest::faction(582, $change_amount);
			}
			elsif ($text=~/\bMischief Castle\b/) {	#:: 583
				quest::faction(583, $change_amount);
			}
			elsif ($text=~/\bDisease Boss\b/) {	#:: 584
				quest::faction(584, $change_amount);
			}
			elsif ($text=~/\bSol Ro Guard\b/) {	#:: 585
				quest::faction(585, $change_amount);
			}
			elsif ($text=~/\bBertoxxulous Race\b/) {	#:: 586
				quest::faction(586, $change_amount);
			}
			elsif ($text=~/\bTribunal Race\b/) {	#:: 587
				quest::faction(587, $change_amount);
			}
			elsif ($text=~/\bTerris-Thule\b/) {	#:: 588
				quest::faction(588, $change_amount);
			}
			elsif ($text=~/\bVegerog\b/) {	#:: 589
				quest::faction(589, $change_amount);
			}
			elsif ($text=~/\bCrocodile\b/) {	#:: 590
				quest::faction(590, $change_amount);
			}
			elsif ($text=~/\bPOP Bat\b/) {	#:: 591
				quest::faction(591, $change_amount);
			}
			elsif ($text=~/\bSlarghilug\b/) {	#:: 592
				quest::faction(592, $change_amount);
			}
			elsif ($text=~/\bTranquilion\b/) {	#:: 593
				quest::faction(593, $change_amount);
			}
			elsif ($text=~/\bTin Soldier\b/) {	#:: 594
				quest::faction(594, $change_amount);
			}
			elsif ($text=~/\bNightmare Wraith\b/) {	#:: 595
				quest::faction(595, $change_amount);
			}
			elsif ($text=~/\bMalarian\b/) {	#:: 596
				quest::faction(596, $change_amount);
			}
			elsif ($text=~/\bKnight of Pestilence\b/) {	#:: 597
				quest::faction(597, $change_amount);
			}
			elsif ($text=~/\bLepertoloth\b/) {	#:: 598
				quest::faction(598, $change_amount);
			}
			elsif ($text=~/\bBubonian Boss\b/) {	#:: 599
				quest::faction(599, $change_amount);
			}
			elsif ($text=~/\bBubonian Underling\b/) {	#:: 600
				quest::faction(600, $change_amount);
			}
			elsif ($text=~/\bPusling\b/) {	#:: 601
				quest::faction(601, $change_amount);
			}
			elsif ($text=~/\bMephit\b/) {	#:: 602
				quest::faction(602, $change_amount);
			}
			elsif ($text=~/\bStormrider\b/) {	#:: 603
				quest::faction(603, $change_amount);
			}
			elsif ($text=~/\bJunk Beast\b/) {	#:: 604
				quest::faction(604, $change_amount);
			}
			elsif ($text=~/\bBroken Clockwork\b/) {	#:: 605
				quest::faction(605, $change_amount);
			}
			elsif ($text=~/\bGiant Clockwork\b/) {	#:: 606
				quest::faction(606, $change_amount);
			}
			elsif ($text=~/\bClockwork Beetle\b/) {	#:: 607
				quest::faction(607, $change_amount);
			}
			elsif ($text=~/\bNightmare Goblin\b/) {	#:: 608
				quest::faction(608, $change_amount);
			}
			elsif ($text=~/\bKarana Race\b/) {	#:: 609
				quest::faction(609, $change_amount);
			}
			elsif ($text=~/\bBlood Raven\b/) {	#:: 610
				quest::faction(610, $change_amount);
			}
			elsif ($text=~/\bNightmare Gargoyle\b/) {	#:: 611
				quest::faction(611, $change_amount);
			}
			elsif ($text=~/\bMouths of Insanity\b/) {	#:: 612
				quest::faction(612, $change_amount);
			}
			elsif ($text=~/\bSkeletal Horse\b/) {	#:: 613
				quest::faction(613, $change_amount);
			}
			elsif ($text=~/\bSaryrn Race\b/) {	#:: 614
				quest::faction(614, $change_amount);
			}
			elsif ($text=~/\bFennin Ro\b/) {	#:: 615
				quest::faction(615, $change_amount);
			}
			elsif ($text=~/\bTormentor\b/) {	#:: 616
				quest::faction(616, $change_amount);
			}
			elsif ($text=~/\bNecromancer Priest\b/) {	#:: 617
				quest::faction(617, $change_amount);
			}
			elsif ($text=~/\bNightmare, Planar\b/) {	#:: 618
				quest::faction(618, $change_amount);
			}
			elsif ($text=~/\bRallos Zek Race Faction\b/) {	#:: 619
				quest::faction(619, $change_amount);
			}
			elsif ($text=~/\bVallon Zek Race Faction\b/) {	#:: 620
				quest::faction(620, $change_amount);
			}
			elsif ($text=~/\bTallon Zek Race Faction\b/) {	#:: 621
				quest::faction(621, $change_amount);
			}
			elsif ($text=~/\bAir Mephit\b/) {	#:: 622
				quest::faction(622, $change_amount);
			}
			elsif ($text=~/\bEarth Mephit\b/) {	#:: 623
				quest::faction(623, $change_amount);
			}
			elsif ($text=~/\bFire Mephit\b/) {	#:: 624
				quest::faction(624, $change_amount);
			}
			elsif ($text=~/\bNightmare Mephit\b/) {	#:: 625
				quest::faction(625, $change_amount);
			}
			elsif ($text=~/\bZebuxoruk\b/) {	#:: 626
				quest::faction(626, $change_amount);
			}
			elsif ($text=~/\bMithaniel Marr (Race)\b/) {	#:: 627
				quest::faction(627, $change_amount);
			}
			elsif ($text=~/\bUndead Knight\b/) {	#:: 628
				quest::faction(628, $change_amount);
			}
			elsif ($text=~/\bThe Rathe\b/) {	#:: 629
				quest::faction(629, $change_amount);
			}
			elsif ($text=~/\bXegony\b/) {	#:: 630
				quest::faction(630, $change_amount);
			}
			elsif ($text=~/\bGreater Fiend\b/) {	#:: 631
				quest::faction(631, $change_amount);
			}
			elsif ($text=~/\bRace Faction (632)\b/) {	#:: 632
				quest::faction(632, $change_amount);
			}
			elsif ($text=~/\bCrab\b/) {	#:: 633
				quest::faction(633, $change_amount);
			}
			elsif ($text=~/\bPhoenix\b/) {	#:: 634
				quest::faction(634, $change_amount);
			}
			elsif ($text=~/\bQuarm (Race)\b/) {	#:: 635
				quest::faction(635, $change_amount);
			}
			elsif ($text=~/\bBear PoP\b/) {	#:: 636
				quest::faction(636, $change_amount);
			}
			elsif ($text=~/\bStorm Taarid\b/) {	#:: 637
				quest::faction(637, $change_amount);
			}
			elsif ($text=~/\bStorm Satuur\b/) {	#:: 638
				quest::faction(638, $change_amount);
			}
			elsif ($text=~/\bStorm Kuraaln\b/) {	#:: 639
				quest::faction(639, $change_amount);
			}
			elsif ($text=~/\bStorm Volaas\b/) {	#:: 640
				quest::faction(640, $change_amount);
			}
			elsif ($text=~/\bStorm Mana\b/) {	#:: 641
				quest::faction(641, $change_amount);
			}
			elsif ($text=~/\bStorm Fire\b/) {	#:: 642
				quest::faction(642, $change_amount);
			}
			elsif ($text=~/\bStorm Celestial\b/) {	#:: 643
				quest::faction(643, $change_amount);
			}
			elsif ($text=~/\bWar Wraith\b/) {	#:: 644
				quest::faction(644, $change_amount);
			}
			elsif ($text=~/\bWrulon\b/) {	#:: 645
				quest::faction(645, $change_amount);
			}
			elsif ($text=~/\bKraken\b/) {	#:: 646
				quest::faction(646, $change_amount);
			}
			elsif ($text=~/\bPoison Frog\b/) {	#:: 647
				quest::faction(647, $change_amount);
			}
			elsif ($text=~/\bQueztocoatal\b/) {	#:: 648
				quest::faction(648, $change_amount);
			}
			elsif ($text=~/\bValorian (War Soldier)\b/) {	#:: 649
				quest::faction(649, $change_amount);
			}
			elsif ($text=~/\bWar Boar\b/) {	#:: 650
				quest::faction(650, $change_amount);
			}
			elsif ($text=~/\bEfreeti PoP\b/) {	#:: 651
				quest::faction(651, $change_amount);
			}
			elsif ($text=~/\bWar Boar Unarmored\b/) {	#:: 652
				quest::faction(652, $change_amount);
			}
			elsif ($text=~/\bBlack Knight\b/) {	#:: 653
				quest::faction(653, $change_amount);
			}
			elsif ($text=~/\bAnimated Armor\b/) {	#:: 654
				quest::faction(654, $change_amount);
			}
			elsif ($text=~/\bUndead Footman\b/) {	#:: 655
				quest::faction(655, $change_amount);
			}
			elsif ($text=~/\bRallos Zek Minion\b/) {	#:: 656
				quest::faction(656, $change_amount);
			}
			elsif ($text=~/\bArachnid - PoP\b/) {	#:: 657
				quest::faction(657, $change_amount);
			}
			elsif ($text=~/\bCrystal Spider (Race)\b/) {	#:: 658
				quest::faction(658, $change_amount);
			}
			elsif ($text=~/\bZebuxoruk's Cage (Race)\b/) {	#:: 659
				quest::faction(659, $change_amount);
			}
			elsif ($text=~/\bBastion of Thunder Portal (Race)\b/) {	#:: 660
				quest::faction(660, $change_amount);
			}
			elsif ($text=~/\bGuktan\b/) {	#:: 661
				quest::faction(661, $change_amount);
			}
			elsif ($text=~/\bTroll Buccaneer\b/) {	#:: 662
				quest::faction(662, $change_amount);
			}
			elsif ($text=~/\bTroll Freebooter\b/) {	#:: 663
				quest::faction(663, $change_amount);
			}
			elsif ($text=~/\bTroll Sea Rover\b/) {	#:: 664
				quest::faction(664, $change_amount);
			}
			elsif ($text=~/\bSpectre Pirate Boss\b/) {	#:: 665
				quest::faction(665, $change_amount);
			}
			elsif ($text=~/\bPirate Boss\b/) {	#:: 666
				quest::faction(666, $change_amount);
			}
			elsif ($text=~/\bPirate Dark Shaman\b/) {	#:: 667
				quest::faction(667, $change_amount);
			}
			elsif ($text=~/\bPirate Officer\b/) {	#:: 668
				quest::faction(668, $change_amount);
			}
			elsif ($text=~/\bGnome Pirate\b/) {	#:: 669
				quest::faction(669, $change_amount);
			}
			elsif ($text=~/\bDark Elf Pirate\b/) {	#:: 670
				quest::faction(670, $change_amount);
			}
			elsif ($text=~/\bOgre Pirate\b/) {	#:: 671
				quest::faction(671, $change_amount);
			}
			elsif ($text=~/\bHuman Pirate\b/) {	#:: 672
				quest::faction(672, $change_amount);
			}
			elsif ($text=~/\bErudite Pirate\b/) {	#:: 673
				quest::faction(673, $change_amount);
			}
			elsif ($text=~/\bPoison Arrow Frog\b/) {	#:: 674
				quest::faction(674, $change_amount);
			}
			elsif ($text=~/\bTroll Zombie\b/) {	#:: 675
				quest::faction(675, $change_amount);
			}
			elsif ($text=~/\bLuggald\b/) {	#:: 676
				quest::faction(676, $change_amount);
			}
			elsif ($text=~/\bLuggald Armored\b/) {	#:: 677
				quest::faction(677, $change_amount);
			}
			elsif ($text=~/\bLuggald Robed\b/) {	#:: 678
				quest::faction(678, $change_amount);
			}
			elsif ($text=~/\bDrogmor (Race)\b/) {	#:: 679
				quest::faction(679, $change_amount);
			}
			elsif ($text=~/\bDream Delvers\b/) {	#:: 680
				quest::faction(680, $change_amount);
			}
			elsif ($text=~/\bBeta Ally\b/) {	#:: 681
				quest::faction(681, $change_amount);
			}
			elsif ($text=~/\bBeta Warmly\b/) {	#:: 682
				quest::faction(682, $change_amount);
			}
			elsif ($text=~/\bBeta Kindly\b/) {	#:: 683
				quest::faction(683, $change_amount);
			}
			elsif ($text=~/\bBeta Amiable\b/) {	#:: 684
				quest::faction(684, $change_amount);
			}
			elsif ($text=~/\bBeta Apprehensive\b/) {	#:: 685
				quest::faction(685, $change_amount);
			}
			elsif ($text=~/\bBeta Dubious\b/) {	#:: 686
				quest::faction(686, $change_amount);
			}
			elsif ($text=~/\bBeta Threatening\b/) {	#:: 687
				quest::faction(687, $change_amount);
			}
			elsif ($text=~/\bShissar (Race)\b/) {	#:: 688
				quest::faction(688, $change_amount);
			}
			elsif ($text=~/\bShik Nar (Race)\b/) {	#:: 689
				quest::faction(689, $change_amount);
			}
			elsif ($text=~/\bShik Nar of Mons Letalis\b/) {	#:: 690
				quest::faction(690, $change_amount);
			}
			elsif ($text=~/\bBrownie (Race)\b/) {	#:: 691
				quest::faction(691, $change_amount);
			}
			elsif ($text=~/\bPixie (Race)\b/) {	#:: 692
				quest::faction(692, $change_amount);
			}
			elsif ($text=~/\bQeynos Citizen (Race)\b/) {	#:: 693
				quest::faction(693, $change_amount);
			}
			elsif ($text=~/\bErudite Citizen (Race)\b/) {	#:: 694
				quest::faction(694, $change_amount);
			}
			elsif ($text=~/\bClockwork Gnome (Race)\b/) {	#:: 695
				quest::faction(695, $change_amount);
			}
			elsif ($text=~/\bKaladim Citizen (Race)\b/) {	#:: 696
				quest::faction(696, $change_amount);
			}
			elsif ($text=~/\bFaction697\b/) {	#:: 697
				quest::faction(697, $change_amount);
			}
			elsif ($text=~/\bFaction698\b/) {	#:: 698
				quest::faction(698, $change_amount);
			}
			elsif ($text=~/\bFaction699\b/) {	#:: 699
				quest::faction(699, $change_amount);
			}
			elsif ($text=~/\bMercenary Coalition\b/) {	#:: 700
				quest::faction(700, $change_amount);
			}
			elsif ($text=~/\bBeta KOS Copy 1\b/) {	#:: 701
				quest::faction(701, $change_amount);
			}
			elsif ($text=~/\bBeta KOS Copy 2\b/) {	#:: 702
				quest::faction(702, $change_amount);
			}
			elsif ($text=~/\bBeta KOS Copy 3\b/) {	#:: 703
				quest::faction(703, $change_amount);
			}
			elsif ($text=~/\bBeta KOS Copy 4\b/) {	#:: 704
				quest::faction(704, $change_amount);
			}
			elsif ($text=~/\bBeta KOS Copy 5\b/) {	#:: 705
				quest::faction(705, $change_amount);
			}
			elsif ($text=~/\bBeta KOS Copy 6\b/) {	#:: 706
				quest::faction(706, $change_amount);
			}
			elsif ($text=~/\bBeta KOS Copy 7\b/) {	#:: 707
				quest::faction(707, $change_amount);
			}
			elsif ($text=~/\bBeta KOS Copy 8\b/) {	#:: 708
				quest::faction(708, $change_amount);
			}
			elsif ($text=~/\bThe Yendan\b/) {	#:: 709
				quest::faction(709, $change_amount);
			}
			elsif ($text=~/\bGuardians of War\b/) {	#:: 710
				quest::faction(710, $change_amount);
			}
			elsif ($text=~/\bCastle Rulnavis\b/) {	#:: 711
				quest::faction(711, $change_amount);
			}
			elsif ($text=~/\bCastle Tamrel\b/) {	#:: 712
				quest::faction(712, $change_amount);
			}
			elsif ($text=~/\bSoldiers of Tallon\b/) {	#:: 713
				quest::faction(713, $change_amount);
			}
			elsif ($text=~/\bSoldiers of Vallon\b/) {	#:: 714
				quest::faction(714, $change_amount);
			}
			elsif ($text=~/\bInhabitants of Rulnavis\b/) {	#:: 715
				quest::faction(715, $change_amount);
			}
			elsif ($text=~/\bInhabitants of Tamrel\b/) {	#:: 716
				quest::faction(716, $change_amount);
			}
			elsif ($text=~/\bKeepers of Narikor\b/) {	#:: 717
				quest::faction(717, $change_amount);
			}
			elsif ($text=~/\bThe Disgraced\b/) {	#:: 718
				quest::faction(718, $change_amount);
			}
			elsif ($text=~/\bMinions of Rot\b/) {	#:: 719
				quest::faction(719, $change_amount);
			}
			elsif ($text=~/\bMemorial Gnomelike\b/) {	#:: 720
				quest::faction(720, $change_amount);
			}
			elsif ($text=~/\bIron Legion\b/) {	#:: 721
				quest::faction(721, $change_amount);
			}
			elsif ($text=~/\bFaction722\b/) {	#:: 722
				quest::faction(722, $change_amount);
			}
			elsif ($text=~/\bFaction723\b/) {	#:: 723
				quest::faction(723, $change_amount);
			}
			elsif ($text=~/\bFaction724\b/) {	#:: 724
				quest::faction(724, $change_amount);
			}
			elsif ($text=~/\bFaction725\b/) {	#:: 725
				quest::faction(725, $change_amount);
			}
			elsif ($text=~/\bFaction726\b/) {	#:: 726
				quest::faction(726, $change_amount);
			}
			elsif ($text=~/\bFaction727\b/) {	#:: 727
				quest::faction(727, $change_amount);
			}
			elsif ($text=~/\bFaction728\b/) {	#:: 728
				quest::faction(728, $change_amount);
			}
			elsif ($text=~/\bFaction729\b/) {	#:: 729
				quest::faction(729, $change_amount);
			}
			elsif ($text=~/\bFaction730\b/) {	#:: 730
				quest::faction(730, $change_amount);
			}
			elsif ($text=~/\bFaction731\b/) {	#:: 731
				quest::faction(731, $change_amount);
			}
			elsif ($text=~/\bFaction732\b/) {	#:: 732
				quest::faction(732, $change_amount);
			}
			elsif ($text=~/\bFaction733\b/) {	#:: 733
				quest::faction(733, $change_amount);
			}
			elsif ($text=~/\bFaction734\b/) {	#:: 734
				quest::faction(734, $change_amount);
			}
			elsif ($text=~/\bFaction735\b/) {	#:: 735
				quest::faction(735, $change_amount);
			}
			elsif ($text=~/\bFaction736\b/) {	#:: 736
				quest::faction(736, $change_amount);
			}
			elsif ($text=~/\bFaction737\b/) {	#:: 737
				quest::faction(737, $change_amount);
			}
			elsif ($text=~/\bFaction738\b/) {	#:: 738
				quest::faction(738, $change_amount);
			}
			elsif ($text=~/\bFaction739\b/) {	#:: 739
				quest::faction(739, $change_amount);
			}
			elsif ($text=~/\bFaction740\b/) {	#:: 740
				quest::faction(740, $change_amount);
			}
			elsif ($text=~/\bFaction741\b/) {	#:: 741
				quest::faction(741, $change_amount);
			}
			elsif ($text=~/\bFaction742\b/) {	#:: 742
				quest::faction(742, $change_amount);
			}
			elsif ($text=~/\bFaction743\b/) {	#:: 743
				quest::faction(743, $change_amount);
			}
			elsif ($text=~/\bFaction744\b/) {	#:: 744
				quest::faction(744, $change_amount);
			}
			elsif ($text=~/\bFaction745\b/) {	#:: 745
				quest::faction(745, $change_amount);
			}
			elsif ($text=~/\bFaction746\b/) {	#:: 746
				quest::faction(746, $change_amount);
			}
			elsif ($text=~/\bFaction747\b/) {	#:: 747
				quest::faction(747, $change_amount);
			}
			elsif ($text=~/\bFaction748\b/) {	#:: 748
				quest::faction(748, $change_amount);
			}
			elsif ($text=~/\bFaction749\b/) {	#:: 749
				quest::faction(749, $change_amount);
			}
			elsif ($text=~/\bFaction750\b/) {	#:: 750
				quest::faction(750, $change_amount);
			}
			elsif ($text=~/\bFaction751\b/) {	#:: 751
				quest::faction(751, $change_amount);
			}
			elsif ($text=~/\bFaction752\b/) {	#:: 752
				quest::faction(752, $change_amount);
			}
			elsif ($text=~/\bFaction753\b/) {	#:: 753
				quest::faction(753, $change_amount);
			}
			elsif ($text=~/\bFaction754\b/) {	#:: 754
				quest::faction(754, $change_amount);
			}
			elsif ($text=~/\bFaction755\b/) {	#:: 755
				quest::faction(755, $change_amount);
			}
			elsif ($text=~/\bFaction756\b/) {	#:: 756
				quest::faction(756, $change_amount);
			}
			elsif ($text=~/\bFaction757\b/) {	#:: 757
				quest::faction(757, $change_amount);
			}
			elsif ($text=~/\bFaction758\b/) {	#:: 758
				quest::faction(758, $change_amount);
			}
			elsif ($text=~/\bFaction759\b/) {	#:: 759
				quest::faction(759, $change_amount);
			}
			elsif ($text=~/\bFaction760\b/) {	#:: 760
				quest::faction(760, $change_amount);
			}
			elsif ($text=~/\bFaction761\b/) {	#:: 761
				quest::faction(761, $change_amount);
			}
			elsif ($text=~/\bFaction762\b/) {	#:: 762
				quest::faction(762, $change_amount);
			}
			elsif ($text=~/\bFaction763\b/) {	#:: 763
				quest::faction(763, $change_amount);
			}
			elsif ($text=~/\bFaction764\b/) {	#:: 764
				quest::faction(764, $change_amount);
			}
			elsif ($text=~/\bFaction765\b/) {	#:: 765
				quest::faction(765, $change_amount);
			}
			elsif ($text=~/\bFaction766\b/) {	#:: 766
				quest::faction(766, $change_amount);
			}
			elsif ($text=~/\bFaction767\b/) {	#:: 767
				quest::faction(767, $change_amount);
			}
			elsif ($text=~/\bFaction768\b/) {	#:: 768
				quest::faction(768, $change_amount);
			}
			elsif ($text=~/\bFaction769\b/) {	#:: 769
				quest::faction(769, $change_amount);
			}
			elsif ($text=~/\bFaction770\b/) {	#:: 770
				quest::faction(770, $change_amount);
			}
			elsif ($text=~/\bFaction771\b/) {	#:: 771
				quest::faction(771, $change_amount);
			}
			elsif ($text=~/\bFaction772\b/) {	#:: 772
				quest::faction(772, $change_amount);
			}
			elsif ($text=~/\bFaction773\b/) {	#:: 773
				quest::faction(773, $change_amount);
			}
			elsif ($text=~/\bFaction774\b/) {	#:: 774
				quest::faction(774, $change_amount);
			}
			elsif ($text=~/\bFaction775\b/) {	#:: 775
				quest::faction(775, $change_amount);
			}
			elsif ($text=~/\bFaction776\b/) {	#:: 776
				quest::faction(776, $change_amount);
			}
			elsif ($text=~/\bFaction777\b/) {	#:: 777
				quest::faction(777, $change_amount);
			}
			elsif ($text=~/\bFaction778\b/) {	#:: 778
				quest::faction(778, $change_amount);
			}
			elsif ($text=~/\bFaction779\b/) {	#:: 779
				quest::faction(779, $change_amount);
			}
			elsif ($text=~/\bFaction780\b/) {	#:: 780
				quest::faction(780, $change_amount);
			}
			elsif ($text=~/\bFaction781\b/) {	#:: 781
				quest::faction(781, $change_amount);
			}
			elsif ($text=~/\bFaction782\b/) {	#:: 782
				quest::faction(782, $change_amount);
			}
			elsif ($text=~/\bFaction783\b/) {	#:: 783
				quest::faction(783, $change_amount);
			}
			elsif ($text=~/\bFaction784\b/) {	#:: 784
				quest::faction(784, $change_amount);
			}
			elsif ($text=~/\bFaction785\b/) {	#:: 785
				quest::faction(785, $change_amount);
			}
			elsif ($text=~/\bFaction786\b/) {	#:: 786
				quest::faction(786, $change_amount);
			}
			elsif ($text=~/\bFaction787\b/) {	#:: 787
				quest::faction(787, $change_amount);
			}
			elsif ($text=~/\bFaction788\b/) {	#:: 788
				quest::faction(788, $change_amount);
			}
			elsif ($text=~/\bFaction789\b/) {	#:: 789
				quest::faction(789, $change_amount);
			}
			elsif ($text=~/\bFaction790\b/) {	#:: 790
				quest::faction(790, $change_amount);
			}
			elsif ($text=~/\bFaction791\b/) {	#:: 791
				quest::faction(791, $change_amount);
			}
			elsif ($text=~/\bFaction792\b/) {	#:: 792
				quest::faction(792, $change_amount);
			}
			elsif ($text=~/\bFaction793\b/) {	#:: 793
				quest::faction(793, $change_amount);
			}
			elsif ($text=~/\bFaction794\b/) {	#:: 794
				quest::faction(794, $change_amount);
			}
			elsif ($text=~/\bFaction795\b/) {	#:: 795
				quest::faction(795, $change_amount);
			}
			elsif ($text=~/\bFaction796\b/) {	#:: 796
				quest::faction(796, $change_amount);
			}
			elsif ($text=~/\bFaction797\b/) {	#:: 797
				quest::faction(797, $change_amount);
			}
			elsif ($text=~/\bFaction798\b/) {	#:: 798
				quest::faction(798, $change_amount);
			}
			elsif ($text=~/\bFaction799\b/) {	#:: 799
				quest::faction(799, $change_amount);
			}
			elsif ($text=~/\bFaction800\b/) {	#:: 800
				quest::faction(800, $change_amount);
			}
			elsif ($text=~/\bFaction801\b/) {	#:: 801
				quest::faction(801, $change_amount);
			}
			elsif ($text=~/\bFaction802\b/) {	#:: 802
				quest::faction(802, $change_amount);
			}
			elsif ($text=~/\bFaction803\b/) {	#:: 803
				quest::faction(803, $change_amount);
			}
			elsif ($text=~/\bFaction804\b/) {	#:: 804
				quest::faction(804, $change_amount);
			}
			elsif ($text=~/\bFaction805\b/) {	#:: 805
				quest::faction(805, $change_amount);
			}
			elsif ($text=~/\bFaction806\b/) {	#:: 806
				quest::faction(806, $change_amount);
			}
			elsif ($text=~/\bFaction807\b/) {	#:: 807
				quest::faction(807, $change_amount);
			}
			elsif ($text=~/\bFaction808\b/) {	#:: 808
				quest::faction(808, $change_amount);
			}
			elsif ($text=~/\bFaction809\b/) {	#:: 809
				quest::faction(809, $change_amount);
			}
			elsif ($text=~/\bFaction810\b/) {	#:: 810
				quest::faction(810, $change_amount);
			}
			elsif ($text=~/\bFaction811\b/) {	#:: 811
				quest::faction(811, $change_amount);
			}
			elsif ($text=~/\bFaction812\b/) {	#:: 812
				quest::faction(812, $change_amount);
			}
			elsif ($text=~/\bFaction813\b/) {	#:: 813
				quest::faction(813, $change_amount);
			}
			elsif ($text=~/\bFaction814\b/) {	#:: 814
				quest::faction(814, $change_amount);
			}
			elsif ($text=~/\bFaction815\b/) {	#:: 815
				quest::faction(815, $change_amount);
			}
			elsif ($text=~/\bFaction816\b/) {	#:: 816
				quest::faction(816, $change_amount);
			}
			elsif ($text=~/\bFaction817\b/) {	#:: 817
				quest::faction(817, $change_amount);
			}
			elsif ($text=~/\bFaction818\b/) {	#:: 818
				quest::faction(818, $change_amount);
			}
			elsif ($text=~/\bFaction819\b/) {	#:: 819
				quest::faction(819, $change_amount);
			}
			elsif ($text=~/\bFaction820\b/) {	#:: 820
				quest::faction(820, $change_amount);
			}
			elsif ($text=~/\bFaction821\b/) {	#:: 821
				quest::faction(821, $change_amount);
			}
			elsif ($text=~/\bFaction822\b/) {	#:: 822
				quest::faction(822, $change_amount);
			}
			elsif ($text=~/\bFaction823\b/) {	#:: 823
				quest::faction(823, $change_amount);
			}
			elsif ($text=~/\bFaction824\b/) {	#:: 824
				quest::faction(824, $change_amount);
			}
			elsif ($text=~/\bFaction825\b/) {	#:: 825
				quest::faction(825, $change_amount);
			}
			elsif ($text=~/\bFaction826\b/) {	#:: 826
				quest::faction(826, $change_amount);
			}
			elsif ($text=~/\bFaction827\b/) {	#:: 827
				quest::faction(827, $change_amount);
			}
			elsif ($text=~/\bFaction828\b/) {	#:: 828
				quest::faction(828, $change_amount);
			}
			elsif ($text=~/\bFaction829\b/) {	#:: 829
				quest::faction(829, $change_amount);
			}
			elsif ($text=~/\bFaction830\b/) {	#:: 830
				quest::faction(830, $change_amount);
			}
			elsif ($text=~/\bFaction831\b/) {	#:: 831
				quest::faction(831, $change_amount);
			}
			elsif ($text=~/\bFaction832\b/) {	#:: 832
				quest::faction(832, $change_amount);
			}
			elsif ($text=~/\bFaction833\b/) {	#:: 833
				quest::faction(833, $change_amount);
			}
			elsif ($text=~/\bFaction834\b/) {	#:: 834
				quest::faction(834, $change_amount);
			}
			elsif ($text=~/\bFaction835\b/) {	#:: 835
				quest::faction(835, $change_amount);
			}
			elsif ($text=~/\bFaction836\b/) {	#:: 836
				quest::faction(836, $change_amount);
			}
			elsif ($text=~/\bFaction837\b/) {	#:: 837
				quest::faction(837, $change_amount);
			}
			elsif ($text=~/\bFaction838\b/) {	#:: 838
				quest::faction(838, $change_amount);
			}
			elsif ($text=~/\bFaction839\b/) {	#:: 839
				quest::faction(839, $change_amount);
			}
			elsif ($text=~/\bFaction840\b/) {	#:: 840
				quest::faction(840, $change_amount);
			}
			elsif ($text=~/\bFaction841\b/) {	#:: 841
				quest::faction(841, $change_amount);
			}
			elsif ($text=~/\bFaction842\b/) {	#:: 842
				quest::faction(842, $change_amount);
			}
			elsif ($text=~/\bFaction843\b/) {	#:: 843
				quest::faction(843, $change_amount);
			}
			elsif ($text=~/\bFaction844\b/) {	#:: 844
				quest::faction(844, $change_amount);
			}
			elsif ($text=~/\bFaction845\b/) {	#:: 845
				quest::faction(845, $change_amount);
			}
			elsif ($text=~/\bFaction846\b/) {	#:: 846
				quest::faction(846, $change_amount);
			}
			elsif ($text=~/\bFaction847\b/) {	#:: 847
				quest::faction(847, $change_amount);
			}
			elsif ($text=~/\bFaction848\b/) {	#:: 848
				quest::faction(848, $change_amount);
			}
			elsif ($text=~/\bFaction849\b/) {	#:: 849
				quest::faction(849, $change_amount);
			}
			elsif ($text=~/\bFaction850\b/) {	#:: 850
				quest::faction(850, $change_amount);
			}
			elsif ($text=~/\bFaction851\b/) {	#:: 851
				quest::faction(851, $change_amount);
			}
			elsif ($text=~/\bFaction852\b/) {	#:: 852
				quest::faction(852, $change_amount);
			}
			elsif ($text=~/\bFaction853\b/) {	#:: 853
				quest::faction(853, $change_amount);
			}
			elsif ($text=~/\bFaction854\b/) {	#:: 854
				quest::faction(854, $change_amount);
			}
			elsif ($text=~/\bFaction855\b/) {	#:: 855
				quest::faction(855, $change_amount);
			}
			elsif ($text=~/\bFaction856\b/) {	#:: 856
				quest::faction(856, $change_amount);
			}
			elsif ($text=~/\bFaction857\b/) {	#:: 857
				quest::faction(857, $change_amount);
			}
			elsif ($text=~/\bFaction858\b/) {	#:: 858
				quest::faction(858, $change_amount);
			}
			elsif ($text=~/\bFaction859\b/) {	#:: 859
				quest::faction(859, $change_amount);
			}
			elsif ($text=~/\bFaction860\b/) {	#:: 860
				quest::faction(860, $change_amount);
			}
			elsif ($text=~/\bFaction861\b/) {	#:: 861
				quest::faction(861, $change_amount);
			}
			elsif ($text=~/\bFaction862\b/) {	#:: 862
				quest::faction(862, $change_amount);
			}
			elsif ($text=~/\bFaction863\b/) {	#:: 863
				quest::faction(863, $change_amount);
			}
			elsif ($text=~/\bFaction864\b/) {	#:: 864
				quest::faction(864, $change_amount);
			}
			elsif ($text=~/\bFaction865\b/) {	#:: 865
				quest::faction(865, $change_amount);
			}
			elsif ($text=~/\bFaction866\b/) {	#:: 866
				quest::faction(866, $change_amount);
			}
			elsif ($text=~/\bFaction867\b/) {	#:: 867
				quest::faction(867, $change_amount);
			}
			elsif ($text=~/\bFaction868\b/) {	#:: 868
				quest::faction(868, $change_amount);
			}
			elsif ($text=~/\bFaction869\b/) {	#:: 869
				quest::faction(869, $change_amount);
			}
			elsif ($text=~/\bFaction870\b/) {	#:: 870
				quest::faction(870, $change_amount);
			}
			elsif ($text=~/\bFaction871\b/) {	#:: 871
				quest::faction(871, $change_amount);
			}
			elsif ($text=~/\bFaction872\b/) {	#:: 872
				quest::faction(872, $change_amount);
			}
			elsif ($text=~/\bFaction873\b/) {	#:: 873
				quest::faction(873, $change_amount);
			}
			elsif ($text=~/\bFaction874\b/) {	#:: 874
				quest::faction(874, $change_amount);
			}
			elsif ($text=~/\bFaction875\b/) {	#:: 875
				quest::faction(875, $change_amount);
			}
			elsif ($text=~/\bFaction876\b/) {	#:: 876
				quest::faction(876, $change_amount);
			}
			elsif ($text=~/\bFaction877\b/) {	#:: 877
				quest::faction(877, $change_amount);
			}
			elsif ($text=~/\bFaction878\b/) {	#:: 878
				quest::faction(878, $change_amount);
			}
			elsif ($text=~/\bFaction879\b/) {	#:: 879
				quest::faction(879, $change_amount);
			}
			elsif ($text=~/\bFaction880\b/) {	#:: 880
				quest::faction(880, $change_amount);
			}
			elsif ($text=~/\bFaction881\b/) {	#:: 881
				quest::faction(881, $change_amount);
			}
			elsif ($text=~/\bFaction882\b/) {	#:: 882
				quest::faction(882, $change_amount);
			}
			elsif ($text=~/\bFaction883\b/) {	#:: 883
				quest::faction(883, $change_amount);
			}
			elsif ($text=~/\bFaction884\b/) {	#:: 884
				quest::faction(884, $change_amount);
			}
			elsif ($text=~/\bFaction885\b/) {	#:: 885
				quest::faction(885, $change_amount);
			}
			elsif ($text=~/\bFaction886\b/) {	#:: 886
				quest::faction(886, $change_amount);
			}
			elsif ($text=~/\bFaction887\b/) {	#:: 887
				quest::faction(887, $change_amount);
			}
			elsif ($text=~/\bFaction888\b/) {	#:: 888
				quest::faction(888, $change_amount);
			}
			elsif ($text=~/\bFaction889\b/) {	#:: 889
				quest::faction(889, $change_amount);
			}
			elsif ($text=~/\bFaction890\b/) {	#:: 890
				quest::faction(890, $change_amount);
			}
			elsif ($text=~/\bFaction891\b/) {	#:: 891
				quest::faction(891, $change_amount);
			}
			elsif ($text=~/\bFaction892\b/) {	#:: 892
				quest::faction(892, $change_amount);
			}
			elsif ($text=~/\bFaction893\b/) {	#:: 893
				quest::faction(893, $change_amount);
			}
			elsif ($text=~/\bFaction894\b/) {	#:: 894
				quest::faction(894, $change_amount);
			}
			elsif ($text=~/\bFaction895\b/) {	#:: 895
				quest::faction(895, $change_amount);
			}
			elsif ($text=~/\bFaction896\b/) {	#:: 896
				quest::faction(896, $change_amount);
			}
			elsif ($text=~/\bFaction897\b/) {	#:: 897
				quest::faction(897, $change_amount);
			}
			elsif ($text=~/\bFaction898\b/) {	#:: 898
				quest::faction(898, $change_amount);
			}
			elsif ($text=~/\bFaction899\b/) {	#:: 899
				quest::faction(899, $change_amount);
			}
			elsif ($text=~/\bFaction900\b/) {	#:: 900
				quest::faction(900, $change_amount);
			}
			elsif ($text=~/\bFaction901\b/) {	#:: 901
				quest::faction(901, $change_amount);
			}
			elsif ($text=~/\bFaction902\b/) {	#:: 902
				quest::faction(902, $change_amount);
			}
			elsif ($text=~/\bFaction903\b/) {	#:: 903
				quest::faction(903, $change_amount);
			}
			elsif ($text=~/\bFaction904\b/) {	#:: 904
				quest::faction(904, $change_amount);
			}
			elsif ($text=~/\bFaction905\b/) {	#:: 905
				quest::faction(905, $change_amount);
			}
			elsif ($text=~/\bFaction906\b/) {	#:: 906
				quest::faction(906, $change_amount);
			}
			elsif ($text=~/\bFaction907\b/) {	#:: 907
				quest::faction(907, $change_amount);
			}
			elsif ($text=~/\bFaction908\b/) {	#:: 908
				quest::faction(908, $change_amount);
			}
			elsif ($text=~/\bFaction909\b/) {	#:: 909
				quest::faction(909, $change_amount);
			}
			elsif ($text=~/\bFaction910\b/) {	#:: 910
				quest::faction(910, $change_amount);
			}
			elsif ($text=~/\bFaction911\b/) {	#:: 911
				quest::faction(911, $change_amount);
			}
			elsif ($text=~/\bFaction912\b/) {	#:: 912
				quest::faction(912, $change_amount);
			}
			elsif ($text=~/\bFaction913\b/) {	#:: 913
				quest::faction(913, $change_amount);
			}
			elsif ($text=~/\bFaction914\b/) {	#:: 914
				quest::faction(914, $change_amount);
			}
			elsif ($text=~/\bFaction915\b/) {	#:: 915
				quest::faction(915, $change_amount);
			}
			elsif ($text=~/\bFaction916\b/) {	#:: 916
				quest::faction(916, $change_amount);
			}
			elsif ($text=~/\bFaction917\b/) {	#:: 917
				quest::faction(917, $change_amount);
			}
			elsif ($text=~/\bFaction918\b/) {	#:: 918
				quest::faction(918, $change_amount);
			}
			elsif ($text=~/\bFaction919\b/) {	#:: 919
				quest::faction(919, $change_amount);
			}
			elsif ($text=~/\bFaction920\b/) {	#:: 920
				quest::faction(920, $change_amount);
			}
			elsif ($text=~/\bFaction921\b/) {	#:: 921
				quest::faction(921, $change_amount);
			}
			elsif ($text=~/\bFaction922\b/) {	#:: 922
				quest::faction(922, $change_amount);
			}
			elsif ($text=~/\bFaction923\b/) {	#:: 923
				quest::faction(923, $change_amount);
			}
			elsif ($text=~/\bFaction924\b/) {	#:: 924
				quest::faction(924, $change_amount);
			}
			elsif ($text=~/\bFaction925\b/) {	#:: 925
				quest::faction(925, $change_amount);
			}
			elsif ($text=~/\bFaction926\b/) {	#:: 926
				quest::faction(926, $change_amount);
			}
			elsif ($text=~/\bFaction927\b/) {	#:: 927
				quest::faction(927, $change_amount);
			}
			elsif ($text=~/\bFaction928\b/) {	#:: 928
				quest::faction(928, $change_amount);
			}
			elsif ($text=~/\bFaction929\b/) {	#:: 929
				quest::faction(929, $change_amount);
			}
			elsif ($text=~/\bFaction930\b/) {	#:: 930
				quest::faction(930, $change_amount);
			}
			elsif ($text=~/\bFaction931\b/) {	#:: 931
				quest::faction(931, $change_amount);
			}
			elsif ($text=~/\bFaction932\b/) {	#:: 932
				quest::faction(932, $change_amount);
			}
			elsif ($text=~/\bFaction933\b/) {	#:: 933
				quest::faction(933, $change_amount);
			}
			elsif ($text=~/\bFaction934\b/) {	#:: 934
				quest::faction(934, $change_amount);
			}
			elsif ($text=~/\bFaction935\b/) {	#:: 935
				quest::faction(935, $change_amount);
			}
			elsif ($text=~/\bFaction936\b/) {	#:: 936
				quest::faction(936, $change_amount);
			}
			elsif ($text=~/\bFaction937\b/) {	#:: 937
				quest::faction(937, $change_amount);
			}
			elsif ($text=~/\bFaction938\b/) {	#:: 938
				quest::faction(938, $change_amount);
			}
			elsif ($text=~/\bFaction939\b/) {	#:: 939
				quest::faction(939, $change_amount);
			}
			elsif ($text=~/\bFaction940\b/) {	#:: 940
				quest::faction(940, $change_amount);
			}
			elsif ($text=~/\bFaction941\b/) {	#:: 941
				quest::faction(941, $change_amount);
			}
			elsif ($text=~/\bFaction942\b/) {	#:: 942
				quest::faction(942, $change_amount);
			}
			elsif ($text=~/\bFaction943\b/) {	#:: 943
				quest::faction(943, $change_amount);
			}
			elsif ($text=~/\bFaction944\b/) {	#:: 944
				quest::faction(944, $change_amount);
			}
			elsif ($text=~/\bFaction945\b/) {	#:: 945
				quest::faction(945, $change_amount);
			}
			elsif ($text=~/\bFaction946\b/) {	#:: 946
				quest::faction(946, $change_amount);
			}
			elsif ($text=~/\bFaction947\b/) {	#:: 947
				quest::faction(947, $change_amount);
			}
			elsif ($text=~/\bFaction948\b/) {	#:: 948
				quest::faction(948, $change_amount);
			}
			elsif ($text=~/\bFaction949\b/) {	#:: 949
				quest::faction(949, $change_amount);
			}
			elsif ($text=~/\bFaction950\b/) {	#:: 950
				quest::faction(950, $change_amount);
			}
			elsif ($text=~/\bFaction951\b/) {	#:: 951
				quest::faction(951, $change_amount);
			}
			elsif ($text=~/\bFaction952\b/) {	#:: 952
				quest::faction(952, $change_amount);
			}
			elsif ($text=~/\bFaction953\b/) {	#:: 953
				quest::faction(953, $change_amount);
			}
			elsif ($text=~/\bFaction954\b/) {	#:: 954
				quest::faction(954, $change_amount);
			}
			elsif ($text=~/\bFaction955\b/) {	#:: 955
				quest::faction(955, $change_amount);
			}
			elsif ($text=~/\bFaction956\b/) {	#:: 956
				quest::faction(956, $change_amount);
			}
			elsif ($text=~/\bFaction957\b/) {	#:: 957
				quest::faction(957, $change_amount);
			}
			elsif ($text=~/\bFaction958\b/) {	#:: 958
				quest::faction(958, $change_amount);
			}
			elsif ($text=~/\bFaction959\b/) {	#:: 959
				quest::faction(959, $change_amount);
			}
			elsif ($text=~/\bFaction960\b/) {	#:: 960
				quest::faction(960, $change_amount);
			}
			elsif ($text=~/\bFaction961\b/) {	#:: 961
				quest::faction(961, $change_amount);
			}
			elsif ($text=~/\bFaction962\b/) {	#:: 962
				quest::faction(962, $change_amount);
			}
			elsif ($text=~/\bFaction963\b/) {	#:: 963
				quest::faction(963, $change_amount);
			}
			elsif ($text=~/\bFaction964\b/) {	#:: 964
				quest::faction(964, $change_amount);
			}
			elsif ($text=~/\bFaction965\b/) {	#:: 965
				quest::faction(965, $change_amount);
			}
			elsif ($text=~/\bFaction966\b/) {	#:: 966
				quest::faction(966, $change_amount);
			}
			elsif ($text=~/\bFaction967\b/) {	#:: 967
				quest::faction(967, $change_amount);
			}
			elsif ($text=~/\bFaction968\b/) {	#:: 968
				quest::faction(968, $change_amount);
			}
			elsif ($text=~/\bFaction969\b/) {	#:: 969
				quest::faction(969, $change_amount);
			}
			elsif ($text=~/\bFaction970\b/) {	#:: 970
				quest::faction(970, $change_amount);
			}
			elsif ($text=~/\bFaction971\b/) {	#:: 971
				quest::faction(971, $change_amount);
			}
			elsif ($text=~/\bFaction972\b/) {	#:: 972
				quest::faction(972, $change_amount);
			}
			elsif ($text=~/\bFaction973\b/) {	#:: 973
				quest::faction(973, $change_amount);
			}
			elsif ($text=~/\bFaction974\b/) {	#:: 974
				quest::faction(974, $change_amount);
			}
			elsif ($text=~/\bFaction975\b/) {	#:: 975
				quest::faction(975, $change_amount);
			}
			elsif ($text=~/\bFaction976\b/) {	#:: 976
				quest::faction(976, $change_amount);
			}
			elsif ($text=~/\bFaction977\b/) {	#:: 977
				quest::faction(977, $change_amount);
			}
			elsif ($text=~/\bFaction978\b/) {	#:: 978
				quest::faction(978, $change_amount);
			}
			elsif ($text=~/\bFaction979\b/) {	#:: 979
				quest::faction(979, $change_amount);
			}
			elsif ($text=~/\bFaction980\b/) {	#:: 980
				quest::faction(980, $change_amount);
			}
			elsif ($text=~/\bFaction981\b/) {	#:: 981
				quest::faction(981, $change_amount);
			}
			elsif ($text=~/\bFaction982\b/) {	#:: 982
				quest::faction(982, $change_amount);
			}
			elsif ($text=~/\bFaction983\b/) {	#:: 983
				quest::faction(983, $change_amount);
			}
			elsif ($text=~/\bFaction984\b/) {	#:: 984
				quest::faction(984, $change_amount);
			}
			elsif ($text=~/\bFaction985\b/) {	#:: 985
				quest::faction(985, $change_amount);
			}
			elsif ($text=~/\bFaction986\b/) {	#:: 986
				quest::faction(986, $change_amount);
			}
			elsif ($text=~/\bFaction987\b/) {	#:: 987
				quest::faction(987, $change_amount);
			}
			elsif ($text=~/\bFaction988\b/) {	#:: 988
				quest::faction(988, $change_amount);
			}
			elsif ($text=~/\bFaction989\b/) {	#:: 989
				quest::faction(989, $change_amount);
			}
			elsif ($text=~/\bFaction990\b/) {	#:: 990
				quest::faction(990, $change_amount);
			}
			elsif ($text=~/\bFaction991\b/) {	#:: 991
				quest::faction(991, $change_amount);
			}
			elsif ($text=~/\bFaction992\b/) {	#:: 992
				quest::faction(992, $change_amount);
			}
			elsif ($text=~/\bFaction993\b/) {	#:: 993
				quest::faction(993, $change_amount);
			}
			elsif ($text=~/\bFaction994\b/) {	#:: 994
				quest::faction(994, $change_amount);
			}
			elsif ($text=~/\bFaction995\b/) {	#:: 995
				quest::faction(995, $change_amount);
			}
			elsif ($text=~/\bFaction996\b/) {	#:: 996
				quest::faction(996, $change_amount);
			}
			elsif ($text=~/\bFaction997\b/) {	#:: 997
				quest::faction(997, $change_amount);
			}
			elsif ($text=~/\bFaction998\b/) {	#:: 998
				quest::faction(998, $change_amount);
			}
			elsif ($text=~/\bFaction999\b/) {	#:: 999
				quest::faction(999, $change_amount);
			}
			elsif ($text=~/\bSlaves of Gloomingdeep\b/) {	#:: 1000
				quest::faction(1000, $change_amount);
			}
			elsif ($text=~/\bKobolds of Gloomingdeep\b/) {	#:: 1001
				quest::faction(1001, $change_amount);
			}
			elsif ($text=~/\bCreatures of Gloomingdeep\b/) {	#:: 1002
				quest::faction(1002, $change_amount);
			}
			elsif ($text=~/\bGuards of Gloomingdeep\b/) {	#:: 1003
				quest::faction(1003, $change_amount);
			}
			elsif ($text=~/\bAnimals of Taelosia\b/) {	#:: 1004
				quest::faction(1004, $change_amount);
			}
			elsif ($text=~/\bQeynos Elite Watch\b/) {	#:: 1005
				quest::faction(1005, $change_amount);
			}
			elsif ($text=~/\bTroupe of Free Speakers\b/) {	#:: 1006
				quest::faction(1006, $change_amount);
			}
			elsif ($text=~/\bRiftseekers\b/) {	#:: 1007
				quest::faction(1007, $change_amount);
			}
			elsif ($text=~/\bDiscordant Creatures of Kuua\b/) {	#:: 1008
				quest::faction(1008, $change_amount);
			}
			elsif ($text=~/\bDenizens of Discord\b/) {	#:: 1009
				quest::faction(1009, $change_amount);
			}
			elsif ($text=~/\bChildren of Dranik\b/) {	#:: 1010
				quest::faction(1010, $change_amount);
			}
			elsif ($text=~/\bFollowers of Mekvidarsh\b/) {	#:: 1011
				quest::faction(1011, $change_amount);
			}
			elsif ($text=~/\bFollowers of Loschryre\b/) {	#:: 1012
				quest::faction(1012, $change_amount);
			}
			elsif ($text=~/\bOverlord Mata Muram\b/) {	#:: 1013
				quest::faction(1013, $change_amount);
			}
			elsif ($text=~/\bBetaOmensNPCKOS\b/) {	#:: 1014
				quest::faction(1014, $change_amount);
			}
			elsif ($text=~/\bCreatures of Kuua\b/) {	#:: 1015
				quest::faction(1015, $change_amount);
			}
			elsif ($text=~/\bDranik Loyalists\b/) {	#:: 1016
				quest::faction(1016, $change_amount);
			}
			elsif ($text=~/\bSenior Guides of Norrath\b/) {	#:: 1017
				quest::faction(1017, $change_amount);
			}
			elsif ($text=~/\bChildren of Mistmoore\b/) {	#:: 1018
				quest::faction(1018, $change_amount);
			}
			elsif ($text=~/\bElemental Invaders\b/) {	#:: 1019
				quest::faction(1019, $change_amount);
			}
			elsif ($text=~/\bLanys T`Vyl\b/) {	#:: 1020
				quest::faction(1020, $change_amount);
			}
			elsif ($text=~/\bDark Reign\b/) {	#:: 1021
				quest::faction(1021, $change_amount);
			}
			elsif ($text=~/\bFiriona Vie\b/) {	#:: 1022
				quest::faction(1022, $change_amount);
			}
			elsif ($text=~/\bNorrath's Keepers\b/) {	#:: 1023
				quest::faction(1023, $change_amount);
			}
			elsif ($text=~/\bTirranun\b/) {	#:: 1024
				quest::faction(1024, $change_amount);
			}
			elsif ($text=~/\bMinions of Tirranun\b/) {	#:: 1025
				quest::faction(1025, $change_amount);
			}
			elsif ($text=~/\bVolkara\b/) {	#:: 1026
				quest::faction(1026, $change_amount);
			}
			elsif ($text=~/\bVolkara's Brood\b/) {	#:: 1027
				quest::faction(1027, $change_amount);
			}
			elsif ($text=~/\bYar`lir\b/) {	#:: 1028
				quest::faction(1028, $change_amount);
			}
			elsif ($text=~/\bThunder Guardians\b/) {	#:: 1029
				quest::faction(1029, $change_amount);
			}
			elsif ($text=~/\bKessdona\b/) {	#:: 1030
				quest::faction(1030, $change_amount);
			}
			elsif ($text=~/\bRikkukin\b/) {	#:: 1031
				quest::faction(1031, $change_amount);
			}
			elsif ($text=~/\bStillmoon Acolytes\b/) {	#:: 1032
				quest::faction(1032, $change_amount);
			}
			elsif ($text=~/\bVishimtar\b/) {	#:: 1033
				quest::faction(1033, $change_amount);
			}
			elsif ($text=~/\bNest Guardians\b/) {	#:: 1034
				quest::faction(1034, $change_amount);
			}
			elsif ($text=~/\bCursed Drakes\b/) {	#:: 1035
				quest::faction(1035, $change_amount);
			}
			elsif ($text=~/\bScorchclaw Goblins\b/) {	#:: 1036
				quest::faction(1036, $change_amount);
			}
			elsif ($text=~/\bFrostflake Goblins\b/) {	#:: 1037
				quest::faction(1037, $change_amount);
			}
			elsif ($text=~/\bWhitecap Goblins\b/) {	#:: 1038
				quest::faction(1038, $change_amount);
			}
			elsif ($text=~/\bDirtdigger Goblins\b/) {	#:: 1039
				quest::faction(1039, $change_amount);
			}
			elsif ($text=~/\bGreenfoot Goblins\b/) {	#:: 1040
				quest::faction(1040, $change_amount);
			}
			elsif ($text=~/\bGrel\b/) {	#:: 1041
				quest::faction(1041, $change_amount);
			}
			elsif ($text=~/\bDefenders of the Broodlands\b/) {	#:: 1042
				quest::faction(1042, $change_amount);
			}
			elsif ($text=~/\bBetaNPCKOS-PC\b/) {	#:: 1043
				quest::faction(1043, $change_amount);
			}
			elsif ($text=~/\bThe Guardians\b/) {	#:: 1044
				quest::faction(1044, $change_amount);
			}
			elsif ($text=~/\bThe Guardian's Alliance\b/) {	#:: 1045
				quest::faction(1045, $change_amount);
			}
			elsif ($text=~/\bThe Dark Alliance\b/) {	#:: 1046
				quest::faction(1046, $change_amount);
			}
			elsif ($text=~/\bThe Dark Suppliers\b/) {	#:: 1047
				quest::faction(1047, $change_amount);
			}
			elsif ($text=~/\bSporali Collective\b/) {	#:: 1048
				quest::faction(1048, $change_amount);
			}
			elsif ($text=~/\bDeep Sporali\b/) {	#:: 1049
				quest::faction(1049, $change_amount);
			}
			elsif ($text=~/\bExpedition 328\b/) {	#:: 1050
				quest::faction(1050, $change_amount);
			}
			elsif ($text=~/\bCreep Reapers\b/) {	#:: 1051
				quest::faction(1051, $change_amount);
			}
			elsif ($text=~/\bShadowmane\b/) {	#:: 1052
				quest::faction(1052, $change_amount);
			}
			elsif ($text=~/\bRagepaw\b/) {	#:: 1053
				quest::faction(1053, $change_amount);
			}
			elsif ($text=~/\bShiliskin Empire\b/) {	#:: 1054
				quest::faction(1054, $change_amount);
			}
			elsif ($text=~/\bFree Traders of Malgrinnor\b/) {	#:: 1055
				quest::faction(1055, $change_amount);
			}
			elsif ($text=~/\bFallen Guard of Illsalin\b/) {	#:: 1056
				quest::faction(1056, $change_amount);
			}
			elsif ($text=~/\bDisciples of Jarzarrad\b/) {	#:: 1057
				quest::faction(1057, $change_amount);
			}
			elsif ($text=~/\bScions of Dreadspire\b/) {	#:: 1058
				quest::faction(1058, $change_amount);
			}
			elsif ($text=~/\bAgents of Dreadspire\b/) {	#:: 1059
				quest::faction(1059, $change_amount);
			}
			elsif ($text=~/\bCreatures of Darkhollow\b/) {	#:: 1060
				quest::faction(1060, $change_amount);
			}
			elsif ($text=~/\bBetaNPCKOS-NPC\b/) {	#:: 1061
				quest::faction(1061, $change_amount);
			}
			elsif ($text=~/\bAssistants of the Scribe\b/) {	#:: 1062
				quest::faction(1062, $change_amount);
			}
			elsif ($text=~/\bCitizens of Freeport\b/) {	#:: 1063
				quest::faction(1063, $change_amount);
			}
			elsif ($text=~/\bSpirits of Arcstone\b/) {	#:: 1064
				quest::faction(1064, $change_amount);
			}
			elsif ($text=~/\bFledgling Scrykin\b/) {	#:: 1065
				quest::faction(1065, $change_amount);
			}
			elsif ($text=~/\bElder Scrykin\b/) {	#:: 1066
				quest::faction(1066, $change_amount);
			}
			elsif ($text=~/\bConstructs of Relic\b/) {	#:: 1067
				quest::faction(1067, $change_amount);
			}
			elsif ($text=~/\bLegions of Sverag\b/) {	#:: 1068
				quest::faction(1068, $change_amount);
			}
			elsif ($text=~/\bRavenous Undead\b/) {	#:: 1069
				quest::faction(1069, $change_amount);
			}
			elsif ($text=~/\bWildfang\b/) {	#:: 1070
				quest::faction(1070, $change_amount);
			}
			elsif ($text=~/\bRedfist Legionnaires\b/) {	#:: 1071
				quest::faction(1071, $change_amount);
			}
			elsif ($text=~/\bThe Irebound\b/) {	#:: 1072
				quest::faction(1072, $change_amount);
			}
			elsif ($text=~/\bRagefang\b/) {	#:: 1073
				quest::faction(1073, $change_amount);
			}
			elsif ($text=~/\bThe Venom Swarm\b/) {	#:: 1074
				quest::faction(1074, $change_amount);
			}
			elsif ($text=~/\bDeathshed Legion\b/) {	#:: 1075
				quest::faction(1075, $change_amount);
			}
			elsif ($text=~/\bBlood Furies\b/) {	#:: 1076
				quest::faction(1076, $change_amount);
			}
			elsif ($text=~/\bFuries of the North\b/) {	#:: 1077
				quest::faction(1077, $change_amount);
			}
			elsif ($text=~/\bStormbreaker Furies\b/) {	#:: 1078
				quest::faction(1078, $change_amount);
			}
			elsif ($text=~/\bBonecracker Furies\b/) {	#:: 1079
				quest::faction(1079, $change_amount);
			}
			elsif ($text=~/\bFuries of Shir\b/) {	#:: 1080
				quest::faction(1080, $change_amount);
			}
			elsif ($text=~/\bThe Wall-Borne\b/) {	#:: 1081
				quest::faction(1081, $change_amount);
			}
			elsif ($text=~/\bLegion of Rage\b/) {	#:: 1082
				quest::faction(1082, $change_amount);
			}
			elsif ($text=~/\bThe Wretched\b/) {	#:: 1083
				quest::faction(1083, $change_amount);
			}
			elsif ($text=~/\bTrueblood Coven\b/) {	#:: 1084
				quest::faction(1084, $change_amount);
			}
			elsif ($text=~/\bCitizens of Takish-Hiz\b/) {	#:: 1085
				quest::faction(1085, $change_amount);
			}
			elsif ($text=~/\bInsurgents of Ro\b/) {	#:: 1086
				quest::faction(1086, $change_amount);
			}
			elsif ($text=~/\bCreatures of Elddar\b/) {	#:: 1087
				quest::faction(1087, $change_amount);
			}
			elsif ($text=~/\bClan Vorzek\b/) {	#:: 1088
				quest::faction(1088, $change_amount);
			}
			elsif ($text=~/\bTribe of the Nogdha\b/) {	#:: 1089
				quest::faction(1089, $change_amount);
			}
			elsif ($text=~/\bServants of the Compact\b/) {	#:: 1090
				quest::faction(1090, $change_amount);
			}
			elsif ($text=~/\bCreatures of Sandflow\b/) {	#:: 1091
				quest::faction(1091, $change_amount);
			}
			elsif ($text=~/\bBlood of Ro\b/) {	#:: 1092
				quest::faction(1092, $change_amount);
			}
			elsif ($text=~/\bDirewind Gnolls\b/) {	#:: 1093
				quest::faction(1093, $change_amount);
			}
			elsif ($text=~/\bForces of Dyn'leth\b/) {	#:: 1094
				quest::faction(1094, $change_amount);
			}
			elsif ($text=~/\bCrusade of the Scale\b/) {	#:: 1095
				quest::faction(1095, $change_amount);
			}
			elsif ($text=~/\bBlackfeather Harpies\b/) {	#:: 1096
				quest::faction(1096, $change_amount);
			}
			elsif ($text=~/\bBlackfeather Royalty\b/) {	#:: 1097
				quest::faction(1097, $change_amount);
			}
			elsif ($text=~/\bBlackfeather Animals\b/) {	#:: 1098
				quest::faction(1098, $change_amount);
			}
			elsif ($text=~/\bBlackfeather Spiders\b/) {	#:: 1099
				quest::faction(1099, $change_amount);
			}
			elsif ($text=~/\bShades of Zek\b/) {	#:: 1100
				quest::faction(1100, $change_amount);
			}
			elsif ($text=~/\bAncestors of Valdeholm\b/) {	#:: 1101
				quest::faction(1101, $change_amount);
			}
			elsif ($text=~/\bConverts of Valdeholm\b/) {	#:: 1102
				quest::faction(1102, $change_amount);
			}
			elsif ($text=~/\bValdeholm Citizens\b/) {	#:: 1103
				quest::faction(1103, $change_amount);
			}
			elsif ($text=~/\bWraithguard\b/) {	#:: 1104
				quest::faction(1104, $change_amount);
			}
			elsif ($text=~/\bWraithguard Leadership\b/) {	#:: 1105
				quest::faction(1105, $change_amount);
			}
			elsif ($text=~/\bDrakkin\b/) {	#:: 1106
				quest::faction(1106, $change_amount);
			}
			elsif ($text=~/\bTuffein\b/) {	#:: 1107
				quest::faction(1107, $change_amount);
			}
			elsif ($text=~/\bTuffein Leadership\b/) {	#:: 1108
				quest::faction(1108, $change_amount);
			}
			elsif ($text=~/\bMinohten\b/) {	#:: 1109
				quest::faction(1109, $change_amount);
			}
			elsif ($text=~/\bNymphs of the Windwillow\b/) {	#:: 1110
				quest::faction(1110, $change_amount);
			}
			elsif ($text=~/\bNymphs of the Darkwater\b/) {	#:: 1111
				quest::faction(1111, $change_amount);
			}
			elsif ($text=~/\bBlackfeather Raiders\b/) {	#:: 1112
				quest::faction(1112, $change_amount);
			}
			elsif ($text=~/\bDromrek\b/) {	#:: 1113
				quest::faction(1113, $change_amount);
			}
			elsif ($text=~/\bLost of the Windwillow\b/) {	#:: 1114
				quest::faction(1114, $change_amount);
			}
			elsif ($text=~/\bFoulblood Fieldstrider Centaur\b/) {	#:: 1115
				quest::faction(1115, $change_amount);
			}
			elsif ($text=~/\bFieldstrider Centaur\b/) {	#:: 1116
				quest::faction(1116, $change_amount);
			}
			elsif ($text=~/\bStonemight Goblins\b/) {	#:: 1117
				quest::faction(1117, $change_amount);
			}
			elsif ($text=~/\bDarkfell Clan\b/) {	#:: 1118
				quest::faction(1118, $change_amount);
			}
			elsif ($text=~/\bGuardians of the Grove\b/) {	#:: 1119
				quest::faction(1119, $change_amount);
			}
			elsif ($text=~/\bColdeye Clan\b/) {	#:: 1120
				quest::faction(1120, $change_amount);
			}
			elsif ($text=~/\bNightmoon Kobolds\b/) {	#:: 1121
				quest::faction(1121, $change_amount);
			}
			elsif ($text=~/\bFrostbite Clan\b/) {	#:: 1122
				quest::faction(1122, $change_amount);
			}
			elsif ($text=~/\bDrones of Stonehive\b/) {	#:: 1123
				quest::faction(1123, $change_amount);
			}
			elsif ($text=~/\bLegion of Stonehive\b/) {	#:: 1124
				quest::faction(1124, $change_amount);
			}
			elsif ($text=~/\bSpirits of Nokk\b/) {	#:: 1125
				quest::faction(1125, $change_amount);
			}
			elsif ($text=~/\bGuardians of the Dark Tower\b/) {	#:: 1126
				quest::faction(1126, $change_amount);
			}
			elsif ($text=~/\bThe Blightfire Tainted\b/) {	#:: 1127
				quest::faction(1127, $change_amount);
			}
			elsif ($text=~/\bMadcaps - Mushroom Men\b/) {	#:: 1128
				quest::faction(1128, $change_amount);
			}
			elsif ($text=~/\bCircle of the Crystalwing\b/) {	#:: 1129
				quest::faction(1129, $change_amount);
			}
			elsif ($text=~/\bSelay\b/) {	#:: 1130
				quest::faction(1130, $change_amount);
			}
			elsif ($text=~/\bDyn`leth\b/) {	#:: 1131
				quest::faction(1131, $change_amount);
			}
			elsif ($text=~/\bLethar\b/) {	#:: 1132
				quest::faction(1132, $change_amount);
			}
			elsif ($text=~/\bVergalid\b/) {	#:: 1133
				quest::faction(1133, $change_amount);
			}
			elsif ($text=~/\bScholars of Solusek\b/) {	#:: 1134
				quest::faction(1134, $change_amount);
			}
			elsif ($text=~/\bInfiltrators and Traitors of Ashengate\b/) {	#:: 1135
				quest::faction(1135, $change_amount);
			}
			elsif ($text=~/\bNature Animal\b/) {	#:: 1136
				quest::faction(1136, $change_amount);
			}
			elsif ($text=~/\bCrescent Reach Guards\b/) {	#:: 1137
				quest::faction(1137, $change_amount);
			}
			elsif ($text=~/\bGreater Shades of Zek\b/) {	#:: 1138
				quest::faction(1138, $change_amount);
			}
			elsif ($text=~/\bNewbie Guard\b/) {	#:: 1139
				quest::faction(1139, $change_amount);
			}
			elsif ($text=~/\bDrowned Dead\b/) {	#:: 1140
				quest::faction(1140, $change_amount);
			}
			elsif ($text=~/\bSharpeye's Reef Runners\b/) {	#:: 1141
				quest::faction(1141, $change_amount);
			}
			elsif ($text=~/\bBlacksail Pirates\b/) {	#:: 1142
				quest::faction(1142, $change_amount);
			}
			elsif ($text=~/\bStormscape Aviaks\b/) {	#:: 1143
				quest::faction(1143, $change_amount);
			}
			elsif ($text=~/\bGaligaba\b/) {	#:: 1144
				quest::faction(1144, $change_amount);
			}
			elsif ($text=~/\bKing Peleke\b/) {	#:: 1145
				quest::faction(1145, $change_amount);
			}
			elsif ($text=~/\bSunstone Goblins\b/) {	#:: 1146
				quest::faction(1146, $change_amount);
			}
			elsif ($text=~/\bKing Vigdos\b/) {	#:: 1147
				quest::faction(1147, $change_amount);
			}
			elsif ($text=~/\bTidewater Goblins\b/) {	#:: 1148
				quest::faction(1148, $change_amount);
			}
			elsif ($text=~/\bKing Tondra\b/) {	#:: 1149
				quest::faction(1149, $change_amount);
			}
			elsif ($text=~/\bPlatinum Efreeti\b/) {	#:: 1150
				quest::faction(1150, $change_amount);
			}
			elsif ($text=~/\bSphinx of Atiiki\b/) {	#:: 1151
				quest::faction(1151, $change_amount);
			}
			elsif ($text=~/\bNature Animal - Snake\b/) {	#:: 1152
				quest::faction(1152, $change_amount);
			}
			elsif ($text=~/\bNature Animal - Crocodile\b/) {	#:: 1153
				quest::faction(1153, $change_amount);
			}
			elsif ($text=~/\bNature Animal - Basilisk\b/) {	#:: 1154
				quest::faction(1154, $change_amount);
			}
			elsif ($text=~/\bNature Animal - Shark\b/) {	#:: 1155
				quest::faction(1155, $change_amount);
			}
			elsif ($text=~/\bNature Animal - Spider\b/) {	#:: 1156
				quest::faction(1156, $change_amount);
			}
			elsif ($text=~/\bNature Animal - Wolf\b/) {	#:: 1157
				quest::faction(1157, $change_amount);
			}
			elsif ($text=~/\bNature Animal - Bear\b/) {	#:: 1158
				quest::faction(1158, $change_amount);
			}
			elsif ($text=~/\bNature Animal - Beetle\b/) {	#:: 1159
				quest::faction(1159, $change_amount);
			}
			elsif ($text=~/\bNature Animal - Fish\b/) {	#:: 1160
				quest::faction(1160, $change_amount);
			}
			elsif ($text=~/\bCombine Citizens\b/) {	#:: 1161
				quest::faction(1161, $change_amount);
			}
			elsif ($text=~/\bDisciples of Zhisza\b/) {	#:: 1162
				quest::faction(1162, $change_amount);
			}
			elsif ($text=~/\bBrood of Vaakiszh\b/) {	#:: 1163
				quest::faction(1163, $change_amount);
			}
			elsif ($text=~/\bFangs of Saarisz\b/) {	#:: 1164
				quest::faction(1164, $change_amount);
			}
			elsif ($text=~/\bKatta Elementals\b/) {	#:: 1165
				quest::faction(1165, $change_amount);
			}
			elsif ($text=~/\bSirens of Maiden's Grave\b/) {	#:: 1166
				quest::faction(1166, $change_amount);
			}
			elsif ($text=~/\bThe Cursed of Monkey Rock\b/) {	#:: 1167
				quest::faction(1167, $change_amount);
			}
			elsif ($text=~/\bMinions of Solusek Ro\b/) {	#:: 1168
				quest::faction(1168, $change_amount);
			}
			elsif ($text=~/\bBlacksail Smugglers\b/) {	#:: 1169
				quest::faction(1169, $change_amount);
			}
			elsif ($text=~/\bCombine Empire Merchants\b/) {	#:: 1170
				quest::faction(1170, $change_amount);
			}
			elsif ($text=~/\bBeta Enemy\b/) {	#:: 1171
				quest::faction(1171, $change_amount);
			}
			elsif ($text=~/\bBeta Friend\b/) {	#:: 1172
				quest::faction(1172, $change_amount);
			}
			elsif ($text=~/\bBeta Neutral 2\b/) {	#:: 1173
				quest::faction(1173, $change_amount);
			}
			elsif ($text=~/\bThe Cursed of Monkey Rock (Instance)\b/) {	#:: 1174
				quest::faction(1174, $change_amount);
			}
			elsif ($text=~/\bCaptains of Dyn`leth\b/) {	#:: 1175
				quest::faction(1175, $change_amount);
			}
			elsif ($text=~/\bBlood of Solusek\b/) {	#:: 1176
				quest::faction(1176, $change_amount);
			}
			elsif ($text=~/\bGuardian \b/) {	#:: 1177
				quest::faction(1177, $change_amount);
			}
			elsif ($text=~/\bWorkshop Workers Union\b/) {	#:: 1178
				quest::faction(1178, $change_amount);
			}
			elsif ($text=~/\bBlackwater\b/) {	#:: 1179
				quest::faction(1179, $change_amount);
			}
			elsif ($text=~/\bKirathas\b/) {	#:: 1180
				quest::faction(1180, $change_amount);
			}
			elsif ($text=~/\bThe Borrowers\b/) {	#:: 1181
				quest::faction(1181, $change_amount);
			}
			elsif ($text=~/\bErollisi's Scorned\b/) {	#:: 1182
				quest::faction(1182, $change_amount);
			}
			elsif ($text=~/\bBertoxxulous' Chosen\b/) {	#:: 1183
				quest::faction(1183, $change_amount);
			}
			elsif ($text=~/\bCamp Valor\b/) {	#:: 1184
				quest::faction(1184, $change_amount);
			}
			elsif ($text=~/\bLadies of the Light\b/) {	#:: 1185
				quest::faction(1185, $change_amount);
			}
			elsif ($text=~/\bLoyalists of Kerafyrm\b/) {	#:: 1186
				quest::faction(1186, $change_amount);
			}
			elsif ($text=~/\bEmissaries of Claws of Veeshan\b/) {	#:: 1187
				quest::faction(1187, $change_amount);
			}
			elsif ($text=~/\bCrusaders of Veeshan\b/) {	#:: 1188
				quest::faction(1188, $change_amount);
			}
			elsif ($text=~/\bBrownie Rebels\b/) {	#:: 1189
				quest::faction(1189, $change_amount);
			}
			elsif ($text=~/\bAk`Anon Strike Force V\b/) {	#:: 1190
				quest::faction(1190, $change_amount);
			}
			elsif ($text=~/\bFang Breakers\b/) {	#:: 1191
				quest::faction(1191, $change_amount);
			}
			elsif ($text=~/\bThe Fallen\b/) {	#:: 1192
				quest::faction(1192, $change_amount);
			}
			elsif ($text=~/\bAncestors of the Crypt\b/) {	#:: 1193
				quest::faction(1193, $change_amount);
			}
			elsif ($text=~/\bMinions of Meldrath\b/) {	#:: 1194
				quest::faction(1194, $change_amount);
			}
			elsif ($text=~/\bBloodmoon Were-Orcs\b/) {	#:: 1195
				quest::faction(1195, $change_amount);
			}
			elsif ($text=~/\bDarkvine Villagers\b/) {	#:: 1196
				quest::faction(1196, $change_amount);
			}
			elsif ($text=~/\bWind Nymphs\b/) {	#:: 1197
				quest::faction(1197, $change_amount);
			}
			elsif ($text=~/\bGuardian Defense Forces\b/) {	#:: 1198
				quest::faction(1198, $change_amount);
			}
			elsif ($text=~/\bResidents of the Glade\b/) {	#:: 1199
				quest::faction(1199, $change_amount);
			}
			elsif ($text=~/\bBayle's Irregulars\b/) {	#:: 1200
				quest::faction(1200, $change_amount);
			}
			elsif ($text=~/\bPlaguebringer Parishioners\b/) {	#:: 1201
				quest::faction(1201, $change_amount);
			}
			elsif ($text=~/\bBlackburrow Gnolls\b/) {	#:: 1202
				quest::faction(1202, $change_amount);
			}
			elsif ($text=~/\bDarkpaw Gnolls\b/) {	#:: 1203
				quest::faction(1203, $change_amount);
			}
			elsif ($text=~/\bArmy of Light \b/) {	#:: 1204
				quest::faction(1204, $change_amount);
			}
			elsif ($text=~/\bThaulen Teir'Duuren\b/) {	#:: 1205
				quest::faction(1205, $change_amount);
			}
			elsif ($text=~/\bKithicor Irregulars\b/) {	#:: 1206
				quest::faction(1206, $change_amount);
			}
			elsif ($text=~/\bPrisoners of the Dark Elves\b/) {	#:: 1207
				quest::faction(1207, $change_amount);
			}
			elsif ($text=~/\bDiscordant Agents\b/) {	#:: 1208
				quest::faction(1208, $change_amount);
			}
			elsif ($text=~/\bDragorn Forces\b/) {	#:: 1209
				quest::faction(1209, $change_amount);
			}
			elsif ($text=~/\bDiscordant Army\b/) {	#:: 1210
				quest::faction(1210, $change_amount);
			}
			elsif ($text=~/\bToskirakk Slaves\b/) {	#:: 1211
				quest::faction(1211, $change_amount);
			}
			elsif ($text=~/\bToskirakk Slavers\b/) {	#:: 1212
				quest::faction(1212, $change_amount);
			}
			elsif ($text=~/\bRallosian Guards\b/) {	#:: 1213
				quest::faction(1213, $change_amount);
			}
			elsif ($text=~/\bToskirakk Merchants\b/) {	#:: 1214
				quest::faction(1214, $change_amount);
			}
			elsif ($text=~/\bRathe Council\b/) {	#:: 1215
				quest::faction(1215, $change_amount);
			}
			elsif ($text=~/\bRallosian Invaders\b/) {	#:: 1216
				quest::faction(1216, $change_amount);
			}
			elsif ($text=~/\bRathe Living Heaps\b/) {	#:: 1217
				quest::faction(1217, $change_amount);
			}
			elsif ($text=~/\bRathe Council Defenders\b/) {	#:: 1218
				quest::faction(1218, $change_amount);
			}
			elsif ($text=~/\bDarkhammer Dwarves\b/) {	#:: 1219
				quest::faction(1219, $change_amount);
			}
			elsif ($text=~/\bPrimal Crystallines\b/) {	#:: 1220
				quest::faction(1220, $change_amount);
			}
			elsif ($text=~/\bOceangreen Residents\b/) {	#:: 1221
				quest::faction(1221, $change_amount);
			}
			elsif ($text=~/\bCirtan, Bayle's Herald\b/) {	#:: 1222
				quest::faction(1222, $change_amount);
			}
			elsif ($text=~/\bSilla Herald\b/) {	#:: 1223
				quest::faction(1223, $change_amount);
			}
			elsif ($text=~/\bTynoc, Herald of Scale\b/) {	#:: 1224
				quest::faction(1224, $change_amount);
			}
			elsif ($text=~/\bMitius, Herald of Change\b/) {	#:: 1225
				quest::faction(1225, $change_amount);
			}
			elsif ($text=~/\bHerald Argoth\b/) {	#:: 1226
				quest::faction(1226, $change_amount);
			}
			elsif ($text=~/\bHerald of Druzzil Ro\b/) {	#:: 1227
				quest::faction(1227, $change_amount);
			}
			elsif ($text=~/\bAncient Blackburrow Gnolls\b/) {	#:: 1228
				quest::faction(1228, $change_amount);
			}
			elsif ($text=~/\bSebilisian Empire\b/) {	#:: 1229
				quest::faction(1229, $change_amount);
			}
			elsif ($text=~/\bDiscordant Armies\b/) {	#:: 1230
				quest::faction(1230, $change_amount);
			}
			elsif ($text=~/\bTanglefuse's Clockworks\b/) {	#:: 1231
				quest::faction(1231, $change_amount);
			}
			elsif ($text=~/\bUnderfoot Citizens\b/) {	#:: 1232
				quest::faction(1232, $change_amount);
			}
			elsif ($text=~/\bUnderfoot Autarchs\b/) {	#:: 1233
				quest::faction(1233, $change_amount);
			}
			elsif ($text=~/\bUnderfoot Denizens\b/) {	#:: 1234
				quest::faction(1234, $change_amount);
			}
			elsif ($text=~/\bUnderfoot Protectors\b/) {	#:: 1235
				quest::faction(1235, $change_amount);
			}
			elsif ($text=~/\bUnderfoot Devout\b/) {	#:: 1236
				quest::faction(1236, $change_amount);
			}
			elsif ($text=~/\bCliknar\b/) {	#:: 1237
				quest::faction(1237, $change_amount);
			}
			elsif ($text=~/\bUnderfoot Subversionists\b/) {	#:: 1238
				quest::faction(1238, $change_amount);
			}
			elsif ($text=~/\bClockwork Magma Meter\b/) {	#:: 1239
				quest::faction(1239, $change_amount);
			}
			elsif ($text=~/\bMorell-Thule\b/) {	#:: 1240
				quest::faction(1240, $change_amount);
			}
			elsif ($text=~/\bDegmar's Loyalists\b/) {	#:: 1241
				quest::faction(1241, $change_amount);
			}
			elsif ($text=~/\bDegmar's Commoners\b/) {	#:: 1242
				quest::faction(1242, $change_amount);
			}
			elsif ($text=~/\bDegmar's Haunts\b/) {	#:: 1243
				quest::faction(1243, $change_amount);
			}
			elsif ($text=~/\bBrother Island Residents\b/) {	#:: 1244
				quest::faction(1244, $change_amount);
			}
			elsif ($text=~/\bBrother Island Animal\b/) {	#:: 1245
				quest::faction(1245, $change_amount);
			}
			elsif ($text=~/\bSirens of the Endless Cavern\b/) {	#:: 1246
				quest::faction(1246, $change_amount);
			}
			elsif ($text=~/\bFaction1247\b/) {	#:: 1247
				quest::faction(1247, $change_amount);
			}
			elsif ($text=~/\bFaction1248\b/) {	#:: 1248
				quest::faction(1248, $change_amount);
			}
			elsif ($text=~/\bFaction1249\b/) {	#:: 1249
				quest::faction(1249, $change_amount);
			}
			elsif ($text=~/\bFaction1250\b/) {	#:: 1250
				quest::faction(1250, $change_amount);
			}
			elsif ($text=~/\bFaction1251\b/) {	#:: 1251
				quest::faction(1251, $change_amount);
			}
			elsif ($text=~/\bFaction1252\b/) {	#:: 1252
				quest::faction(1252, $change_amount);
			}
			elsif ($text=~/\bFaction1253\b/) {	#:: 1253
				quest::faction(1253, $change_amount);
			}
			elsif ($text=~/\bFaction1254\b/) {	#:: 1254
				quest::faction(1254, $change_amount);
			}
			elsif ($text=~/\bFaction1255\b/) {	#:: 1255
				quest::faction(1255, $change_amount);
			}
			elsif ($text=~/\bFaction1256\b/) {	#:: 1256
				quest::faction(1256, $change_amount);
			}
			elsif ($text=~/\bFaction1257\b/) {	#:: 1257
				quest::faction(1257, $change_amount);
			}
			elsif ($text=~/\bFaction1258\b/) {	#:: 1258
				quest::faction(1258, $change_amount);
			}
			elsif ($text=~/\bFaction1259\b/) {	#:: 1259
				quest::faction(1259, $change_amount);
			}
			elsif ($text=~/\bFaction1260\b/) {	#:: 1260
				quest::faction(1260, $change_amount);
			}
			elsif ($text=~/\bFaction1261\b/) {	#:: 1261
				quest::faction(1261, $change_amount);
			}
			elsif ($text=~/\bFaction1262\b/) {	#:: 1262
				quest::faction(1262, $change_amount);
			}
			elsif ($text=~/\bFaction1263\b/) {	#:: 1263
				quest::faction(1263, $change_amount);
			}
			elsif ($text=~/\bFaction1264\b/) {	#:: 1264
				quest::faction(1264, $change_amount);
			}
			elsif ($text=~/\bFaction1265\b/) {	#:: 1265
				quest::faction(1265, $change_amount);
			}
			elsif ($text=~/\bFaction1266\b/) {	#:: 1266
				quest::faction(1266, $change_amount);
			}
			elsif ($text=~/\bFaction1267\b/) {	#:: 1267
				quest::faction(1267, $change_amount);
			}
			elsif ($text=~/\bFaction1268\b/) {	#:: 1268
				quest::faction(1268, $change_amount);
			}
			elsif ($text=~/\bFaction1269\b/) {	#:: 1269
				quest::faction(1269, $change_amount);
			}
			elsif ($text=~/\bFaction1270\b/) {	#:: 1270
				quest::faction(1270, $change_amount);
			}
			elsif ($text=~/\bFaction1271\b/) {	#:: 1271
				quest::faction(1271, $change_amount);
			}
			elsif ($text=~/\bFaction1272\b/) {	#:: 1272
				quest::faction(1272, $change_amount);
			}
			elsif ($text=~/\bFaction1273\b/) {	#:: 1273
				quest::faction(1273, $change_amount);
			}
			elsif ($text=~/\bFaction1274\b/) {	#:: 1274
				quest::faction(1274, $change_amount);
			}
			elsif ($text=~/\bFaction1275\b/) {	#:: 1275
				quest::faction(1275, $change_amount);
			}
			elsif ($text=~/\bFaction1276\b/) {	#:: 1276
				quest::faction(1276, $change_amount);
			}
			elsif ($text=~/\bFaction1277\b/) {	#:: 1277
				quest::faction(1277, $change_amount);
			}
			elsif ($text=~/\bFaction1278\b/) {	#:: 1278
				quest::faction(1278, $change_amount);
			}
			elsif ($text=~/\bFaction1279\b/) {	#:: 1279
				quest::faction(1279, $change_amount);
			}
			elsif ($text=~/\bFaction1280\b/) {	#:: 1280
				quest::faction(1280, $change_amount);
			}
			elsif ($text=~/\bFaction1281\b/) {	#:: 1281
				quest::faction(1281, $change_amount);
			}
			elsif ($text=~/\bFaction1282\b/) {	#:: 1282
				quest::faction(1282, $change_amount);
			}
			elsif ($text=~/\bFaction1283\b/) {	#:: 1283
				quest::faction(1283, $change_amount);
			}
			elsif ($text=~/\bFaction1284\b/) {	#:: 1284
				quest::faction(1284, $change_amount);
			}
			elsif ($text=~/\bFaction1285\b/) {	#:: 1285
				quest::faction(1285, $change_amount);
			}
			elsif ($text=~/\bFaction1286\b/) {	#:: 1286
				quest::faction(1286, $change_amount);
			}
			elsif ($text=~/\bFaction1287\b/) {	#:: 1287
				quest::faction(1287, $change_amount);
			}
			elsif ($text=~/\bFaction1288\b/) {	#:: 1288
				quest::faction(1288, $change_amount);
			}
			elsif ($text=~/\bFaction1289\b/) {	#:: 1289
				quest::faction(1289, $change_amount);
			}
			elsif ($text=~/\bFaction1290\b/) {	#:: 1290
				quest::faction(1290, $change_amount);
			}
			elsif ($text=~/\bFaction1291\b/) {	#:: 1291
				quest::faction(1291, $change_amount);
			}
			elsif ($text=~/\bFaction1292\b/) {	#:: 1292
				quest::faction(1292, $change_amount);
			}
			elsif ($text=~/\bFaction1293\b/) {	#:: 1293
				quest::faction(1293, $change_amount);
			}
			elsif ($text=~/\bFaction1294\b/) {	#:: 1294
				quest::faction(1294, $change_amount);
			}
			elsif ($text=~/\bFaction1295\b/) {	#:: 1295
				quest::faction(1295, $change_amount);
			}
			elsif ($text=~/\bFaction1296\b/) {	#:: 1296
				quest::faction(1296, $change_amount);
			}
			elsif ($text=~/\bFaction1297\b/) {	#:: 1297
				quest::faction(1297, $change_amount);
			}
			elsif ($text=~/\bFaction1298\b/) {	#:: 1298
				quest::faction(1298, $change_amount);
			}
			elsif ($text=~/\bFaction1299\b/) {	#:: 1299
				quest::faction(1299, $change_amount);
			}
			elsif ($text=~/\bFaction1300\b/) {	#:: 1300
				quest::faction(1300, $change_amount);
			}
			elsif ($text=~/\bFaction1301\b/) {	#:: 1301
				quest::faction(1301, $change_amount);
			}
			elsif ($text=~/\bFaction1302\b/) {	#:: 1302
				quest::faction(1302, $change_amount);
			}
			elsif ($text=~/\bFaction1303\b/) {	#:: 1303
				quest::faction(1303, $change_amount);
			}
			elsif ($text=~/\bFaction1304\b/) {	#:: 1304
				quest::faction(1304, $change_amount);
			}
			elsif ($text=~/\bFaction1305\b/) {	#:: 1305
				quest::faction(1305, $change_amount);
			}
			elsif ($text=~/\bFaction1306\b/) {	#:: 1306
				quest::faction(1306, $change_amount);
			}
			elsif ($text=~/\bFaction1307\b/) {	#:: 1307
				quest::faction(1307, $change_amount);
			}
			elsif ($text=~/\bFaction1308\b/) {	#:: 1308
				quest::faction(1308, $change_amount);
			}
			elsif ($text=~/\bFaction1309\b/) {	#:: 1309
				quest::faction(1309, $change_amount);
			}
			elsif ($text=~/\bFaction1310\b/) {	#:: 1310
				quest::faction(1310, $change_amount);
			}
			elsif ($text=~/\bFaction1311\b/) {	#:: 1311
				quest::faction(1311, $change_amount);
			}
			elsif ($text=~/\bFaction1312\b/) {	#:: 1312
				quest::faction(1312, $change_amount);
			}
			elsif ($text=~/\bFaction1313\b/) {	#:: 1313
				quest::faction(1313, $change_amount);
			}
			elsif ($text=~/\bFaction1314\b/) {	#:: 1314
				quest::faction(1314, $change_amount);
			}
			elsif ($text=~/\bFaction1315\b/) {	#:: 1315
				quest::faction(1315, $change_amount);
			}
			elsif ($text=~/\bFaction1316\b/) {	#:: 1316
				quest::faction(1316, $change_amount);
			}
			elsif ($text=~/\bFaction1317\b/) {	#:: 1317
				quest::faction(1317, $change_amount);
			}
			elsif ($text=~/\bFaction1318\b/) {	#:: 1318
				quest::faction(1318, $change_amount);
			}
			elsif ($text=~/\bFaction1319\b/) {	#:: 1319
				quest::faction(1319, $change_amount);
			}
			elsif ($text=~/\bFaction1320\b/) {	#:: 1320
				quest::faction(1320, $change_amount);
			}
			elsif ($text=~/\bFaction1321\b/) {	#:: 1321
				quest::faction(1321, $change_amount);
			}
			elsif ($text=~/\bFaction1322\b/) {	#:: 1322
				quest::faction(1322, $change_amount);
			}
			elsif ($text=~/\bFaction1323\b/) {	#:: 1323
				quest::faction(1323, $change_amount);
			}
			elsif ($text=~/\bFaction1324\b/) {	#:: 1324
				quest::faction(1324, $change_amount);
			}
			elsif ($text=~/\bFaction1325\b/) {	#:: 1325
				quest::faction(1325, $change_amount);
			}
			elsif ($text=~/\bFaction1326\b/) {	#:: 1326
				quest::faction(1326, $change_amount);
			}
			elsif ($text=~/\bFaction1327\b/) {	#:: 1327
				quest::faction(1327, $change_amount);
			}
			elsif ($text=~/\bFaction1328\b/) {	#:: 1328
				quest::faction(1328, $change_amount);
			}
			elsif ($text=~/\bFaction1329\b/) {	#:: 1329
				quest::faction(1329, $change_amount);
			}
			elsif ($text=~/\bFaction1330\b/) {	#:: 1330
				quest::faction(1330, $change_amount);
			}
			elsif ($text=~/\bFaction1331\b/) {	#:: 1331
				quest::faction(1331, $change_amount);
			}
			elsif ($text=~/\bFaction1332\b/) {	#:: 1332
				quest::faction(1332, $change_amount);
			}
			elsif ($text=~/\bFaction1333\b/) {	#:: 1333
				quest::faction(1333, $change_amount);
			}
			elsif ($text=~/\bFaction1334\b/) {	#:: 1334
				quest::faction(1334, $change_amount);
			}
			elsif ($text=~/\bFaction1335\b/) {	#:: 1335
				quest::faction(1335, $change_amount);
			}
			elsif ($text=~/\bFaction1336\b/) {	#:: 1336
				quest::faction(1336, $change_amount);
			}
			elsif ($text=~/\bFaction1337\b/) {	#:: 1337
				quest::faction(1337, $change_amount);
			}
			elsif ($text=~/\bFaction1338\b/) {	#:: 1338
				quest::faction(1338, $change_amount);
			}
			elsif ($text=~/\bFaction1339\b/) {	#:: 1339
				quest::faction(1339, $change_amount);
			}
			elsif ($text=~/\bFaction1340\b/) {	#:: 1340
				quest::faction(1340, $change_amount);
			}
			elsif ($text=~/\bFaction1341\b/) {	#:: 1341
				quest::faction(1341, $change_amount);
			}
			elsif ($text=~/\bFaction1342\b/) {	#:: 1342
				quest::faction(1342, $change_amount);
			}
			elsif ($text=~/\bFaction1343\b/) {	#:: 1343
				quest::faction(1343, $change_amount);
			}
			elsif ($text=~/\bFaction1344\b/) {	#:: 1344
				quest::faction(1344, $change_amount);
			}
			elsif ($text=~/\bFaction1345\b/) {	#:: 1345
				quest::faction(1345, $change_amount);
			}
			elsif ($text=~/\bFaction1346\b/) {	#:: 1346
				quest::faction(1346, $change_amount);
			}
			elsif ($text=~/\bFaction1347\b/) {	#:: 1347
				quest::faction(1347, $change_amount);
			}
			elsif ($text=~/\bFaction1348\b/) {	#:: 1348
				quest::faction(1348, $change_amount);
			}
			elsif ($text=~/\bFaction1349\b/) {	#:: 1349
				quest::faction(1349, $change_amount);
			}
			elsif ($text=~/\bFaction1350\b/) {	#:: 1350
				quest::faction(1350, $change_amount);
			}
			elsif ($text=~/\bFaction1351\b/) {	#:: 1351
				quest::faction(1351, $change_amount);
			}
			elsif ($text=~/\bFaction1352\b/) {	#:: 1352
				quest::faction(1352, $change_amount);
			}
			elsif ($text=~/\bFaction1353\b/) {	#:: 1353
				quest::faction(1353, $change_amount);
			}
			elsif ($text=~/\bFaction1354\b/) {	#:: 1354
				quest::faction(1354, $change_amount);
			}
			elsif ($text=~/\bFaction1355\b/) {	#:: 1355
				quest::faction(1355, $change_amount);
			}
			elsif ($text=~/\bFaction1356\b/) {	#:: 1356
				quest::faction(1356, $change_amount);
			}
			elsif ($text=~/\bFaction1357\b/) {	#:: 1357
				quest::faction(1357, $change_amount);
			}
			elsif ($text=~/\bFaction1358\b/) {	#:: 1358
				quest::faction(1358, $change_amount);
			}
			elsif ($text=~/\bFaction1359\b/) {	#:: 1359
				quest::faction(1359, $change_amount);
			}
			elsif ($text=~/\bFaction1360\b/) {	#:: 1360
				quest::faction(1360, $change_amount);
			}
			elsif ($text=~/\bFaction1361\b/) {	#:: 1361
				quest::faction(1361, $change_amount);
			}
			elsif ($text=~/\bFaction1362\b/) {	#:: 1362
				quest::faction(1362, $change_amount);
			}
			elsif ($text=~/\bFaction1363\b/) {	#:: 1363
				quest::faction(1363, $change_amount);
			}
			elsif ($text=~/\bFaction1364\b/) {	#:: 1364
				quest::faction(1364, $change_amount);
			}
			elsif ($text=~/\bFaction1365\b/) {	#:: 1365
				quest::faction(1365, $change_amount);
			}
			elsif ($text=~/\bFaction1366\b/) {	#:: 1366
				quest::faction(1366, $change_amount);
			}
			elsif ($text=~/\bFaction1367\b/) {	#:: 1367
				quest::faction(1367, $change_amount);
			}
			elsif ($text=~/\bFaction1368\b/) {	#:: 1368
				quest::faction(1368, $change_amount);
			}
			elsif ($text=~/\bFaction1369\b/) {	#:: 1369
				quest::faction(1369, $change_amount);
			}
			elsif ($text=~/\bFaction1370\b/) {	#:: 1370
				quest::faction(1370, $change_amount);
			}
			elsif ($text=~/\bFaction1371\b/) {	#:: 1371
				quest::faction(1371, $change_amount);
			}
			elsif ($text=~/\bFaction1372\b/) {	#:: 1372
				quest::faction(1372, $change_amount);
			}
			elsif ($text=~/\bFaction1373\b/) {	#:: 1373
				quest::faction(1373, $change_amount);
			}
			elsif ($text=~/\bFaction1374\b/) {	#:: 1374
				quest::faction(1374, $change_amount);
			}
			elsif ($text=~/\bFaction1375\b/) {	#:: 1375
				quest::faction(1375, $change_amount);
			}
			elsif ($text=~/\bFaction1376\b/) {	#:: 1376
				quest::faction(1376, $change_amount);
			}
			elsif ($text=~/\bFaction1377\b/) {	#:: 1377
				quest::faction(1377, $change_amount);
			}
			elsif ($text=~/\bFaction1378\b/) {	#:: 1378
				quest::faction(1378, $change_amount);
			}
			elsif ($text=~/\bFaction1379\b/) {	#:: 1379
				quest::faction(1379, $change_amount);
			}
			elsif ($text=~/\bFaction1380\b/) {	#:: 1380
				quest::faction(1380, $change_amount);
			}
			elsif ($text=~/\bFaction1381\b/) {	#:: 1381
				quest::faction(1381, $change_amount);
			}
			elsif ($text=~/\bFaction1382\b/) {	#:: 1382
				quest::faction(1382, $change_amount);
			}
			elsif ($text=~/\bFaction1383\b/) {	#:: 1383
				quest::faction(1383, $change_amount);
			}
			elsif ($text=~/\bFaction1384\b/) {	#:: 1384
				quest::faction(1384, $change_amount);
			}
			elsif ($text=~/\bFaction1385\b/) {	#:: 1385
				quest::faction(1385, $change_amount);
			}
			elsif ($text=~/\bFaction1386\b/) {	#:: 1386
				quest::faction(1386, $change_amount);
			}
			elsif ($text=~/\bFaction1387\b/) {	#:: 1387
				quest::faction(1387, $change_amount);
			}
			elsif ($text=~/\bFaction1388\b/) {	#:: 1388
				quest::faction(1388, $change_amount);
			}
			elsif ($text=~/\bFaction1389\b/) {	#:: 1389
				quest::faction(1389, $change_amount);
			}
			elsif ($text=~/\bFaction1390\b/) {	#:: 1390
				quest::faction(1390, $change_amount);
			}
			elsif ($text=~/\bFaction1391\b/) {	#:: 1391
				quest::faction(1391, $change_amount);
			}
			elsif ($text=~/\bFaction1392\b/) {	#:: 1392
				quest::faction(1392, $change_amount);
			}
			elsif ($text=~/\bFaction1393\b/) {	#:: 1393
				quest::faction(1393, $change_amount);
			}
			elsif ($text=~/\bFaction1394\b/) {	#:: 1394
				quest::faction(1394, $change_amount);
			}
			elsif ($text=~/\bFaction1395\b/) {	#:: 1395
				quest::faction(1395, $change_amount);
			}
			elsif ($text=~/\bFaction1396\b/) {	#:: 1396
				quest::faction(1396, $change_amount);
			}
			elsif ($text=~/\bFaction1397\b/) {	#:: 1397
				quest::faction(1397, $change_amount);
			}
			elsif ($text=~/\bFaction1398\b/) {	#:: 1398
				quest::faction(1398, $change_amount);
			}
			elsif ($text=~/\bFaction1399\b/) {	#:: 1399
				quest::faction(1399, $change_amount);
			}
			elsif ($text=~/\bFaction1400\b/) {	#:: 1400
				quest::faction(1400, $change_amount);
			}
			elsif ($text=~/\bFaction1401\b/) {	#:: 1401
				quest::faction(1401, $change_amount);
			}
			elsif ($text=~/\bFaction1402\b/) {	#:: 1402
				quest::faction(1402, $change_amount);
			}
			elsif ($text=~/\bFaction1403\b/) {	#:: 1403
				quest::faction(1403, $change_amount);
			}
			elsif ($text=~/\bFaction1404\b/) {	#:: 1404
				quest::faction(1404, $change_amount);
			}
			elsif ($text=~/\bFaction1405\b/) {	#:: 1405
				quest::faction(1405, $change_amount);
			}
			elsif ($text=~/\bFaction1406\b/) {	#:: 1406
				quest::faction(1406, $change_amount);
			}
			elsif ($text=~/\bFaction1407\b/) {	#:: 1407
				quest::faction(1407, $change_amount);
			}
			elsif ($text=~/\bFaction1408\b/) {	#:: 1408
				quest::faction(1408, $change_amount);
			}
			elsif ($text=~/\bFaction1409\b/) {	#:: 1409
				quest::faction(1409, $change_amount);
			}
			elsif ($text=~/\bFaction1410\b/) {	#:: 1410
				quest::faction(1410, $change_amount);
			}
			elsif ($text=~/\bFaction1411\b/) {	#:: 1411
				quest::faction(1411, $change_amount);
			}
			elsif ($text=~/\bFaction1412\b/) {	#:: 1412
				quest::faction(1412, $change_amount);
			}
			elsif ($text=~/\bFaction1413\b/) {	#:: 1413
				quest::faction(1413, $change_amount);
			}
			elsif ($text=~/\bFaction1414\b/) {	#:: 1414
				quest::faction(1414, $change_amount);
			}
			elsif ($text=~/\bFaction1415\b/) {	#:: 1415
				quest::faction(1415, $change_amount);
			}
			elsif ($text=~/\bFaction1416\b/) {	#:: 1416
				quest::faction(1416, $change_amount);
			}
			elsif ($text=~/\bFaction1417\b/) {	#:: 1417
				quest::faction(1417, $change_amount);
			}
			elsif ($text=~/\bFaction1418\b/) {	#:: 1418
				quest::faction(1418, $change_amount);
			}
			elsif ($text=~/\bFaction1419\b/) {	#:: 1419
				quest::faction(1419, $change_amount);
			}
			elsif ($text=~/\bFaction1420\b/) {	#:: 1420
				quest::faction(1420, $change_amount);
			}
			elsif ($text=~/\bFaction1421\b/) {	#:: 1421
				quest::faction(1421, $change_amount);
			}
			elsif ($text=~/\bFaction1422\b/) {	#:: 1422
				quest::faction(1422, $change_amount);
			}
			elsif ($text=~/\bFaction1423\b/) {	#:: 1423
				quest::faction(1423, $change_amount);
			}
			elsif ($text=~/\bFaction1424\b/) {	#:: 1424
				quest::faction(1424, $change_amount);
			}
			elsif ($text=~/\bFaction1425\b/) {	#:: 1425
				quest::faction(1425, $change_amount);
			}
			elsif ($text=~/\bFaction1426\b/) {	#:: 1426
				quest::faction(1426, $change_amount);
			}
			elsif ($text=~/\bFaction1427\b/) {	#:: 1427
				quest::faction(1427, $change_amount);
			}
			elsif ($text=~/\bFaction1428\b/) {	#:: 1428
				quest::faction(1428, $change_amount);
			}
			elsif ($text=~/\bFaction1429\b/) {	#:: 1429
				quest::faction(1429, $change_amount);
			}
			elsif ($text=~/\bFaction1430\b/) {	#:: 1430
				quest::faction(1430, $change_amount);
			}
			elsif ($text=~/\bFaction1431\b/) {	#:: 1431
				quest::faction(1431, $change_amount);
			}
			elsif ($text=~/\bFaction1432\b/) {	#:: 1432
				quest::faction(1432, $change_amount);
			}
			elsif ($text=~/\bFaction1433\b/) {	#:: 1433
				quest::faction(1433, $change_amount);
			}
			elsif ($text=~/\bFaction1434\b/) {	#:: 1434
				quest::faction(1434, $change_amount);
			}
			elsif ($text=~/\bFaction1435\b/) {	#:: 1435
				quest::faction(1435, $change_amount);
			}
			elsif ($text=~/\bFaction1436\b/) {	#:: 1436
				quest::faction(1436, $change_amount);
			}
			elsif ($text=~/\bFaction1437\b/) {	#:: 1437
				quest::faction(1437, $change_amount);
			}
			elsif ($text=~/\bFaction1438\b/) {	#:: 1438
				quest::faction(1438, $change_amount);
			}
			elsif ($text=~/\bFaction1439\b/) {	#:: 1439
				quest::faction(1439, $change_amount);
			}
			elsif ($text=~/\bFaction1440\b/) {	#:: 1440
				quest::faction(1440, $change_amount);
			}
			elsif ($text=~/\bFaction1441\b/) {	#:: 1441
				quest::faction(1441, $change_amount);
			}
			elsif ($text=~/\bFaction1442\b/) {	#:: 1442
				quest::faction(1442, $change_amount);
			}
			elsif ($text=~/\bFaction1443\b/) {	#:: 1443
				quest::faction(1443, $change_amount);
			}
			elsif ($text=~/\bFaction1444\b/) {	#:: 1444
				quest::faction(1444, $change_amount);
			}
			elsif ($text=~/\bFaction1445\b/) {	#:: 1445
				quest::faction(1445, $change_amount);
			}
			elsif ($text=~/\bFaction1446\b/) {	#:: 1446
				quest::faction(1446, $change_amount);
			}
			elsif ($text=~/\bFaction1447\b/) {	#:: 1447
				quest::faction(1447, $change_amount);
			}
			elsif ($text=~/\bFaction1448\b/) {	#:: 1448
				quest::faction(1448, $change_amount);
			}
			elsif ($text=~/\bFaction1449\b/) {	#:: 1449
				quest::faction(1449, $change_amount);
			}
			elsif ($text=~/\bFaction1450\b/) {	#:: 1450
				quest::faction(1450, $change_amount);
			}
			elsif ($text=~/\bFaction1451\b/) {	#:: 1451
				quest::faction(1451, $change_amount);
			}
			elsif ($text=~/\bFaction1452\b/) {	#:: 1452
				quest::faction(1452, $change_amount);
			}
			elsif ($text=~/\bFaction1453\b/) {	#:: 1453
				quest::faction(1453, $change_amount);
			}
			elsif ($text=~/\bFaction1454\b/) {	#:: 1454
				quest::faction(1454, $change_amount);
			}
			elsif ($text=~/\bFaction1455\b/) {	#:: 1455
				quest::faction(1455, $change_amount);
			}
			elsif ($text=~/\bFaction1456\b/) {	#:: 1456
				quest::faction(1456, $change_amount);
			}
			elsif ($text=~/\bFaction1457\b/) {	#:: 1457
				quest::faction(1457, $change_amount);
			}
			elsif ($text=~/\bFaction1458\b/) {	#:: 1458
				quest::faction(1458, $change_amount);
			}
			elsif ($text=~/\bFaction1459\b/) {	#:: 1459
				quest::faction(1459, $change_amount);
			}
			elsif ($text=~/\bFaction1460\b/) {	#:: 1460
				quest::faction(1460, $change_amount);
			}
			elsif ($text=~/\bFaction1461\b/) {	#:: 1461
				quest::faction(1461, $change_amount);
			}
			elsif ($text=~/\bFaction1462\b/) {	#:: 1462
				quest::faction(1462, $change_amount);
			}
			elsif ($text=~/\bFaction1463\b/) {	#:: 1463
				quest::faction(1463, $change_amount);
			}
			elsif ($text=~/\bFaction1464\b/) {	#:: 1464
				quest::faction(1464, $change_amount);
			}
			elsif ($text=~/\bFaction1465\b/) {	#:: 1465
				quest::faction(1465, $change_amount);
			}
			elsif ($text=~/\bFaction1466\b/) {	#:: 1466
				quest::faction(1466, $change_amount);
			}
			elsif ($text=~/\bFaction1467\b/) {	#:: 1467
				quest::faction(1467, $change_amount);
			}
			elsif ($text=~/\bFaction1468\b/) {	#:: 1468
				quest::faction(1468, $change_amount);
			}
			elsif ($text=~/\bFaction1469\b/) {	#:: 1469
				quest::faction(1469, $change_amount);
			}
			elsif ($text=~/\bFaction1470\b/) {	#:: 1470
				quest::faction(1470, $change_amount);
			}
			elsif ($text=~/\bFaction1471\b/) {	#:: 1471
				quest::faction(1471, $change_amount);
			}
			elsif ($text=~/\bFaction1472\b/) {	#:: 1472
				quest::faction(1472, $change_amount);
			}
			elsif ($text=~/\bFaction1473\b/) {	#:: 1473
				quest::faction(1473, $change_amount);
			}
			elsif ($text=~/\bFaction1474\b/) {	#:: 1474
				quest::faction(1474, $change_amount);
			}
			elsif ($text=~/\bFaction1475\b/) {	#:: 1475
				quest::faction(1475, $change_amount);
			}
			elsif ($text=~/\bFaction1476\b/) {	#:: 1476
				quest::faction(1476, $change_amount);
			}
			elsif ($text=~/\bFaction1477\b/) {	#:: 1477
				quest::faction(1477, $change_amount);
			}
			elsif ($text=~/\bFaction1478\b/) {	#:: 1478
				quest::faction(1478, $change_amount);
			}
			elsif ($text=~/\bFaction1479\b/) {	#:: 1479
				quest::faction(1479, $change_amount);
			}
			elsif ($text=~/\bFaction1480\b/) {	#:: 1480
				quest::faction(1480, $change_amount);
			}
			elsif ($text=~/\bFaction1481\b/) {	#:: 1481
				quest::faction(1481, $change_amount);
			}
			elsif ($text=~/\bFaction1482\b/) {	#:: 1482
				quest::faction(1482, $change_amount);
			}
			elsif ($text=~/\bSeru\b/) {	#:: 1483
				quest::faction(1483, $change_amount);
			}
			elsif ($text=~/\bHand of Seru\b/) {	#:: 1484
				quest::faction(1484, $change_amount);
			}
			elsif ($text=~/\bEye of Seru\b/) {	#:: 1485
				quest::faction(1485, $change_amount);
			}
			elsif ($text=~/\bHeart of Seru\b/) {	#:: 1486
				quest::faction(1486, $change_amount);
			}
			elsif ($text=~/\bShoulders of Seru\b/) {	#:: 1487
				quest::faction(1487, $change_amount);
			}
			elsif ($text=~/\bThe Recuso\b/) {	#:: 1488
				quest::faction(1488, $change_amount);
			}
			elsif ($text=~/\bGladiators and Slaves of Sanctus Seru\b/) {	#:: 1489
				quest::faction(1489, $change_amount);
			}
			elsif ($text=~/\bGrimlings of the Moor\b/) {	#:: 1490
				quest::faction(1490, $change_amount);
			}
			elsif ($text=~/\bSonic Wolves of the Moor\b/) {	#:: 1491
				quest::faction(1491, $change_amount);
			}
			elsif ($text=~/\bOwlbears of the Moor\b/) {	#:: 1492
				quest::faction(1492, $change_amount);
			}
			elsif ($text=~/\bGrimling Invaders\b/) {	#:: 1493
				quest::faction(1493, $change_amount);
			}
			elsif ($text=~/\bOwlbear Invaders\b/) {	#:: 1494
				quest::faction(1494, $change_amount);
			}
			elsif ($text=~/\bSonic Wolf Invaders\b/) {	#:: 1495
				quest::faction(1495, $change_amount);
			}
			elsif ($text=~/\bGrimling Defenders\b/) {	#:: 1496
				quest::faction(1496, $change_amount);
			}
			elsif ($text=~/\bOwlbear Defenders\b/) {	#:: 1497
				quest::faction(1497, $change_amount);
			}
			elsif ($text=~/\bSonic Wolf Defenders\b/) {	#:: 1498
				quest::faction(1498, $change_amount);
			}
			elsif ($text=~/\bCitizens of Seru\b/) {	#:: 1499
				quest::faction(1499, $change_amount);
			}
			elsif ($text=~/\bGor Taku\b/) {	#:: 1500
				quest::faction(1500, $change_amount);
			}
			elsif ($text=~/\bShak Dratha\b/) {	#:: 1501
				quest::faction(1501, $change_amount);
			}
			elsif ($text=~/\bKatta Castellum Citizens\b/) {	#:: 1502
				quest::faction(1502, $change_amount);
			}
			elsif ($text=~/\bValidus Custodus\b/) {	#:: 1503
				quest::faction(1503, $change_amount);
			}
			elsif ($text=~/\bMagus Conlegium\b/) {	#:: 1504
				quest::faction(1504, $change_amount);
			}
			elsif ($text=~/\bNathyn Illuminious\b/) {	#:: 1505
				quest::faction(1505, $change_amount);
			}
			elsif ($text=~/\bCoterie of the Eternal Night\b/) {	#:: 1506
				quest::faction(1506, $change_amount);
			}
			elsif ($text=~/\bValdanov Zevfeer\b/) {	#:: 1507
				quest::faction(1507, $change_amount);
			}
			elsif ($text=~/\bTraders of the Haven\b/) {	#:: 1508
				quest::faction(1508, $change_amount);
			}
			elsif ($text=~/\bHaven Defenders\b/) {	#:: 1509
				quest::faction(1509, $change_amount);
			}
			elsif ($text=~/\bHouse of Fordel\b/) {	#:: 1510
				quest::faction(1510, $change_amount);
			}
			elsif ($text=~/\bHouse of Midst\b/) {	#:: 1511
				quest::faction(1511, $change_amount);
			}
			elsif ($text=~/\bHouse of Stout\b/) {	#:: 1512
				quest::faction(1512, $change_amount);
			}
			elsif ($text=~/\bGuardians of Shar Vahl\b/) {	#:: 1513
				quest::faction(1513, $change_amount);
			}
			elsif ($text=~/\bTestfaction\b/) {	#:: 1514
				quest::faction(1514, $change_amount);
			}
			elsif ($text=~/\bDark Forest Denizens\b/) {	#:: 1515
				quest::faction(1515, $change_amount);
			}
			elsif ($text=~/\bGrimlings of the Forest\b/) {	#:: 1516
				quest::faction(1516, $change_amount);
			}
			elsif ($text=~/\bDeepwood Owlbears\b/) {	#:: 1517
				quest::faction(1517, $change_amount);
			}
			elsif ($text=~/\bPack of the Great Moon\b/) {	#:: 1518
				quest::faction(1518, $change_amount);
			}
			elsif ($text=~/\bLodikai\b/) {	#:: 1519
				quest::faction(1519, $change_amount);
			}
			elsif ($text=~/\bWhisperling\b/) {	#:: 1520
				quest::faction(1520, $change_amount);
			}
			elsif ($text=~/\bAkheva\b/) {	#:: 1521
				quest::faction(1521, $change_amount);
			}
			elsif ($text=~/\bPrimordial Malice\b/) {	#:: 1522
				quest::faction(1522, $change_amount);
			}
			elsif ($text=~/\bFeast of the Burrowers\b/) {	#:: 1523
				quest::faction(1523, $change_amount);
			}
			elsif ($text=~/\bJohanius Barleou\b/) {	#:: 1524
				quest::faction(1524, $change_amount);
			}
			elsif ($text=~/\bCoterie Elite\b/) {	#:: 1525
				quest::faction(1525, $change_amount);
			}
			elsif ($text=~/\bOld Disciples of Kerafyrm\b/) {	#:: 1526
				quest::faction(1526, $change_amount);
			}
			elsif ($text=~/\bSpire Spirits\b/) {	#:: 1527
				quest::faction(1527, $change_amount);
			}
			elsif ($text=~/\bThought Leeches\b/) {	#:: 1528
				quest::faction(1528, $change_amount);
			}
			elsif ($text=~/\bKhala Dun\b/) {	#:: 1529
				quest::faction(1529, $change_amount);
			}
			elsif ($text=~/\bTaruun\b/) {	#:: 1530
				quest::faction(1530, $change_amount);
			}
			elsif ($text=~/\bJharin\b/) {	#:: 1531
				quest::faction(1531, $change_amount);
			}
			elsif ($text=~/\bKhati Sha\b/) {	#:: 1532
				quest::faction(1532, $change_amount);
			}
			elsif ($text=~/\bDar Khura\b/) {	#:: 1533
				quest::faction(1533, $change_amount);
			}
			elsif ($text=~/\bLuclin Monsters\b/) {	#:: 1534
				quest::faction(1534, $change_amount);
			}
			elsif ($text=~/\bBrood of Ssraeshza\b/) {	#:: 1535
				quest::faction(1535, $change_amount);
			}
			elsif ($text=~/\bEmperor Ssraeshza\b/) {	#:: 1536
				quest::faction(1536, $change_amount);
			}
			elsif ($text=~/\bIksar Temple Slaves\b/) {	#:: 1537
				quest::faction(1537, $change_amount);
			}
			elsif ($text=~/\bSpirits of Katta Castellum\b/) {	#:: 1538
				quest::faction(1538, $change_amount);
			}
			elsif ($text=~/\bNetherbians\b/) {	#:: 1539
				quest::faction(1539, $change_amount);
			}
			elsif ($text=~/\bTroglodytes\b/) {	#:: 1540
				quest::faction(1540, $change_amount);
			}
			elsif ($text=~/\bHand Legionnaries\b/) {	#:: 1541
				quest::faction(1541, $change_amount);
			}
			elsif ($text=~/\bHaven Smugglers\b/) {	#:: 1542
				quest::faction(1542, $change_amount);
			}
			elsif ($text=~/\bServants of Aero\b/) {	#:: 1543
				quest::faction(1543, $change_amount);
			}
			elsif ($text=~/\bServants of Terra\b/) {	#:: 1544
				quest::faction(1544, $change_amount);
			}
			elsif ($text=~/\bServants of Inferno\b/) {	#:: 1545
				quest::faction(1545, $change_amount);
			}
			elsif ($text=~/\bServants of Hydro\b/) {	#:: 1546
				quest::faction(1546, $change_amount);
			}
			elsif ($text=~/\bVornol Transon\b/) {	#:: 1547
				quest::faction(1547, $change_amount);
			}
			elsif ($text=~/\bThe Vas Ren Clan\b/) {	#:: 1548
				quest::faction(1548, $change_amount);
			}
			elsif ($text=~/\bThe Grol Baku Clan\b/) {	#:: 1549
				quest::faction(1549, $change_amount);
			}
			elsif ($text=~/\bThe Cral Ligi Clan\b/) {	#:: 1550
				quest::faction(1550, $change_amount);
			}
			elsif ($text=~/\bThe Tro Jeg Clan\b/) {	#:: 1551
				quest::faction(1551, $change_amount);
			}
			elsif ($text=~/\bVah Shir Crusaders\b/) {	#:: 1552
				quest::faction(1552, $change_amount);
			}
			elsif ($text=~/\bNetherbian Ambush\b/) {	#:: 1553
				quest::faction(1553, $change_amount);
			}
			elsif ($text=~/\bNetherbian Caravan\b/) {	#:: 1554
				quest::faction(1554, $change_amount);
			}
			elsif ($text=~/\bGrieg\b/) {	#:: 1555
				quest::faction(1555, $change_amount);
			}
			elsif ($text=~/\bLuclin\b/) {	#:: 1556
				quest::faction(1556, $change_amount);
			}
			elsif ($text=~/\bDark Sendings\b/) {	#:: 1557
				quest::faction(1557, $change_amount);
			}
			elsif ($text=~/\bGrimling Captives\b/) {	#:: 1558
				quest::faction(1558, $change_amount);
			}
			elsif ($text=~/\bLake Recondite Bandits\b/) {	#:: 1559
				quest::faction(1559, $change_amount);
			}
			elsif ($text=~/\bKanaad\b/) {	#:: 1560
				quest::faction(1560, $change_amount);
			}
			elsif ($text=~/\bConcilium Universus\b/) {	#:: 1561
				quest::faction(1561, $change_amount);
			}
			elsif ($text=~/\bDisciples of Rhag`Zadune\b/) {	#:: 1562
				quest::faction(1562, $change_amount);
			}
			elsif ($text=~/\bThe Sambata Tribe\b/) {	#:: 1563
				quest::faction(1563, $change_amount);
			}
			elsif ($text=~/\bDawnhoppers\b/) {	#:: 1564
				quest::faction(1564, $change_amount);
			}
			elsif ($text=~/\bTarmok Tribe\b/) {	#:: 1565
				quest::faction(1565, $change_amount);
			}
			elsif ($text=~/\bNetok Tribe\b/) {	#:: 1566
				quest::faction(1566, $change_amount);
			}
			elsif ($text=~/\bKatta Traitors\b/) {	#:: 1567
				quest::faction(1567, $change_amount);
			}
			elsif ($text=~/\bDeepshade Collective\b/) {	#:: 1568
				quest::faction(1568, $change_amount);
			}
			elsif ($text=~/\bDeklean Korgad\b/) {	#:: 1569
				quest::faction(1569, $change_amount);
			}
			elsif ($text=~/\bOrder of Autarkic Umbrage\b/) {	#:: 1570
				quest::faction(1570, $change_amount);
			}
			elsif ($text=~/\bShei Vinitras\b/) {	#:: 1571
				quest::faction(1571, $change_amount);
			}
			elsif ($text=~/\bAnti Vinitras\b/) {	#:: 1572
				quest::faction(1572, $change_amount);
			}
			elsif ($text=~/\bThe Bloodtribe\b/) {	#:: 1573
				quest::faction(1573, $change_amount);
			}
			elsif ($text=~/\bMinions of the Sunlord\b/) {	#:: 1574
				quest::faction(1574, $change_amount);
			}
			elsif ($text=~/\bImps\b/) {	#:: 1575
				quest::faction(1575, $change_amount);
			}
			elsif ($text=~/\bKingdom of Above and Below\b/) {	#:: 1576
				quest::faction(1576, $change_amount);
			}
			elsif ($text=~/\bThe Truth\b/) {	#:: 1577
				quest::faction(1577, $change_amount);
			}
			elsif ($text=~/\bDeklean Korgad\b/) {	#:: 1578
				quest::faction(1578, $change_amount);
			}
			elsif ($text=~/\bDroga Goblins\b/) {	#:: 1579
				quest::faction(1579, $change_amount);
			}
			elsif ($text=~/\bNurga Goblins\b/) {	#:: 1580
				quest::faction(1580, $change_amount);
			}
			elsif ($text=~/\bLuclin Friendly Monsters\b/) {	#:: 1581
				quest::faction(1581, $change_amount);
			}
			elsif ($text=~/\bOutcasts and Mutants\b/) {	#:: 1582
				quest::faction(1582, $change_amount);
			}
			elsif ($text=~/\bCult of the Great Saprophyte\b/) {	#:: 1583
				quest::faction(1583, $change_amount);
			}
			elsif ($text=~/\bCitizens of Shar Vahl\b/) {	#:: 1584
				quest::faction(1584, $change_amount);
			}
			elsif ($text=~/\bFiends of the Grove\b/) {	#:: 1585
				quest::faction(1585, $change_amount);
			}
			elsif ($text=~/\bSavage Spirit\b/) {	#:: 1586
				quest::faction(1586, $change_amount);
			}
			elsif ($text=~/\bZordak Ragefire\b/) {	#:: 1587
				quest::faction(1587, $change_amount);
			}
			elsif ($text=~/\bCaptain Cruikshanks\b/) {	#:: 1588
				quest::faction(1588, $change_amount);
			}
			elsif ($text=~/\bScourge\b/) {	#:: 1589
				quest::faction(1589, $change_amount);
			}
			elsif ($text=~/\bCaptain Stottal\b/) {	#:: 1590
				quest::faction(1590, $change_amount);
			}
			elsif ($text=~/\bCaptain Smythe\b/) {	#:: 1591
				quest::faction(1591, $change_amount);
			}
			elsif ($text=~/\bCaptain Dorian Dulein\b/) {	#:: 1592
				quest::faction(1592, $change_amount);
			}
			elsif ($text=~/\bFrogloks of Krup\b/) {	#:: 1593
				quest::faction(1593, $change_amount);
			}
			elsif ($text=~/\bCult of the Arisen\b/) {	#:: 1594
				quest::faction(1594, $change_amount);
			}
			elsif ($text=~/\bNew Alliance of Stone\b/) {	#:: 1595
				quest::faction(1595, $change_amount);
			}
			elsif ($text=~/\bIdelia the Serene\b/) {	#:: 1596
				quest::faction(1596, $change_amount);
			}
			elsif ($text=~/\bResidents of Jaggedpine\b/) {	#:: 1597
				quest::faction(1597, $change_amount);
			}
			elsif ($text=~/\bAnchorites of Brell Serilis\b/) {	#:: 1598
				quest::faction(1598, $change_amount);
			}
			elsif ($text=~/\bDarkpaws of Jaggedpine\b/) {	#:: 1599
				quest::faction(1599, $change_amount);
			}
			elsif ($text=~/\bGuardians of the Hatchling\b/) {	#:: 1600
				quest::faction(1600, $change_amount);
			}
			elsif ($text=~/\bPirates of the Pine\b/) {	#:: 1601
				quest::faction(1601, $change_amount);
			}
			elsif ($text=~/\bCritters of Jaggedpine\b/) {	#:: 1602
				quest::faction(1602, $change_amount);
			}
			elsif ($text=~/\bDryads of the Grove\b/) {	#:: 1603
				quest::faction(1603, $change_amount);
			}
			elsif ($text=~/\bClan Grikbar\b/) {	#:: 1604
				quest::faction(1604, $change_amount);
			}
			elsif ($text=~/\bHaven Smuggler Associates\b/) {	#:: 1605
				quest::faction(1605, $change_amount);
			}
			elsif ($text=~/\bKOS to Beta Neutral\b/) {	#:: 1606
				quest::faction(1606, $change_amount);
			}
			elsif ($text=~/\bPlague Bringer\b/) {	#:: 1607
				quest::faction(1607, $change_amount);
			}
			elsif ($text=~/\bSpirits of Lxanvom\b/) {	#:: 1608
				quest::faction(1608, $change_amount);
			}
			elsif ($text=~/\bAskr the Lost\b/) {	#:: 1609
				quest::faction(1609, $change_amount);
			}
			elsif ($text=~/\bGreater Jord Giants\b/) {	#:: 1610
				quest::faction(1610, $change_amount);
			}
			elsif ($text=~/\bGreater Brann Giants\b/) {	#:: 1611
				quest::faction(1611, $change_amount);
			}
			elsif ($text=~/\bGreater Vind Giants\b/) {	#:: 1612
				quest::faction(1612, $change_amount);
			}
			elsif ($text=~/\bGreater Vann Giants\b/) {	#:: 1613
				quest::faction(1613, $change_amount);
			}
			elsif ($text=~/\bLesser Jord Giants\b/) {	#:: 1614
				quest::faction(1614, $change_amount);
			}
			elsif ($text=~/\bLesser Brann Giants\b/) {	#:: 1615
				quest::faction(1615, $change_amount);
			}
			elsif ($text=~/\bLesser Vind Giants\b/) {	#:: 1616
				quest::faction(1616, $change_amount);
			}
			elsif ($text=~/\bLesser Vann Giants\b/) {	#:: 1617
				quest::faction(1617, $change_amount);
			}
			elsif ($text=~/\bStorm Guardians\b/) {	#:: 1618
				quest::faction(1618, $change_amount);
			}
			elsif ($text=~/\bThe Rainkeeper\b/) {	#:: 1619
				quest::faction(1619, $change_amount);
			}
			elsif ($text=~/\bTreants of Jaggedpine\b/) {	#:: 1620
				quest::faction(1620, $change_amount);
			}
			elsif ($text=~/\bAgnarr\b/) {	#:: 1621
				quest::faction(1621, $change_amount);
			}
			elsif ($text=~/\bArboreans of the Faydark\b/) {	#:: 1622
				quest::faction(1622, $change_amount);
			}
			elsif ($text=~/\bDisciples of Kerafyrm\b/) {	#:: 1623
				quest::faction(1623, $change_amount);
			}
			elsif ($text=~/\bServants of Saryrn\b/) {	#:: 1624
				quest::faction(1624, $change_amount);
			}
			elsif ($text=~/\bGuardians of Justice\b/) {	#:: 1625
				quest::faction(1625, $change_amount);
			}
			elsif ($text=~/\bJacosh Steldenn\b/) {	#:: 1626
				quest::faction(1626, $change_amount);
			}
			elsif ($text=~/\bPrisoners of Justice\b/) {	#:: 1627
				quest::faction(1627, $change_amount);
			}
			elsif ($text=~/\bCreatures of Justice\b/) {	#:: 1628
				quest::faction(1628, $change_amount);
			}
			elsif ($text=~/\bGralloks\b/) {	#:: 1629
				quest::faction(1629, $change_amount);
			}
			elsif ($text=~/\bBurning Dead\b/) {	#:: 1630
				quest::faction(1630, $change_amount);
			}
			elsif ($text=~/\bKOS All PC And Beta Neutral\b/) {	#:: 1631
				quest::faction(1631, $change_amount);
			}
			elsif ($text=~/\bDenizens of Water\b/) {	#:: 1632
				quest::faction(1632, $change_amount);
			}
			elsif ($text=~/\bMinions of Coirnav\b/) {	#:: 1633
				quest::faction(1633, $change_amount);
			}
			elsif ($text=~/\bFish Lords\b/) {	#:: 1634
				quest::faction(1634, $change_amount);
			}
			elsif ($text=~/\bDwellers of the Deep\b/) {	#:: 1635
				quest::faction(1635, $change_amount);
			}
			elsif ($text=~/\bInhabitants of Tanaan\b/) {	#:: 1636
				quest::faction(1636, $change_amount);
			}
			elsif ($text=~/\bTruespirit Companion\b/) {	#:: 1637
				quest::faction(1637, $change_amount);
			}
			elsif ($text=~/\bRallos Zek, The Warlord\b/) {	#:: 1638
				quest::faction(1638, $change_amount);
			}
			elsif ($text=~/\bTallon Zek\b/) {	#:: 1639
				quest::faction(1639, $change_amount);
			}
			elsif ($text=~/\bVallon Zek\b/) {	#:: 1640
				quest::faction(1640, $change_amount);
			}
			elsif ($text=~/\bEriak\b/) {	#:: 1641
				quest::faction(1641, $change_amount);
			}
			elsif ($text=~/\bThe Damned of Narikor\b/) {	#:: 1642
				quest::faction(1642, $change_amount);
			}
			elsif ($text=~/\bThe Diaku\b/) {	#:: 1643
				quest::faction(1643, $change_amount);
			}
			elsif ($text=~/\bThe Gindan\b/) {	#:: 1644
				quest::faction(1644, $change_amount);
			}
			elsif ($text=~/\bThe Hendin\b/) {	#:: 1645
				quest::faction(1645, $change_amount);
			}
			elsif ($text=~/\bThe Decorus\b/) {	#:: 1646
				quest::faction(1646, $change_amount);
			}
			elsif ($text=~/\bGladiators of Drunder\b/) {	#:: 1647
				quest::faction(1647, $change_amount);
			}
			elsif ($text=~/\bDenizens of Fire\b/) {	#:: 1648
				quest::faction(1648, $change_amount);
			}
			elsif ($text=~/\bMinions of Fennin Ro\b/) {	#:: 1649
				quest::faction(1649, $change_amount);
			}
			elsif ($text=~/\bInhabitants of Tranquility\b/) {	#:: 1650
				quest::faction(1650, $change_amount);
			}
			elsif ($text=~/\bVictim of Torment\b/) {	#:: 1651
				quest::faction(1651, $change_amount);
			}
			elsif ($text=~/\bStampeding War Boar\b/) {	#:: 1652
				quest::faction(1652, $change_amount);
			}
			elsif ($text=~/\bWar Boar Piglet\b/) {	#:: 1653
				quest::faction(1653, $change_amount);
			}
			elsif ($text=~/\bInhabitants of Disease\b/) {	#:: 1654
				quest::faction(1654, $change_amount);
			}
			elsif ($text=~/\bInhabitants of Valor\b/) {	#:: 1655
				quest::faction(1655, $change_amount);
			}
			elsif ($text=~/\bBattalion of Marr\b/) {	#:: 1656
				quest::faction(1656, $change_amount);
			}
			elsif ($text=~/\bRats of Justice\b/) {	#:: 1657
				quest::faction(1657, $change_amount);
			}
			elsif ($text=~/\bDenizens of Storm\b/) {	#:: 1658
				quest::faction(1658, $change_amount);
			}
			elsif ($text=~/\bLost Kingdom of Lok\b/) {	#:: 1659
				quest::faction(1659, $change_amount);
			}
			elsif ($text=~/\bKoka'Vor Tribe\b/) {	#:: 1660
				quest::faction(1660, $change_amount);
			}
			elsif ($text=~/\bInhabitants of Air\b/) {	#:: 1661
				quest::faction(1661, $change_amount);
			}
			elsif ($text=~/\bGuardians of the Living Earth\b/) {	#:: 1662
				quest::faction(1662, $change_amount);
			}
			elsif ($text=~/\bThe Protectorate of the Twelve\b/) {	#:: 1663
				quest::faction(1663, $change_amount);
			}
			elsif ($text=~/\bEino\b/) {	#:: 1664
				quest::faction(1664, $change_amount);
			}
			elsif ($text=~/\bFrogloks of Sebilis\b/) {	#:: 1665
				quest::faction(1665, $change_amount);
			}
			elsif ($text=~/\bFrogloks of Ykesha\b/) {	#:: 1666
				quest::faction(1666, $change_amount);
			}
			elsif ($text=~/\bFallen Follies of Mischief\b/) {	#:: 1667
				quest::faction(1667, $change_amount);
			}
			elsif ($text=~/\bLhranc the Disgraced\b/) {	#:: 1668
				quest::faction(1668, $change_amount);
			}
			elsif ($text=~/\bMinions of Enmity\b/) {	#:: 1669
				quest::faction(1669, $change_amount);
			}
			elsif ($text=~/\bMinions of Hope\b/) {	#:: 1670
				quest::faction(1670, $change_amount);
			}
			elsif ($text=~/\bAgents of the Pillars\b/) {	#:: 1671
				quest::faction(1671, $change_amount);
			}
			elsif ($text=~/\bFriends of Zordak Ragefire\b/) {	#:: 1672
				quest::faction(1672, $change_amount);
			}
			elsif ($text=~/\bEnemies of Zordak Ragefire\b/) {	#:: 1673
				quest::faction(1673, $change_amount);
			}
			elsif ($text=~/\bKyle Bayle\b/) {	#:: 1674
				quest::faction(1674, $change_amount);
			}
			elsif ($text=~/\bKyle Bayle's Royal Guard\b/) {	#:: 1675
				quest::faction(1675, $change_amount);
			}
			elsif ($text=~/\bHills Revenant\b/) {	#:: 1676
				quest::faction(1676, $change_amount);
			}
			elsif ($text=~/\bDead Hills Archaeologists\b/) {	#:: 1677
				quest::faction(1677, $change_amount);
			}
			elsif ($text=~/\bXulous of the Dead Hills\b/) {	#:: 1678
				quest::faction(1678, $change_amount);
			}
			elsif ($text=~/\bThe Kromtus\b/) {	#:: 1679
				quest::faction(1679, $change_amount);
			}
			elsif ($text=~/\bBloodfeather Aviaks\b/) {	#:: 1680
				quest::faction(1680, $change_amount);
			}
			elsif ($text=~/\bThe Thaell Ew\b/) {	#:: 1681
				quest::faction(1681, $change_amount);
			}
			elsif ($text=~/\bFaction1682\b/) {	#:: 1682
				quest::faction(1682, $change_amount);
			}
			elsif ($text=~/\bFaction1683\b/) {	#:: 1683
				quest::faction(1683, $change_amount);
			}
			elsif ($text=~/\bFaction1684\b/) {	#:: 1684
				quest::faction(1684, $change_amount);
			}
			elsif ($text=~/\bFaction1685\b/) {	#:: 1685
				quest::faction(1685, $change_amount);
			}
			elsif ($text=~/\bFaction1686\b/) {	#:: 1686
				quest::faction(1686, $change_amount);
			}
			elsif ($text=~/\bFaction1687\b/) {	#:: 1687
				quest::faction(1687, $change_amount);
			}
			elsif ($text=~/\bFaction1688\b/) {	#:: 1688
				quest::faction(1688, $change_amount);
			}
			elsif ($text=~/\bFaction1689\b/) {	#:: 1689
				quest::faction(1689, $change_amount);
			}
			elsif ($text=~/\bFaction1690\b/) {	#:: 1690
				quest::faction(1690, $change_amount);
			}
			elsif ($text=~/\bFaction1691\b/) {	#:: 1691
				quest::faction(1691, $change_amount);
			}
			elsif ($text=~/\bFaction1692\b/) {	#:: 1692
				quest::faction(1692, $change_amount);
			}
			elsif ($text=~/\bFaction1693\b/) {	#:: 1693
				quest::faction(1693, $change_amount);
			}
			elsif ($text=~/\bFaction1694\b/) {	#:: 1694
				quest::faction(1694, $change_amount);
			}
			elsif ($text=~/\bFaction1695\b/) {	#:: 1695
				quest::faction(1695, $change_amount);
			}
			elsif ($text=~/\bFaction1696\b/) {	#:: 1696
				quest::faction(1696, $change_amount);
			}
			elsif ($text=~/\bFaction1697\b/) {	#:: 1697
				quest::faction(1697, $change_amount);
			}
			elsif ($text=~/\bFaction1698\b/) {	#:: 1698
				quest::faction(1698, $change_amount);
			}
			elsif ($text=~/\bFaction1699\b/) {	#:: 1699
				quest::faction(1699, $change_amount);
			}
			elsif ($text=~/\bTorgiran\b/) {	#:: 1700
				quest::faction(1700, $change_amount);
			}
			elsif ($text=~/\bWarlord Ngrub\b/) {	#:: 1701
				quest::faction(1701, $change_amount);
			}
			elsif ($text=~/\bResistance Miners\b/) {	#:: 1702
				quest::faction(1702, $change_amount);
			}
			elsif ($text=~/\bNadox Initiate\b/) {	#:: 1703
				quest::faction(1703, $change_amount);
			}
			elsif ($text=~/\bCursed Frogloks of Gukta\b/) {	#:: 1704
				quest::faction(1704, $change_amount);
			}
			elsif ($text=~/\bCreatures of Gunthak\b/) {	#:: 1705
				quest::faction(1705, $change_amount);
			}
			elsif ($text=~/\bUndead of Gunthak\b/) {	#:: 1706
				quest::faction(1706, $change_amount);
			}
			elsif ($text=~/\bResidents of Gunthak\b/) {	#:: 1707
				quest::faction(1707, $change_amount);
			}
			elsif ($text=~/\bCrew of the Scorned Maiden\b/) {	#:: 1708
				quest::faction(1708, $change_amount);
			}
			elsif ($text=~/\bProtectors of Gukta\b/) {	#:: 1709
				quest::faction(1709, $change_amount);
			}
			elsif ($text=~/\bInnothule Monster\b/) {	#:: 1710
				quest::faction(1710, $change_amount);
			}
			elsif ($text=~/\bClerics of Gutka\b/) {	#:: 1711
				quest::faction(1711, $change_amount);
			}
			elsif ($text=~/\bWarriors of Gukta\b/) {	#:: 1712
				quest::faction(1712, $change_amount);
			}
			elsif ($text=~/\bPaladins of Gukta\b/) {	#:: 1713
				quest::faction(1713, $change_amount);
			}
			elsif ($text=~/\bWizards of Gukta\b/) {	#:: 1714
				quest::faction(1714, $change_amount);
			}
			elsif ($text=~/\bShaman of Gukta\b/) {	#:: 1715
				quest::faction(1715, $change_amount);
			}
			elsif ($text=~/\bHigh Council of Gukta\b/) {	#:: 1716
				quest::faction(1716, $change_amount);
			}
			elsif ($text=~/\bLorekeepers of Gukta\b/) {	#:: 1717
				quest::faction(1717, $change_amount);
			}
			elsif ($text=~/\bGuktan Elders\b/) {	#:: 1718
				quest::faction(1718, $change_amount);
			}
			elsif ($text=~/\bCitizens of Gukta\b/) {	#:: 1719
				quest::faction(1719, $change_amount);
			}
			elsif ($text=~/\bGuktan Suppliers\b/) {	#:: 1720
				quest::faction(1720, $change_amount);
			}
			elsif ($text=~/\bTroll Raiders\b/) {	#:: 1721
				quest::faction(1721, $change_amount);
			}
			elsif ($text=~/\bExiled Frogloks\b/) {	#:: 1722
				quest::faction(1722, $change_amount);
			}
			elsif ($text=~/\bGrimling Bandits\b/) {	#:: 1723
				quest::faction(1723, $change_amount);
			}
			elsif ($text=~/\bNewbie Monster\b/) {	#:: 1724
				quest::faction(1724, $change_amount);
			}
			elsif ($text=~/\bSyrik Iceblood\b/) {	#:: 1725
				quest::faction(1725, $change_amount);
			}
			elsif ($text=~/\bInhabitants of Time\b/) {	#:: 1726
				quest::faction(1726, $change_amount);
			}
			elsif ($text=~/\bCity Vermin\b/) {	#:: 1727
				quest::faction(1727, $change_amount);
			}
			elsif ($text=~/\bBetrayers of Di`Zok\b/) {	#:: 1728
				quest::faction(1728, $change_amount);
			}
			elsif ($text=~/\bFollowers of Korucust\b/) {	#:: 1729
				quest::faction(1729, $change_amount);
			}
			elsif ($text=~/\bLDoNGood\b/) {	#:: 1730
				quest::faction(1730, $change_amount);
			}
			elsif ($text=~/\bLDoNEvil\b/) {	#:: 1731
				quest::faction(1731, $change_amount);
			}
			elsif ($text=~/\bTribe Vrodak\b/) {	#:: 1732
				quest::faction(1732, $change_amount);
			}
			elsif ($text=~/\bWitnesses of Hate\b/) {	#:: 1733
				quest::faction(1733, $change_amount);
			}
			elsif ($text=~/\bForgotten Guktan Spirits\b/) {	#:: 1734
				quest::faction(1734, $change_amount);
			}
			elsif ($text=~/\bInnoruuk's Curse of the Cauldron\b/) {	#:: 1735
				quest::faction(1735, $change_amount);
			}
			elsif ($text=~/\bFrostfoot Goblins\b/) {	#:: 1736
				quest::faction(1736, $change_amount);
			}
			elsif ($text=~/\bLost Minions of Miragul\b/) {	#:: 1737
				quest::faction(1737, $change_amount);
			}
			elsif ($text=~/\bPlanar Collective\b/) {	#:: 1738
				quest::faction(1738, $change_amount);
			}
			elsif ($text=~/\bSynarcana\b/) {	#:: 1739
				quest::faction(1739, $change_amount);
			}
			elsif ($text=~/\bAgents of the Synarcana\b/) {	#:: 1740
				quest::faction(1740, $change_amount);
			}
			elsif ($text=~/\bOrphans\b/) {	#:: 1741
				quest::faction(1741, $change_amount);
			}
			elsif ($text=~/\bSustainers\b/) {	#:: 1742
				quest::faction(1742, $change_amount);
			}
			elsif ($text=~/\bLoyals\b/) {	#:: 1743
				quest::faction(1743, $change_amount);
			}
			elsif ($text=~/\bProgeny\b/) {	#:: 1744
				quest::faction(1744, $change_amount);
			}
			elsif ($text=~/\bRujarkian Slavers\b/) {	#:: 1745
				quest::faction(1745, $change_amount);
			}
			elsif ($text=~/\bThe Broken\b/) {	#:: 1746
				quest::faction(1746, $change_amount);
			}
			elsif ($text=~/\bSteelcrown\b/) {	#:: 1747
				quest::faction(1747, $change_amount);
			}
			elsif ($text=~/\bSpiritbound\b/) {	#:: 1748
				quest::faction(1748, $change_amount);
			}
			elsif ($text=~/\bSteelslaves\b/) {	#:: 1749
				quest::faction(1749, $change_amount);
			}
			elsif ($text=~/\bCitizens of Takish-Hiz\b/) {	#:: 1750
				quest::faction(1750, $change_amount);
			}
			elsif ($text=~/\bGeomantic Compact\b/) {	#:: 1751
				quest::faction(1751, $change_amount);
			}
			elsif ($text=~/\bRoyal Attendants\b/) {	#:: 1752
				quest::faction(1752, $change_amount);
			}
			elsif ($text=~/\bFlowkeepers\b/) {	#:: 1753
				quest::faction(1753, $change_amount);
			}
			elsif ($text=~/\bArchitects of Sand\b/) {	#:: 1754
				quest::faction(1754, $change_amount);
			}
			elsif ($text=~/\bSandworkers\b/) {	#:: 1755
				quest::faction(1755, $change_amount);
			}
			elsif ($text=~/\bLDoN Hostages\b/) {	#:: 1756
				quest::faction(1756, $change_amount);
			}
			elsif ($text=~/\bServants of the First Witness\b/) {	#:: 1757
				quest::faction(1757, $change_amount);
			}
			elsif ($text=~/\bGuktan Scouts\b/) {	#:: 1758
				quest::faction(1758, $change_amount);
			}
			elsif ($text=~/\bWayfarers Brotherhood\b/) {	#:: 1759
				quest::faction(1759, $change_amount);
			}
			elsif ($text=~/\bMinions of Mischief\b/) {	#:: 1760
				quest::faction(1760, $change_amount);
			}
			elsif ($text=~/\bNihil\b/) {	#:: 1761
				quest::faction(1761, $change_amount);
			}
			elsif ($text=~/\bTrusik Tribe\b/) {	#:: 1762
				quest::faction(1762, $change_amount);
			}
			elsif ($text=~/\bLegion of Mata Muram\b/) {	#:: 1763
				quest::faction(1763, $change_amount);
			}
			elsif ($text=~/\bTunat`Muram\b/) {	#:: 1764
				quest::faction(1764, $change_amount);
			}
			elsif ($text=~/\bZun`Muram\b/) {	#:: 1765
				quest::faction(1765, $change_amount);
			}
			elsif ($text=~/\bPixtt\b/) {	#:: 1766
				quest::faction(1766, $change_amount);
			}
			elsif ($text=~/\bHexxt\b/) {	#:: 1767
				quest::faction(1767, $change_amount);
			}
			elsif ($text=~/\bRav\b/) {	#:: 1768
				quest::faction(1768, $change_amount);
			}
			elsif ($text=~/\bCreatures of Taelosia\b/) {	#:: 1769
				quest::faction(1769, $change_amount);
			}
			elsif ($text=~/\bYunjo Slave Resistance\b/) {	#:: 1770
				quest::faction(1770, $change_amount);
			}
			elsif ($text=~/\bGladiators of Mata Muram\b/) {	#:: 1771
				quest::faction(1771, $change_amount);
			}
			elsif ($text=~/\bThe Sun\b/) {	#:: 1772
				quest::faction(1772, $change_amount);
			}
			elsif ($text=~/\bThe Moon\b/) {	#:: 1773
				quest::faction(1773, $change_amount);
			}
			elsif ($text=~/\bOrcakar Players\b/) {	#:: 1774
				quest::faction(1774, $change_amount);
			}
			elsif ($text=~/\bCitizens of Argath\b/) {	#:: 1775
				quest::faction(1775, $change_amount);
			}
			elsif ($text=~/\bLiving Steel\b/) {	#:: 1776
				quest::faction(1776, $change_amount);
			}
			elsif ($text=~/\bArgathian Looters\b/) {	#:: 1777
				quest::faction(1777, $change_amount);
			}
			elsif ($text=~/\bCitizens of Arelis\b/) {	#:: 1778
				quest::faction(1778, $change_amount);
			}
			elsif ($text=~/\bFarmers of the Lunanyn\b/) {	#:: 1779
				quest::faction(1779, $change_amount);
			}
			elsif ($text=~/\bMinions of War\b/) {	#:: 1780
				quest::faction(1780, $change_amount);
			}
			elsif ($text=~/\bMinions of the Sun\b/) {	#:: 1781
				quest::faction(1781, $change_amount);
			}
			elsif ($text=~/\bDominion of Beasts\b/) {	#:: 1782
				quest::faction(1782, $change_amount);
			}
			elsif ($text=~/\bCitizens of Sarith\b/) {	#:: 1783
				quest::faction(1783, $change_amount);
			}
			elsif ($text=~/\bDevout of Oseka\b/) {	#:: 1784
				quest::faction(1784, $change_amount);
			}
			elsif ($text=~/\bMinions of Prexus\b/) {	#:: 1785
				quest::faction(1785, $change_amount);
			}
			elsif ($text=~/\bSeekers of Splendor\b/) {	#:: 1786
				quest::faction(1786, $change_amount);
			}
			elsif ($text=~/\bOrder of Radiance\b/) {	#:: 1787
				quest::faction(1787, $change_amount);
			}
			elsif ($text=~/\bDevotees of Decay\b/) {	#:: 1788
				quest::faction(1788, $change_amount);
			}
			elsif ($text=~/\bPurity of Alra\b/) {	#:: 1789
				quest::faction(1789, $change_amount);
			}
			elsif ($text=~/\bParagons of Purity\b/) {	#:: 1790
				quest::faction(1790, $change_amount);
			}
			elsif ($text=~/\bShades of Alra\b/) {	#:: 1791
				quest::faction(1791, $change_amount);
			}
			elsif ($text=~/\bParagons of Shadows\b/) {	#:: 1792
				quest::faction(1792, $change_amount);
			}
			elsif ($text=~/\bArcanists of Alra\b/) {	#:: 1793
				quest::faction(1793, $change_amount);
			}
			elsif ($text=~/\bParagons of the Arcane\b/) {	#:: 1794
				quest::faction(1794, $change_amount);
			}
			elsif ($text=~/\bLiving Will of Alra\b/) {	#:: 1795
				quest::faction(1795, $change_amount);
			}
			elsif ($text=~/\bParagons of Will\b/) {	#:: 1796
				quest::faction(1796, $change_amount);
			}
			elsif ($text=~/\bServants of the Song\b/) {	#:: 1797
				quest::faction(1797, $change_amount);
			}
			elsif ($text=~/\bCitizens of Erillion\b/) {	#:: 1798
				quest::faction(1798, $change_amount);
			}
			elsif ($text=~/\bDisciples of Order\b/) {	#:: 1799
				quest::faction(1799, $change_amount);
			}
			elsif ($text=~/\bThe Godblooded\b/) {	#:: 1800
				quest::faction(1800, $change_amount);
			}
			elsif ($text=~/\bIceshard Manor\b/) {	#:: 1801
				quest::faction(1801, $change_amount);
			}
			elsif ($text=~/\bDragon Death Keep\b/) {	#:: 1802
				quest::faction(1802, $change_amount);
			}
			elsif ($text=~/\bApparitions of Fear\b/) {	#:: 1803
				quest::faction(1803, $change_amount);
			}
			elsif ($text=~/\bBeetles of Shard's Landing\b/) {	#:: 1804
				quest::faction(1804, $change_amount);
			}
			elsif ($text=~/\bOashim of Shard's Landing\b/) {	#:: 1805
				quest::faction(1805, $change_amount);
			}
			elsif ($text=~/\bPests of Shard's Landing\b/) {	#:: 1806
				quest::faction(1806, $change_amount);
			}
			elsif ($text=~/\bScavengers of Shard's Landing\b/) {	#:: 1807
				quest::faction(1807, $change_amount);
			}
			elsif ($text=~/\bKangon of Shard's Landing\b/) {	#:: 1808
				quest::faction(1808, $change_amount);
			}
			elsif ($text=~/\bBraxi of Shard's Landing\b/) {	#:: 1809
				quest::faction(1809, $change_amount);
			}
			elsif ($text=~/\bWyverns of Shard's Landing\b/) {	#:: 1810
				quest::faction(1810, $change_amount);
			}
			elsif ($text=~/\bSelyrah of Shard's Landing\b/) {	#:: 1811
				quest::faction(1811, $change_amount);
			}
			elsif ($text=~/\bGoral of Shard's Landing\b/) {	#:: 1812
				quest::faction(1812, $change_amount);
			}
			elsif ($text=~/\bSnakes of Shard's Landing\b/) {	#:: 1813
				quest::faction(1813, $change_amount);
			}
			elsif ($text=~/\bPumas of Shard's Landing\b/) {	#:: 1814
				quest::faction(1814, $change_amount);
			}
			elsif ($text=~/\bGrendlaen of Shard's Landing\b/) {	#:: 1815
				quest::faction(1815, $change_amount);
			}
			elsif ($text=~/\bWolves of Shard's Landing\b/) {	#:: 1816
				quest::faction(1816, $change_amount);
			}
			elsif ($text=~/\bHunters of Shard's Landing\b/) {	#:: 1817
				quest::faction(1817, $change_amount);
			}
			elsif ($text=~/\bForsaken Believers\b/) {	#:: 1818
				quest::faction(1818, $change_amount);
			}
			elsif ($text=~/\bThe Believers\b/) {	#:: 1819
				quest::faction(1819, $change_amount);
			}
			elsif ($text=~/\bThe Conscripted\b/) {	#:: 1820
				quest::faction(1820, $change_amount);
			}
			elsif ($text=~/\bHeralds of the Unspoken\b/) {	#:: 1821
				quest::faction(1821, $change_amount);
			}
			elsif ($text=~/\bHarbingers of Thule\b/) {	#:: 1822
				quest::faction(1822, $change_amount);
			}
			elsif ($text=~/\bVa`Ker\b/) {	#:: 1823
				quest::faction(1823, $change_amount);
			}
			elsif ($text=~/\bTerrorwing\b/) {	#:: 1824
				quest::faction(1824, $change_amount);
			}
			elsif ($text=~/\bCrystal Circle Builders\b/) {	#:: 1825
				quest::faction(1825, $change_amount);
			}
			elsif ($text=~/\bThe Unearthers\b/) {	#:: 1826
				quest::faction(1826, $change_amount);
			}
			elsif ($text=~/\bThe Displaced\b/) {	#:: 1827
				quest::faction(1827, $change_amount);
			}
			elsif ($text=~/\bThe Sol'Dal\b/) {	#:: 1828
				quest::faction(1828, $change_amount);
			}
			elsif ($text=~/\bThe Ember\b/) {	#:: 1829
				quest::faction(1829, $change_amount);
			}
			elsif ($text=~/\bDefenders of Decay\b/) {	#:: 1830
				quest::faction(1830, $change_amount);
			}
			elsif ($text=~/\bWarriors of Rodcet\b/) {	#:: 1831
				quest::faction(1831, $change_amount);
			}
			elsif ($text=~/\bFaction1832\b/) {	#:: 1832
				quest::faction(1832, $change_amount);
			}
			elsif ($text=~/\bFaction1833\b/) {	#:: 1833
				quest::faction(1833, $change_amount);
			}
			elsif ($text=~/\bFaction1834\b/) {	#:: 1834
				quest::faction(1834, $change_amount);
			}
			elsif ($text=~/\bHarrowing Horde\b/) {	#:: 1835
				quest::faction(1835, $change_amount);
			}
			elsif ($text=~/\bWestern Plains Bandits\b/) {	#:: 1836
				quest::faction(1836, $change_amount);
			}
			elsif ($text=~/\bUrsarachnids\b/) {	#:: 1837
				quest::faction(1837, $change_amount);
			}
			elsif ($text=~/\bDoomscale Cultists\b/) {	#:: 1838
				quest::faction(1838, $change_amount);
			}
			elsif ($text=~/\bNature Soul - Fire\b/) {	#:: 1839
				quest::faction(1839, $change_amount);
			}
			elsif ($text=~/\bNature Soul - Water\b/) {	#:: 1840
				quest::faction(1840, $change_amount);
			}
			elsif ($text=~/\bNature Soul - Earth\b/) {	#:: 1841
				quest::faction(1841, $change_amount);
			}
			elsif ($text=~/\bNature Soul - Wood\b/) {	#:: 1842
				quest::faction(1842, $change_amount);
			}
			elsif ($text=~/\bFlaming Jacks\b/) {	#:: 1843
				quest::faction(1843, $change_amount);
			}
			elsif ($text=~/\bEthernere Revenants\b/) {	#:: 1844
				quest::faction(1844, $change_amount);
			}
			elsif ($text=~/\bEthernere Spirits\b/) {	#:: 1845
				quest::faction(1845, $change_amount);
			}
			elsif ($text=~/\bKing Naythox Thex Loyalists\b/) {	#:: 1846
				quest::faction(1846, $change_amount);
			}
			elsif ($text=~/\bQueen Cristanos Thex Loyalists\b/) {	#:: 1847
				quest::faction(1847, $change_amount);
			}
			elsif ($text=~/\bNeriak Fourth Gate Residents\b/) {	#:: 1848
				quest::faction(1848, $change_amount);
			}
			elsif ($text=~/\bQeynos Guards of West Karana\b/) {	#:: 1849
				quest::faction(1849, $change_amount);
			}
			elsif ($text=~/\bFellowship of the Peacock\b/) {	#:: 1850
				quest::faction(1850, $change_amount);
			}
			elsif ($text=~/\bDamsel of Decay's Denizens\b/) {	#:: 1851
				quest::faction(1851, $change_amount);
			}
			elsif ($text=~/\bEnemies of Tranquility\b/) {	#:: 1852
				quest::faction(1852, $change_amount);
			}
			elsif ($text=~/\bLegion of the Overking\b/) {	#:: 1853
				quest::faction(1853, $change_amount);
			}
			elsif ($text=~/\bEmpire of the Di`Zok\b/) {	#:: 1854
				quest::faction(1854, $change_amount);
			}
			elsif ($text=~/\bKar`Zok\b/) {	#:: 1855
				quest::faction(1855, $change_amount);
			}
			elsif ($text=~/\bFlamescale Legion\b/) {	#:: 1856
				quest::faction(1856, $change_amount);
			}
			elsif ($text=~/\bGuardians of Konikor\b/) {	#:: 1857
				quest::faction(1857, $change_amount);
			}
			elsif ($text=~/\bClan Droga\b/) {	#:: 1858
				quest::faction(1858, $change_amount);
			}
			elsif ($text=~/\bMajestic Centurion Alliance\b/) {	#:: 1859
				quest::faction(1859, $change_amount);
			}
			elsif ($text=~/\bThe Clawdigger Clan\b/) {	#:: 1860
				quest::faction(1860, $change_amount);
			}
			elsif ($text=~/\bScorpiki\b/) {	#:: 1861
				quest::faction(1861, $change_amount);
			}
			elsif ($text=~/\bDenizens of Veeshan's Peak\b/) {	#:: 1862
				quest::faction(1862, $change_amount);
			}
			elsif ($text=~/\bServants of Esianti\b/) {	#:: 1863
				quest::faction(1863, $change_amount);
			}
			elsif ($text=~/\bServants of Aalishai\b/) {	#:: 1864
				quest::faction(1864, $change_amount);
			}
			elsif ($text=~/\bServants of Mearatas\b/) {	#:: 1865
				quest::faction(1865, $change_amount);
			}
			elsif ($text=~/\bServants of Loruella\b/) {	#:: 1866
				quest::faction(1866, $change_amount);
			}
			elsif ($text=~/\bContingent of the Alabaster Owl\b/) {	#:: 1867
				quest::faction(1867, $change_amount);
			}
			elsif ($text=~/\bBrass Phoenix Brigade\b/) {	#:: 1868
				quest::faction(1868, $change_amount);
			}
			elsif ($text=~/\bCompany of the Alabaster Owl\b/) {	#:: 1869
				quest::faction(1869, $change_amount);
			}
			elsif ($text=~/\bBrass Phoenix Legion\b/) {	#:: 1870
				quest::faction(1870, $change_amount);
			}
			elsif ($text=~/\bLords of Esianti\b/) {	#:: 1871
				quest::faction(1871, $change_amount);
			}
			elsif ($text=~/\bLords of Aalishai\b/) {	#:: 1872
				quest::faction(1872, $change_amount);
			}
			elsif ($text=~/\bBloodmoon Night-Orcs\b/) {	#:: 1873
				quest::faction(1873, $change_amount);
			}
			elsif ($text=~/\bFaction1874\b/) {	#:: 1874
				quest::faction(1874, $change_amount);
			}
			elsif ($text=~/\bFaction1875\b/) {	#:: 1875
				quest::faction(1875, $change_amount);
			}
			elsif ($text=~/\bFaction1876\b/) {	#:: 1876
				quest::faction(1876, $change_amount);
			}
			elsif ($text=~/\bFaction1877\b/) {	#:: 1877
				quest::faction(1877, $change_amount);
			}
			elsif ($text=~/\bFaction1878\b/) {	#:: 1878
				quest::faction(1878, $change_amount);
			}
			elsif ($text=~/\bFaction1879\b/) {	#:: 1879
				quest::faction(1879, $change_amount);
			}
			elsif ($text=~/\bFaction1880\b/) {	#:: 1880
				quest::faction(1880, $change_amount);
			}
			elsif ($text=~/\bFaction1881\b/) {	#:: 1881
				quest::faction(1881, $change_amount);
			}
			elsif ($text=~/\bFaction1882\b/) {	#:: 1882
				quest::faction(1882, $change_amount);
			}
			elsif ($text=~/\bFaction1883\b/) {	#:: 1883
				quest::faction(1883, $change_amount);
			}
			elsif ($text=~/\bFaction1884\b/) {	#:: 1884
				quest::faction(1884, $change_amount);
			}
			elsif ($text=~/\bFaction1885\b/) {	#:: 1885
				quest::faction(1885, $change_amount);
			}
			elsif ($text=~/\bFaction1886\b/) {	#:: 1886
				quest::faction(1886, $change_amount);
			}
			elsif ($text=~/\bFaction1887\b/) {	#:: 1887
				quest::faction(1887, $change_amount);
			}
			elsif ($text=~/\bFaction1888\b/) {	#:: 1888
				quest::faction(1888, $change_amount);
			}
			elsif ($text=~/\bFaction1889\b/) {	#:: 1889
				quest::faction(1889, $change_amount);
			}
			elsif ($text=~/\bFaction1890\b/) {	#:: 1890
				quest::faction(1890, $change_amount);
			}
			elsif ($text=~/\bFaction1891\b/) {	#:: 1891
				quest::faction(1891, $change_amount);
			}
			elsif ($text=~/\bFaction1892\b/) {	#:: 1892
				quest::faction(1892, $change_amount);
			}
			elsif ($text=~/\bFaction1893\b/) {	#:: 1893
				quest::faction(1893, $change_amount);
			}
			elsif ($text=~/\bFaction1894\b/) {	#:: 1894
				quest::faction(1894, $change_amount);
			}
			elsif ($text=~/\bFaction1895\b/) {	#:: 1895
				quest::faction(1895, $change_amount);
			}
			elsif ($text=~/\bFaction1896\b/) {	#:: 1896
				quest::faction(1896, $change_amount);
			}
			elsif ($text=~/\bFaction1897\b/) {	#:: 1897
				quest::faction(1897, $change_amount);
			}
			elsif ($text=~/\bFaction1898\b/) {	#:: 1898
				quest::faction(1898, $change_amount);
			}
			elsif ($text=~/\bFaction1899\b/) {	#:: 1899
				quest::faction(1899, $change_amount);
			}
			elsif ($text=~/\bFaction1900\b/) {	#:: 1900
				quest::faction(1900, $change_amount);
			}
			elsif ($text=~/\bFaction1901\b/) {	#:: 1901
				quest::faction(1901, $change_amount);
			}
			elsif ($text=~/\bFaction1902\b/) {	#:: 1902
				quest::faction(1902, $change_amount);
			}
			elsif ($text=~/\bFaction1903\b/) {	#:: 1903
				quest::faction(1903, $change_amount);
			}
			elsif ($text=~/\bFaction1904\b/) {	#:: 1904
				quest::faction(1904, $change_amount);
			}
			elsif ($text=~/\bFaction1905\b/) {	#:: 1905
				quest::faction(1905, $change_amount);
			}
			elsif ($text=~/\bFaction1906\b/) {	#:: 1906
				quest::faction(1906, $change_amount);
			}
			elsif ($text=~/\bFaction1907\b/) {	#:: 1907
				quest::faction(1907, $change_amount);
			}
			elsif ($text=~/\bFaction1908\b/) {	#:: 1908
				quest::faction(1908, $change_amount);
			}
			elsif ($text=~/\bFaction1909\b/) {	#:: 1909
				quest::faction(1909, $change_amount);
			}
			elsif ($text=~/\bFaction1910\b/) {	#:: 1910
				quest::faction(1910, $change_amount);
			}
			elsif ($text=~/\bFaction1911\b/) {	#:: 1911
				quest::faction(1911, $change_amount);
			}
			elsif ($text=~/\bFaction1912\b/) {	#:: 1912
				quest::faction(1912, $change_amount);
			}
			elsif ($text=~/\bFaction1913\b/) {	#:: 1913
				quest::faction(1913, $change_amount);
			}
			elsif ($text=~/\bFaction1914\b/) {	#:: 1914
				quest::faction(1914, $change_amount);
			}
			elsif ($text=~/\bFaction1915\b/) {	#:: 1915
				quest::faction(1915, $change_amount);
			}
			elsif ($text=~/\bFaction1916\b/) {	#:: 1916
				quest::faction(1916, $change_amount);
			}
			elsif ($text=~/\bFaction1917\b/) {	#:: 1917
				quest::faction(1917, $change_amount);
			}
			elsif ($text=~/\bFaction1918\b/) {	#:: 1918
				quest::faction(1918, $change_amount);
			}
			elsif ($text=~/\bFaction1919\b/) {	#:: 1919
				quest::faction(1919, $change_amount);
			}
			elsif ($text=~/\bFaction1920\b/) {	#:: 1920
				quest::faction(1920, $change_amount);
			}
			elsif ($text=~/\bFaction1921\b/) {	#:: 1921
				quest::faction(1921, $change_amount);
			}
			elsif ($text=~/\bFaction1922\b/) {	#:: 1922
				quest::faction(1922, $change_amount);
			}
			elsif ($text=~/\bFaction1923\b/) {	#:: 1923
				quest::faction(1923, $change_amount);
			}
			elsif ($text=~/\bFaction1924\b/) {	#:: 1924
				quest::faction(1924, $change_amount);
			}
			elsif ($text=~/\bFaction1925\b/) {	#:: 1925
				quest::faction(1925, $change_amount);
			}
			elsif ($text=~/\bFaction1926\b/) {	#:: 1926
				quest::faction(1926, $change_amount);
			}
			elsif ($text=~/\bFaction1927\b/) {	#:: 1927
				quest::faction(1927, $change_amount);
			}
			elsif ($text=~/\bFaction1928\b/) {	#:: 1928
				quest::faction(1928, $change_amount);
			}
			elsif ($text=~/\bFaction1929\b/) {	#:: 1929
				quest::faction(1929, $change_amount);
			}
			elsif ($text=~/\bFaction1930\b/) {	#:: 1930
				quest::faction(1930, $change_amount);
			}
			elsif ($text=~/\bFaction1931\b/) {	#:: 1931
				quest::faction(1931, $change_amount);
			}
			elsif ($text=~/\bFaction1932\b/) {	#:: 1932
				quest::faction(1932, $change_amount);
			}
			elsif ($text=~/\bFaction1933\b/) {	#:: 1933
				quest::faction(1933, $change_amount);
			}
			elsif ($text=~/\bFaction1934\b/) {	#:: 1934
				quest::faction(1934, $change_amount);
			}
			elsif ($text=~/\bFaction1935\b/) {	#:: 1935
				quest::faction(1935, $change_amount);
			}
			elsif ($text=~/\bFaction1936\b/) {	#:: 1936
				quest::faction(1936, $change_amount);
			}
			elsif ($text=~/\bFaction1937\b/) {	#:: 1937
				quest::faction(1937, $change_amount);
			}
			elsif ($text=~/\bFaction1938\b/) {	#:: 1938
				quest::faction(1938, $change_amount);
			}
			elsif ($text=~/\bFaction1939\b/) {	#:: 1939
				quest::faction(1939, $change_amount);
			}
			elsif ($text=~/\bFaction1940\b/) {	#:: 1940
				quest::faction(1940, $change_amount);
			}
			elsif ($text=~/\bFaction1941\b/) {	#:: 1941
				quest::faction(1941, $change_amount);
			}
			elsif ($text=~/\bFaction1942\b/) {	#:: 1942
				quest::faction(1942, $change_amount);
			}
			elsif ($text=~/\bFaction1943\b/) {	#:: 1943
				quest::faction(1943, $change_amount);
			}
			elsif ($text=~/\bFaction1944\b/) {	#:: 1944
				quest::faction(1944, $change_amount);
			}
			elsif ($text=~/\bFaction1945\b/) {	#:: 1945
				quest::faction(1945, $change_amount);
			}
			elsif ($text=~/\bFaction1946\b/) {	#:: 1946
				quest::faction(1946, $change_amount);
			}
			elsif ($text=~/\bFaction1947\b/) {	#:: 1947
				quest::faction(1947, $change_amount);
			}
			elsif ($text=~/\bFaction1948\b/) {	#:: 1948
				quest::faction(1948, $change_amount);
			}
			elsif ($text=~/\bFaction1949\b/) {	#:: 1949
				quest::faction(1949, $change_amount);
			}
			elsif ($text=~/\bFaction1950\b/) {	#:: 1950
				quest::faction(1950, $change_amount);
			}
			elsif ($text=~/\bFaction1951\b/) {	#:: 1951
				quest::faction(1951, $change_amount);
			}
			elsif ($text=~/\bFaction1952\b/) {	#:: 1952
				quest::faction(1952, $change_amount);
			}
			elsif ($text=~/\bFaction1953\b/) {	#:: 1953
				quest::faction(1953, $change_amount);
			}
			elsif ($text=~/\bFaction1954\b/) {	#:: 1954
				quest::faction(1954, $change_amount);
			}
			elsif ($text=~/\bFaction1955\b/) {	#:: 1955
				quest::faction(1955, $change_amount);
			}
			elsif ($text=~/\bFaction1956\b/) {	#:: 1956
				quest::faction(1956, $change_amount);
			}
			elsif ($text=~/\bFaction1957\b/) {	#:: 1957
				quest::faction(1957, $change_amount);
			}
			elsif ($text=~/\bFaction1958\b/) {	#:: 1958
				quest::faction(1958, $change_amount);
			}
			elsif ($text=~/\bFaction1959\b/) {	#:: 1959
				quest::faction(1959, $change_amount);
			}
			elsif ($text=~/\bFaction1960\b/) {	#:: 1960
				quest::faction(1960, $change_amount);
			}
			elsif ($text=~/\bFaction1961\b/) {	#:: 1961
				quest::faction(1961, $change_amount);
			}
			elsif ($text=~/\bFaction1962\b/) {	#:: 1962
				quest::faction(1962, $change_amount);
			}
			elsif ($text=~/\bFaction1963\b/) {	#:: 1963
				quest::faction(1963, $change_amount);
			}
			elsif ($text=~/\bFaction1964\b/) {	#:: 1964
				quest::faction(1964, $change_amount);
			}
			elsif ($text=~/\bFaction1965\b/) {	#:: 1965
				quest::faction(1965, $change_amount);
			}
			elsif ($text=~/\bFaction1966\b/) {	#:: 1966
				quest::faction(1966, $change_amount);
			}
			elsif ($text=~/\bFaction1967\b/) {	#:: 1967
				quest::faction(1967, $change_amount);
			}
			elsif ($text=~/\bFaction1968\b/) {	#:: 1968
				quest::faction(1968, $change_amount);
			}
			elsif ($text=~/\bFaction1969\b/) {	#:: 1969
				quest::faction(1969, $change_amount);
			}
			elsif ($text=~/\bFaction1970\b/) {	#:: 1970
				quest::faction(1970, $change_amount);
			}
			elsif ($text=~/\bFaction1971\b/) {	#:: 1971
				quest::faction(1971, $change_amount);
			}
			elsif ($text=~/\bFaction1972\b/) {	#:: 1972
				quest::faction(1972, $change_amount);
			}
			elsif ($text=~/\bFaction1973\b/) {	#:: 1973
				quest::faction(1973, $change_amount);
			}
			elsif ($text=~/\bFaction1974\b/) {	#:: 1974
				quest::faction(1974, $change_amount);
			}
			elsif ($text=~/\bFaction1975\b/) {	#:: 1975
				quest::faction(1975, $change_amount);
			}
			elsif ($text=~/\bFaction1976\b/) {	#:: 1976
				quest::faction(1976, $change_amount);
			}
			elsif ($text=~/\bFaction1977\b/) {	#:: 1977
				quest::faction(1977, $change_amount);
			}
			elsif ($text=~/\bFaction1978\b/) {	#:: 1978
				quest::faction(1978, $change_amount);
			}
			elsif ($text=~/\bFaction1979\b/) {	#:: 1979
				quest::faction(1979, $change_amount);
			}
			elsif ($text=~/\bFaction1980\b/) {	#:: 1980
				quest::faction(1980, $change_amount);
			}
			elsif ($text=~/\bFaction1981\b/) {	#:: 1981
				quest::faction(1981, $change_amount);
			}
			elsif ($text=~/\bFaction1982\b/) {	#:: 1982
				quest::faction(1982, $change_amount);
			}
			elsif ($text=~/\bFaction1983\b/) {	#:: 1983
				quest::faction(1983, $change_amount);
			}
			elsif ($text=~/\bFaction1984\b/) {	#:: 1984
				quest::faction(1984, $change_amount);
			}
			elsif ($text=~/\bFaction1985\b/) {	#:: 1985
				quest::faction(1985, $change_amount);
			}
			elsif ($text=~/\bFaction1986\b/) {	#:: 1986
				quest::faction(1986, $change_amount);
			}
			elsif ($text=~/\bFaction1987\b/) {	#:: 1987
				quest::faction(1987, $change_amount);
			}
			elsif ($text=~/\bFaction1988\b/) {	#:: 1988
				quest::faction(1988, $change_amount);
			}
			elsif ($text=~/\bFaction1989\b/) {	#:: 1989
				quest::faction(1989, $change_amount);
			}
			elsif ($text=~/\bFaction1990\b/) {	#:: 1990
				quest::faction(1990, $change_amount);
			}
			elsif ($text=~/\bFaction1991\b/) {	#:: 1991
				quest::faction(1991, $change_amount);
			}
			elsif ($text=~/\bFaction1992\b/) {	#:: 1992
				quest::faction(1992, $change_amount);
			}
			elsif ($text=~/\bFaction1993\b/) {	#:: 1993
				quest::faction(1993, $change_amount);
			}
			elsif ($text=~/\bFaction1994\b/) {	#:: 1994
				quest::faction(1994, $change_amount);
			}
			elsif ($text=~/\bFaction1995\b/) {	#:: 1995
				quest::faction(1995, $change_amount);
			}
			elsif ($text=~/\bFaction1996\b/) {	#:: 1996
				quest::faction(1996, $change_amount);
			}
			elsif ($text=~/\bFaction1997\b/) {	#:: 1997
				quest::faction(1997, $change_amount);
			}
			elsif ($text=~/\bFaction1998\b/) {	#:: 1998
				quest::faction(1998, $change_amount);
			}
			elsif ($text=~/\bFaction1999\b/) {	#:: 1999
				quest::faction(1999, $change_amount);
			}
			elsif ($text=~/\bFaction2000\b/) {	#:: 2000
				quest::faction(2000, $change_amount);
			}
			elsif ($text=~/\bFaction2001\b/) {	#:: 2001
				quest::faction(2001, $change_amount);
			}
			elsif ($text=~/\bFaction2002\b/) {	#:: 2002
				quest::faction(2002, $change_amount);
			}
			elsif ($text=~/\bFaction2003\b/) {	#:: 2003
				quest::faction(2003, $change_amount);
			}
			elsif ($text=~/\bFaction2004\b/) {	#:: 2004
				quest::faction(2004, $change_amount);
			}
			elsif ($text=~/\bFaction2005\b/) {	#:: 2005
				quest::faction(2005, $change_amount);
			}
			elsif ($text=~/\bFaction2006\b/) {	#:: 2006
				quest::faction(2006, $change_amount);
			}
			elsif ($text=~/\bFaction2007\b/) {	#:: 2007
				quest::faction(2007, $change_amount);
			}
			elsif ($text=~/\bFaction2008\b/) {	#:: 2008
				quest::faction(2008, $change_amount);
			}
			elsif ($text=~/\bFaction2009\b/) {	#:: 2009
				quest::faction(2009, $change_amount);
			}
			elsif ($text=~/\bFaction2010\b/) {	#:: 2010
				quest::faction(2010, $change_amount);
			}
			elsif ($text=~/\bFaction2011\b/) {	#:: 2011
				quest::faction(2011, $change_amount);
			}
			elsif ($text=~/\bFaction2012\b/) {	#:: 2012
				quest::faction(2012, $change_amount);
			}
			elsif ($text=~/\bFaction2013\b/) {	#:: 2013
				quest::faction(2013, $change_amount);
			}
			elsif ($text=~/\bFaction2014\b/) {	#:: 2014
				quest::faction(2014, $change_amount);
			}
			elsif ($text=~/\bFaction2015\b/) {	#:: 2015
				quest::faction(2015, $change_amount);
			}
			elsif ($text=~/\bFaction2016\b/) {	#:: 2016
				quest::faction(2016, $change_amount);
			}
			elsif ($text=~/\bFaction2017\b/) {	#:: 2017
				quest::faction(2017, $change_amount);
			}
			elsif ($text=~/\bFaction2018\b/) {	#:: 2018
				quest::faction(2018, $change_amount);
			}
			elsif ($text=~/\bFaction2019\b/) {	#:: 2019
				quest::faction(2019, $change_amount);
			}
			elsif ($text=~/\bFaction2020\b/) {	#:: 2020
				quest::faction(2020, $change_amount);
			}
			elsif ($text=~/\bFaction2021\b/) {	#:: 2021
				quest::faction(2021, $change_amount);
			}
			elsif ($text=~/\bFaction2022\b/) {	#:: 2022
				quest::faction(2022, $change_amount);
			}
			elsif ($text=~/\bFaction2023\b/) {	#:: 2023
				quest::faction(2023, $change_amount);
			}
			elsif ($text=~/\bFaction2024\b/) {	#:: 2024
				quest::faction(2024, $change_amount);
			}
			elsif ($text=~/\bFaction2025\b/) {	#:: 2025
				quest::faction(2025, $change_amount);
			}
			elsif ($text=~/\bFaction2026\b/) {	#:: 2026
				quest::faction(2026, $change_amount);
			}
			elsif ($text=~/\bFaction2027\b/) {	#:: 2027
				quest::faction(2027, $change_amount);
			}
			elsif ($text=~/\bFaction2028\b/) {	#:: 2028
				quest::faction(2028, $change_amount);
			}
			elsif ($text=~/\bFaction2029\b/) {	#:: 2029
				quest::faction(2029, $change_amount);
			}
			elsif ($text=~/\bFaction2030\b/) {	#:: 2030
				quest::faction(2030, $change_amount);
			}
			elsif ($text=~/\bFaction2031\b/) {	#:: 2031
				quest::faction(2031, $change_amount);
			}
			elsif ($text=~/\bFaction2032\b/) {	#:: 2032
				quest::faction(2032, $change_amount);
			}
			elsif ($text=~/\bFaction2033\b/) {	#:: 2033
				quest::faction(2033, $change_amount);
			}
			elsif ($text=~/\bFaction2034\b/) {	#:: 2034
				quest::faction(2034, $change_amount);
			}
			elsif ($text=~/\bFaction2035\b/) {	#:: 2035
				quest::faction(2035, $change_amount);
			}
			elsif ($text=~/\bFaction2036\b/) {	#:: 2036
				quest::faction(2036, $change_amount);
			}
			elsif ($text=~/\bFaction2037\b/) {	#:: 2037
				quest::faction(2037, $change_amount);
			}
			elsif ($text=~/\bFaction2038\b/) {	#:: 2038
				quest::faction(2038, $change_amount);
			}
			elsif ($text=~/\bFaction2039\b/) {	#:: 2039
				quest::faction(2039, $change_amount);
			}
			elsif ($text=~/\bFaction2040\b/) {	#:: 2040
				quest::faction(2040, $change_amount);
			}
			elsif ($text=~/\bFaction2041\b/) {	#:: 2041
				quest::faction(2041, $change_amount);
			}
			elsif ($text=~/\bFaction2042\b/) {	#:: 2042
				quest::faction(2042, $change_amount);
			}
			elsif ($text=~/\bFaction2043\b/) {	#:: 2043
				quest::faction(2043, $change_amount);
			}
			elsif ($text=~/\bFaction2044\b/) {	#:: 2044
				quest::faction(2044, $change_amount);
			}
			elsif ($text=~/\bFaction2045\b/) {	#:: 2045
				quest::faction(2045, $change_amount);
			}
			elsif ($text=~/\bFaction2046\b/) {	#:: 2046
				quest::faction(2046, $change_amount);
			}
			elsif ($text=~/\bFaction2047\b/) {	#:: 2047
				quest::faction(2047, $change_amount);
			}
			elsif ($text=~/\b376\b/) {	#:: Grobb Merchants
				quest::faction(376, $change_amount);
			}
			elsif ($text=~/\b375\b/) {	#:: Death Fist Orcs (good)
				quest::faction(375, $change_amount);
			}
			elsif ($text=~/\b374\b/) {	#:: Oggok Resident
				quest::faction(374, $change_amount);
			}
			elsif ($text=~/\b373\b/) {	#:: Mucktail Gnolls
				quest::faction(373, $change_amount);
			}
			elsif ($text=~/\b5001\b/) {	#:: Anti-mage
				quest::faction(5001, $change_amount);
			}
			elsif ($text=~/\b372\b/) {	#:: Najena
				quest::faction(372, $change_amount);
			}
			elsif ($text=~/\b371\b/) {	#:: Neriak Ghoul
				quest::faction(371, $change_amount);
			}
			elsif ($text=~/\b370\b/) {	#:: Dreadguard Inner
				quest::faction(370, $change_amount);
			}
			elsif ($text=~/\b369\b/) {	#:: Timmerain Darkbrow
				quest::faction(369, $change_amount);
			}
			elsif ($text=~/\b5002\b/) {	#:: Banker
				quest::faction(5002, $change_amount);
			}
			elsif ($text=~/\b368\b/) {	#:: Dervish Cutthroats
				quest::faction(368, $change_amount);
			}
			elsif ($text=~/\b367\b/) {	#:: Donovon
				quest::faction(367, $change_amount);
			}
			elsif ($text=~/\b366\b/) {	#:: Karana Bandits
				quest::faction(366, $change_amount);
			}
			elsif ($text=~/\b365\b/) {	#:: Pickclaw Goblins
				quest::faction(365, $change_amount);
			}
			elsif ($text=~/\b364\b/) {	#:: Shralok Orcs
				quest::faction(364, $change_amount);
			}
			elsif ($text=~/\b363\b/) {	#:: The Spurned
				quest::faction(363, $change_amount);
			}
			elsif ($text=~/\b362\b/) {	#:: Priests of Marr
				quest::faction(362, $change_amount);
			}
			elsif ($text=~/\b361\b/) {	#:: Ashen Order
				quest::faction(361, $change_amount);
			}
			elsif ($text=~/\b360\b/) {	#:: Iskar
				quest::faction(360, $change_amount);
			}
			elsif ($text=~/\b359\b/) {	#:: Defenders of Luclin
				quest::faction(359, $change_amount);
			}
			elsif ($text=~/\b358\b/) {	#:: Corrupt Akhevan
				quest::faction(358, $change_amount);
			}
			elsif ($text=~/\b357\b/) {	#:: Akhevan (Plane of Shadow)
				quest::faction(357, $change_amount);
			}
			elsif ($text=~/\b356\b/) {	#:: Diseased Animal
				quest::faction(356, $change_amount);
			}
			elsif ($text=~/\b355\b/) {	#:: Storm Reapers
				quest::faction(355, $change_amount);
			}
			elsif ($text=~/\b354\b/) {	#:: Neriak Troll
				quest::faction(354, $change_amount);
			}
			elsif ($text=~/\b353\b/) {	#:: Neriak Ogre
				quest::faction(353, $change_amount);
			}
			elsif ($text=~/\b352\b/) {	#:: Neriak Inner
				quest::faction(352, $change_amount);
			}
			elsif ($text=~/\b351\b/) {	#:: Neriak Outer
				quest::faction(351, $change_amount);
			}
			elsif ($text=~/\b350\b/) {	#:: Runnyeye C
				quest::faction(350, $change_amount);
			}
			elsif ($text=~/\b349\b/) {	#:: Runnyeye B
				quest::faction(349, $change_amount);
			}
			elsif ($text=~/\b348\b/) {	#:: Runnyeye A
				quest::faction(348, $change_amount);
			}
			elsif ($text=~/\b347\b/) {	#:: Shark
				quest::faction(347, $change_amount);
			}
			elsif ($text=~/\b346\b/) {	#:: Commons Residents
				quest::faction(346, $change_amount);
			}
			elsif ($text=~/\b345\b/) {	#:: Karana Residents
				quest::faction(345, $change_amount);
			}
			elsif ($text=~/\b344\b/) {	#:: Beta Neutral
				quest::faction(344, $change_amount);
			}
			elsif ($text=~/\b343\b/) {	#:: Surefall Protected Animals
				quest::faction(343, $change_amount);
			}
			elsif ($text=~/\b342\b/) {	#:: Order of Three
				quest::faction(342, $change_amount);
			}
			elsif ($text=~/\b341\b/) {	#:: Priests of Life
				quest::faction(341, $change_amount);
			}
			elsif ($text=~/\b340\b/) {	#:: Priests of Innoruuk
				quest::faction(340, $change_amount);
			}
			elsif ($text=~/\b339\b/) {	#:: Bonethrowers
				quest::faction(339, $change_amount);
			}
			elsif ($text=~/\b338\b/) {	#:: Merchants of Oggok
				quest::faction(338, $change_amount);
			}
			elsif ($text=~/\b337\b/) {	#:: Oggok Guards
				quest::faction(337, $change_amount);
			}
			elsif ($text=~/\b336\b/) {	#:: Coalition of Tradefolk Underground
				quest::faction(336, $change_amount);
			}
			elsif ($text=~/\b335\b/) {	#:: Thoughtbleeders of Fear
				quest::faction(335, $change_amount);
			}
			elsif ($text=~/\b334\b/) {	#:: Dreadguard Outer
				quest::faction(334, $change_amount);
			}
			elsif ($text=~/\b333\b/) {	#:: King Ak`Anon
				quest::faction(333, $change_amount);
			}
			elsif ($text=~/\b332\b/) {	#:: Highpass Guards
				quest::faction(332, $change_amount);
			}
			elsif ($text=~/\b331\b/) {	#:: Merchants of Highpass
				quest::faction(331, $change_amount);
			}
			elsif ($text=~/\b330\b/) {	#:: The Freeport Militia
				quest::faction(330, $change_amount);
			}
			elsif ($text=~/\b329\b/) {	#:: Carson McCabe
				quest::faction(329, $change_amount);
			}
			elsif ($text=~/\b328\b/) {	#:: Merchants of Halas
				quest::faction(328, $change_amount);
			}
			elsif ($text=~/\b327\b/) {	#:: Shamen of Justice
				quest::faction(327, $change_amount);
			}
			elsif ($text=~/\b326\b/) {	#:: Emerald Warriors
				quest::faction(326, $change_amount);
			}
			elsif ($text=~/\b325\b/) {	#:: Merchants of Felwithe
				quest::faction(325, $change_amount);
			}
			elsif ($text=~/\b324\b/) {	#:: Unkempt Druids
				quest::faction(324, $change_amount);
			}
			elsif ($text=~/\b323\b/) {	#:: Solusek Mining Co.
				quest::faction(323, $change_amount);
			}
			elsif ($text=~/\b322\b/) {	#:: Miners Guild 628
				quest::faction(322, $change_amount);
			}
			elsif ($text=~/\b321\b/) {	#:: Split Paw Clan
				quest::faction(321, $change_amount);
			}
			elsif ($text=~/\b5003\b/) {	#:: Defenders of the Haven
				quest::faction(5003, $change_amount);
			}
			elsif ($text=~/\b5004\b/) {	#:: Denizens of Fear
				quest::faction(5004, $change_amount);
			}
			elsif ($text=~/\b320\b/) {	#:: Wolves of the North
				quest::faction(320, $change_amount);
			}
			elsif ($text=~/\b319\b/) {	#:: Vox
				quest::faction(319, $change_amount);
			}
			elsif ($text=~/\b318\b/) {	#:: Venril Sathir
				quest::faction(318, $change_amount);
			}
			elsif ($text=~/\b317\b/) {	#:: Undead Frogloks of Guk
				quest::faction(317, $change_amount);
			}
			elsif ($text=~/\b316\b/) {	#:: Tunare's Scouts
				quest::faction(316, $change_amount);
			}
			elsif ($text=~/\b315\b/) {	#:: Trakanon
				quest::faction(315, $change_amount);
			}
			elsif ($text=~/\b314\b/) {	#:: Syth of Permafrost
				quest::faction(314, $change_amount);
			}
			elsif ($text=~/\b313\b/) {	#:: Pirates of Gunthak
				quest::faction(313, $change_amount);
			}
			elsif ($text=~/\b312\b/) {	#:: Storm Guard
				quest::faction(312, $change_amount);
			}
			elsif ($text=~/\b311\b/) {	#:: Steel Warriors
				quest::faction(311, $change_amount);
			}
			elsif ($text=~/\b310\b/) {	#:: Soldiers of Tunare
				quest::faction(310, $change_amount);
			}
			elsif ($text=~/\b309\b/) {	#:: Silent Fist Clan
				quest::faction(309, $change_amount);
			}
			elsif ($text=~/\b5005\b/) {	#:: Fizzlethorpe
				quest::faction(5005, $change_amount);
			}
			elsif ($text=~/\b308\b/) {	#:: Shadowknights of Night Keep
				quest::faction(308, $change_amount);
			}
			elsif ($text=~/\b307\b/) {	#:: Sarnak Collective
				quest::faction(307, $change_amount);
			}
			elsif ($text=~/\b306\b/) {	#:: Sabertooths of Blackburrow
				quest::faction(306, $change_amount);
			}
			elsif ($text=~/\b305\b/) {	#:: Rogues of the White Rose
				quest::faction(305, $change_amount);
			}
			elsif ($text=~/\b304\b/) {	#:: Ring of Scale
				quest::faction(304, $change_amount);
			}
			elsif ($text=~/\b303\b/) {	#:: Queen Cristanos Thex
				quest::faction(303, $change_amount);
			}
			elsif ($text=~/\b302\b/) {	#:: Protectors of Pine
				quest::faction(302, $change_amount);
			}
			elsif ($text=~/\b301\b/) {	#:: Priests of Nagafen
				quest::faction(301, $change_amount);
			}
			elsif ($text=~/\b300\b/) {	#:: Priests of Mischief
				quest::faction(300, $change_amount);
			}
			elsif ($text=~/\b299\b/) {	#:: Phinigel Autropos
				quest::faction(299, $change_amount);
			}
			elsif ($text=~/\b298\b/) {	#:: Peace Keepers
				quest::faction(298, $change_amount);
			}
			elsif ($text=~/\b297\b/) {	#:: Paladins of Underfoot
				quest::faction(297, $change_amount);
			}
			elsif ($text=~/\b296\b/) {	#:: Opal Darkbriar
				quest::faction(296, $change_amount);
			}
			elsif ($text=~/\b295\b/) {	#:: The Kromdek
				quest::faction(295, $change_amount);
			}
			elsif ($text=~/\b294\b/) {	#:: Miragul
				quest::faction(294, $change_amount);
			}
			elsif ($text=~/\b293\b/) {	#:: Miners Guild 249
				quest::faction(293, $change_amount);
			}
			elsif ($text=~/\b292\b/) {	#:: Merchants of Rivervale
				quest::faction(292, $change_amount);
			}
			elsif ($text=~/\b291\b/) {	#:: Merchants of Qeynos
				quest::faction(291, $change_amount);
			}
			elsif ($text=~/\b290\b/) {	#:: Merchants of Kaladim
				quest::faction(290, $change_amount);
			}
			elsif ($text=~/\b289\b/) {	#:: Merchants of Erudin
				quest::faction(289, $change_amount);
			}
			elsif ($text=~/\b288\b/) {	#:: Merchants of Ak`Anon
				quest::faction(288, $change_amount);
			}
			elsif ($text=~/\b287\b/) {	#:: Meldrath
				quest::faction(287, $change_amount);
			}
			elsif ($text=~/\b286\b/) {	#:: Mayor Gubbin
				quest::faction(286, $change_amount);
			}
			elsif ($text=~/\b285\b/) {	#:: Mayong Mistmoore
				quest::faction(285, $change_amount);
			}
			elsif ($text=~/\b284\b/) {	#:: League of Antonican Bards
				quest::faction(284, $change_amount);
			}
			elsif ($text=~/\b283\b/) {	#:: Pack of Tomar
				quest::faction(283, $change_amount);
			}
			elsif ($text=~/\b5006\b/) {	#:: Hall of the Ebon Mask
				quest::faction(5006, $change_amount);
			}
			elsif ($text=~/\b282\b/) {	#:: Kobolds of Fire Pit
				quest::faction(282, $change_amount);
			}
			elsif ($text=~/\b281\b/) {	#:: Knights of Truth
				quest::faction(281, $change_amount);
			}
			elsif ($text=~/\b280\b/) {	#:: Knights of Thunder
				quest::faction(280, $change_amount);
			}
			elsif ($text=~/\b279\b/) {	#:: King Tearis Thex
				quest::faction(279, $change_amount);
			}
			elsif ($text=~/\b278\b/) {	#:: King Naythox Thex
				quest::faction(278, $change_amount);
			}
			elsif ($text=~/\b277\b/) {	#:: Kerra of Barren Coast
				quest::faction(277, $change_amount);
			}
			elsif ($text=~/\b276\b/) {	#:: Kelethin Merchants
				quest::faction(276, $change_amount);
			}
			elsif ($text=~/\b275\b/) {	#:: Keepers of the Art
				quest::faction(275, $change_amount);
			}
			elsif ($text=~/\b274\b/) {	#:: Kazon Stormhammer
				quest::faction(274, $change_amount);
			}
			elsif ($text=~/\b273\b/) {	#:: Kane Bayle
				quest::faction(273, $change_amount);
			}
			elsif ($text=~/\b272\b/) {	#:: Jaggedpine Treefolk
				quest::faction(272, $change_amount);
			}
			elsif ($text=~/\b271\b/) {	#:: Dismal Rage
				quest::faction(271, $change_amount);
			}
			elsif ($text=~/\b270\b/) {	#:: Indigo Brotherhood
				quest::faction(270, $change_amount);
			}
			elsif ($text=~/\b269\b/) {	#:: Kithicor Residents
				quest::faction(269, $change_amount);
			}
			elsif ($text=~/\b268\b/) {	#:: Combine Empire
				quest::faction(268, $change_amount);
			}
			elsif ($text=~/\b267\b/) {	#:: High Guard of Erudin
				quest::faction(267, $change_amount);
			}
			elsif ($text=~/\b266\b/) {	#:: High Council of Erudin
				quest::faction(266, $change_amount);
			}
			elsif ($text=~/\b265\b/) {	#:: Heretics
				quest::faction(265, $change_amount);
			}
			elsif ($text=~/\b264\b/) {	#:: Whistling Fist Brotherhood
				quest::faction(264, $change_amount);
			}
			elsif ($text=~/\b263\b/) {	#:: Guardians of the Vale
				quest::faction(263, $change_amount);
			}
			elsif ($text=~/\b262\b/) {	#:: Guards of Qeynos
				quest::faction(262, $change_amount);
			}
			elsif ($text=~/\b261\b/) {	#:: Green Blood Knights
				quest::faction(261, $change_amount);
			}
			elsif ($text=~/\b260\b/) {	#:: Gnarled Fist
				quest::faction(260, $change_amount);
			}
			elsif ($text=~/\b259\b/) {	#:: Goblins of Mountain Death
				quest::faction(259, $change_amount);
			}
			elsif ($text=~/\b258\b/) {	#:: Goblins of Fire Peak
				quest::faction(258, $change_amount);
			}
			elsif ($text=~/\b5007\b/) {	#:: Keepers of the Claw
				quest::faction(5007, $change_amount);
			}
			elsif ($text=~/\b5008\b/) {	#:: Kejekan
				quest::faction(5008, $change_amount);
			}
			elsif ($text=~/\b257\b/) {	#:: Goblins of Cleaving Tooth
				quest::faction(257, $change_amount);
			}
			elsif ($text=~/\b256\b/) {	#:: Bloodgills
				quest::faction(256, $change_amount);
			}
			elsif ($text=~/\b255\b/) {	#:: Gem Choppers
				quest::faction(255, $change_amount);
			}
			elsif ($text=~/\b254\b/) {	#:: Gate Callers
				quest::faction(254, $change_amount);
			}
			elsif ($text=~/\b253\b/) {	#:: Burynai Legion
				quest::faction(253, $change_amount);
			}
			elsif ($text=~/\b252\b/) {	#:: Frogloks of Kunark
				quest::faction(252, $change_amount);
			}
			elsif ($text=~/\b251\b/) {	#:: Frogloks of Guk
				quest::faction(251, $change_amount);
			}
			elsif ($text=~/\b250\b/) {	#:: The Kromdul
				quest::faction(250, $change_amount);
			}
			elsif ($text=~/\b249\b/) {	#:: Nagafen
				quest::faction(249, $change_amount);
			}
			elsif ($text=~/\b248\b/) {	#:: Inhabitants of Firiona Vie
				quest::faction(248, $change_amount);
			}
			elsif ($text=~/\b247\b/) {	#:: Horde of Xalgoz
				quest::faction(247, $change_amount);
			}
			elsif ($text=~/\b246\b/) {	#:: Faydarks Champions
				quest::faction(246, $change_amount);
			}
			elsif ($text=~/\b5009\b/) {	#:: Kunark Fire Giants
				quest::faction(5009, $change_amount);
			}
			elsif ($text=~/\b245\b/) {	#:: Eldritch Collective
				quest::faction(245, $change_amount);
			}
			elsif ($text=~/\b244\b/) {	#:: Ebon Mask
				quest::faction(244, $change_amount);
			}
			elsif ($text=~/\b243\b/) {	#:: Drafling
				quest::faction(243, $change_amount);
			}
			elsif ($text=~/\b242\b/) {	#:: Deepwater Knights
				quest::faction(242, $change_amount);
			}
			elsif ($text=~/\b241\b/) {	#:: Deeppockets
				quest::faction(241, $change_amount);
			}
			elsif ($text=~/\b240\b/) {	#:: Deepmuses
				quest::faction(240, $change_amount);
			}
			elsif ($text=~/\b239\b/) {	#:: The Dead
				quest::faction(239, $change_amount);
			}
			elsif ($text=~/\b238\b/) {	#:: Dark Reflection
				quest::faction(238, $change_amount);
			}
			elsif ($text=~/\b237\b/) {	#:: Dark Ones
				quest::faction(237, $change_amount);
			}
			elsif ($text=~/\b236\b/) {	#:: Dark Bargainers
				quest::faction(236, $change_amount);
			}
			elsif ($text=~/\b235\b/) {	#:: DaBashers
				quest::faction(235, $change_amount);
			}
			elsif ($text=~/\b234\b/) {	#:: Crushbone Orcs
				quest::faction(234, $change_amount);
			}
			elsif ($text=~/\b233\b/) {	#:: Crimson Hands
				quest::faction(233, $change_amount);
			}
			elsif ($text=~/\b232\b/) {	#:: Craknek Warriors
				quest::faction(232, $change_amount);
			}
			elsif ($text=~/\b231\b/) {	#:: Craftkeepers
				quest::faction(231, $change_amount);
			}
			elsif ($text=~/\b230\b/) {	#:: Corrupt Qeynos Guards
				quest::faction(230, $change_amount);
			}
			elsif ($text=~/\b229\b/) {	#:: Coalition of Tradefolk
				quest::faction(229, $change_amount);
			}
			elsif ($text=~/\b228\b/) {	#:: Clurg
				quest::faction(228, $change_amount);
			}
			elsif ($text=~/\b227\b/) {	#:: Clerics of Underfoot
				quest::faction(227, $change_amount);
			}
			elsif ($text=~/\b226\b/) {	#:: Clerics of Tunare
				quest::faction(226, $change_amount);
			}
			elsif ($text=~/\b225\b/) {	#:: Clan Runnyeye
				quest::faction(225, $change_amount);
			}
			elsif ($text=~/\b224\b/) {	#:: Clan Drippycan
				quest::faction(224, $change_amount);
			}
			elsif ($text=~/\b223\b/) {	#:: Circle of Unseen Hands
				quest::faction(223, $change_amount);
			}
			elsif ($text=~/\b222\b/) {	#:: Broken Skull Clan
				quest::faction(222, $change_amount);
			}
			elsif ($text=~/\b221\b/) {	#:: Bloodsabers
				quest::faction(221, $change_amount);
			}
			elsif ($text=~/\b220\b/) {	#:: Arcane Scientists
				quest::faction(220, $change_amount);
			}
			elsif ($text=~/\b219\b/) {	#:: Antonius Bayle
				quest::faction(219, $change_amount);
			}
			elsif ($text=~/\b218\b/) {	#:: Allize Taeew
				quest::faction(218, $change_amount);
			}
			elsif ($text=~/\b217\b/) {	#:: Allize Volew
				quest::faction(217, $change_amount);
			}
			elsif ($text=~/\b216\b/) {	#:: Veeshan
				quest::faction(216, $change_amount);
			}
			elsif ($text=~/\b215\b/) {	#:: Tunare
				quest::faction(215, $change_amount);
			}
			elsif ($text=~/\b214\b/) {	#:: Tribunal
				quest::faction(214, $change_amount);
			}
			elsif ($text=~/\b213\b/) {	#:: Solusek Ro
				quest::faction(213, $change_amount);
			}
			elsif ($text=~/\b212\b/) {	#:: Rodcet Nife
				quest::faction(212, $change_amount);
			}
			elsif ($text=~/\b211\b/) {	#:: Rallos Zek
				quest::faction(211, $change_amount);
			}
			elsif ($text=~/\b210\b/) {	#:: Quellious
				quest::faction(210, $change_amount);
			}
			elsif ($text=~/\b209\b/) {	#:: Prexus
				quest::faction(209, $change_amount);
			}
			elsif ($text=~/\b208\b/) {	#:: Mithaniel Marr
				quest::faction(208, $change_amount);
			}
			elsif ($text=~/\b207\b/) {	#:: Karana
				quest::faction(207, $change_amount);
			}
			elsif ($text=~/\b5010\b/) {	#:: Ogre Warriors
				quest::faction(5010, $change_amount);
			}
			elsif ($text=~/\b206\b/) {	#:: Innoruuk
				quest::faction(206, $change_amount);
			}
			elsif ($text=~/\b205\b/) {	#:: Fizzlethorp
				quest::faction(205, $change_amount);
			}
			elsif ($text=~/\b204\b/) {	#:: Erollisi Marr
				quest::faction(204, $change_amount);
			}
			elsif ($text=~/\b203\b/) {	#:: Cazic-Thule
				quest::faction(203, $change_amount);
			}
			elsif ($text=~/\b202\b/) {	#:: Brell Serilis
				quest::faction(202, $change_amount);
			}
			elsif ($text=~/\b201\b/) {	#:: Bertoxxulous
				quest::faction(201, $change_amount);
			}
			elsif ($text=~/\b200\b/) {	#:: Erollisi Marr (Race)
				quest::faction(200, $change_amount);
			}
			elsif ($text=~/\b199\b/) {	#:: Iksar Scorpion
				quest::faction(199, $change_amount);
			}
			elsif ($text=~/\b198\b/) {	#:: Kunark Fish
				quest::faction(198, $change_amount);
			}
			elsif ($text=~/\b197\b/) {	#:: Spectral Iksar
				quest::faction(197, $change_amount);
			}
			elsif ($text=~/\b196\b/) {	#:: Spectral Sarnak
				quest::faction(196, $change_amount);
			}
			elsif ($text=~/\b195\b/) {	#:: Goo
				quest::faction(195, $change_amount);
			}
			elsif ($text=~/\b194\b/) {	#:: Burynai
				quest::faction(194, $change_amount);
			}
			elsif ($text=~/\b193\b/) {	#:: Race Faction (193)
				quest::faction(193, $change_amount);
			}
			elsif ($text=~/\b192\b/) {	#:: Race Faction (192)
				quest::faction(192, $change_amount);
			}
			elsif ($text=~/\b191\b/) {	#:: Boat
				quest::faction(191, $change_amount);
			}
			elsif ($text=~/\b190\b/) {	#:: Forest Giant
				quest::faction(190, $change_amount);
			}
			elsif ($text=~/\b189\b/) {	#:: Iksar Citizen
				quest::faction(189, $change_amount);
			}
			elsif ($text=~/\b188\b/) {	#:: Yeti
				quest::faction(188, $change_amount);
			}
			elsif ($text=~/\b187\b/) {	#:: Kunark Goblin
				quest::faction(187, $change_amount);
			}
			elsif ($text=~/\b186\b/) {	#:: Xalgoz Race
				quest::faction(186, $change_amount);
			}
			elsif ($text=~/\b185\b/) {	#:: Rhino
				quest::faction(185, $change_amount);
			}
			elsif ($text=~/\b184\b/) {	#:: Mosquito
				quest::faction(184, $change_amount);
			}
			elsif ($text=~/\b183\b/) {	#:: Lycanthrope
				quest::faction(183, $change_amount);
			}
			elsif ($text=~/\b182\b/) {	#:: Draglok Invalid Race
				quest::faction(182, $change_amount);
			}
			elsif ($text=~/\b181\b/) {	#:: Sarnak
				quest::faction(181, $change_amount);
			}
			elsif ($text=~/\b180\b/) {	#:: Vah Shir
				quest::faction(180, $change_amount);
			}
			elsif ($text=~/\b179\b/) {	#:: Scorpion
				quest::faction(179, $change_amount);
			}
			elsif ($text=~/\b178\b/) {	#:: Iksar
				quest::faction(178, $change_amount);
			}
			elsif ($text=~/\b177\b/) {	#:: Invisible Man
				quest::faction(177, $change_amount);
			}
			elsif ($text=~/\b176\b/) {	#:: Djinn (Race)
				quest::faction(176, $change_amount);
			}
			elsif ($text=~/\b175\b/) {	#:: Pegasus
				quest::faction(175, $change_amount);
			}
			elsif ($text=~/\b5011\b/) {	#:: Residents of Karanas
				quest::faction(5011, $change_amount);
			}
			elsif ($text=~/\b174\b/) {	#:: Unicorn Nightmare
				quest::faction(174, $change_amount);
			}
			elsif ($text=~/\b173\b/) {	#:: Innoruuk (Race)
				quest::faction(173, $change_amount);
			}
			elsif ($text=~/\b172\b/) {	#:: Dragon Skeleton
				quest::faction(172, $change_amount);
			}
			elsif ($text=~/\b5012\b/) {	#:: Root of Innuruuk
				quest::faction(5012, $change_amount);
			}
			elsif ($text=~/\b171\b/) {	#:: Gorgon
				quest::faction(171, $change_amount);
			}
			elsif ($text=~/\b170\b/) {	#:: SpiritWolf
				quest::faction(170, $change_amount);
			}
			elsif ($text=~/\b169\b/) {	#:: Saber-toothed Cat
				quest::faction(169, $change_amount);
			}
			elsif ($text=~/\b168\b/) {	#:: Erudite Ghost
				quest::faction(168, $change_amount);
			}
			elsif ($text=~/\b167\b/) {	#:: Ghost Dwarf
				quest::faction(167, $change_amount);
			}
			elsif ($text=~/\b166\b/) {	#:: Sea Horse
				quest::faction(166, $change_amount);
			}
			elsif ($text=~/\b165\b/) {	#:: Clam
				quest::faction(165, $change_amount);
			}
			elsif ($text=~/\b164\b/) {	#:: Ghost Ship
				quest::faction(164, $change_amount);
			}
			elsif ($text=~/\b163\b/) {	#:: Drixie
				quest::faction(163, $change_amount);
			}
			elsif ($text=~/\b162\b/) {	#:: Fayguard
				quest::faction(162, $change_amount);
			}
			elsif ($text=~/\b161\b/) {	#:: Harpie
				quest::faction(161, $change_amount);
			}
			elsif ($text=~/\b160\b/) {	#:: Mermaid
				quest::faction(160, $change_amount);
			}
			elsif ($text=~/\b159\b/) {	#:: Wasp
				quest::faction(159, $change_amount);
			}
			elsif ($text=~/\b158\b/) {	#:: Eye of Zomm
				quest::faction(158, $change_amount);
			}
			elsif ($text=~/\b157\b/) {	#:: Mammoth
				quest::faction(157, $change_amount);
			}
			elsif ($text=~/\b156\b/) {	#:: Fel Guard
				quest::faction(156, $change_amount);
			}
			elsif ($text=~/\b155\b/) {	#:: Sword Fish
				quest::faction(155, $change_amount);
			}
			elsif ($text=~/\b154\b/) {	#:: Leech
				quest::faction(154, $change_amount);
			}
			elsif ($text=~/\b153\b/) {	#:: Kedge
				quest::faction(153, $change_amount);
			}
			elsif ($text=~/\b152\b/) {	#:: Froglok Tadpole
				quest::faction(152, $change_amount);
			}
			elsif ($text=~/\b151\b/) {	#:: Efreeti
				quest::faction(151, $change_amount);
			}
			elsif ($text=~/\b150\b/) {	#:: Dervish
				quest::faction(150, $change_amount);
			}
			elsif ($text=~/\b149\b/) {	#:: Amygdalan
				quest::faction(149, $change_amount);
			}
			elsif ($text=~/\b148\b/) {	#:: Elf Vampire
				quest::faction(148, $change_amount);
			}
			elsif ($text=~/\b147\b/) {	#:: Diasy Men
				quest::faction(147, $change_amount);
			}
			elsif ($text=~/\b146\b/) {	#:: Cockatrice
				quest::faction(146, $change_amount);
			}
			elsif ($text=~/\b145\b/) {	#:: Cazic-Thule (Race)
				quest::faction(145, $change_amount);
			}
			elsif ($text=~/\b144\b/) {	#:: Kaladim Citizens
				quest::faction(144, $change_amount);
			}
			elsif ($text=~/\b143\b/) {	#:: Oggok Citizen
				quest::faction(143, $change_amount);
			}
			elsif ($text=~/\b142\b/) {	#:: Grobb Citizen
				quest::faction(142, $change_amount);
			}
			elsif ($text=~/\b141\b/) {	#:: Alligator
				quest::faction(141, $change_amount);
			}
			elsif ($text=~/\b140\b/) {	#:: Halas Citizen
				quest::faction(140, $change_amount);
			}
			elsif ($text=~/\b139\b/) {	#:: Drake
				quest::faction(139, $change_amount);
			}
			elsif ($text=~/\b138\b/) {	#:: Clockworks of Ak`Anon
				quest::faction(138, $change_amount);
			}
			elsif ($text=~/\b137\b/) {	#:: Armadillo
				quest::faction(137, $change_amount);
			}
			elsif ($text=~/\b136\b/) {	#:: Sphinx
				quest::faction(136, $change_amount);
			}
			elsif ($text=~/\b135\b/) {	#:: Spectre
				quest::faction(135, $change_amount);
			}
			elsif ($text=~/\b134\b/) {	#:: Snake Elemental
				quest::faction(134, $change_amount);
			}
			elsif ($text=~/\b133\b/) {	#:: Skunk
				quest::faction(133, $change_amount);
			}
			elsif ($text=~/\b132\b/) {	#:: Scarecrow
				quest::faction(132, $change_amount);
			}
			elsif ($text=~/\b131\b/) {	#:: Rivervale Guard
				quest::faction(131, $change_amount);
			}
			elsif ($text=~/\b130\b/) {	#:: Reanimated Hand
				quest::faction(130, $change_amount);
			}
			elsif ($text=~/\b129\b/) {	#:: Bixie
				quest::faction(129, $change_amount);
			}
			elsif ($text=~/\b128\b/) {	#:: Erudin Citizens
				quest::faction(128, $change_amount);
			}
			elsif ($text=~/\b127\b/) {	#:: Neriak Citizen
				quest::faction(127, $change_amount);
			}
			elsif ($text=~/\b126\b/) {	#:: Puma
				quest::faction(126, $change_amount);
			}
			elsif ($text=~/\b125\b/) {	#:: Elemental
				quest::faction(125, $change_amount);
			}
			elsif ($text=~/\b124\b/) {	#:: Piranha
				quest::faction(124, $change_amount);
			}
			elsif ($text=~/\b123\b/) {	#:: Launch
				quest::faction(123, $change_amount);
			}
			elsif ($text=~/\b122\b/) {	#:: Ship
				quest::faction(122, $change_amount);
			}
			elsif ($text=~/\b121\b/) {	#:: Qeynos Citizens
				quest::faction(121, $change_amount);
			}
			elsif ($text=~/\b120\b/) {	#:: Zombie
				quest::faction(120, $change_amount);
			}
			elsif ($text=~/\b119\b/) {	#:: Will-O-Wisp
				quest::faction(119, $change_amount);
			}
			elsif ($text=~/\b118\b/) {	#:: Tentacle
				quest::faction(118, $change_amount);
			}
			elsif ($text=~/\b117\b/) {	#:: High Hold Citizen
				quest::faction(117, $change_amount);
			}
			elsif ($text=~/\b116\b/) {	#:: Rallos Zek (Race)
				quest::faction(116, $change_amount);
			}
			elsif ($text=~/\b115\b/) {	#:: Vampire
				quest::faction(115, $change_amount);
			}
			elsif ($text=~/\b114\b/) {	#:: Treant
				quest::faction(114, $change_amount);
			}
			elsif ($text=~/\b113\b/) {	#:: Tiger
				quest::faction(113, $change_amount);
			}
			elsif ($text=~/\b112\b/) {	#:: Tunare (Race)
				quest::faction(112, $change_amount);
			}
			elsif ($text=~/\b111\b/) {	#:: Shark (Race)
				quest::faction(111, $change_amount);
			}
			elsif ($text=~/\b110\b/) {	#:: Skeleton
				quest::faction(110, $change_amount);
			}
			elsif ($text=~/\b109\b/) {	#:: Kunark Goblin (Race)
				quest::faction(109, $change_amount);
			}
			elsif ($text=~/\b108\b/) {	#:: Solusek Ro (Race)
				quest::faction(108, $change_amount);
			}
			elsif ($text=~/\b107\b/) {	#:: Drachnid (Race)
				quest::faction(107, $change_amount);
			}
			elsif ($text=~/\b106\b/) {	#:: Pixies of Faydwer
				quest::faction(106, $change_amount);
			}
			elsif ($text=~/\b105\b/) {	#:: Human Beggar
				quest::faction(105, $change_amount);
			}
			elsif ($text=~/\b104\b/) {	#:: Orc
				quest::faction(104, $change_amount);
			}
			elsif ($text=~/\b103\b/) {	#:: Minotaur
				quest::faction(103, $change_amount);
			}
			elsif ($text=~/\b102\b/) {	#:: Mimic
				quest::faction(102, $change_amount);
			}
			elsif ($text=~/\b101\b/) {	#:: Lizard Man
				quest::faction(101, $change_amount);
			}
			elsif ($text=~/\b100\b/) {	#:: Lion
				quest::faction(100, $change_amount);
			}
			elsif ($text=~/\b99\b/) {	#:: Lava Dragon
				quest::faction(99, $change_amount);
			}
			elsif ($text=~/\b98\b/) {	#:: Kobold
				quest::faction(98, $change_amount);
			}
			elsif ($text=~/\b97\b/) {	#:: Griffon
				quest::faction(97, $change_amount);
			}
			elsif ($text=~/\b96\b/) {	#:: Imp
				quest::faction(96, $change_amount);
			}
			elsif ($text=~/\b95\b/) {	#:: Demi Lich (Race)
				quest::faction(95, $change_amount);
			}
			elsif ($text=~/\b94\b/) {	#:: Human Guard (Race)
				quest::faction(94, $change_amount);
			}
			elsif ($text=~/\b93\b/) {	#:: Bear
				quest::faction(93, $change_amount);
			}
			elsif ($text=~/\b92\b/) {	#:: Wolf
				quest::faction(92, $change_amount);
			}
			elsif ($text=~/\b91\b/) {	#:: Gorilla
				quest::faction(91, $change_amount);
			}
			elsif ($text=~/\b90\b/) {	#:: Goblin
				quest::faction(90, $change_amount);
			}
			elsif ($text=~/\b89\b/) {	#:: Gnoll
				quest::faction(89, $change_amount);
			}
			elsif ($text=~/\b5013\b/) {	#:: KOS
				quest::faction(5013, $change_amount);
			}
			elsif ($text=~/\b5014\b/) {	#:: KOS_animal
				quest::faction(5014, $change_amount);
			}
			elsif ($text=~/\b5015\b/) {	#:: Coalition of TradeFolk III
				quest::faction(5015, $change_amount);
			}
			elsif ($text=~/\b5016\b/) {	#:: Swamp Giants of Kunark
				quest::faction(5016, $change_amount);
			}
			elsif ($text=~/\b88\b/) {	#:: Giant Spider
				quest::faction(88, $change_amount);
			}
			elsif ($text=~/\b5017\b/) {	#:: Murrissa Sandwhisper
				quest::faction(5017, $change_amount);
			}
			elsif ($text=~/\b87\b/) {	#:: Giant Snake
				quest::faction(87, $change_amount);
			}
			elsif ($text=~/\b86\b/) {	#:: Giant Rat
				quest::faction(86, $change_amount);
			}
			elsif ($text=~/\b5018\b/) {	#:: Mermaids
				quest::faction(5018, $change_amount);
			}
			elsif ($text=~/\b85\b/) {	#:: Beta KOS Copy 9
				quest::faction(85, $change_amount);
			}
			elsif ($text=~/\b84\b/) {	#:: Giant Bat
				quest::faction(84, $change_amount);
			}
			elsif ($text=~/\b5019\b/) {	#:: King Aythox Thex
				quest::faction(5019, $change_amount);
			}
			elsif ($text=~/\b83\b/) {	#:: Ghoul
				quest::faction(83, $change_amount);
			}
			elsif ($text=~/\b5020\b/) {	#:: Undead Residents of Kithicor
				quest::faction(5020, $change_amount);
			}
			elsif ($text=~/\b82\b/) {	#:: Ghost
				quest::faction(82, $change_amount);
			}
			elsif ($text=~/\b5021\b/) {	#:: Cleaving Tooth Clan
				quest::faction(5021, $change_amount);
			}
			elsif ($text=~/\b5022\b/) {	#:: Mountain Death Clan
				quest::faction(5022, $change_amount);
			}
			elsif ($text=~/\b81\b/) {	#:: Gelatinous Cube
				quest::faction(81, $change_amount);
			}
			elsif ($text=~/\b80\b/) {	#:: Race Faction (80)
				quest::faction(80, $change_amount);
			}
			elsif ($text=~/\b79\b/) {	#:: Gargoyle
				quest::faction(79, $change_amount);
			}
			elsif ($text=~/\b78\b/) {	#:: Fungus Man
				quest::faction(78, $change_amount);
			}
			elsif ($text=~/\b77\b/) {	#:: Froglok Ghoul
				quest::faction(77, $change_amount);
			}
			elsif ($text=~/\b76\b/) {	#:: Froglok
				quest::faction(76, $change_amount);
			}
			elsif ($text=~/\b75\b/) {	#:: Fairy (Race)
				quest::faction(75, $change_amount);
			}
			elsif ($text=~/\b5023\b/) {	#:: Noobie Monsters KOS to Guards
				quest::faction(5023, $change_amount);
			}
			elsif ($text=~/\b74\b/) {	#:: Fish
				quest::faction(74, $change_amount);
			}
			elsif ($text=~/\b73\b/) {	#:: Kerran (Race)
				quest::faction(73, $change_amount);
			}
			elsif ($text=~/\b72\b/) {	#:: Fire Beetle
				quest::faction(72, $change_amount);
			}
			elsif ($text=~/\b71\b/) {	#:: Evil Eye
				quest::faction(71, $change_amount);
			}
			elsif ($text=~/\b70\b/) {	#:: Venril Sathir (Race)
				quest::faction(70, $change_amount);
			}
			elsif ($text=~/\b69\b/) {	#:: Trakanon (Race)
				quest::faction(69, $change_amount);
			}
			elsif ($text=~/\b68\b/) {	#:: Cyclops
				quest::faction(68, $change_amount);
			}
			elsif ($text=~/\b67\b/) {	#:: Clay Golem
				quest::faction(67, $change_amount);
			}
			elsif ($text=~/\b66\b/) {	#:: Centaur
				quest::faction(66, $change_amount);
			}
			elsif ($text=~/\b5024\b/) {	#:: Death Fist Orcs
				quest::faction(5024, $change_amount);
			}
			elsif ($text=~/\b65\b/) {	#:: Brownies of Faydwer
				quest::faction(65, $change_amount);
			}
			elsif ($text=~/\b64\b/) {	#:: Werewolf
				quest::faction(64, $change_amount);
			}
			elsif ($text=~/\b63\b/) {	#:: Aviak
				quest::faction(63, $change_amount);
			}
			elsif ($text=~/\b62\b/) {	#:: Gnome
				quest::faction(62, $change_amount);
			}
			elsif ($text=~/\b61\b/) {	#:: Halfling
				quest::faction(61, $change_amount);
			}
			elsif ($text=~/\b60\b/) {	#:: Ogre
				quest::faction(60, $change_amount);
			}
			elsif ($text=~/\b59\b/) {	#:: Troll
				quest::faction(59, $change_amount);
			}
			elsif ($text=~/\b58\b/) {	#:: Dwarf
				quest::faction(58, $change_amount);
			}
			elsif ($text=~/\b57\b/) {	#:: Half Elf
				quest::faction(57, $change_amount);
			}
			elsif ($text=~/\b56\b/) {	#:: Dark Elf
				quest::faction(56, $change_amount);
			}
			elsif ($text=~/\b55\b/) {	#:: High Elf
				quest::faction(55, $change_amount);
			}
			elsif ($text=~/\b54\b/) {	#:: Wood Elf
				quest::faction(54, $change_amount);
			}
			elsif ($text=~/\b5025\b/) {	#:: Kaladim Merchants
				quest::faction(5025, $change_amount);
			}
			elsif ($text=~/\b53\b/) {	#:: Erudite
				quest::faction(53, $change_amount);
			}
			elsif ($text=~/\b52\b/) {	#:: Barbarian
				quest::faction(52, $change_amount);
			}
			elsif ($text=~/\b51\b/) {	#:: Human
				quest::faction(51, $change_amount);
			}
			elsif ($text=~/\b50\b/) {	#:: Class50
				quest::faction(50, $change_amount);
			}
			elsif ($text=~/\b49\b/) {	#:: Class49
				quest::faction(49, $change_amount);
			}
			elsif ($text=~/\b48\b/) {	#:: Class48
				quest::faction(48, $change_amount);
			}
			elsif ($text=~/\b47\b/) {	#:: Class47
				quest::faction(47, $change_amount);
			}
			elsif ($text=~/\b46\b/) {	#:: Class46
				quest::faction(46, $change_amount);
			}
			elsif ($text=~/\b45\b/) {	#:: Class45
				quest::faction(45, $change_amount);
			}
			elsif ($text=~/\b44\b/) {	#:: Class44
				quest::faction(44, $change_amount);
			}
			elsif ($text=~/\b5026\b/) {	#:: Ogguk Residents
				quest::faction(5026, $change_amount);
			}
			elsif ($text=~/\b43\b/) {	#:: Class43
				quest::faction(43, $change_amount);
			}
			elsif ($text=~/\b42\b/) {	#:: Class42
				quest::faction(42, $change_amount);
			}
			elsif ($text=~/\b5027\b/) {	#:: Phingel Autropos
				quest::faction(5027, $change_amount);
			}
			elsif ($text=~/\b41\b/) {	#:: Class41
				quest::faction(41, $change_amount);
			}
			elsif ($text=~/\b40\b/) {	#:: Class40
				quest::faction(40, $change_amount);
			}
			elsif ($text=~/\b39\b/) {	#:: Class39
				quest::faction(39, $change_amount);
			}
			elsif ($text=~/\b38\b/) {	#:: Class38
				quest::faction(38, $change_amount);
			}
			elsif ($text=~/\b37\b/) {	#:: Class37
				quest::faction(37, $change_amount);
			}
			elsif ($text=~/\b5028\b/) {	#:: Sky Talons
				quest::faction(5028, $change_amount);
			}
			elsif ($text=~/\b36\b/) {	#:: Class36
				quest::faction(36, $change_amount);
			}
			elsif ($text=~/\b35\b/) {	#:: Class35
				quest::faction(35, $change_amount);
			}
			elsif ($text=~/\b5029\b/) {	#:: Temple Of Sol Ro
				quest::faction(5029, $change_amount);
			}
			elsif ($text=~/\b34\b/) {	#:: Class34
				quest::faction(34, $change_amount);
			}
			elsif ($text=~/\b33\b/) {	#:: Class33
				quest::faction(33, $change_amount);
			}
			elsif ($text=~/\b32\b/) {	#:: Merchant
				quest::faction(32, $change_amount);
			}
			elsif ($text=~/\b31\b/) {	#:: Class31
				quest::faction(31, $change_amount);
			}
			elsif ($text=~/\b30\b/) {	#:: GUILDMASTERENCHANTER
				quest::faction(30, $change_amount);
			}
			elsif ($text=~/\b29\b/) {	#:: GUILDMASTERMAGICIAN
				quest::faction(29, $change_amount);
			}
			elsif ($text=~/\b28\b/) {	#:: GUILDMASTERWIZARD
				quest::faction(28, $change_amount);
			}
			elsif ($text=~/\b27\b/) {	#:: GUILDMASTERNECRO
				quest::faction(27, $change_amount);
			}
			elsif ($text=~/\b26\b/) {	#:: GUILDMASTERSHAMAN
				quest::faction(26, $change_amount);
			}
			elsif ($text=~/\b25\b/) {	#:: GUILDMASTERROGUE
				quest::faction(25, $change_amount);
			}
			elsif ($text=~/\b5030\b/) {	#:: Dulaks Clan
				quest::faction(5030, $change_amount);
			}
			elsif ($text=~/\b5031\b/) {	#:: Needlite
				quest::faction(5031, $change_amount);
			}
			elsif ($text=~/\b24\b/) {	#:: GUILDMASTERBARD
				quest::faction(24, $change_amount);
			}
			elsif ($text=~/\b5032\b/) {	#:: Indifferent
				quest::faction(5032, $change_amount);
			}
			elsif ($text=~/\b23\b/) {	#:: GUILDMASTERMONK
				quest::faction(23, $change_amount);
			}
			elsif ($text=~/\b22\b/) {	#:: GUILDMASTERDRUID
				quest::faction(22, $change_amount);
			}
			elsif ($text=~/\b21\b/) {	#:: GUILDMASTERSK
				quest::faction(21, $change_amount);
			}
			elsif ($text=~/\b5033\b/) {	#:: KOS Plane of Nightmare
				quest::faction(5033, $change_amount);
			}
			elsif ($text=~/\b5034\b/) {	#:: KOS Plane of Innovation
				quest::faction(5034, $change_amount);
			}
			elsif ($text=~/\b5035\b/) {	#:: WehateThelin
				quest::faction(5035, $change_amount);
			}
			elsif ($text=~/\b5036\b/) {	#:: HoHMaiden
				quest::faction(5036, $change_amount);
			}
			elsif ($text=~/\b5037\b/) {	#:: Nadox Clan
				quest::faction(5037, $change_amount);
			}
			elsif ($text=~/\b20\b/) {	#:: GUILDMASTERRANGER
				quest::faction(20, $change_amount);
			}
			elsif ($text=~/\b5038\b/) {	#:: Nitram
				quest::faction(5038, $change_amount);
			}
			elsif ($text=~/\b19\b/) {	#:: GUILDMASTERPALADIN
				quest::faction(19, $change_amount);
			}
			elsif ($text=~/\b5039\b/) {	#:: Residents of Gloomingdeep
				quest::faction(5039, $change_amount);
			}
			elsif ($text=~/\b5040\b/) {	#:: Madmen
				quest::faction(5040, $change_amount);
			}
			elsif ($text=~/\b18\b/) {	#:: GUILDMASTERCLERIC
				quest::faction(18, $change_amount);
			}
			elsif ($text=~/\b5041\b/) {	#:: VillagerRoom
				quest::faction(5041, $change_amount);
			}
			elsif ($text=~/\b17\b/) {	#:: GUILDMASTERWARRIOR
				quest::faction(17, $change_amount);
			}
			elsif ($text=~/\b16\b/) {	#:: Berserker
				quest::faction(16, $change_amount);
			}
			elsif ($text=~/\b5042\b/) {	#:: OmensBatRat
				quest::faction(5042, $change_amount);
			}
			elsif ($text=~/\b5043\b/) {	#:: Neriak Merchants
				quest::faction(5043, $change_amount);
			}
			elsif ($text=~/\b15\b/) {	#:: Beastlord
				quest::faction(15, $change_amount);
			}
			elsif ($text=~/\b5044\b/) {	#:: Planes_Neutral
				quest::faction(5044, $change_amount);
			}
			elsif ($text=~/\b5045\b/) {	#:: KOS Plane of Storms
				quest::faction(5045, $change_amount);
			}
			elsif ($text=~/\b5046\b/) {	#:: Paludal_Mushrooms
				quest::faction(5046, $change_amount);
			}
			elsif ($text=~/\b5047\b/) {	#:: Paludal_Underbulk
				quest::faction(5047, $change_amount);
			}
			elsif ($text=~/\b5048\b/) {	#:: The_Angry_Sambata
				quest::faction(5048, $change_amount);
			}
			elsif ($text=~/\b5049\b/) {	#:: Crescent Guards
				quest::faction(5049, $change_amount);
			}
			elsif ($text=~/\b14\b/) {	#:: Enchanter
				quest::faction(14, $change_amount);
			}
			elsif ($text=~/\b13\b/) {	#:: Magician
				quest::faction(13, $change_amount);
			}
			elsif ($text=~/\b12\b/) {	#:: Wizard
				quest::faction(12, $change_amount);
			}
			elsif ($text=~/\b11\b/) {	#:: Necromancer
				quest::faction(11, $change_amount);
			}
			elsif ($text=~/\b10\b/) {	#:: Shaman
				quest::faction(10, $change_amount);
			}
			elsif ($text=~/\b9\b/) {	#:: Rogue
				quest::faction(9, $change_amount);
			}
			elsif ($text=~/\b8\b/) {	#:: Bard
				quest::faction(8, $change_amount);
			}
			elsif ($text=~/\b7\b/) {	#:: Monk
				quest::faction(7, $change_amount);
			}
			elsif ($text=~/\b5050\b/) {	#:: Invaders of the Moor
				quest::faction(5050, $change_amount);
			}
			elsif ($text=~/\b6\b/) {	#:: Druid
				quest::faction(6, $change_amount);
			}
			elsif ($text=~/\b5\b/) {	#:: ShadowKnight
				quest::faction(5, $change_amount);
			}
			elsif ($text=~/\b4\b/) {	#:: Ranger
				quest::faction(4, $change_amount);
			}
			elsif ($text=~/\b3\b/) {	#:: Paladin
				quest::faction(3, $change_amount);
			}
			elsif ($text=~/\b2\b/) {	#:: Cleric
				quest::faction(2, $change_amount);
			}
			elsif ($text=~/\b5051\b/) {	#:: Asylum of Anguish
				quest::faction(5051, $change_amount);
			}
			elsif ($text=~/\b5052\b/) {	#:: dubious
				quest::faction(5052, $change_amount);
			}
			elsif ($text=~/\b5053\b/) {	#:: dubious-storms
				quest::faction(5053, $change_amount);
			}
			elsif ($text=~/\b1\b/) {	#:: Warrior
				quest::faction(1, $change_amount);
			}
			elsif ($text=~/\b5054\b/) {	#:: Scout_Guke
				quest::faction(5054, $change_amount);
			}
			elsif ($text=~/\b5055\b/) {	#:: Dark_Reign_Guard
				quest::faction(5055, $change_amount);
			}
			elsif ($text=~/\b0\b/) {	#:: NoFaction
				quest::faction(0, $change_amount);
			}
			elsif ($text=~/\b377\b/) {	#:: Grobb Guard
				quest::faction(377, $change_amount);
			}
			elsif ($text=~/\b378\b/) {	#:: Stone Hive Bixies
				quest::faction(378, $change_amount);
			}
			elsif ($text=~/\b379\b/) {	#:: Butcherblock Bandits
				quest::faction(379, $change_amount);
			}
			elsif ($text=~/\b380\b/) {	#:: Wood Elf Bards
				quest::faction(380, $change_amount);
			}
			elsif ($text=~/\b381\b/) {	#:: Tunare's Martyrs 2
				quest::faction(381, $change_amount);
			}
			elsif ($text=~/\b382\b/) {	#:: Kerra Isle
				quest::faction(382, $change_amount);
			}
			elsif ($text=~/\b383\b/) {	#:: Thunder Hooves
				quest::faction(383, $change_amount);
			}
			elsif ($text=~/\b384\b/) {	#:: Fay Scout
				quest::faction(384, $change_amount);
			}
			elsif ($text=~/\b385\b/) {	#:: Defective Clockwork
				quest::faction(385, $change_amount);
			}
			elsif ($text=~/\b386\b/) {	#:: Unrest Inhabitants
				quest::faction(386, $change_amount);
			}
			elsif ($text=~/\b387\b/) {	#:: Befallen Inhabitants
				quest::faction(387, $change_amount);
			}
			elsif ($text=~/\b388\b/) {	#:: Fairie
				quest::faction(388, $change_amount);
			}
			elsif ($text=~/\b389\b/) {	#:: Golem
				quest::faction(389, $change_amount);
			}
			elsif ($text=~/\b390\b/) {	#:: New Combine Guards
				quest::faction(390, $change_amount);
			}
			elsif ($text=~/\b391\b/) {	#:: New Combine
				quest::faction(391, $change_amount);
			}
			elsif ($text=~/\b392\b/) {	#:: Faction392
				quest::faction(392, $change_amount);
			}
			elsif ($text=~/\b393\b/) {	#:: Djinn
				quest::faction(393, $change_amount);
			}
			elsif ($text=~/\b394\b/) {	#:: Shamen of War
				quest::faction(394, $change_amount);
			}
			elsif ($text=~/\b395\b/) {	#:: Morawk
				quest::faction(395, $change_amount);
			}
			elsif ($text=~/\b396\b/) {	#:: Agnostic
				quest::faction(396, $change_amount);
			}
			elsif ($text=~/\b397\b/) {	#:: Sky Talons (good)
				quest::faction(397, $change_amount);
			}
			elsif ($text=~/\b398\b/) {	#:: Riptide Goblins
				quest::faction(398, $change_amount);
			}
			elsif ($text=~/\b399\b/) {	#:: Sea Furies
				quest::faction(399, $change_amount);
			}
			elsif ($text=~/\b400\b/) {	#:: Cult of Fear
				quest::faction(400, $change_amount);
			}
			elsif ($text=~/\b401\b/) {	#:: Song Weavers
				quest::faction(401, $change_amount);
			}
			elsif ($text=~/\b402\b/) {	#:: Oracle of K`Arnon
				quest::faction(402, $change_amount);
			}
			elsif ($text=~/\b403\b/) {	#:: Oracle of Marud
				quest::faction(403, $change_amount);
			}
			elsif ($text=~/\b404\b/) {	#:: Truespirit
				quest::faction(404, $change_amount);
			}
			elsif ($text=~/\b405\b/) {	#:: Dain Frostreaver IV
				quest::faction(405, $change_amount);
			}
			elsif ($text=~/\b406\b/) {	#:: Coldain
				quest::faction(406, $change_amount);
			}
			elsif ($text=~/\b407\b/) {	#:: Ry`Gorr Clan Snow Orcs
				quest::faction(407, $change_amount);
			}
			elsif ($text=~/\b408\b/) {	#:: Faction408
				quest::faction(408, $change_amount);
			}
			elsif ($text=~/\b409\b/) {	#:: Tserrina Syl`Tor
				quest::faction(409, $change_amount);
			}
			elsif ($text=~/\b410\b/) {	#:: Guide1
				quest::faction(410, $change_amount);
			}
			elsif ($text=~/\b411\b/) {	#:: Guide2
				quest::faction(411, $change_amount);
			}
			elsif ($text=~/\b412\b/) {	#:: Krag
				quest::faction(412, $change_amount);
			}
			elsif ($text=~/\b413\b/) {	#:: Guide3
				quest::faction(413, $change_amount);
			}
			elsif ($text=~/\b414\b/) {	#:: Residents of Fear
				quest::faction(414, $change_amount);
			}
			elsif ($text=~/\b415\b/) {	#:: Temple of Solusek Ro
				quest::faction(415, $change_amount);
			}
			elsif ($text=~/\b416\b/) {	#:: Shadowed Men
				quest::faction(416, $change_amount);
			}
			elsif ($text=~/\b417\b/) {	#:: Ankhefenmut
				quest::faction(417, $change_amount);
			}
			elsif ($text=~/\b418\b/) {	#:: Zazamoukh
				quest::faction(418, $change_amount);
			}
			elsif ($text=~/\b419\b/) {	#:: Kromrif
				quest::faction(419, $change_amount);
			}
			elsif ($text=~/\b420\b/) {	#:: Fallen of Bloody Kithicor
				quest::faction(420, $change_amount);
			}
			elsif ($text=~/\b421\b/) {	#:: Aggressors of Kithicor
				quest::faction(421, $change_amount);
			}
			elsif ($text=~/\b422\b/) {	#:: Defenders of Kithicor
				quest::faction(422, $change_amount);
			}
			elsif ($text=~/\b423\b/) {	#:: Verish Mal
				quest::faction(423, $change_amount);
			}
			elsif ($text=~/\b424\b/) {	#:: Inhabitants of Sky
				quest::faction(424, $change_amount);
			}
			elsif ($text=~/\b425\b/) {	#:: Inhabitants of Hate
				quest::faction(425, $change_amount);
			}
			elsif ($text=~/\b426\b/) {	#:: Agents of Mistmoore
				quest::faction(426, $change_amount);
			}
			elsif ($text=~/\b427\b/) {	#:: Spirocs of Timorous
				quest::faction(427, $change_amount);
			}
			elsif ($text=~/\b428\b/) {	#:: Minions of Underfoot
				quest::faction(428, $change_amount);
			}
			elsif ($text=~/\b429\b/) {	#:: King Tormax
				quest::faction(429, $change_amount);
			}
			elsif ($text=~/\b430\b/) {	#:: Claws of Veeshan
				quest::faction(430, $change_amount);
			}
			elsif ($text=~/\b431\b/) {	#:: Ulthork
				quest::faction(431, $change_amount);
			}
			elsif ($text=~/\b432\b/) {	#:: Othmir
				quest::faction(432, $change_amount);
			}
			elsif ($text=~/\b433\b/) {	#:: Jaled Dar
				quest::faction(433, $change_amount);
			}
			elsif ($text=~/\b434\b/) {	#:: Sirens of the Grotto
				quest::faction(434, $change_amount);
			}
			elsif ($text=~/\b435\b/) {	#:: Velketor
				quest::faction(435, $change_amount);
			}
			elsif ($text=~/\b436\b/) {	#:: Yelinak
				quest::faction(436, $change_amount);
			}
			elsif ($text=~/\b437\b/) {	#:: Denizens of Mischief
				quest::faction(437, $change_amount);
			}
			elsif ($text=~/\b438\b/) {	#:: Servants of Tunare
				quest::faction(438, $change_amount);
			}
			elsif ($text=~/\b439\b/) {	#:: Snowfang Gnolls
				quest::faction(439, $change_amount);
			}
			elsif ($text=~/\b440\b/) {	#:: Cabilis Residents
				quest::faction(440, $change_amount);
			}
			elsif ($text=~/\b441\b/) {	#:: Legion of Cabilis
				quest::faction(441, $change_amount);
			}
			elsif ($text=~/\b442\b/) {	#:: Crusaders of Greenmist
				quest::faction(442, $change_amount);
			}
			elsif ($text=~/\b443\b/) {	#:: Brood of Kotiz
				quest::faction(443, $change_amount);
			}
			elsif ($text=~/\b444\b/) {	#:: Swift Tails
				quest::faction(444, $change_amount);
			}
			elsif ($text=~/\b445\b/) {	#:: Scaled Mystics
				quest::faction(445, $change_amount);
			}
			elsif ($text=~/\b446\b/) {	#:: The Forsaken
				quest::faction(446, $change_amount);
			}
			elsif ($text=~/\b447\b/) {	#:: Pirates of Iceclad
				quest::faction(447, $change_amount);
			}
			elsif ($text=~/\b448\b/) {	#:: Kromzek
				quest::faction(448, $change_amount);
			}
			elsif ($text=~/\b449\b/) {	#:: Tunarean Court
				quest::faction(449, $change_amount);
			}
			elsif ($text=~/\b450\b/) {	#:: Thrall of Kly
				quest::faction(450, $change_amount);
			}
			elsif ($text=~/\b451\b/) {	#:: Brood of Di`Zok
				quest::faction(451, $change_amount);
			}
			elsif ($text=~/\b452\b/) {	#:: The Hotwingz
				quest::faction(452, $change_amount);
			}
			elsif ($text=~/\b453\b/) {	#:: Citizens of Torsis
				quest::faction(453, $change_amount);
			}
			elsif ($text=~/\b454\b/) {	#:: Drusella Sathir
				quest::faction(454, $change_amount);
			}
			elsif ($text=~/\b455\b/) {	#:: Minions of Scale
				quest::faction(455, $change_amount);
			}
			elsif ($text=~/\b456\b/) {	#:: Gelistial
				quest::faction(456, $change_amount);
			}
			elsif ($text=~/\b457\b/) {	#:: Holgresh
				quest::faction(457, $change_amount);
			}
			elsif ($text=~/\b458\b/) {	#:: Geonid Collective
				quest::faction(458, $change_amount);
			}
			elsif ($text=~/\b459\b/) {	#:: Lithiniath
				quest::faction(459, $change_amount);
			}
			elsif ($text=~/\b460\b/) {	#:: Citizens of Froststone
				quest::faction(460, $change_amount);
			}
			elsif ($text=~/\b461\b/) {	#:: Crystal Denizens
				quest::faction(461, $change_amount);
			}
			elsif ($text=~/\b462\b/) {	#:: Chetari
				quest::faction(462, $change_amount);
			}
			elsif ($text=~/\b463\b/) {	#:: Paebala
				quest::faction(463, $change_amount);
			}
			elsif ($text=~/\b464\b/) {	#:: Zlandicar
				quest::faction(464, $change_amount);
			}
			elsif ($text=~/\b465\b/) {	#:: Tizmak Clan
				quest::faction(465, $change_amount);
			}
			elsif ($text=~/\b466\b/) {	#:: Guardians of the Shrine
				quest::faction(466, $change_amount);
			}
			elsif ($text=~/\b467\b/) {	#:: Guardians of Veeshan
				quest::faction(467, $change_amount);
			}
			elsif ($text=~/\b468\b/) {	#:: The Sleeper
				quest::faction(468, $change_amount);
			}
			elsif ($text=~/\b469\b/) {	#:: Protectors of Growth
				quest::faction(469, $change_amount);
			}
			elsif ($text=~/\b470\b/) {	#:: Peoples Republic of Thurgadin
				quest::faction(470, $change_amount);
			}
			elsif ($text=~/\b471\b/) {	#:: Clan Kolbok
				quest::faction(471, $change_amount);
			}
			elsif ($text=~/\b472\b/) {	#:: Warders of The Claw
				quest::faction(472, $change_amount);
			}
			elsif ($text=~/\b473\b/) {	#:: Kejek Village
				quest::faction(473, $change_amount);
			}
			elsif ($text=~/\b474\b/) {	#:: Sporali
				quest::faction(474, $change_amount);
			}
			elsif ($text=~/\b475\b/) {	#:: King Xorbb
				quest::faction(475, $change_amount);
			}
			elsif ($text=~/\b476\b/) {	#:: Beta Good
				quest::faction(476, $change_amount);
			}
			elsif ($text=~/\b477\b/) {	#:: Beta Evil
				quest::faction(477, $change_amount);
			}
			elsif ($text=~/\b478\b/) {	#:: Beta Warmly
				quest::faction(478, $change_amount);
			}
			elsif ($text=~/\b479\b/) {	#:: Beta KOS
				quest::faction(479, $change_amount);
			}
			elsif ($text=~/\b480\b/) {	#:: Faction480
				quest::faction(480, $change_amount);
			}
			elsif ($text=~/\b481\b/) {	#:: Faction481
				quest::faction(481, $change_amount);
			}
			elsif ($text=~/\b482\b/) {	#:: Tribunal (Race)
				quest::faction(482, $change_amount);
			}
			elsif ($text=~/\b483\b/) {	#:: Bertoxxulous (Race)
				quest::faction(483, $change_amount);
			}
			elsif ($text=~/\b484\b/) {	#:: Bristlebane (Race)
				quest::faction(484, $change_amount);
			}
			elsif ($text=~/\b485\b/) {	#:: Faydrake
				quest::faction(485, $change_amount);
			}
			elsif ($text=~/\b486\b/) {	#:: Sarnak Skeleton
				quest::faction(486, $change_amount);
			}
			elsif ($text=~/\b487\b/) {	#:: Ratman
				quest::faction(487, $change_amount);
			}
			elsif ($text=~/\b488\b/) {	#:: Wyvern
				quest::faction(488, $change_amount);
			}
			elsif ($text=~/\b489\b/) {	#:: Wurm
				quest::faction(489, $change_amount);
			}
			elsif ($text=~/\b490\b/) {	#:: Devourer
				quest::faction(490, $change_amount);
			}
			elsif ($text=~/\b491\b/) {	#:: Iksar Golem
				quest::faction(491, $change_amount);
			}
			elsif ($text=~/\b492\b/) {	#:: Iksar Skeleton
				quest::faction(492, $change_amount);
			}
			elsif ($text=~/\b493\b/) {	#:: Man-Eating Plant
				quest::faction(493, $change_amount);
			}
			elsif ($text=~/\b494\b/) {	#:: Raptor
				quest::faction(494, $change_amount);
			}
			elsif ($text=~/\b495\b/) {	#:: Sarnak Golem
				quest::faction(495, $change_amount);
			}
			elsif ($text=~/\b496\b/) {	#:: Water Dragon
				quest::faction(496, $change_amount);
			}
			elsif ($text=~/\b497\b/) {	#:: Iksar Hand
				quest::faction(497, $change_amount);
			}
			elsif ($text=~/\b498\b/) {	#:: Cactus Man
				quest::faction(498, $change_amount);
			}
			elsif ($text=~/\b499\b/) {	#:: Flying Monkey
				quest::faction(499, $change_amount);
			}
			elsif ($text=~/\b500\b/) {	#:: Brontotherium
				quest::faction(500, $change_amount);
			}
			elsif ($text=~/\b501\b/) {	#:: Snow Dervish
				quest::faction(501, $change_amount);
			}
			elsif ($text=~/\b502\b/) {	#:: Dire Wolf
				quest::faction(502, $change_amount);
			}
			elsif ($text=~/\b503\b/) {	#:: Manticore
				quest::faction(503, $change_amount);
			}
			elsif ($text=~/\b504\b/) {	#:: Totem Man
				quest::faction(504, $change_amount);
			}
			elsif ($text=~/\b505\b/) {	#:: Cold Spectre
				quest::faction(505, $change_amount);
			}
			elsif ($text=~/\b506\b/) {	#:: Enchanted Armor
				quest::faction(506, $change_amount);
			}
			elsif ($text=~/\b507\b/) {	#:: Snow Bunny
				quest::faction(507, $change_amount);
			}
			elsif ($text=~/\b508\b/) {	#:: Walrus
				quest::faction(508, $change_amount);
			}
			elsif ($text=~/\b509\b/) {	#:: Rock Gem Man
				quest::faction(509, $change_amount);
			}
			elsif ($text=~/\b510\b/) {	#:: Race Faction (510)
				quest::faction(510, $change_amount);
			}
			elsif ($text=~/\b511\b/) {	#:: Race Faction (511)
				quest::faction(511, $change_amount);
			}
			elsif ($text=~/\b512\b/) {	#:: Yakman
				quest::faction(512, $change_amount);
			}
			elsif ($text=~/\b513\b/) {	#:: Faun
				quest::faction(513, $change_amount);
			}
			elsif ($text=~/\b514\b/) {	#:: Coldain (Race)
				quest::faction(514, $change_amount);
			}
			elsif ($text=~/\b515\b/) {	#:: Velious Dragon
				quest::faction(515, $change_amount);
			}
			elsif ($text=~/\b516\b/) {	#:: Hag
				quest::faction(516, $change_amount);
			}
			elsif ($text=~/\b517\b/) {	#:: Hippogriff
				quest::faction(517, $change_amount);
			}
			elsif ($text=~/\b518\b/) {	#:: Siren
				quest::faction(518, $change_amount);
			}
			elsif ($text=~/\b519\b/) {	#:: Frost Giant
				quest::faction(519, $change_amount);
			}
			elsif ($text=~/\b520\b/) {	#:: Storm Giant
				quest::faction(520, $change_amount);
			}
			elsif ($text=~/\b521\b/) {	#:: Otter Man
				quest::faction(521, $change_amount);
			}
			elsif ($text=~/\b522\b/) {	#:: Walrus Man
				quest::faction(522, $change_amount);
			}
			elsif ($text=~/\b523\b/) {	#:: Clockwork Dragon
				quest::faction(523, $change_amount);
			}
			elsif ($text=~/\b524\b/) {	#:: Abhorrent
				quest::faction(524, $change_amount);
			}
			elsif ($text=~/\b525\b/) {	#:: Sea Turtle
				quest::faction(525, $change_amount);
			}
			elsif ($text=~/\b526\b/) {	#:: BandWdragons
				quest::faction(526, $change_amount);
			}
			elsif ($text=~/\b527\b/) {	#:: Ghost Dragon
				quest::faction(527, $change_amount);
			}
			elsif ($text=~/\b528\b/) {	#:: Race Faction (528)
				quest::faction(528, $change_amount);
			}
			elsif ($text=~/\b529\b/) {	#:: Prismatic Dragon
				quest::faction(529, $change_amount);
			}
			elsif ($text=~/\b530\b/) {	#:: Shik Nar of Fungus Grove
				quest::faction(530, $change_amount);
			}
			elsif ($text=~/\b531\b/) {	#:: Rockhopper
				quest::faction(531, $change_amount);
			}
			elsif ($text=~/\b532\b/) {	#:: Underbulk
				quest::faction(532, $change_amount);
			}
			elsif ($text=~/\b533\b/) {	#:: Grimling
				quest::faction(533, $change_amount);
			}
			elsif ($text=~/\b534\b/) {	#:: Vacuum Worm
				quest::faction(534, $change_amount);
			}
			elsif ($text=~/\b535\b/) {	#:: Race Faction (535)
				quest::faction(535, $change_amount);
			}
			elsif ($text=~/\b536\b/) {	#:: Kahli Shah
				quest::faction(536, $change_amount);
			}
			elsif ($text=~/\b537\b/) {	#:: Owlbear
				quest::faction(537, $change_amount);
			}
			elsif ($text=~/\b538\b/) {	#:: Rhino Beetle
				quest::faction(538, $change_amount);
			}
			elsif ($text=~/\b539\b/) {	#:: Vampyre
				quest::faction(539, $change_amount);
			}
			elsif ($text=~/\b540\b/) {	#:: Earth Elemental (Race)
				quest::faction(540, $change_amount);
			}
			elsif ($text=~/\b541\b/) {	#:: Air Elemental (Race)
				quest::faction(541, $change_amount);
			}
			elsif ($text=~/\b542\b/) {	#:: Water Elemental (Race)
				quest::faction(542, $change_amount);
			}
			elsif ($text=~/\b543\b/) {	#:: Fire Elemental (Race)
				quest::faction(543, $change_amount);
			}
			elsif ($text=~/\b544\b/) {	#:: Wetfang Minnow
				quest::faction(544, $change_amount);
			}
			elsif ($text=~/\b545\b/) {	#:: Thought Horror
				quest::faction(545, $change_amount);
			}
			elsif ($text=~/\b546\b/) {	#:: Tegi
				quest::faction(546, $change_amount);
			}
			elsif ($text=~/\b547\b/) {	#:: Horse
				quest::faction(547, $change_amount);
			}
			elsif ($text=~/\b548\b/) {	#:: Shissar of Chelsith
				quest::faction(548, $change_amount);
			}
			elsif ($text=~/\b549\b/) {	#:: Fungal Fiend
				quest::faction(549, $change_amount);
			}
			elsif ($text=~/\b550\b/) {	#:: Vampire Volatalis
				quest::faction(550, $change_amount);
			}
			elsif ($text=~/\b551\b/) {	#:: Stonegrabber
				quest::faction(551, $change_amount);
			}
			elsif ($text=~/\b552\b/) {	#:: Scarlet Cheetah
				quest::faction(552, $change_amount);
			}
			elsif ($text=~/\b553\b/) {	#:: Zelniak
				quest::faction(553, $change_amount);
			}
			elsif ($text=~/\b554\b/) {	#:: Lightcrawler
				quest::faction(554, $change_amount);
			}
			elsif ($text=~/\b555\b/) {	#:: Shade
				quest::faction(555, $change_amount);
			}
			elsif ($text=~/\b556\b/) {	#:: Sunflower
				quest::faction(556, $change_amount);
			}
			elsif ($text=~/\b557\b/) {	#:: Sun Revenant
				quest::faction(557, $change_amount);
			}
			elsif ($text=~/\b558\b/) {	#:: Shrieker
				quest::faction(558, $change_amount);
			}
			elsif ($text=~/\b559\b/) {	#:: Galorian
				quest::faction(559, $change_amount);
			}
			elsif ($text=~/\b560\b/) {	#:: Netherbian
				quest::faction(560, $change_amount);
			}
			elsif ($text=~/\b561\b/) {	#:: Akheva (Race Type)
				quest::faction(561, $change_amount);
			}
			elsif ($text=~/\b562\b/) {	#:: Spire Spirit
				quest::faction(562, $change_amount);
			}
			elsif ($text=~/\b563\b/) {	#:: Sonic Wolf
				quest::faction(563, $change_amount);
			}
			elsif ($text=~/\b564\b/) {	#:: Ground Shaker
				quest::faction(564, $change_amount);
			}
			elsif ($text=~/\b565\b/) {	#:: Vah Shir Skeleton
				quest::faction(565, $change_amount);
			}
			elsif ($text=~/\b566\b/) {	#:: Mutant Humanoid
				quest::faction(566, $change_amount);
			}
			elsif ($text=~/\b567\b/) {	#:: Seru Race
				quest::faction(567, $change_amount);
			}
			elsif ($text=~/\b568\b/) {	#:: Recuso
				quest::faction(568, $change_amount);
			}
			elsif ($text=~/\b569\b/) {	#:: Vah Shir King (Race)
				quest::faction(569, $change_amount);
			}
			elsif ($text=~/\b570\b/) {	#:: Vah Shir Guard (Race)
				quest::faction(570, $change_amount);
			}
			elsif ($text=~/\b571\b/) {	#:: Portal Man (Race)
				quest::faction(571, $change_amount);
			}
			elsif ($text=~/\b572\b/) {	#:: Lujein
				quest::faction(572, $change_amount);
			}
			elsif ($text=~/\b573\b/) {	#:: Potamide
				quest::faction(573, $change_amount);
			}
			elsif ($text=~/\b574\b/) {	#:: Dryad
				quest::faction(574, $change_amount);
			}
			elsif ($text=~/\b575\b/) {	#:: Evil Treant
				quest::faction(575, $change_amount);
			}
			elsif ($text=~/\b576\b/) {	#:: Mutant Fly
				quest::faction(576, $change_amount);
			}
			elsif ($text=~/\b577\b/) {	#:: Tarew Marr
				quest::faction(577, $change_amount);
			}
			elsif ($text=~/\b578\b/) {	#:: Solusek Ro New
				quest::faction(578, $change_amount);
			}
			elsif ($text=~/\b579\b/) {	#:: Clockwork Golem
				quest::faction(579, $change_amount);
			}
			elsif ($text=~/\b580\b/) {	#:: Clockwork Brain
				quest::faction(580, $change_amount);
			}
			elsif ($text=~/\b581\b/) {	#:: Spectral Banshee
				quest::faction(581, $change_amount);
			}
			elsif ($text=~/\b582\b/) {	#:: Guard of Justice Race
				quest::faction(582, $change_amount);
			}
			elsif ($text=~/\b583\b/) {	#:: Mischief Castle
				quest::faction(583, $change_amount);
			}
			elsif ($text=~/\b584\b/) {	#:: Disease Boss
				quest::faction(584, $change_amount);
			}
			elsif ($text=~/\b585\b/) {	#:: Sol Ro Guard
				quest::faction(585, $change_amount);
			}
			elsif ($text=~/\b586\b/) {	#:: Bertoxxulous Race
				quest::faction(586, $change_amount);
			}
			elsif ($text=~/\b587\b/) {	#:: Tribunal Race
				quest::faction(587, $change_amount);
			}
			elsif ($text=~/\b588\b/) {	#:: Terris-Thule
				quest::faction(588, $change_amount);
			}
			elsif ($text=~/\b589\b/) {	#:: Vegerog
				quest::faction(589, $change_amount);
			}
			elsif ($text=~/\b590\b/) {	#:: Crocodile
				quest::faction(590, $change_amount);
			}
			elsif ($text=~/\b591\b/) {	#:: POP Bat
				quest::faction(591, $change_amount);
			}
			elsif ($text=~/\b592\b/) {	#:: Slarghilug
				quest::faction(592, $change_amount);
			}
			elsif ($text=~/\b593\b/) {	#:: Tranquilion
				quest::faction(593, $change_amount);
			}
			elsif ($text=~/\b594\b/) {	#:: Tin Soldier
				quest::faction(594, $change_amount);
			}
			elsif ($text=~/\b595\b/) {	#:: Nightmare Wraith
				quest::faction(595, $change_amount);
			}
			elsif ($text=~/\b596\b/) {	#:: Malarian
				quest::faction(596, $change_amount);
			}
			elsif ($text=~/\b597\b/) {	#:: Knight of Pestilence
				quest::faction(597, $change_amount);
			}
			elsif ($text=~/\b598\b/) {	#:: Lepertoloth
				quest::faction(598, $change_amount);
			}
			elsif ($text=~/\b599\b/) {	#:: Bubonian Boss
				quest::faction(599, $change_amount);
			}
			elsif ($text=~/\b600\b/) {	#:: Bubonian Underling
				quest::faction(600, $change_amount);
			}
			elsif ($text=~/\b601\b/) {	#:: Pusling
				quest::faction(601, $change_amount);
			}
			elsif ($text=~/\b602\b/) {	#:: Mephit
				quest::faction(602, $change_amount);
			}
			elsif ($text=~/\b603\b/) {	#:: Stormrider
				quest::faction(603, $change_amount);
			}
			elsif ($text=~/\b604\b/) {	#:: Junk Beast
				quest::faction(604, $change_amount);
			}
			elsif ($text=~/\b605\b/) {	#:: Broken Clockwork
				quest::faction(605, $change_amount);
			}
			elsif ($text=~/\b606\b/) {	#:: Giant Clockwork
				quest::faction(606, $change_amount);
			}
			elsif ($text=~/\b607\b/) {	#:: Clockwork Beetle
				quest::faction(607, $change_amount);
			}
			elsif ($text=~/\b608\b/) {	#:: Nightmare Goblin
				quest::faction(608, $change_amount);
			}
			elsif ($text=~/\b609\b/) {	#:: Karana Race
				quest::faction(609, $change_amount);
			}
			elsif ($text=~/\b610\b/) {	#:: Blood Raven
				quest::faction(610, $change_amount);
			}
			elsif ($text=~/\b611\b/) {	#:: Nightmare Gargoyle
				quest::faction(611, $change_amount);
			}
			elsif ($text=~/\b612\b/) {	#:: Mouths of Insanity
				quest::faction(612, $change_amount);
			}
			elsif ($text=~/\b613\b/) {	#:: Skeletal Horse
				quest::faction(613, $change_amount);
			}
			elsif ($text=~/\b614\b/) {	#:: Saryrn Race
				quest::faction(614, $change_amount);
			}
			elsif ($text=~/\b615\b/) {	#:: Fennin Ro
				quest::faction(615, $change_amount);
			}
			elsif ($text=~/\b616\b/) {	#:: Tormentor
				quest::faction(616, $change_amount);
			}
			elsif ($text=~/\b617\b/) {	#:: Necromancer Priest
				quest::faction(617, $change_amount);
			}
			elsif ($text=~/\b618\b/) {	#:: Nightmare, Planar
				quest::faction(618, $change_amount);
			}
			elsif ($text=~/\b619\b/) {	#:: Rallos Zek Race Faction
				quest::faction(619, $change_amount);
			}
			elsif ($text=~/\b620\b/) {	#:: Vallon Zek Race Faction
				quest::faction(620, $change_amount);
			}
			elsif ($text=~/\b621\b/) {	#:: Tallon Zek Race Faction
				quest::faction(621, $change_amount);
			}
			elsif ($text=~/\b622\b/) {	#:: Air Mephit
				quest::faction(622, $change_amount);
			}
			elsif ($text=~/\b623\b/) {	#:: Earth Mephit
				quest::faction(623, $change_amount);
			}
			elsif ($text=~/\b624\b/) {	#:: Fire Mephit
				quest::faction(624, $change_amount);
			}
			elsif ($text=~/\b625\b/) {	#:: Nightmare Mephit
				quest::faction(625, $change_amount);
			}
			elsif ($text=~/\b626\b/) {	#:: Zebuxoruk
				quest::faction(626, $change_amount);
			}
			elsif ($text=~/\b627\b/) {	#:: Mithaniel Marr (Race)
				quest::faction(627, $change_amount);
			}
			elsif ($text=~/\b628\b/) {	#:: Undead Knight
				quest::faction(628, $change_amount);
			}
			elsif ($text=~/\b629\b/) {	#:: The Rathe
				quest::faction(629, $change_amount);
			}
			elsif ($text=~/\b630\b/) {	#:: Xegony
				quest::faction(630, $change_amount);
			}
			elsif ($text=~/\b631\b/) {	#:: Greater Fiend
				quest::faction(631, $change_amount);
			}
			elsif ($text=~/\b632\b/) {	#:: Race Faction (632)
				quest::faction(632, $change_amount);
			}
			elsif ($text=~/\b633\b/) {	#:: Crab
				quest::faction(633, $change_amount);
			}
			elsif ($text=~/\b634\b/) {	#:: Phoenix
				quest::faction(634, $change_amount);
			}
			elsif ($text=~/\b635\b/) {	#:: Quarm (Race)
				quest::faction(635, $change_amount);
			}
			elsif ($text=~/\b636\b/) {	#:: Bear PoP
				quest::faction(636, $change_amount);
			}
			elsif ($text=~/\b637\b/) {	#:: Storm Taarid
				quest::faction(637, $change_amount);
			}
			elsif ($text=~/\b638\b/) {	#:: Storm Satuur
				quest::faction(638, $change_amount);
			}
			elsif ($text=~/\b639\b/) {	#:: Storm Kuraaln
				quest::faction(639, $change_amount);
			}
			elsif ($text=~/\b640\b/) {	#:: Storm Volaas
				quest::faction(640, $change_amount);
			}
			elsif ($text=~/\b641\b/) {	#:: Storm Mana
				quest::faction(641, $change_amount);
			}
			elsif ($text=~/\b642\b/) {	#:: Storm Fire
				quest::faction(642, $change_amount);
			}
			elsif ($text=~/\b643\b/) {	#:: Storm Celestial
				quest::faction(643, $change_amount);
			}
			elsif ($text=~/\b644\b/) {	#:: War Wraith
				quest::faction(644, $change_amount);
			}
			elsif ($text=~/\b645\b/) {	#:: Wrulon
				quest::faction(645, $change_amount);
			}
			elsif ($text=~/\b646\b/) {	#:: Kraken
				quest::faction(646, $change_amount);
			}
			elsif ($text=~/\b647\b/) {	#:: Poison Frog
				quest::faction(647, $change_amount);
			}
			elsif ($text=~/\b648\b/) {	#:: Queztocoatal
				quest::faction(648, $change_amount);
			}
			elsif ($text=~/\b649\b/) {	#:: Valorian (War Soldier)
				quest::faction(649, $change_amount);
			}
			elsif ($text=~/\b650\b/) {	#:: War Boar
				quest::faction(650, $change_amount);
			}
			elsif ($text=~/\b651\b/) {	#:: Efreeti PoP
				quest::faction(651, $change_amount);
			}
			elsif ($text=~/\b652\b/) {	#:: War Boar Unarmored
				quest::faction(652, $change_amount);
			}
			elsif ($text=~/\b653\b/) {	#:: Black Knight
				quest::faction(653, $change_amount);
			}
			elsif ($text=~/\b654\b/) {	#:: Animated Armor
				quest::faction(654, $change_amount);
			}
			elsif ($text=~/\b655\b/) {	#:: Undead Footman
				quest::faction(655, $change_amount);
			}
			elsif ($text=~/\b656\b/) {	#:: Rallos Zek Minion
				quest::faction(656, $change_amount);
			}
			elsif ($text=~/\b657\b/) {	#:: Arachnid - PoP
				quest::faction(657, $change_amount);
			}
			elsif ($text=~/\b658\b/) {	#:: Crystal Spider (Race)
				quest::faction(658, $change_amount);
			}
			elsif ($text=~/\b659\b/) {	#:: Zebuxoruk's Cage (Race)
				quest::faction(659, $change_amount);
			}
			elsif ($text=~/\b660\b/) {	#:: Bastion of Thunder Portal (Race)
				quest::faction(660, $change_amount);
			}
			elsif ($text=~/\b661\b/) {	#:: Guktan
				quest::faction(661, $change_amount);
			}
			elsif ($text=~/\b662\b/) {	#:: Troll Buccaneer
				quest::faction(662, $change_amount);
			}
			elsif ($text=~/\b663\b/) {	#:: Troll Freebooter
				quest::faction(663, $change_amount);
			}
			elsif ($text=~/\b664\b/) {	#:: Troll Sea Rover
				quest::faction(664, $change_amount);
			}
			elsif ($text=~/\b665\b/) {	#:: Spectre Pirate Boss
				quest::faction(665, $change_amount);
			}
			elsif ($text=~/\b666\b/) {	#:: Pirate Boss
				quest::faction(666, $change_amount);
			}
			elsif ($text=~/\b667\b/) {	#:: Pirate Dark Shaman
				quest::faction(667, $change_amount);
			}
			elsif ($text=~/\b668\b/) {	#:: Pirate Officer
				quest::faction(668, $change_amount);
			}
			elsif ($text=~/\b669\b/) {	#:: Gnome Pirate
				quest::faction(669, $change_amount);
			}
			elsif ($text=~/\b670\b/) {	#:: Dark Elf Pirate
				quest::faction(670, $change_amount);
			}
			elsif ($text=~/\b671\b/) {	#:: Ogre Pirate
				quest::faction(671, $change_amount);
			}
			elsif ($text=~/\b672\b/) {	#:: Human Pirate
				quest::faction(672, $change_amount);
			}
			elsif ($text=~/\b673\b/) {	#:: Erudite Pirate
				quest::faction(673, $change_amount);
			}
			elsif ($text=~/\b674\b/) {	#:: Poison Arrow Frog
				quest::faction(674, $change_amount);
			}
			elsif ($text=~/\b675\b/) {	#:: Troll Zombie
				quest::faction(675, $change_amount);
			}
			elsif ($text=~/\b676\b/) {	#:: Luggald
				quest::faction(676, $change_amount);
			}
			elsif ($text=~/\b677\b/) {	#:: Luggald Armored
				quest::faction(677, $change_amount);
			}
			elsif ($text=~/\b678\b/) {	#:: Luggald Robed
				quest::faction(678, $change_amount);
			}
			elsif ($text=~/\b679\b/) {	#:: Drogmor (Race)
				quest::faction(679, $change_amount);
			}
			elsif ($text=~/\b680\b/) {	#:: Dream Delvers
				quest::faction(680, $change_amount);
			}
			elsif ($text=~/\b681\b/) {	#:: Beta Ally
				quest::faction(681, $change_amount);
			}
			elsif ($text=~/\b682\b/) {	#:: Beta Warmly
				quest::faction(682, $change_amount);
			}
			elsif ($text=~/\b683\b/) {	#:: Beta Kindly
				quest::faction(683, $change_amount);
			}
			elsif ($text=~/\b684\b/) {	#:: Beta Amiable
				quest::faction(684, $change_amount);
			}
			elsif ($text=~/\b685\b/) {	#:: Beta Apprehensive
				quest::faction(685, $change_amount);
			}
			elsif ($text=~/\b686\b/) {	#:: Beta Dubious
				quest::faction(686, $change_amount);
			}
			elsif ($text=~/\b687\b/) {	#:: Beta Threatening
				quest::faction(687, $change_amount);
			}
			elsif ($text=~/\b688\b/) {	#:: Shissar (Race)
				quest::faction(688, $change_amount);
			}
			elsif ($text=~/\b689\b/) {	#:: Shik Nar (Race)
				quest::faction(689, $change_amount);
			}
			elsif ($text=~/\b690\b/) {	#:: Shik Nar of Mons Letalis
				quest::faction(690, $change_amount);
			}
			elsif ($text=~/\b691\b/) {	#:: Brownie (Race)
				quest::faction(691, $change_amount);
			}
			elsif ($text=~/\b692\b/) {	#:: Pixie (Race)
				quest::faction(692, $change_amount);
			}
			elsif ($text=~/\b693\b/) {	#:: Qeynos Citizen (Race)
				quest::faction(693, $change_amount);
			}
			elsif ($text=~/\b694\b/) {	#:: Erudite Citizen (Race)
				quest::faction(694, $change_amount);
			}
			elsif ($text=~/\b695\b/) {	#:: Clockwork Gnome (Race)
				quest::faction(695, $change_amount);
			}
			elsif ($text=~/\b696\b/) {	#:: Kaladim Citizen (Race)
				quest::faction(696, $change_amount);
			}
			elsif ($text=~/\b697\b/) {	#:: Faction697
				quest::faction(697, $change_amount);
			}
			elsif ($text=~/\b698\b/) {	#:: Faction698
				quest::faction(698, $change_amount);
			}
			elsif ($text=~/\b699\b/) {	#:: Faction699
				quest::faction(699, $change_amount);
			}
			elsif ($text=~/\b700\b/) {	#:: Mercenary Coalition
				quest::faction(700, $change_amount);
			}
			elsif ($text=~/\b701\b/) {	#:: Beta KOS Copy 1
				quest::faction(701, $change_amount);
			}
			elsif ($text=~/\b702\b/) {	#:: Beta KOS Copy 2
				quest::faction(702, $change_amount);
			}
			elsif ($text=~/\b703\b/) {	#:: Beta KOS Copy 3
				quest::faction(703, $change_amount);
			}
			elsif ($text=~/\b704\b/) {	#:: Beta KOS Copy 4
				quest::faction(704, $change_amount);
			}
			elsif ($text=~/\b705\b/) {	#:: Beta KOS Copy 5
				quest::faction(705, $change_amount);
			}
			elsif ($text=~/\b706\b/) {	#:: Beta KOS Copy 6
				quest::faction(706, $change_amount);
			}
			elsif ($text=~/\b707\b/) {	#:: Beta KOS Copy 7
				quest::faction(707, $change_amount);
			}
			elsif ($text=~/\b708\b/) {	#:: Beta KOS Copy 8
				quest::faction(708, $change_amount);
			}
			elsif ($text=~/\b709\b/) {	#:: The Yendan
				quest::faction(709, $change_amount);
			}
			elsif ($text=~/\b710\b/) {	#:: Guardians of War
				quest::faction(710, $change_amount);
			}
			elsif ($text=~/\b711\b/) {	#:: Castle Rulnavis
				quest::faction(711, $change_amount);
			}
			elsif ($text=~/\b712\b/) {	#:: Castle Tamrel
				quest::faction(712, $change_amount);
			}
			elsif ($text=~/\b713\b/) {	#:: Soldiers of Tallon
				quest::faction(713, $change_amount);
			}
			elsif ($text=~/\b714\b/) {	#:: Soldiers of Vallon
				quest::faction(714, $change_amount);
			}
			elsif ($text=~/\b715\b/) {	#:: Inhabitants of Rulnavis
				quest::faction(715, $change_amount);
			}
			elsif ($text=~/\b716\b/) {	#:: Inhabitants of Tamrel
				quest::faction(716, $change_amount);
			}
			elsif ($text=~/\b717\b/) {	#:: Keepers of Narikor
				quest::faction(717, $change_amount);
			}
			elsif ($text=~/\b718\b/) {	#:: The Disgraced
				quest::faction(718, $change_amount);
			}
			elsif ($text=~/\b719\b/) {	#:: Minions of Rot
				quest::faction(719, $change_amount);
			}
			elsif ($text=~/\b720\b/) {	#:: Memorial Gnomelike
				quest::faction(720, $change_amount);
			}
			elsif ($text=~/\b721\b/) {	#:: Iron Legion
				quest::faction(721, $change_amount);
			}
			elsif ($text=~/\b722\b/) {	#:: Faction722
				quest::faction(722, $change_amount);
			}
			elsif ($text=~/\b723\b/) {	#:: Faction723
				quest::faction(723, $change_amount);
			}
			elsif ($text=~/\b724\b/) {	#:: Faction724
				quest::faction(724, $change_amount);
			}
			elsif ($text=~/\b725\b/) {	#:: Faction725
				quest::faction(725, $change_amount);
			}
			elsif ($text=~/\b726\b/) {	#:: Faction726
				quest::faction(726, $change_amount);
			}
			elsif ($text=~/\b727\b/) {	#:: Faction727
				quest::faction(727, $change_amount);
			}
			elsif ($text=~/\b728\b/) {	#:: Faction728
				quest::faction(728, $change_amount);
			}
			elsif ($text=~/\b729\b/) {	#:: Faction729
				quest::faction(729, $change_amount);
			}
			elsif ($text=~/\b730\b/) {	#:: Faction730
				quest::faction(730, $change_amount);
			}
			elsif ($text=~/\b731\b/) {	#:: Faction731
				quest::faction(731, $change_amount);
			}
			elsif ($text=~/\b732\b/) {	#:: Faction732
				quest::faction(732, $change_amount);
			}
			elsif ($text=~/\b733\b/) {	#:: Faction733
				quest::faction(733, $change_amount);
			}
			elsif ($text=~/\b734\b/) {	#:: Faction734
				quest::faction(734, $change_amount);
			}
			elsif ($text=~/\b735\b/) {	#:: Faction735
				quest::faction(735, $change_amount);
			}
			elsif ($text=~/\b736\b/) {	#:: Faction736
				quest::faction(736, $change_amount);
			}
			elsif ($text=~/\b737\b/) {	#:: Faction737
				quest::faction(737, $change_amount);
			}
			elsif ($text=~/\b738\b/) {	#:: Faction738
				quest::faction(738, $change_amount);
			}
			elsif ($text=~/\b739\b/) {	#:: Faction739
				quest::faction(739, $change_amount);
			}
			elsif ($text=~/\b740\b/) {	#:: Faction740
				quest::faction(740, $change_amount);
			}
			elsif ($text=~/\b741\b/) {	#:: Faction741
				quest::faction(741, $change_amount);
			}
			elsif ($text=~/\b742\b/) {	#:: Faction742
				quest::faction(742, $change_amount);
			}
			elsif ($text=~/\b743\b/) {	#:: Faction743
				quest::faction(743, $change_amount);
			}
			elsif ($text=~/\b744\b/) {	#:: Faction744
				quest::faction(744, $change_amount);
			}
			elsif ($text=~/\b745\b/) {	#:: Faction745
				quest::faction(745, $change_amount);
			}
			elsif ($text=~/\b746\b/) {	#:: Faction746
				quest::faction(746, $change_amount);
			}
			elsif ($text=~/\b747\b/) {	#:: Faction747
				quest::faction(747, $change_amount);
			}
			elsif ($text=~/\b748\b/) {	#:: Faction748
				quest::faction(748, $change_amount);
			}
			elsif ($text=~/\b749\b/) {	#:: Faction749
				quest::faction(749, $change_amount);
			}
			elsif ($text=~/\b750\b/) {	#:: Faction750
				quest::faction(750, $change_amount);
			}
			elsif ($text=~/\b751\b/) {	#:: Faction751
				quest::faction(751, $change_amount);
			}
			elsif ($text=~/\b752\b/) {	#:: Faction752
				quest::faction(752, $change_amount);
			}
			elsif ($text=~/\b753\b/) {	#:: Faction753
				quest::faction(753, $change_amount);
			}
			elsif ($text=~/\b754\b/) {	#:: Faction754
				quest::faction(754, $change_amount);
			}
			elsif ($text=~/\b755\b/) {	#:: Faction755
				quest::faction(755, $change_amount);
			}
			elsif ($text=~/\b756\b/) {	#:: Faction756
				quest::faction(756, $change_amount);
			}
			elsif ($text=~/\b757\b/) {	#:: Faction757
				quest::faction(757, $change_amount);
			}
			elsif ($text=~/\b758\b/) {	#:: Faction758
				quest::faction(758, $change_amount);
			}
			elsif ($text=~/\b759\b/) {	#:: Faction759
				quest::faction(759, $change_amount);
			}
			elsif ($text=~/\b760\b/) {	#:: Faction760
				quest::faction(760, $change_amount);
			}
			elsif ($text=~/\b761\b/) {	#:: Faction761
				quest::faction(761, $change_amount);
			}
			elsif ($text=~/\b762\b/) {	#:: Faction762
				quest::faction(762, $change_amount);
			}
			elsif ($text=~/\b763\b/) {	#:: Faction763
				quest::faction(763, $change_amount);
			}
			elsif ($text=~/\b764\b/) {	#:: Faction764
				quest::faction(764, $change_amount);
			}
			elsif ($text=~/\b765\b/) {	#:: Faction765
				quest::faction(765, $change_amount);
			}
			elsif ($text=~/\b766\b/) {	#:: Faction766
				quest::faction(766, $change_amount);
			}
			elsif ($text=~/\b767\b/) {	#:: Faction767
				quest::faction(767, $change_amount);
			}
			elsif ($text=~/\b768\b/) {	#:: Faction768
				quest::faction(768, $change_amount);
			}
			elsif ($text=~/\b769\b/) {	#:: Faction769
				quest::faction(769, $change_amount);
			}
			elsif ($text=~/\b770\b/) {	#:: Faction770
				quest::faction(770, $change_amount);
			}
			elsif ($text=~/\b771\b/) {	#:: Faction771
				quest::faction(771, $change_amount);
			}
			elsif ($text=~/\b772\b/) {	#:: Faction772
				quest::faction(772, $change_amount);
			}
			elsif ($text=~/\b773\b/) {	#:: Faction773
				quest::faction(773, $change_amount);
			}
			elsif ($text=~/\b774\b/) {	#:: Faction774
				quest::faction(774, $change_amount);
			}
			elsif ($text=~/\b775\b/) {	#:: Faction775
				quest::faction(775, $change_amount);
			}
			elsif ($text=~/\b776\b/) {	#:: Faction776
				quest::faction(776, $change_amount);
			}
			elsif ($text=~/\b777\b/) {	#:: Faction777
				quest::faction(777, $change_amount);
			}
			elsif ($text=~/\b778\b/) {	#:: Faction778
				quest::faction(778, $change_amount);
			}
			elsif ($text=~/\b779\b/) {	#:: Faction779
				quest::faction(779, $change_amount);
			}
			elsif ($text=~/\b780\b/) {	#:: Faction780
				quest::faction(780, $change_amount);
			}
			elsif ($text=~/\b781\b/) {	#:: Faction781
				quest::faction(781, $change_amount);
			}
			elsif ($text=~/\b782\b/) {	#:: Faction782
				quest::faction(782, $change_amount);
			}
			elsif ($text=~/\b783\b/) {	#:: Faction783
				quest::faction(783, $change_amount);
			}
			elsif ($text=~/\b784\b/) {	#:: Faction784
				quest::faction(784, $change_amount);
			}
			elsif ($text=~/\b785\b/) {	#:: Faction785
				quest::faction(785, $change_amount);
			}
			elsif ($text=~/\b786\b/) {	#:: Faction786
				quest::faction(786, $change_amount);
			}
			elsif ($text=~/\b787\b/) {	#:: Faction787
				quest::faction(787, $change_amount);
			}
			elsif ($text=~/\b788\b/) {	#:: Faction788
				quest::faction(788, $change_amount);
			}
			elsif ($text=~/\b789\b/) {	#:: Faction789
				quest::faction(789, $change_amount);
			}
			elsif ($text=~/\b790\b/) {	#:: Faction790
				quest::faction(790, $change_amount);
			}
			elsif ($text=~/\b791\b/) {	#:: Faction791
				quest::faction(791, $change_amount);
			}
			elsif ($text=~/\b792\b/) {	#:: Faction792
				quest::faction(792, $change_amount);
			}
			elsif ($text=~/\b793\b/) {	#:: Faction793
				quest::faction(793, $change_amount);
			}
			elsif ($text=~/\b794\b/) {	#:: Faction794
				quest::faction(794, $change_amount);
			}
			elsif ($text=~/\b795\b/) {	#:: Faction795
				quest::faction(795, $change_amount);
			}
			elsif ($text=~/\b796\b/) {	#:: Faction796
				quest::faction(796, $change_amount);
			}
			elsif ($text=~/\b797\b/) {	#:: Faction797
				quest::faction(797, $change_amount);
			}
			elsif ($text=~/\b798\b/) {	#:: Faction798
				quest::faction(798, $change_amount);
			}
			elsif ($text=~/\b799\b/) {	#:: Faction799
				quest::faction(799, $change_amount);
			}
			elsif ($text=~/\b800\b/) {	#:: Faction800
				quest::faction(800, $change_amount);
			}
			elsif ($text=~/\b801\b/) {	#:: Faction801
				quest::faction(801, $change_amount);
			}
			elsif ($text=~/\b802\b/) {	#:: Faction802
				quest::faction(802, $change_amount);
			}
			elsif ($text=~/\b803\b/) {	#:: Faction803
				quest::faction(803, $change_amount);
			}
			elsif ($text=~/\b804\b/) {	#:: Faction804
				quest::faction(804, $change_amount);
			}
			elsif ($text=~/\b805\b/) {	#:: Faction805
				quest::faction(805, $change_amount);
			}
			elsif ($text=~/\b806\b/) {	#:: Faction806
				quest::faction(806, $change_amount);
			}
			elsif ($text=~/\b807\b/) {	#:: Faction807
				quest::faction(807, $change_amount);
			}
			elsif ($text=~/\b808\b/) {	#:: Faction808
				quest::faction(808, $change_amount);
			}
			elsif ($text=~/\b809\b/) {	#:: Faction809
				quest::faction(809, $change_amount);
			}
			elsif ($text=~/\b810\b/) {	#:: Faction810
				quest::faction(810, $change_amount);
			}
			elsif ($text=~/\b811\b/) {	#:: Faction811
				quest::faction(811, $change_amount);
			}
			elsif ($text=~/\b812\b/) {	#:: Faction812
				quest::faction(812, $change_amount);
			}
			elsif ($text=~/\b813\b/) {	#:: Faction813
				quest::faction(813, $change_amount);
			}
			elsif ($text=~/\b814\b/) {	#:: Faction814
				quest::faction(814, $change_amount);
			}
			elsif ($text=~/\b815\b/) {	#:: Faction815
				quest::faction(815, $change_amount);
			}
			elsif ($text=~/\b816\b/) {	#:: Faction816
				quest::faction(816, $change_amount);
			}
			elsif ($text=~/\b817\b/) {	#:: Faction817
				quest::faction(817, $change_amount);
			}
			elsif ($text=~/\b818\b/) {	#:: Faction818
				quest::faction(818, $change_amount);
			}
			elsif ($text=~/\b819\b/) {	#:: Faction819
				quest::faction(819, $change_amount);
			}
			elsif ($text=~/\b820\b/) {	#:: Faction820
				quest::faction(820, $change_amount);
			}
			elsif ($text=~/\b821\b/) {	#:: Faction821
				quest::faction(821, $change_amount);
			}
			elsif ($text=~/\b822\b/) {	#:: Faction822
				quest::faction(822, $change_amount);
			}
			elsif ($text=~/\b823\b/) {	#:: Faction823
				quest::faction(823, $change_amount);
			}
			elsif ($text=~/\b824\b/) {	#:: Faction824
				quest::faction(824, $change_amount);
			}
			elsif ($text=~/\b825\b/) {	#:: Faction825
				quest::faction(825, $change_amount);
			}
			elsif ($text=~/\b826\b/) {	#:: Faction826
				quest::faction(826, $change_amount);
			}
			elsif ($text=~/\b827\b/) {	#:: Faction827
				quest::faction(827, $change_amount);
			}
			elsif ($text=~/\b828\b/) {	#:: Faction828
				quest::faction(828, $change_amount);
			}
			elsif ($text=~/\b829\b/) {	#:: Faction829
				quest::faction(829, $change_amount);
			}
			elsif ($text=~/\b830\b/) {	#:: Faction830
				quest::faction(830, $change_amount);
			}
			elsif ($text=~/\b831\b/) {	#:: Faction831
				quest::faction(831, $change_amount);
			}
			elsif ($text=~/\b832\b/) {	#:: Faction832
				quest::faction(832, $change_amount);
			}
			elsif ($text=~/\b833\b/) {	#:: Faction833
				quest::faction(833, $change_amount);
			}
			elsif ($text=~/\b834\b/) {	#:: Faction834
				quest::faction(834, $change_amount);
			}
			elsif ($text=~/\b835\b/) {	#:: Faction835
				quest::faction(835, $change_amount);
			}
			elsif ($text=~/\b836\b/) {	#:: Faction836
				quest::faction(836, $change_amount);
			}
			elsif ($text=~/\b837\b/) {	#:: Faction837
				quest::faction(837, $change_amount);
			}
			elsif ($text=~/\b838\b/) {	#:: Faction838
				quest::faction(838, $change_amount);
			}
			elsif ($text=~/\b839\b/) {	#:: Faction839
				quest::faction(839, $change_amount);
			}
			elsif ($text=~/\b840\b/) {	#:: Faction840
				quest::faction(840, $change_amount);
			}
			elsif ($text=~/\b841\b/) {	#:: Faction841
				quest::faction(841, $change_amount);
			}
			elsif ($text=~/\b842\b/) {	#:: Faction842
				quest::faction(842, $change_amount);
			}
			elsif ($text=~/\b843\b/) {	#:: Faction843
				quest::faction(843, $change_amount);
			}
			elsif ($text=~/\b844\b/) {	#:: Faction844
				quest::faction(844, $change_amount);
			}
			elsif ($text=~/\b845\b/) {	#:: Faction845
				quest::faction(845, $change_amount);
			}
			elsif ($text=~/\b846\b/) {	#:: Faction846
				quest::faction(846, $change_amount);
			}
			elsif ($text=~/\b847\b/) {	#:: Faction847
				quest::faction(847, $change_amount);
			}
			elsif ($text=~/\b848\b/) {	#:: Faction848
				quest::faction(848, $change_amount);
			}
			elsif ($text=~/\b849\b/) {	#:: Faction849
				quest::faction(849, $change_amount);
			}
			elsif ($text=~/\b850\b/) {	#:: Faction850
				quest::faction(850, $change_amount);
			}
			elsif ($text=~/\b851\b/) {	#:: Faction851
				quest::faction(851, $change_amount);
			}
			elsif ($text=~/\b852\b/) {	#:: Faction852
				quest::faction(852, $change_amount);
			}
			elsif ($text=~/\b853\b/) {	#:: Faction853
				quest::faction(853, $change_amount);
			}
			elsif ($text=~/\b854\b/) {	#:: Faction854
				quest::faction(854, $change_amount);
			}
			elsif ($text=~/\b855\b/) {	#:: Faction855
				quest::faction(855, $change_amount);
			}
			elsif ($text=~/\b856\b/) {	#:: Faction856
				quest::faction(856, $change_amount);
			}
			elsif ($text=~/\b857\b/) {	#:: Faction857
				quest::faction(857, $change_amount);
			}
			elsif ($text=~/\b858\b/) {	#:: Faction858
				quest::faction(858, $change_amount);
			}
			elsif ($text=~/\b859\b/) {	#:: Faction859
				quest::faction(859, $change_amount);
			}
			elsif ($text=~/\b860\b/) {	#:: Faction860
				quest::faction(860, $change_amount);
			}
			elsif ($text=~/\b861\b/) {	#:: Faction861
				quest::faction(861, $change_amount);
			}
			elsif ($text=~/\b862\b/) {	#:: Faction862
				quest::faction(862, $change_amount);
			}
			elsif ($text=~/\b863\b/) {	#:: Faction863
				quest::faction(863, $change_amount);
			}
			elsif ($text=~/\b864\b/) {	#:: Faction864
				quest::faction(864, $change_amount);
			}
			elsif ($text=~/\b865\b/) {	#:: Faction865
				quest::faction(865, $change_amount);
			}
			elsif ($text=~/\b866\b/) {	#:: Faction866
				quest::faction(866, $change_amount);
			}
			elsif ($text=~/\b867\b/) {	#:: Faction867
				quest::faction(867, $change_amount);
			}
			elsif ($text=~/\b868\b/) {	#:: Faction868
				quest::faction(868, $change_amount);
			}
			elsif ($text=~/\b869\b/) {	#:: Faction869
				quest::faction(869, $change_amount);
			}
			elsif ($text=~/\b870\b/) {	#:: Faction870
				quest::faction(870, $change_amount);
			}
			elsif ($text=~/\b871\b/) {	#:: Faction871
				quest::faction(871, $change_amount);
			}
			elsif ($text=~/\b872\b/) {	#:: Faction872
				quest::faction(872, $change_amount);
			}
			elsif ($text=~/\b873\b/) {	#:: Faction873
				quest::faction(873, $change_amount);
			}
			elsif ($text=~/\b874\b/) {	#:: Faction874
				quest::faction(874, $change_amount);
			}
			elsif ($text=~/\b875\b/) {	#:: Faction875
				quest::faction(875, $change_amount);
			}
			elsif ($text=~/\b876\b/) {	#:: Faction876
				quest::faction(876, $change_amount);
			}
			elsif ($text=~/\b877\b/) {	#:: Faction877
				quest::faction(877, $change_amount);
			}
			elsif ($text=~/\b878\b/) {	#:: Faction878
				quest::faction(878, $change_amount);
			}
			elsif ($text=~/\b879\b/) {	#:: Faction879
				quest::faction(879, $change_amount);
			}
			elsif ($text=~/\b880\b/) {	#:: Faction880
				quest::faction(880, $change_amount);
			}
			elsif ($text=~/\b881\b/) {	#:: Faction881
				quest::faction(881, $change_amount);
			}
			elsif ($text=~/\b882\b/) {	#:: Faction882
				quest::faction(882, $change_amount);
			}
			elsif ($text=~/\b883\b/) {	#:: Faction883
				quest::faction(883, $change_amount);
			}
			elsif ($text=~/\b884\b/) {	#:: Faction884
				quest::faction(884, $change_amount);
			}
			elsif ($text=~/\b885\b/) {	#:: Faction885
				quest::faction(885, $change_amount);
			}
			elsif ($text=~/\b886\b/) {	#:: Faction886
				quest::faction(886, $change_amount);
			}
			elsif ($text=~/\b887\b/) {	#:: Faction887
				quest::faction(887, $change_amount);
			}
			elsif ($text=~/\b888\b/) {	#:: Faction888
				quest::faction(888, $change_amount);
			}
			elsif ($text=~/\b889\b/) {	#:: Faction889
				quest::faction(889, $change_amount);
			}
			elsif ($text=~/\b890\b/) {	#:: Faction890
				quest::faction(890, $change_amount);
			}
			elsif ($text=~/\b891\b/) {	#:: Faction891
				quest::faction(891, $change_amount);
			}
			elsif ($text=~/\b892\b/) {	#:: Faction892
				quest::faction(892, $change_amount);
			}
			elsif ($text=~/\b893\b/) {	#:: Faction893
				quest::faction(893, $change_amount);
			}
			elsif ($text=~/\b894\b/) {	#:: Faction894
				quest::faction(894, $change_amount);
			}
			elsif ($text=~/\b895\b/) {	#:: Faction895
				quest::faction(895, $change_amount);
			}
			elsif ($text=~/\b896\b/) {	#:: Faction896
				quest::faction(896, $change_amount);
			}
			elsif ($text=~/\b897\b/) {	#:: Faction897
				quest::faction(897, $change_amount);
			}
			elsif ($text=~/\b898\b/) {	#:: Faction898
				quest::faction(898, $change_amount);
			}
			elsif ($text=~/\b899\b/) {	#:: Faction899
				quest::faction(899, $change_amount);
			}
			elsif ($text=~/\b900\b/) {	#:: Faction900
				quest::faction(900, $change_amount);
			}
			elsif ($text=~/\b901\b/) {	#:: Faction901
				quest::faction(901, $change_amount);
			}
			elsif ($text=~/\b902\b/) {	#:: Faction902
				quest::faction(902, $change_amount);
			}
			elsif ($text=~/\b903\b/) {	#:: Faction903
				quest::faction(903, $change_amount);
			}
			elsif ($text=~/\b904\b/) {	#:: Faction904
				quest::faction(904, $change_amount);
			}
			elsif ($text=~/\b905\b/) {	#:: Faction905
				quest::faction(905, $change_amount);
			}
			elsif ($text=~/\b906\b/) {	#:: Faction906
				quest::faction(906, $change_amount);
			}
			elsif ($text=~/\b907\b/) {	#:: Faction907
				quest::faction(907, $change_amount);
			}
			elsif ($text=~/\b908\b/) {	#:: Faction908
				quest::faction(908, $change_amount);
			}
			elsif ($text=~/\b909\b/) {	#:: Faction909
				quest::faction(909, $change_amount);
			}
			elsif ($text=~/\b910\b/) {	#:: Faction910
				quest::faction(910, $change_amount);
			}
			elsif ($text=~/\b911\b/) {	#:: Faction911
				quest::faction(911, $change_amount);
			}
			elsif ($text=~/\b912\b/) {	#:: Faction912
				quest::faction(912, $change_amount);
			}
			elsif ($text=~/\b913\b/) {	#:: Faction913
				quest::faction(913, $change_amount);
			}
			elsif ($text=~/\b914\b/) {	#:: Faction914
				quest::faction(914, $change_amount);
			}
			elsif ($text=~/\b915\b/) {	#:: Faction915
				quest::faction(915, $change_amount);
			}
			elsif ($text=~/\b916\b/) {	#:: Faction916
				quest::faction(916, $change_amount);
			}
			elsif ($text=~/\b917\b/) {	#:: Faction917
				quest::faction(917, $change_amount);
			}
			elsif ($text=~/\b918\b/) {	#:: Faction918
				quest::faction(918, $change_amount);
			}
			elsif ($text=~/\b919\b/) {	#:: Faction919
				quest::faction(919, $change_amount);
			}
			elsif ($text=~/\b920\b/) {	#:: Faction920
				quest::faction(920, $change_amount);
			}
			elsif ($text=~/\b921\b/) {	#:: Faction921
				quest::faction(921, $change_amount);
			}
			elsif ($text=~/\b922\b/) {	#:: Faction922
				quest::faction(922, $change_amount);
			}
			elsif ($text=~/\b923\b/) {	#:: Faction923
				quest::faction(923, $change_amount);
			}
			elsif ($text=~/\b924\b/) {	#:: Faction924
				quest::faction(924, $change_amount);
			}
			elsif ($text=~/\b925\b/) {	#:: Faction925
				quest::faction(925, $change_amount);
			}
			elsif ($text=~/\b926\b/) {	#:: Faction926
				quest::faction(926, $change_amount);
			}
			elsif ($text=~/\b927\b/) {	#:: Faction927
				quest::faction(927, $change_amount);
			}
			elsif ($text=~/\b928\b/) {	#:: Faction928
				quest::faction(928, $change_amount);
			}
			elsif ($text=~/\b929\b/) {	#:: Faction929
				quest::faction(929, $change_amount);
			}
			elsif ($text=~/\b930\b/) {	#:: Faction930
				quest::faction(930, $change_amount);
			}
			elsif ($text=~/\b931\b/) {	#:: Faction931
				quest::faction(931, $change_amount);
			}
			elsif ($text=~/\b932\b/) {	#:: Faction932
				quest::faction(932, $change_amount);
			}
			elsif ($text=~/\b933\b/) {	#:: Faction933
				quest::faction(933, $change_amount);
			}
			elsif ($text=~/\b934\b/) {	#:: Faction934
				quest::faction(934, $change_amount);
			}
			elsif ($text=~/\b935\b/) {	#:: Faction935
				quest::faction(935, $change_amount);
			}
			elsif ($text=~/\b936\b/) {	#:: Faction936
				quest::faction(936, $change_amount);
			}
			elsif ($text=~/\b937\b/) {	#:: Faction937
				quest::faction(937, $change_amount);
			}
			elsif ($text=~/\b938\b/) {	#:: Faction938
				quest::faction(938, $change_amount);
			}
			elsif ($text=~/\b939\b/) {	#:: Faction939
				quest::faction(939, $change_amount);
			}
			elsif ($text=~/\b940\b/) {	#:: Faction940
				quest::faction(940, $change_amount);
			}
			elsif ($text=~/\b941\b/) {	#:: Faction941
				quest::faction(941, $change_amount);
			}
			elsif ($text=~/\b942\b/) {	#:: Faction942
				quest::faction(942, $change_amount);
			}
			elsif ($text=~/\b943\b/) {	#:: Faction943
				quest::faction(943, $change_amount);
			}
			elsif ($text=~/\b944\b/) {	#:: Faction944
				quest::faction(944, $change_amount);
			}
			elsif ($text=~/\b945\b/) {	#:: Faction945
				quest::faction(945, $change_amount);
			}
			elsif ($text=~/\b946\b/) {	#:: Faction946
				quest::faction(946, $change_amount);
			}
			elsif ($text=~/\b947\b/) {	#:: Faction947
				quest::faction(947, $change_amount);
			}
			elsif ($text=~/\b948\b/) {	#:: Faction948
				quest::faction(948, $change_amount);
			}
			elsif ($text=~/\b949\b/) {	#:: Faction949
				quest::faction(949, $change_amount);
			}
			elsif ($text=~/\b950\b/) {	#:: Faction950
				quest::faction(950, $change_amount);
			}
			elsif ($text=~/\b951\b/) {	#:: Faction951
				quest::faction(951, $change_amount);
			}
			elsif ($text=~/\b952\b/) {	#:: Faction952
				quest::faction(952, $change_amount);
			}
			elsif ($text=~/\b953\b/) {	#:: Faction953
				quest::faction(953, $change_amount);
			}
			elsif ($text=~/\b954\b/) {	#:: Faction954
				quest::faction(954, $change_amount);
			}
			elsif ($text=~/\b955\b/) {	#:: Faction955
				quest::faction(955, $change_amount);
			}
			elsif ($text=~/\b956\b/) {	#:: Faction956
				quest::faction(956, $change_amount);
			}
			elsif ($text=~/\b957\b/) {	#:: Faction957
				quest::faction(957, $change_amount);
			}
			elsif ($text=~/\b958\b/) {	#:: Faction958
				quest::faction(958, $change_amount);
			}
			elsif ($text=~/\b959\b/) {	#:: Faction959
				quest::faction(959, $change_amount);
			}
			elsif ($text=~/\b960\b/) {	#:: Faction960
				quest::faction(960, $change_amount);
			}
			elsif ($text=~/\b961\b/) {	#:: Faction961
				quest::faction(961, $change_amount);
			}
			elsif ($text=~/\b962\b/) {	#:: Faction962
				quest::faction(962, $change_amount);
			}
			elsif ($text=~/\b963\b/) {	#:: Faction963
				quest::faction(963, $change_amount);
			}
			elsif ($text=~/\b964\b/) {	#:: Faction964
				quest::faction(964, $change_amount);
			}
			elsif ($text=~/\b965\b/) {	#:: Faction965
				quest::faction(965, $change_amount);
			}
			elsif ($text=~/\b966\b/) {	#:: Faction966
				quest::faction(966, $change_amount);
			}
			elsif ($text=~/\b967\b/) {	#:: Faction967
				quest::faction(967, $change_amount);
			}
			elsif ($text=~/\b968\b/) {	#:: Faction968
				quest::faction(968, $change_amount);
			}
			elsif ($text=~/\b969\b/) {	#:: Faction969
				quest::faction(969, $change_amount);
			}
			elsif ($text=~/\b970\b/) {	#:: Faction970
				quest::faction(970, $change_amount);
			}
			elsif ($text=~/\b971\b/) {	#:: Faction971
				quest::faction(971, $change_amount);
			}
			elsif ($text=~/\b972\b/) {	#:: Faction972
				quest::faction(972, $change_amount);
			}
			elsif ($text=~/\b973\b/) {	#:: Faction973
				quest::faction(973, $change_amount);
			}
			elsif ($text=~/\b974\b/) {	#:: Faction974
				quest::faction(974, $change_amount);
			}
			elsif ($text=~/\b975\b/) {	#:: Faction975
				quest::faction(975, $change_amount);
			}
			elsif ($text=~/\b976\b/) {	#:: Faction976
				quest::faction(976, $change_amount);
			}
			elsif ($text=~/\b977\b/) {	#:: Faction977
				quest::faction(977, $change_amount);
			}
			elsif ($text=~/\b978\b/) {	#:: Faction978
				quest::faction(978, $change_amount);
			}
			elsif ($text=~/\b979\b/) {	#:: Faction979
				quest::faction(979, $change_amount);
			}
			elsif ($text=~/\b980\b/) {	#:: Faction980
				quest::faction(980, $change_amount);
			}
			elsif ($text=~/\b981\b/) {	#:: Faction981
				quest::faction(981, $change_amount);
			}
			elsif ($text=~/\b982\b/) {	#:: Faction982
				quest::faction(982, $change_amount);
			}
			elsif ($text=~/\b983\b/) {	#:: Faction983
				quest::faction(983, $change_amount);
			}
			elsif ($text=~/\b984\b/) {	#:: Faction984
				quest::faction(984, $change_amount);
			}
			elsif ($text=~/\b985\b/) {	#:: Faction985
				quest::faction(985, $change_amount);
			}
			elsif ($text=~/\b986\b/) {	#:: Faction986
				quest::faction(986, $change_amount);
			}
			elsif ($text=~/\b987\b/) {	#:: Faction987
				quest::faction(987, $change_amount);
			}
			elsif ($text=~/\b988\b/) {	#:: Faction988
				quest::faction(988, $change_amount);
			}
			elsif ($text=~/\b989\b/) {	#:: Faction989
				quest::faction(989, $change_amount);
			}
			elsif ($text=~/\b990\b/) {	#:: Faction990
				quest::faction(990, $change_amount);
			}
			elsif ($text=~/\b991\b/) {	#:: Faction991
				quest::faction(991, $change_amount);
			}
			elsif ($text=~/\b992\b/) {	#:: Faction992
				quest::faction(992, $change_amount);
			}
			elsif ($text=~/\b993\b/) {	#:: Faction993
				quest::faction(993, $change_amount);
			}
			elsif ($text=~/\b994\b/) {	#:: Faction994
				quest::faction(994, $change_amount);
			}
			elsif ($text=~/\b995\b/) {	#:: Faction995
				quest::faction(995, $change_amount);
			}
			elsif ($text=~/\b996\b/) {	#:: Faction996
				quest::faction(996, $change_amount);
			}
			elsif ($text=~/\b997\b/) {	#:: Faction997
				quest::faction(997, $change_amount);
			}
			elsif ($text=~/\b998\b/) {	#:: Faction998
				quest::faction(998, $change_amount);
			}
			elsif ($text=~/\b999\b/) {	#:: Faction999
				quest::faction(999, $change_amount);
			}
			elsif ($text=~/\b1000\b/) {	#:: Slaves of Gloomingdeep
				quest::faction(1000, $change_amount);
			}
			elsif ($text=~/\b1001\b/) {	#:: Kobolds of Gloomingdeep
				quest::faction(1001, $change_amount);
			}
			elsif ($text=~/\b1002\b/) {	#:: Creatures of Gloomingdeep
				quest::faction(1002, $change_amount);
			}
			elsif ($text=~/\b1003\b/) {	#:: Guards of Gloomingdeep
				quest::faction(1003, $change_amount);
			}
			elsif ($text=~/\b1004\b/) {	#:: Animals of Taelosia
				quest::faction(1004, $change_amount);
			}
			elsif ($text=~/\b1005\b/) {	#:: Qeynos Elite Watch
				quest::faction(1005, $change_amount);
			}
			elsif ($text=~/\b1006\b/) {	#:: Troupe of Free Speakers
				quest::faction(1006, $change_amount);
			}
			elsif ($text=~/\b1007\b/) {	#:: Riftseekers
				quest::faction(1007, $change_amount);
			}
			elsif ($text=~/\b1008\b/) {	#:: Discordant Creatures of Kuua
				quest::faction(1008, $change_amount);
			}
			elsif ($text=~/\b1009\b/) {	#:: Denizens of Discord
				quest::faction(1009, $change_amount);
			}
			elsif ($text=~/\b1010\b/) {	#:: Children of Dranik
				quest::faction(1010, $change_amount);
			}
			elsif ($text=~/\b1011\b/) {	#:: Followers of Mekvidarsh
				quest::faction(1011, $change_amount);
			}
			elsif ($text=~/\b1012\b/) {	#:: Followers of Loschryre
				quest::faction(1012, $change_amount);
			}
			elsif ($text=~/\b1013\b/) {	#:: Overlord Mata Muram
				quest::faction(1013, $change_amount);
			}
			elsif ($text=~/\b1014\b/) {	#:: BetaOmensNPCKOS
				quest::faction(1014, $change_amount);
			}
			elsif ($text=~/\b1015\b/) {	#:: Creatures of Kuua
				quest::faction(1015, $change_amount);
			}
			elsif ($text=~/\b1016\b/) {	#:: Dranik Loyalists
				quest::faction(1016, $change_amount);
			}
			elsif ($text=~/\b1017\b/) {	#:: Senior Guides of Norrath
				quest::faction(1017, $change_amount);
			}
			elsif ($text=~/\b1018\b/) {	#:: Children of Mistmoore
				quest::faction(1018, $change_amount);
			}
			elsif ($text=~/\b1019\b/) {	#:: Elemental Invaders
				quest::faction(1019, $change_amount);
			}
			elsif ($text=~/\b1020\b/) {	#:: Lanys T`Vyl
				quest::faction(1020, $change_amount);
			}
			elsif ($text=~/\b1021\b/) {	#:: Dark Reign
				quest::faction(1021, $change_amount);
			}
			elsif ($text=~/\b1022\b/) {	#:: Firiona Vie
				quest::faction(1022, $change_amount);
			}
			elsif ($text=~/\b1023\b/) {	#:: Norrath's Keepers
				quest::faction(1023, $change_amount);
			}
			elsif ($text=~/\b1024\b/) {	#:: Tirranun
				quest::faction(1024, $change_amount);
			}
			elsif ($text=~/\b1025\b/) {	#:: Minions of Tirranun
				quest::faction(1025, $change_amount);
			}
			elsif ($text=~/\b1026\b/) {	#:: Volkara
				quest::faction(1026, $change_amount);
			}
			elsif ($text=~/\b1027\b/) {	#:: Volkara's Brood
				quest::faction(1027, $change_amount);
			}
			elsif ($text=~/\b1028\b/) {	#:: Yar`lir
				quest::faction(1028, $change_amount);
			}
			elsif ($text=~/\b1029\b/) {	#:: Thunder Guardians
				quest::faction(1029, $change_amount);
			}
			elsif ($text=~/\b1030\b/) {	#:: Kessdona
				quest::faction(1030, $change_amount);
			}
			elsif ($text=~/\b1031\b/) {	#:: Rikkukin
				quest::faction(1031, $change_amount);
			}
			elsif ($text=~/\b1032\b/) {	#:: Stillmoon Acolytes
				quest::faction(1032, $change_amount);
			}
			elsif ($text=~/\b1033\b/) {	#:: Vishimtar
				quest::faction(1033, $change_amount);
			}
			elsif ($text=~/\b1034\b/) {	#:: Nest Guardians
				quest::faction(1034, $change_amount);
			}
			elsif ($text=~/\b1035\b/) {	#:: Cursed Drakes
				quest::faction(1035, $change_amount);
			}
			elsif ($text=~/\b1036\b/) {	#:: Scorchclaw Goblins
				quest::faction(1036, $change_amount);
			}
			elsif ($text=~/\b1037\b/) {	#:: Frostflake Goblins
				quest::faction(1037, $change_amount);
			}
			elsif ($text=~/\b1038\b/) {	#:: Whitecap Goblins
				quest::faction(1038, $change_amount);
			}
			elsif ($text=~/\b1039\b/) {	#:: Dirtdigger Goblins
				quest::faction(1039, $change_amount);
			}
			elsif ($text=~/\b1040\b/) {	#:: Greenfoot Goblins
				quest::faction(1040, $change_amount);
			}
			elsif ($text=~/\b1041\b/) {	#:: Grel
				quest::faction(1041, $change_amount);
			}
			elsif ($text=~/\b1042\b/) {	#:: Defenders of the Broodlands
				quest::faction(1042, $change_amount);
			}
			elsif ($text=~/\b1043\b/) {	#:: BetaNPCKOS-PC
				quest::faction(1043, $change_amount);
			}
			elsif ($text=~/\b1044\b/) {	#:: The Guardians
				quest::faction(1044, $change_amount);
			}
			elsif ($text=~/\b1045\b/) {	#:: The Guardian's Alliance
				quest::faction(1045, $change_amount);
			}
			elsif ($text=~/\b1046\b/) {	#:: The Dark Alliance
				quest::faction(1046, $change_amount);
			}
			elsif ($text=~/\b1047\b/) {	#:: The Dark Suppliers
				quest::faction(1047, $change_amount);
			}
			elsif ($text=~/\b1048\b/) {	#:: Sporali Collective
				quest::faction(1048, $change_amount);
			}
			elsif ($text=~/\b1049\b/) {	#:: Deep Sporali
				quest::faction(1049, $change_amount);
			}
			elsif ($text=~/\b1050\b/) {	#:: Expedition 328
				quest::faction(1050, $change_amount);
			}
			elsif ($text=~/\b1051\b/) {	#:: Creep Reapers
				quest::faction(1051, $change_amount);
			}
			elsif ($text=~/\b1052\b/) {	#:: Shadowmane
				quest::faction(1052, $change_amount);
			}
			elsif ($text=~/\b1053\b/) {	#:: Ragepaw
				quest::faction(1053, $change_amount);
			}
			elsif ($text=~/\b1054\b/) {	#:: Shiliskin Empire
				quest::faction(1054, $change_amount);
			}
			elsif ($text=~/\b1055\b/) {	#:: Free Traders of Malgrinnor
				quest::faction(1055, $change_amount);
			}
			elsif ($text=~/\b1056\b/) {	#:: Fallen Guard of Illsalin
				quest::faction(1056, $change_amount);
			}
			elsif ($text=~/\b1057\b/) {	#:: Disciples of Jarzarrad
				quest::faction(1057, $change_amount);
			}
			elsif ($text=~/\b1058\b/) {	#:: Scions of Dreadspire
				quest::faction(1058, $change_amount);
			}
			elsif ($text=~/\b1059\b/) {	#:: Agents of Dreadspire
				quest::faction(1059, $change_amount);
			}
			elsif ($text=~/\b1060\b/) {	#:: Creatures of Darkhollow
				quest::faction(1060, $change_amount);
			}
			elsif ($text=~/\b1061\b/) {	#:: BetaNPCKOS-NPC
				quest::faction(1061, $change_amount);
			}
			elsif ($text=~/\b1062\b/) {	#:: Assistants of the Scribe
				quest::faction(1062, $change_amount);
			}
			elsif ($text=~/\b1063\b/) {	#:: Citizens of Freeport
				quest::faction(1063, $change_amount);
			}
			elsif ($text=~/\b1064\b/) {	#:: Spirits of Arcstone
				quest::faction(1064, $change_amount);
			}
			elsif ($text=~/\b1065\b/) {	#:: Fledgling Scrykin
				quest::faction(1065, $change_amount);
			}
			elsif ($text=~/\b1066\b/) {	#:: Elder Scrykin
				quest::faction(1066, $change_amount);
			}
			elsif ($text=~/\b1067\b/) {	#:: Constructs of Relic
				quest::faction(1067, $change_amount);
			}
			elsif ($text=~/\b1068\b/) {	#:: Legions of Sverag
				quest::faction(1068, $change_amount);
			}
			elsif ($text=~/\b1069\b/) {	#:: Ravenous Undead
				quest::faction(1069, $change_amount);
			}
			elsif ($text=~/\b1070\b/) {	#:: Wildfang
				quest::faction(1070, $change_amount);
			}
			elsif ($text=~/\b1071\b/) {	#:: Redfist Legionnaires
				quest::faction(1071, $change_amount);
			}
			elsif ($text=~/\b1072\b/) {	#:: The Irebound
				quest::faction(1072, $change_amount);
			}
			elsif ($text=~/\b1073\b/) {	#:: Ragefang
				quest::faction(1073, $change_amount);
			}
			elsif ($text=~/\b1074\b/) {	#:: The Venom Swarm
				quest::faction(1074, $change_amount);
			}
			elsif ($text=~/\b1075\b/) {	#:: Deathshed Legion
				quest::faction(1075, $change_amount);
			}
			elsif ($text=~/\b1076\b/) {	#:: Blood Furies
				quest::faction(1076, $change_amount);
			}
			elsif ($text=~/\b1077\b/) {	#:: Furies of the North
				quest::faction(1077, $change_amount);
			}
			elsif ($text=~/\b1078\b/) {	#:: Stormbreaker Furies
				quest::faction(1078, $change_amount);
			}
			elsif ($text=~/\b1079\b/) {	#:: Bonecracker Furies
				quest::faction(1079, $change_amount);
			}
			elsif ($text=~/\b1080\b/) {	#:: Furies of Shir
				quest::faction(1080, $change_amount);
			}
			elsif ($text=~/\b1081\b/) {	#:: The Wall-Borne
				quest::faction(1081, $change_amount);
			}
			elsif ($text=~/\b1082\b/) {	#:: Legion of Rage
				quest::faction(1082, $change_amount);
			}
			elsif ($text=~/\b1083\b/) {	#:: The Wretched
				quest::faction(1083, $change_amount);
			}
			elsif ($text=~/\b1084\b/) {	#:: Trueblood Coven
				quest::faction(1084, $change_amount);
			}
			elsif ($text=~/\b1085\b/) {	#:: Citizens of Takish-Hiz
				quest::faction(1085, $change_amount);
			}
			elsif ($text=~/\b1086\b/) {	#:: Insurgents of Ro
				quest::faction(1086, $change_amount);
			}
			elsif ($text=~/\b1087\b/) {	#:: Creatures of Elddar
				quest::faction(1087, $change_amount);
			}
			elsif ($text=~/\b1088\b/) {	#:: Clan Vorzek
				quest::faction(1088, $change_amount);
			}
			elsif ($text=~/\b1089\b/) {	#:: Tribe of the Nogdha
				quest::faction(1089, $change_amount);
			}
			elsif ($text=~/\b1090\b/) {	#:: Servants of the Compact
				quest::faction(1090, $change_amount);
			}
			elsif ($text=~/\b1091\b/) {	#:: Creatures of Sandflow
				quest::faction(1091, $change_amount);
			}
			elsif ($text=~/\b1092\b/) {	#:: Blood of Ro
				quest::faction(1092, $change_amount);
			}
			elsif ($text=~/\b1093\b/) {	#:: Direwind Gnolls
				quest::faction(1093, $change_amount);
			}
			elsif ($text=~/\b1094\b/) {	#:: Forces of Dyn'leth
				quest::faction(1094, $change_amount);
			}
			elsif ($text=~/\b1095\b/) {	#:: Crusade of the Scale
				quest::faction(1095, $change_amount);
			}
			elsif ($text=~/\b1096\b/) {	#:: Blackfeather Harpies
				quest::faction(1096, $change_amount);
			}
			elsif ($text=~/\b1097\b/) {	#:: Blackfeather Royalty
				quest::faction(1097, $change_amount);
			}
			elsif ($text=~/\b1098\b/) {	#:: Blackfeather Animals
				quest::faction(1098, $change_amount);
			}
			elsif ($text=~/\b1099\b/) {	#:: Blackfeather Spiders
				quest::faction(1099, $change_amount);
			}
			elsif ($text=~/\b1100\b/) {	#:: Shades of Zek
				quest::faction(1100, $change_amount);
			}
			elsif ($text=~/\b1101\b/) {	#:: Ancestors of Valdeholm
				quest::faction(1101, $change_amount);
			}
			elsif ($text=~/\b1102\b/) {	#:: Converts of Valdeholm
				quest::faction(1102, $change_amount);
			}
			elsif ($text=~/\b1103\b/) {	#:: Valdeholm Citizens
				quest::faction(1103, $change_amount);
			}
			elsif ($text=~/\b1104\b/) {	#:: Wraithguard
				quest::faction(1104, $change_amount);
			}
			elsif ($text=~/\b1105\b/) {	#:: Wraithguard Leadership
				quest::faction(1105, $change_amount);
			}
			elsif ($text=~/\b1106\b/) {	#:: Drakkin
				quest::faction(1106, $change_amount);
			}
			elsif ($text=~/\b1107\b/) {	#:: Tuffein
				quest::faction(1107, $change_amount);
			}
			elsif ($text=~/\b1108\b/) {	#:: Tuffein Leadership
				quest::faction(1108, $change_amount);
			}
			elsif ($text=~/\b1109\b/) {	#:: Minohten
				quest::faction(1109, $change_amount);
			}
			elsif ($text=~/\b1110\b/) {	#:: Nymphs of the Windwillow
				quest::faction(1110, $change_amount);
			}
			elsif ($text=~/\b1111\b/) {	#:: Nymphs of the Darkwater
				quest::faction(1111, $change_amount);
			}
			elsif ($text=~/\b1112\b/) {	#:: Blackfeather Raiders
				quest::faction(1112, $change_amount);
			}
			elsif ($text=~/\b1113\b/) {	#:: Dromrek
				quest::faction(1113, $change_amount);
			}
			elsif ($text=~/\b1114\b/) {	#:: Lost of the Windwillow
				quest::faction(1114, $change_amount);
			}
			elsif ($text=~/\b1115\b/) {	#:: Foulblood Fieldstrider Centaur
				quest::faction(1115, $change_amount);
			}
			elsif ($text=~/\b1116\b/) {	#:: Fieldstrider Centaur
				quest::faction(1116, $change_amount);
			}
			elsif ($text=~/\b1117\b/) {	#:: Stonemight Goblins
				quest::faction(1117, $change_amount);
			}
			elsif ($text=~/\b1118\b/) {	#:: Darkfell Clan
				quest::faction(1118, $change_amount);
			}
			elsif ($text=~/\b1119\b/) {	#:: Guardians of the Grove
				quest::faction(1119, $change_amount);
			}
			elsif ($text=~/\b1120\b/) {	#:: Coldeye Clan
				quest::faction(1120, $change_amount);
			}
			elsif ($text=~/\b1121\b/) {	#:: Nightmoon Kobolds
				quest::faction(1121, $change_amount);
			}
			elsif ($text=~/\b1122\b/) {	#:: Frostbite Clan
				quest::faction(1122, $change_amount);
			}
			elsif ($text=~/\b1123\b/) {	#:: Drones of Stonehive
				quest::faction(1123, $change_amount);
			}
			elsif ($text=~/\b1124\b/) {	#:: Legion of Stonehive
				quest::faction(1124, $change_amount);
			}
			elsif ($text=~/\b1125\b/) {	#:: Spirits of Nokk
				quest::faction(1125, $change_amount);
			}
			elsif ($text=~/\b1126\b/) {	#:: Guardians of the Dark Tower
				quest::faction(1126, $change_amount);
			}
			elsif ($text=~/\b1127\b/) {	#:: The Blightfire Tainted
				quest::faction(1127, $change_amount);
			}
			elsif ($text=~/\b1128\b/) {	#:: Madcaps - Mushroom Men
				quest::faction(1128, $change_amount);
			}
			elsif ($text=~/\b1129\b/) {	#:: Circle of the Crystalwing
				quest::faction(1129, $change_amount);
			}
			elsif ($text=~/\b1130\b/) {	#:: Selay
				quest::faction(1130, $change_amount);
			}
			elsif ($text=~/\b1131\b/) {	#:: Dyn`leth
				quest::faction(1131, $change_amount);
			}
			elsif ($text=~/\b1132\b/) {	#:: Lethar
				quest::faction(1132, $change_amount);
			}
			elsif ($text=~/\b1133\b/) {	#:: Vergalid
				quest::faction(1133, $change_amount);
			}
			elsif ($text=~/\b1134\b/) {	#:: Scholars of Solusek
				quest::faction(1134, $change_amount);
			}
			elsif ($text=~/\b1135\b/) {	#:: Infiltrators and Traitors of Ashengate
				quest::faction(1135, $change_amount);
			}
			elsif ($text=~/\b1136\b/) {	#:: Nature Animal
				quest::faction(1136, $change_amount);
			}
			elsif ($text=~/\b1137\b/) {	#:: Crescent Reach Guards
				quest::faction(1137, $change_amount);
			}
			elsif ($text=~/\b1138\b/) {	#:: Greater Shades of Zek
				quest::faction(1138, $change_amount);
			}
			elsif ($text=~/\b1139\b/) {	#:: Newbie Guard
				quest::faction(1139, $change_amount);
			}
			elsif ($text=~/\b1140\b/) {	#:: Drowned Dead
				quest::faction(1140, $change_amount);
			}
			elsif ($text=~/\b1141\b/) {	#:: Sharpeye's Reef Runners
				quest::faction(1141, $change_amount);
			}
			elsif ($text=~/\b1142\b/) {	#:: Blacksail Pirates
				quest::faction(1142, $change_amount);
			}
			elsif ($text=~/\b1143\b/) {	#:: Stormscape Aviaks
				quest::faction(1143, $change_amount);
			}
			elsif ($text=~/\b1144\b/) {	#:: Galigaba
				quest::faction(1144, $change_amount);
			}
			elsif ($text=~/\b1145\b/) {	#:: King Peleke
				quest::faction(1145, $change_amount);
			}
			elsif ($text=~/\b1146\b/) {	#:: Sunstone Goblins
				quest::faction(1146, $change_amount);
			}
			elsif ($text=~/\b1147\b/) {	#:: King Vigdos
				quest::faction(1147, $change_amount);
			}
			elsif ($text=~/\b1148\b/) {	#:: Tidewater Goblins
				quest::faction(1148, $change_amount);
			}
			elsif ($text=~/\b1149\b/) {	#:: King Tondra
				quest::faction(1149, $change_amount);
			}
			elsif ($text=~/\b1150\b/) {	#:: Platinum Efreeti
				quest::faction(1150, $change_amount);
			}
			elsif ($text=~/\b1151\b/) {	#:: Sphinx of Atiiki
				quest::faction(1151, $change_amount);
			}
			elsif ($text=~/\b1152\b/) {	#:: Nature Animal - Snake
				quest::faction(1152, $change_amount);
			}
			elsif ($text=~/\b1153\b/) {	#:: Nature Animal - Crocodile
				quest::faction(1153, $change_amount);
			}
			elsif ($text=~/\b1154\b/) {	#:: Nature Animal - Basilisk
				quest::faction(1154, $change_amount);
			}
			elsif ($text=~/\b1155\b/) {	#:: Nature Animal - Shark
				quest::faction(1155, $change_amount);
			}
			elsif ($text=~/\b1156\b/) {	#:: Nature Animal - Spider
				quest::faction(1156, $change_amount);
			}
			elsif ($text=~/\b1157\b/) {	#:: Nature Animal - Wolf
				quest::faction(1157, $change_amount);
			}
			elsif ($text=~/\b1158\b/) {	#:: Nature Animal - Bear
				quest::faction(1158, $change_amount);
			}
			elsif ($text=~/\b1159\b/) {	#:: Nature Animal - Beetle
				quest::faction(1159, $change_amount);
			}
			elsif ($text=~/\b1160\b/) {	#:: Nature Animal - Fish
				quest::faction(1160, $change_amount);
			}
			elsif ($text=~/\b1161\b/) {	#:: Combine Citizens
				quest::faction(1161, $change_amount);
			}
			elsif ($text=~/\b1162\b/) {	#:: Disciples of Zhisza
				quest::faction(1162, $change_amount);
			}
			elsif ($text=~/\b1163\b/) {	#:: Brood of Vaakiszh
				quest::faction(1163, $change_amount);
			}
			elsif ($text=~/\b1164\b/) {	#:: Fangs of Saarisz
				quest::faction(1164, $change_amount);
			}
			elsif ($text=~/\b1165\b/) {	#:: Katta Elementals
				quest::faction(1165, $change_amount);
			}
			elsif ($text=~/\b1166\b/) {	#:: Sirens of Maiden's Grave
				quest::faction(1166, $change_amount);
			}
			elsif ($text=~/\b1167\b/) {	#:: The Cursed of Monkey Rock
				quest::faction(1167, $change_amount);
			}
			elsif ($text=~/\b1168\b/) {	#:: Minions of Solusek Ro
				quest::faction(1168, $change_amount);
			}
			elsif ($text=~/\b1169\b/) {	#:: Blacksail Smugglers
				quest::faction(1169, $change_amount);
			}
			elsif ($text=~/\b1170\b/) {	#:: Combine Empire Merchants
				quest::faction(1170, $change_amount);
			}
			elsif ($text=~/\b1171\b/) {	#:: Beta Enemy
				quest::faction(1171, $change_amount);
			}
			elsif ($text=~/\b1172\b/) {	#:: Beta Friend
				quest::faction(1172, $change_amount);
			}
			elsif ($text=~/\b1173\b/) {	#:: Beta Neutral 2
				quest::faction(1173, $change_amount);
			}
			elsif ($text=~/\b1174\b/) {	#:: The Cursed of Monkey Rock (Instance)
				quest::faction(1174, $change_amount);
			}
			elsif ($text=~/\b1175\b/) {	#:: Captains of Dyn`leth
				quest::faction(1175, $change_amount);
			}
			elsif ($text=~/\b1176\b/) {	#:: Blood of Solusek
				quest::faction(1176, $change_amount);
			}
			elsif ($text=~/\b1177\b/) {	#:: Guardian 
				quest::faction(1177, $change_amount);
			}
			elsif ($text=~/\b1178\b/) {	#:: Workshop Workers Union
				quest::faction(1178, $change_amount);
			}
			elsif ($text=~/\b1179\b/) {	#:: Blackwater
				quest::faction(1179, $change_amount);
			}
			elsif ($text=~/\b1180\b/) {	#:: Kirathas
				quest::faction(1180, $change_amount);
			}
			elsif ($text=~/\b1181\b/) {	#:: The Borrowers
				quest::faction(1181, $change_amount);
			}
			elsif ($text=~/\b1182\b/) {	#:: Erollisi's Scorned
				quest::faction(1182, $change_amount);
			}
			elsif ($text=~/\b1183\b/) {	#:: Bertoxxulous' Chosen
				quest::faction(1183, $change_amount);
			}
			elsif ($text=~/\b1184\b/) {	#:: Camp Valor
				quest::faction(1184, $change_amount);
			}
			elsif ($text=~/\b1185\b/) {	#:: Ladies of the Light
				quest::faction(1185, $change_amount);
			}
			elsif ($text=~/\b1186\b/) {	#:: Loyalists of Kerafyrm
				quest::faction(1186, $change_amount);
			}
			elsif ($text=~/\b1187\b/) {	#:: Emissaries of Claws of Veeshan
				quest::faction(1187, $change_amount);
			}
			elsif ($text=~/\b1188\b/) {	#:: Crusaders of Veeshan
				quest::faction(1188, $change_amount);
			}
			elsif ($text=~/\b1189\b/) {	#:: Brownie Rebels
				quest::faction(1189, $change_amount);
			}
			elsif ($text=~/\b1190\b/) {	#:: Ak`Anon Strike Force V
				quest::faction(1190, $change_amount);
			}
			elsif ($text=~/\b1191\b/) {	#:: Fang Breakers
				quest::faction(1191, $change_amount);
			}
			elsif ($text=~/\b1192\b/) {	#:: The Fallen
				quest::faction(1192, $change_amount);
			}
			elsif ($text=~/\b1193\b/) {	#:: Ancestors of the Crypt
				quest::faction(1193, $change_amount);
			}
			elsif ($text=~/\b1194\b/) {	#:: Minions of Meldrath
				quest::faction(1194, $change_amount);
			}
			elsif ($text=~/\b1195\b/) {	#:: Bloodmoon Were-Orcs
				quest::faction(1195, $change_amount);
			}
			elsif ($text=~/\b1196\b/) {	#:: Darkvine Villagers
				quest::faction(1196, $change_amount);
			}
			elsif ($text=~/\b1197\b/) {	#:: Wind Nymphs
				quest::faction(1197, $change_amount);
			}
			elsif ($text=~/\b1198\b/) {	#:: Guardian Defense Forces
				quest::faction(1198, $change_amount);
			}
			elsif ($text=~/\b1199\b/) {	#:: Residents of the Glade
				quest::faction(1199, $change_amount);
			}
			elsif ($text=~/\b1200\b/) {	#:: Bayle's Irregulars
				quest::faction(1200, $change_amount);
			}
			elsif ($text=~/\b1201\b/) {	#:: Plaguebringer Parishioners
				quest::faction(1201, $change_amount);
			}
			elsif ($text=~/\b1202\b/) {	#:: Blackburrow Gnolls
				quest::faction(1202, $change_amount);
			}
			elsif ($text=~/\b1203\b/) {	#:: Darkpaw Gnolls
				quest::faction(1203, $change_amount);
			}
			elsif ($text=~/\b1204\b/) {	#:: Army of Light 
				quest::faction(1204, $change_amount);
			}
			elsif ($text=~/\b1205\b/) {	#:: Thaulen Teir'Duuren
				quest::faction(1205, $change_amount);
			}
			elsif ($text=~/\b1206\b/) {	#:: Kithicor Irregulars
				quest::faction(1206, $change_amount);
			}
			elsif ($text=~/\b1207\b/) {	#:: Prisoners of the Dark Elves
				quest::faction(1207, $change_amount);
			}
			elsif ($text=~/\b1208\b/) {	#:: Discordant Agents
				quest::faction(1208, $change_amount);
			}
			elsif ($text=~/\b1209\b/) {	#:: Dragorn Forces
				quest::faction(1209, $change_amount);
			}
			elsif ($text=~/\b1210\b/) {	#:: Discordant Army
				quest::faction(1210, $change_amount);
			}
			elsif ($text=~/\b1211\b/) {	#:: Toskirakk Slaves
				quest::faction(1211, $change_amount);
			}
			elsif ($text=~/\b1212\b/) {	#:: Toskirakk Slavers
				quest::faction(1212, $change_amount);
			}
			elsif ($text=~/\b1213\b/) {	#:: Rallosian Guards
				quest::faction(1213, $change_amount);
			}
			elsif ($text=~/\b1214\b/) {	#:: Toskirakk Merchants
				quest::faction(1214, $change_amount);
			}
			elsif ($text=~/\b1215\b/) {	#:: Rathe Council
				quest::faction(1215, $change_amount);
			}
			elsif ($text=~/\b1216\b/) {	#:: Rallosian Invaders
				quest::faction(1216, $change_amount);
			}
			elsif ($text=~/\b1217\b/) {	#:: Rathe Living Heaps
				quest::faction(1217, $change_amount);
			}
			elsif ($text=~/\b1218\b/) {	#:: Rathe Council Defenders
				quest::faction(1218, $change_amount);
			}
			elsif ($text=~/\b1219\b/) {	#:: Darkhammer Dwarves
				quest::faction(1219, $change_amount);
			}
			elsif ($text=~/\b1220\b/) {	#:: Primal Crystallines
				quest::faction(1220, $change_amount);
			}
			elsif ($text=~/\b1221\b/) {	#:: Oceangreen Residents
				quest::faction(1221, $change_amount);
			}
			elsif ($text=~/\b1222\b/) {	#:: Cirtan, Bayle's Herald
				quest::faction(1222, $change_amount);
			}
			elsif ($text=~/\b1223\b/) {	#:: Silla Herald
				quest::faction(1223, $change_amount);
			}
			elsif ($text=~/\b1224\b/) {	#:: Tynoc, Herald of Scale
				quest::faction(1224, $change_amount);
			}
			elsif ($text=~/\b1225\b/) {	#:: Mitius, Herald of Change
				quest::faction(1225, $change_amount);
			}
			elsif ($text=~/\b1226\b/) {	#:: Herald Argoth
				quest::faction(1226, $change_amount);
			}
			elsif ($text=~/\b1227\b/) {	#:: Herald of Druzzil Ro
				quest::faction(1227, $change_amount);
			}
			elsif ($text=~/\b1228\b/) {	#:: Ancient Blackburrow Gnolls
				quest::faction(1228, $change_amount);
			}
			elsif ($text=~/\b1229\b/) {	#:: Sebilisian Empire
				quest::faction(1229, $change_amount);
			}
			elsif ($text=~/\b1230\b/) {	#:: Discordant Armies
				quest::faction(1230, $change_amount);
			}
			elsif ($text=~/\b1231\b/) {	#:: Tanglefuse's Clockworks
				quest::faction(1231, $change_amount);
			}
			elsif ($text=~/\b1232\b/) {	#:: Underfoot Citizens
				quest::faction(1232, $change_amount);
			}
			elsif ($text=~/\b1233\b/) {	#:: Underfoot Autarchs
				quest::faction(1233, $change_amount);
			}
			elsif ($text=~/\b1234\b/) {	#:: Underfoot Denizens
				quest::faction(1234, $change_amount);
			}
			elsif ($text=~/\b1235\b/) {	#:: Underfoot Protectors
				quest::faction(1235, $change_amount);
			}
			elsif ($text=~/\b1236\b/) {	#:: Underfoot Devout
				quest::faction(1236, $change_amount);
			}
			elsif ($text=~/\b1237\b/) {	#:: Cliknar
				quest::faction(1237, $change_amount);
			}
			elsif ($text=~/\b1238\b/) {	#:: Underfoot Subversionists
				quest::faction(1238, $change_amount);
			}
			elsif ($text=~/\b1239\b/) {	#:: Clockwork Magma Meter
				quest::faction(1239, $change_amount);
			}
			elsif ($text=~/\b1240\b/) {	#:: Morell-Thule
				quest::faction(1240, $change_amount);
			}
			elsif ($text=~/\b1241\b/) {	#:: Degmar's Loyalists
				quest::faction(1241, $change_amount);
			}
			elsif ($text=~/\b1242\b/) {	#:: Degmar's Commoners
				quest::faction(1242, $change_amount);
			}
			elsif ($text=~/\b1243\b/) {	#:: Degmar's Haunts
				quest::faction(1243, $change_amount);
			}
			elsif ($text=~/\b1244\b/) {	#:: Brother Island Residents
				quest::faction(1244, $change_amount);
			}
			elsif ($text=~/\b1245\b/) {	#:: Brother Island Animal
				quest::faction(1245, $change_amount);
			}
			elsif ($text=~/\b1246\b/) {	#:: Sirens of the Endless Cavern
				quest::faction(1246, $change_amount);
			}
			elsif ($text=~/\b1247\b/) {	#:: Faction1247
				quest::faction(1247, $change_amount);
			}
			elsif ($text=~/\b1248\b/) {	#:: Faction1248
				quest::faction(1248, $change_amount);
			}
			elsif ($text=~/\b1249\b/) {	#:: Faction1249
				quest::faction(1249, $change_amount);
			}
			elsif ($text=~/\b1250\b/) {	#:: Faction1250
				quest::faction(1250, $change_amount);
			}
			elsif ($text=~/\b1251\b/) {	#:: Faction1251
				quest::faction(1251, $change_amount);
			}
			elsif ($text=~/\b1252\b/) {	#:: Faction1252
				quest::faction(1252, $change_amount);
			}
			elsif ($text=~/\b1253\b/) {	#:: Faction1253
				quest::faction(1253, $change_amount);
			}
			elsif ($text=~/\b1254\b/) {	#:: Faction1254
				quest::faction(1254, $change_amount);
			}
			elsif ($text=~/\b1255\b/) {	#:: Faction1255
				quest::faction(1255, $change_amount);
			}
			elsif ($text=~/\b1256\b/) {	#:: Faction1256
				quest::faction(1256, $change_amount);
			}
			elsif ($text=~/\b1257\b/) {	#:: Faction1257
				quest::faction(1257, $change_amount);
			}
			elsif ($text=~/\b1258\b/) {	#:: Faction1258
				quest::faction(1258, $change_amount);
			}
			elsif ($text=~/\b1259\b/) {	#:: Faction1259
				quest::faction(1259, $change_amount);
			}
			elsif ($text=~/\b1260\b/) {	#:: Faction1260
				quest::faction(1260, $change_amount);
			}
			elsif ($text=~/\b1261\b/) {	#:: Faction1261
				quest::faction(1261, $change_amount);
			}
			elsif ($text=~/\b1262\b/) {	#:: Faction1262
				quest::faction(1262, $change_amount);
			}
			elsif ($text=~/\b1263\b/) {	#:: Faction1263
				quest::faction(1263, $change_amount);
			}
			elsif ($text=~/\b1264\b/) {	#:: Faction1264
				quest::faction(1264, $change_amount);
			}
			elsif ($text=~/\b1265\b/) {	#:: Faction1265
				quest::faction(1265, $change_amount);
			}
			elsif ($text=~/\b1266\b/) {	#:: Faction1266
				quest::faction(1266, $change_amount);
			}
			elsif ($text=~/\b1267\b/) {	#:: Faction1267
				quest::faction(1267, $change_amount);
			}
			elsif ($text=~/\b1268\b/) {	#:: Faction1268
				quest::faction(1268, $change_amount);
			}
			elsif ($text=~/\b1269\b/) {	#:: Faction1269
				quest::faction(1269, $change_amount);
			}
			elsif ($text=~/\b1270\b/) {	#:: Faction1270
				quest::faction(1270, $change_amount);
			}
			elsif ($text=~/\b1271\b/) {	#:: Faction1271
				quest::faction(1271, $change_amount);
			}
			elsif ($text=~/\b1272\b/) {	#:: Faction1272
				quest::faction(1272, $change_amount);
			}
			elsif ($text=~/\b1273\b/) {	#:: Faction1273
				quest::faction(1273, $change_amount);
			}
			elsif ($text=~/\b1274\b/) {	#:: Faction1274
				quest::faction(1274, $change_amount);
			}
			elsif ($text=~/\b1275\b/) {	#:: Faction1275
				quest::faction(1275, $change_amount);
			}
			elsif ($text=~/\b1276\b/) {	#:: Faction1276
				quest::faction(1276, $change_amount);
			}
			elsif ($text=~/\b1277\b/) {	#:: Faction1277
				quest::faction(1277, $change_amount);
			}
			elsif ($text=~/\b1278\b/) {	#:: Faction1278
				quest::faction(1278, $change_amount);
			}
			elsif ($text=~/\b1279\b/) {	#:: Faction1279
				quest::faction(1279, $change_amount);
			}
			elsif ($text=~/\b1280\b/) {	#:: Faction1280
				quest::faction(1280, $change_amount);
			}
			elsif ($text=~/\b1281\b/) {	#:: Faction1281
				quest::faction(1281, $change_amount);
			}
			elsif ($text=~/\b1282\b/) {	#:: Faction1282
				quest::faction(1282, $change_amount);
			}
			elsif ($text=~/\b1283\b/) {	#:: Faction1283
				quest::faction(1283, $change_amount);
			}
			elsif ($text=~/\b1284\b/) {	#:: Faction1284
				quest::faction(1284, $change_amount);
			}
			elsif ($text=~/\b1285\b/) {	#:: Faction1285
				quest::faction(1285, $change_amount);
			}
			elsif ($text=~/\b1286\b/) {	#:: Faction1286
				quest::faction(1286, $change_amount);
			}
			elsif ($text=~/\b1287\b/) {	#:: Faction1287
				quest::faction(1287, $change_amount);
			}
			elsif ($text=~/\b1288\b/) {	#:: Faction1288
				quest::faction(1288, $change_amount);
			}
			elsif ($text=~/\b1289\b/) {	#:: Faction1289
				quest::faction(1289, $change_amount);
			}
			elsif ($text=~/\b1290\b/) {	#:: Faction1290
				quest::faction(1290, $change_amount);
			}
			elsif ($text=~/\b1291\b/) {	#:: Faction1291
				quest::faction(1291, $change_amount);
			}
			elsif ($text=~/\b1292\b/) {	#:: Faction1292
				quest::faction(1292, $change_amount);
			}
			elsif ($text=~/\b1293\b/) {	#:: Faction1293
				quest::faction(1293, $change_amount);
			}
			elsif ($text=~/\b1294\b/) {	#:: Faction1294
				quest::faction(1294, $change_amount);
			}
			elsif ($text=~/\b1295\b/) {	#:: Faction1295
				quest::faction(1295, $change_amount);
			}
			elsif ($text=~/\b1296\b/) {	#:: Faction1296
				quest::faction(1296, $change_amount);
			}
			elsif ($text=~/\b1297\b/) {	#:: Faction1297
				quest::faction(1297, $change_amount);
			}
			elsif ($text=~/\b1298\b/) {	#:: Faction1298
				quest::faction(1298, $change_amount);
			}
			elsif ($text=~/\b1299\b/) {	#:: Faction1299
				quest::faction(1299, $change_amount);
			}
			elsif ($text=~/\b1300\b/) {	#:: Faction1300
				quest::faction(1300, $change_amount);
			}
			elsif ($text=~/\b1301\b/) {	#:: Faction1301
				quest::faction(1301, $change_amount);
			}
			elsif ($text=~/\b1302\b/) {	#:: Faction1302
				quest::faction(1302, $change_amount);
			}
			elsif ($text=~/\b1303\b/) {	#:: Faction1303
				quest::faction(1303, $change_amount);
			}
			elsif ($text=~/\b1304\b/) {	#:: Faction1304
				quest::faction(1304, $change_amount);
			}
			elsif ($text=~/\b1305\b/) {	#:: Faction1305
				quest::faction(1305, $change_amount);
			}
			elsif ($text=~/\b1306\b/) {	#:: Faction1306
				quest::faction(1306, $change_amount);
			}
			elsif ($text=~/\b1307\b/) {	#:: Faction1307
				quest::faction(1307, $change_amount);
			}
			elsif ($text=~/\b1308\b/) {	#:: Faction1308
				quest::faction(1308, $change_amount);
			}
			elsif ($text=~/\b1309\b/) {	#:: Faction1309
				quest::faction(1309, $change_amount);
			}
			elsif ($text=~/\b1310\b/) {	#:: Faction1310
				quest::faction(1310, $change_amount);
			}
			elsif ($text=~/\b1311\b/) {	#:: Faction1311
				quest::faction(1311, $change_amount);
			}
			elsif ($text=~/\b1312\b/) {	#:: Faction1312
				quest::faction(1312, $change_amount);
			}
			elsif ($text=~/\b1313\b/) {	#:: Faction1313
				quest::faction(1313, $change_amount);
			}
			elsif ($text=~/\b1314\b/) {	#:: Faction1314
				quest::faction(1314, $change_amount);
			}
			elsif ($text=~/\b1315\b/) {	#:: Faction1315
				quest::faction(1315, $change_amount);
			}
			elsif ($text=~/\b1316\b/) {	#:: Faction1316
				quest::faction(1316, $change_amount);
			}
			elsif ($text=~/\b1317\b/) {	#:: Faction1317
				quest::faction(1317, $change_amount);
			}
			elsif ($text=~/\b1318\b/) {	#:: Faction1318
				quest::faction(1318, $change_amount);
			}
			elsif ($text=~/\b1319\b/) {	#:: Faction1319
				quest::faction(1319, $change_amount);
			}
			elsif ($text=~/\b1320\b/) {	#:: Faction1320
				quest::faction(1320, $change_amount);
			}
			elsif ($text=~/\b1321\b/) {	#:: Faction1321
				quest::faction(1321, $change_amount);
			}
			elsif ($text=~/\b1322\b/) {	#:: Faction1322
				quest::faction(1322, $change_amount);
			}
			elsif ($text=~/\b1323\b/) {	#:: Faction1323
				quest::faction(1323, $change_amount);
			}
			elsif ($text=~/\b1324\b/) {	#:: Faction1324
				quest::faction(1324, $change_amount);
			}
			elsif ($text=~/\b1325\b/) {	#:: Faction1325
				quest::faction(1325, $change_amount);
			}
			elsif ($text=~/\b1326\b/) {	#:: Faction1326
				quest::faction(1326, $change_amount);
			}
			elsif ($text=~/\b1327\b/) {	#:: Faction1327
				quest::faction(1327, $change_amount);
			}
			elsif ($text=~/\b1328\b/) {	#:: Faction1328
				quest::faction(1328, $change_amount);
			}
			elsif ($text=~/\b1329\b/) {	#:: Faction1329
				quest::faction(1329, $change_amount);
			}
			elsif ($text=~/\b1330\b/) {	#:: Faction1330
				quest::faction(1330, $change_amount);
			}
			elsif ($text=~/\b1331\b/) {	#:: Faction1331
				quest::faction(1331, $change_amount);
			}
			elsif ($text=~/\b1332\b/) {	#:: Faction1332
				quest::faction(1332, $change_amount);
			}
			elsif ($text=~/\b1333\b/) {	#:: Faction1333
				quest::faction(1333, $change_amount);
			}
			elsif ($text=~/\b1334\b/) {	#:: Faction1334
				quest::faction(1334, $change_amount);
			}
			elsif ($text=~/\b1335\b/) {	#:: Faction1335
				quest::faction(1335, $change_amount);
			}
			elsif ($text=~/\b1336\b/) {	#:: Faction1336
				quest::faction(1336, $change_amount);
			}
			elsif ($text=~/\b1337\b/) {	#:: Faction1337
				quest::faction(1337, $change_amount);
			}
			elsif ($text=~/\b1338\b/) {	#:: Faction1338
				quest::faction(1338, $change_amount);
			}
			elsif ($text=~/\b1339\b/) {	#:: Faction1339
				quest::faction(1339, $change_amount);
			}
			elsif ($text=~/\b1340\b/) {	#:: Faction1340
				quest::faction(1340, $change_amount);
			}
			elsif ($text=~/\b1341\b/) {	#:: Faction1341
				quest::faction(1341, $change_amount);
			}
			elsif ($text=~/\b1342\b/) {	#:: Faction1342
				quest::faction(1342, $change_amount);
			}
			elsif ($text=~/\b1343\b/) {	#:: Faction1343
				quest::faction(1343, $change_amount);
			}
			elsif ($text=~/\b1344\b/) {	#:: Faction1344
				quest::faction(1344, $change_amount);
			}
			elsif ($text=~/\b1345\b/) {	#:: Faction1345
				quest::faction(1345, $change_amount);
			}
			elsif ($text=~/\b1346\b/) {	#:: Faction1346
				quest::faction(1346, $change_amount);
			}
			elsif ($text=~/\b1347\b/) {	#:: Faction1347
				quest::faction(1347, $change_amount);
			}
			elsif ($text=~/\b1348\b/) {	#:: Faction1348
				quest::faction(1348, $change_amount);
			}
			elsif ($text=~/\b1349\b/) {	#:: Faction1349
				quest::faction(1349, $change_amount);
			}
			elsif ($text=~/\b1350\b/) {	#:: Faction1350
				quest::faction(1350, $change_amount);
			}
			elsif ($text=~/\b1351\b/) {	#:: Faction1351
				quest::faction(1351, $change_amount);
			}
			elsif ($text=~/\b1352\b/) {	#:: Faction1352
				quest::faction(1352, $change_amount);
			}
			elsif ($text=~/\b1353\b/) {	#:: Faction1353
				quest::faction(1353, $change_amount);
			}
			elsif ($text=~/\b1354\b/) {	#:: Faction1354
				quest::faction(1354, $change_amount);
			}
			elsif ($text=~/\b1355\b/) {	#:: Faction1355
				quest::faction(1355, $change_amount);
			}
			elsif ($text=~/\b1356\b/) {	#:: Faction1356
				quest::faction(1356, $change_amount);
			}
			elsif ($text=~/\b1357\b/) {	#:: Faction1357
				quest::faction(1357, $change_amount);
			}
			elsif ($text=~/\b1358\b/) {	#:: Faction1358
				quest::faction(1358, $change_amount);
			}
			elsif ($text=~/\b1359\b/) {	#:: Faction1359
				quest::faction(1359, $change_amount);
			}
			elsif ($text=~/\b1360\b/) {	#:: Faction1360
				quest::faction(1360, $change_amount);
			}
			elsif ($text=~/\b1361\b/) {	#:: Faction1361
				quest::faction(1361, $change_amount);
			}
			elsif ($text=~/\b1362\b/) {	#:: Faction1362
				quest::faction(1362, $change_amount);
			}
			elsif ($text=~/\b1363\b/) {	#:: Faction1363
				quest::faction(1363, $change_amount);
			}
			elsif ($text=~/\b1364\b/) {	#:: Faction1364
				quest::faction(1364, $change_amount);
			}
			elsif ($text=~/\b1365\b/) {	#:: Faction1365
				quest::faction(1365, $change_amount);
			}
			elsif ($text=~/\b1366\b/) {	#:: Faction1366
				quest::faction(1366, $change_amount);
			}
			elsif ($text=~/\b1367\b/) {	#:: Faction1367
				quest::faction(1367, $change_amount);
			}
			elsif ($text=~/\b1368\b/) {	#:: Faction1368
				quest::faction(1368, $change_amount);
			}
			elsif ($text=~/\b1369\b/) {	#:: Faction1369
				quest::faction(1369, $change_amount);
			}
			elsif ($text=~/\b1370\b/) {	#:: Faction1370
				quest::faction(1370, $change_amount);
			}
			elsif ($text=~/\b1371\b/) {	#:: Faction1371
				quest::faction(1371, $change_amount);
			}
			elsif ($text=~/\b1372\b/) {	#:: Faction1372
				quest::faction(1372, $change_amount);
			}
			elsif ($text=~/\b1373\b/) {	#:: Faction1373
				quest::faction(1373, $change_amount);
			}
			elsif ($text=~/\b1374\b/) {	#:: Faction1374
				quest::faction(1374, $change_amount);
			}
			elsif ($text=~/\b1375\b/) {	#:: Faction1375
				quest::faction(1375, $change_amount);
			}
			elsif ($text=~/\b1376\b/) {	#:: Faction1376
				quest::faction(1376, $change_amount);
			}
			elsif ($text=~/\b1377\b/) {	#:: Faction1377
				quest::faction(1377, $change_amount);
			}
			elsif ($text=~/\b1378\b/) {	#:: Faction1378
				quest::faction(1378, $change_amount);
			}
			elsif ($text=~/\b1379\b/) {	#:: Faction1379
				quest::faction(1379, $change_amount);
			}
			elsif ($text=~/\b1380\b/) {	#:: Faction1380
				quest::faction(1380, $change_amount);
			}
			elsif ($text=~/\b1381\b/) {	#:: Faction1381
				quest::faction(1381, $change_amount);
			}
			elsif ($text=~/\b1382\b/) {	#:: Faction1382
				quest::faction(1382, $change_amount);
			}
			elsif ($text=~/\b1383\b/) {	#:: Faction1383
				quest::faction(1383, $change_amount);
			}
			elsif ($text=~/\b1384\b/) {	#:: Faction1384
				quest::faction(1384, $change_amount);
			}
			elsif ($text=~/\b1385\b/) {	#:: Faction1385
				quest::faction(1385, $change_amount);
			}
			elsif ($text=~/\b1386\b/) {	#:: Faction1386
				quest::faction(1386, $change_amount);
			}
			elsif ($text=~/\b1387\b/) {	#:: Faction1387
				quest::faction(1387, $change_amount);
			}
			elsif ($text=~/\b1388\b/) {	#:: Faction1388
				quest::faction(1388, $change_amount);
			}
			elsif ($text=~/\b1389\b/) {	#:: Faction1389
				quest::faction(1389, $change_amount);
			}
			elsif ($text=~/\b1390\b/) {	#:: Faction1390
				quest::faction(1390, $change_amount);
			}
			elsif ($text=~/\b1391\b/) {	#:: Faction1391
				quest::faction(1391, $change_amount);
			}
			elsif ($text=~/\b1392\b/) {	#:: Faction1392
				quest::faction(1392, $change_amount);
			}
			elsif ($text=~/\b1393\b/) {	#:: Faction1393
				quest::faction(1393, $change_amount);
			}
			elsif ($text=~/\b1394\b/) {	#:: Faction1394
				quest::faction(1394, $change_amount);
			}
			elsif ($text=~/\b1395\b/) {	#:: Faction1395
				quest::faction(1395, $change_amount);
			}
			elsif ($text=~/\b1396\b/) {	#:: Faction1396
				quest::faction(1396, $change_amount);
			}
			elsif ($text=~/\b1397\b/) {	#:: Faction1397
				quest::faction(1397, $change_amount);
			}
			elsif ($text=~/\b1398\b/) {	#:: Faction1398
				quest::faction(1398, $change_amount);
			}
			elsif ($text=~/\b1399\b/) {	#:: Faction1399
				quest::faction(1399, $change_amount);
			}
			elsif ($text=~/\b1400\b/) {	#:: Faction1400
				quest::faction(1400, $change_amount);
			}
			elsif ($text=~/\b1401\b/) {	#:: Faction1401
				quest::faction(1401, $change_amount);
			}
			elsif ($text=~/\b1402\b/) {	#:: Faction1402
				quest::faction(1402, $change_amount);
			}
			elsif ($text=~/\b1403\b/) {	#:: Faction1403
				quest::faction(1403, $change_amount);
			}
			elsif ($text=~/\b1404\b/) {	#:: Faction1404
				quest::faction(1404, $change_amount);
			}
			elsif ($text=~/\b1405\b/) {	#:: Faction1405
				quest::faction(1405, $change_amount);
			}
			elsif ($text=~/\b1406\b/) {	#:: Faction1406
				quest::faction(1406, $change_amount);
			}
			elsif ($text=~/\b1407\b/) {	#:: Faction1407
				quest::faction(1407, $change_amount);
			}
			elsif ($text=~/\b1408\b/) {	#:: Faction1408
				quest::faction(1408, $change_amount);
			}
			elsif ($text=~/\b1409\b/) {	#:: Faction1409
				quest::faction(1409, $change_amount);
			}
			elsif ($text=~/\b1410\b/) {	#:: Faction1410
				quest::faction(1410, $change_amount);
			}
			elsif ($text=~/\b1411\b/) {	#:: Faction1411
				quest::faction(1411, $change_amount);
			}
			elsif ($text=~/\b1412\b/) {	#:: Faction1412
				quest::faction(1412, $change_amount);
			}
			elsif ($text=~/\b1413\b/) {	#:: Faction1413
				quest::faction(1413, $change_amount);
			}
			elsif ($text=~/\b1414\b/) {	#:: Faction1414
				quest::faction(1414, $change_amount);
			}
			elsif ($text=~/\b1415\b/) {	#:: Faction1415
				quest::faction(1415, $change_amount);
			}
			elsif ($text=~/\b1416\b/) {	#:: Faction1416
				quest::faction(1416, $change_amount);
			}
			elsif ($text=~/\b1417\b/) {	#:: Faction1417
				quest::faction(1417, $change_amount);
			}
			elsif ($text=~/\b1418\b/) {	#:: Faction1418
				quest::faction(1418, $change_amount);
			}
			elsif ($text=~/\b1419\b/) {	#:: Faction1419
				quest::faction(1419, $change_amount);
			}
			elsif ($text=~/\b1420\b/) {	#:: Faction1420
				quest::faction(1420, $change_amount);
			}
			elsif ($text=~/\b1421\b/) {	#:: Faction1421
				quest::faction(1421, $change_amount);
			}
			elsif ($text=~/\b1422\b/) {	#:: Faction1422
				quest::faction(1422, $change_amount);
			}
			elsif ($text=~/\b1423\b/) {	#:: Faction1423
				quest::faction(1423, $change_amount);
			}
			elsif ($text=~/\b1424\b/) {	#:: Faction1424
				quest::faction(1424, $change_amount);
			}
			elsif ($text=~/\b1425\b/) {	#:: Faction1425
				quest::faction(1425, $change_amount);
			}
			elsif ($text=~/\b1426\b/) {	#:: Faction1426
				quest::faction(1426, $change_amount);
			}
			elsif ($text=~/\b1427\b/) {	#:: Faction1427
				quest::faction(1427, $change_amount);
			}
			elsif ($text=~/\b1428\b/) {	#:: Faction1428
				quest::faction(1428, $change_amount);
			}
			elsif ($text=~/\b1429\b/) {	#:: Faction1429
				quest::faction(1429, $change_amount);
			}
			elsif ($text=~/\b1430\b/) {	#:: Faction1430
				quest::faction(1430, $change_amount);
			}
			elsif ($text=~/\b1431\b/) {	#:: Faction1431
				quest::faction(1431, $change_amount);
			}
			elsif ($text=~/\b1432\b/) {	#:: Faction1432
				quest::faction(1432, $change_amount);
			}
			elsif ($text=~/\b1433\b/) {	#:: Faction1433
				quest::faction(1433, $change_amount);
			}
			elsif ($text=~/\b1434\b/) {	#:: Faction1434
				quest::faction(1434, $change_amount);
			}
			elsif ($text=~/\b1435\b/) {	#:: Faction1435
				quest::faction(1435, $change_amount);
			}
			elsif ($text=~/\b1436\b/) {	#:: Faction1436
				quest::faction(1436, $change_amount);
			}
			elsif ($text=~/\b1437\b/) {	#:: Faction1437
				quest::faction(1437, $change_amount);
			}
			elsif ($text=~/\b1438\b/) {	#:: Faction1438
				quest::faction(1438, $change_amount);
			}
			elsif ($text=~/\b1439\b/) {	#:: Faction1439
				quest::faction(1439, $change_amount);
			}
			elsif ($text=~/\b1440\b/) {	#:: Faction1440
				quest::faction(1440, $change_amount);
			}
			elsif ($text=~/\b1441\b/) {	#:: Faction1441
				quest::faction(1441, $change_amount);
			}
			elsif ($text=~/\b1442\b/) {	#:: Faction1442
				quest::faction(1442, $change_amount);
			}
			elsif ($text=~/\b1443\b/) {	#:: Faction1443
				quest::faction(1443, $change_amount);
			}
			elsif ($text=~/\b1444\b/) {	#:: Faction1444
				quest::faction(1444, $change_amount);
			}
			elsif ($text=~/\b1445\b/) {	#:: Faction1445
				quest::faction(1445, $change_amount);
			}
			elsif ($text=~/\b1446\b/) {	#:: Faction1446
				quest::faction(1446, $change_amount);
			}
			elsif ($text=~/\b1447\b/) {	#:: Faction1447
				quest::faction(1447, $change_amount);
			}
			elsif ($text=~/\b1448\b/) {	#:: Faction1448
				quest::faction(1448, $change_amount);
			}
			elsif ($text=~/\b1449\b/) {	#:: Faction1449
				quest::faction(1449, $change_amount);
			}
			elsif ($text=~/\b1450\b/) {	#:: Faction1450
				quest::faction(1450, $change_amount);
			}
			elsif ($text=~/\b1451\b/) {	#:: Faction1451
				quest::faction(1451, $change_amount);
			}
			elsif ($text=~/\b1452\b/) {	#:: Faction1452
				quest::faction(1452, $change_amount);
			}
			elsif ($text=~/\b1453\b/) {	#:: Faction1453
				quest::faction(1453, $change_amount);
			}
			elsif ($text=~/\b1454\b/) {	#:: Faction1454
				quest::faction(1454, $change_amount);
			}
			elsif ($text=~/\b1455\b/) {	#:: Faction1455
				quest::faction(1455, $change_amount);
			}
			elsif ($text=~/\b1456\b/) {	#:: Faction1456
				quest::faction(1456, $change_amount);
			}
			elsif ($text=~/\b1457\b/) {	#:: Faction1457
				quest::faction(1457, $change_amount);
			}
			elsif ($text=~/\b1458\b/) {	#:: Faction1458
				quest::faction(1458, $change_amount);
			}
			elsif ($text=~/\b1459\b/) {	#:: Faction1459
				quest::faction(1459, $change_amount);
			}
			elsif ($text=~/\b1460\b/) {	#:: Faction1460
				quest::faction(1460, $change_amount);
			}
			elsif ($text=~/\b1461\b/) {	#:: Faction1461
				quest::faction(1461, $change_amount);
			}
			elsif ($text=~/\b1462\b/) {	#:: Faction1462
				quest::faction(1462, $change_amount);
			}
			elsif ($text=~/\b1463\b/) {	#:: Faction1463
				quest::faction(1463, $change_amount);
			}
			elsif ($text=~/\b1464\b/) {	#:: Faction1464
				quest::faction(1464, $change_amount);
			}
			elsif ($text=~/\b1465\b/) {	#:: Faction1465
				quest::faction(1465, $change_amount);
			}
			elsif ($text=~/\b1466\b/) {	#:: Faction1466
				quest::faction(1466, $change_amount);
			}
			elsif ($text=~/\b1467\b/) {	#:: Faction1467
				quest::faction(1467, $change_amount);
			}
			elsif ($text=~/\b1468\b/) {	#:: Faction1468
				quest::faction(1468, $change_amount);
			}
			elsif ($text=~/\b1469\b/) {	#:: Faction1469
				quest::faction(1469, $change_amount);
			}
			elsif ($text=~/\b1470\b/) {	#:: Faction1470
				quest::faction(1470, $change_amount);
			}
			elsif ($text=~/\b1471\b/) {	#:: Faction1471
				quest::faction(1471, $change_amount);
			}
			elsif ($text=~/\b1472\b/) {	#:: Faction1472
				quest::faction(1472, $change_amount);
			}
			elsif ($text=~/\b1473\b/) {	#:: Faction1473
				quest::faction(1473, $change_amount);
			}
			elsif ($text=~/\b1474\b/) {	#:: Faction1474
				quest::faction(1474, $change_amount);
			}
			elsif ($text=~/\b1475\b/) {	#:: Faction1475
				quest::faction(1475, $change_amount);
			}
			elsif ($text=~/\b1476\b/) {	#:: Faction1476
				quest::faction(1476, $change_amount);
			}
			elsif ($text=~/\b1477\b/) {	#:: Faction1477
				quest::faction(1477, $change_amount);
			}
			elsif ($text=~/\b1478\b/) {	#:: Faction1478
				quest::faction(1478, $change_amount);
			}
			elsif ($text=~/\b1479\b/) {	#:: Faction1479
				quest::faction(1479, $change_amount);
			}
			elsif ($text=~/\b1480\b/) {	#:: Faction1480
				quest::faction(1480, $change_amount);
			}
			elsif ($text=~/\b1481\b/) {	#:: Faction1481
				quest::faction(1481, $change_amount);
			}
			elsif ($text=~/\b1482\b/) {	#:: Faction1482
				quest::faction(1482, $change_amount);
			}
			elsif ($text=~/\b1483\b/) {	#:: Seru
				quest::faction(1483, $change_amount);
			}
			elsif ($text=~/\b1484\b/) {	#:: Hand of Seru
				quest::faction(1484, $change_amount);
			}
			elsif ($text=~/\b1485\b/) {	#:: Eye of Seru
				quest::faction(1485, $change_amount);
			}
			elsif ($text=~/\b1486\b/) {	#:: Heart of Seru
				quest::faction(1486, $change_amount);
			}
			elsif ($text=~/\b1487\b/) {	#:: Shoulders of Seru
				quest::faction(1487, $change_amount);
			}
			elsif ($text=~/\b1488\b/) {	#:: The Recuso
				quest::faction(1488, $change_amount);
			}
			elsif ($text=~/\b1489\b/) {	#:: Gladiators and Slaves of Sanctus Seru
				quest::faction(1489, $change_amount);
			}
			elsif ($text=~/\b1490\b/) {	#:: Grimlings of the Moor
				quest::faction(1490, $change_amount);
			}
			elsif ($text=~/\b1491\b/) {	#:: Sonic Wolves of the Moor
				quest::faction(1491, $change_amount);
			}
			elsif ($text=~/\b1492\b/) {	#:: Owlbears of the Moor
				quest::faction(1492, $change_amount);
			}
			elsif ($text=~/\b1493\b/) {	#:: Grimling Invaders
				quest::faction(1493, $change_amount);
			}
			elsif ($text=~/\b1494\b/) {	#:: Owlbear Invaders
				quest::faction(1494, $change_amount);
			}
			elsif ($text=~/\b1495\b/) {	#:: Sonic Wolf Invaders
				quest::faction(1495, $change_amount);
			}
			elsif ($text=~/\b1496\b/) {	#:: Grimling Defenders
				quest::faction(1496, $change_amount);
			}
			elsif ($text=~/\b1497\b/) {	#:: Owlbear Defenders
				quest::faction(1497, $change_amount);
			}
			elsif ($text=~/\b1498\b/) {	#:: Sonic Wolf Defenders
				quest::faction(1498, $change_amount);
			}
			elsif ($text=~/\b1499\b/) {	#:: Citizens of Seru
				quest::faction(1499, $change_amount);
			}
			elsif ($text=~/\b1500\b/) {	#:: Gor Taku
				quest::faction(1500, $change_amount);
			}
			elsif ($text=~/\b1501\b/) {	#:: Shak Dratha
				quest::faction(1501, $change_amount);
			}
			elsif ($text=~/\b1502\b/) {	#:: Katta Castellum Citizens
				quest::faction(1502, $change_amount);
			}
			elsif ($text=~/\b1503\b/) {	#:: Validus Custodus
				quest::faction(1503, $change_amount);
			}
			elsif ($text=~/\b1504\b/) {	#:: Magus Conlegium
				quest::faction(1504, $change_amount);
			}
			elsif ($text=~/\b1505\b/) {	#:: Nathyn Illuminious
				quest::faction(1505, $change_amount);
			}
			elsif ($text=~/\b1506\b/) {	#:: Coterie of the Eternal Night
				quest::faction(1506, $change_amount);
			}
			elsif ($text=~/\b1507\b/) {	#:: Valdanov Zevfeer
				quest::faction(1507, $change_amount);
			}
			elsif ($text=~/\b1508\b/) {	#:: Traders of the Haven
				quest::faction(1508, $change_amount);
			}
			elsif ($text=~/\b1509\b/) {	#:: Haven Defenders
				quest::faction(1509, $change_amount);
			}
			elsif ($text=~/\b1510\b/) {	#:: House of Fordel
				quest::faction(1510, $change_amount);
			}
			elsif ($text=~/\b1511\b/) {	#:: House of Midst
				quest::faction(1511, $change_amount);
			}
			elsif ($text=~/\b1512\b/) {	#:: House of Stout
				quest::faction(1512, $change_amount);
			}
			elsif ($text=~/\b1513\b/) {	#:: Guardians of Shar Vahl
				quest::faction(1513, $change_amount);
			}
			elsif ($text=~/\b1514\b/) {	#:: Testfaction
				quest::faction(1514, $change_amount);
			}
			elsif ($text=~/\b1515\b/) {	#:: Dark Forest Denizens
				quest::faction(1515, $change_amount);
			}
			elsif ($text=~/\b1516\b/) {	#:: Grimlings of the Forest
				quest::faction(1516, $change_amount);
			}
			elsif ($text=~/\b1517\b/) {	#:: Deepwood Owlbears
				quest::faction(1517, $change_amount);
			}
			elsif ($text=~/\b1518\b/) {	#:: Pack of the Great Moon
				quest::faction(1518, $change_amount);
			}
			elsif ($text=~/\b1519\b/) {	#:: Lodikai
				quest::faction(1519, $change_amount);
			}
			elsif ($text=~/\b1520\b/) {	#:: Whisperling
				quest::faction(1520, $change_amount);
			}
			elsif ($text=~/\b1521\b/) {	#:: Akheva
				quest::faction(1521, $change_amount);
			}
			elsif ($text=~/\b1522\b/) {	#:: Primordial Malice
				quest::faction(1522, $change_amount);
			}
			elsif ($text=~/\b1523\b/) {	#:: Feast of the Burrowers
				quest::faction(1523, $change_amount);
			}
			elsif ($text=~/\b1524\b/) {	#:: Johanius Barleou
				quest::faction(1524, $change_amount);
			}
			elsif ($text=~/\b1525\b/) {	#:: Coterie Elite
				quest::faction(1525, $change_amount);
			}
			elsif ($text=~/\b1526\b/) {	#:: Old Disciples of Kerafyrm
				quest::faction(1526, $change_amount);
			}
			elsif ($text=~/\b1527\b/) {	#:: Spire Spirits
				quest::faction(1527, $change_amount);
			}
			elsif ($text=~/\b1528\b/) {	#:: Thought Leeches
				quest::faction(1528, $change_amount);
			}
			elsif ($text=~/\b1529\b/) {	#:: Khala Dun
				quest::faction(1529, $change_amount);
			}
			elsif ($text=~/\b1530\b/) {	#:: Taruun
				quest::faction(1530, $change_amount);
			}
			elsif ($text=~/\b1531\b/) {	#:: Jharin
				quest::faction(1531, $change_amount);
			}
			elsif ($text=~/\b1532\b/) {	#:: Khati Sha
				quest::faction(1532, $change_amount);
			}
			elsif ($text=~/\b1533\b/) {	#:: Dar Khura
				quest::faction(1533, $change_amount);
			}
			elsif ($text=~/\b1534\b/) {	#:: Luclin Monsters
				quest::faction(1534, $change_amount);
			}
			elsif ($text=~/\b1535\b/) {	#:: Brood of Ssraeshza
				quest::faction(1535, $change_amount);
			}
			elsif ($text=~/\b1536\b/) {	#:: Emperor Ssraeshza
				quest::faction(1536, $change_amount);
			}
			elsif ($text=~/\b1537\b/) {	#:: Iksar Temple Slaves
				quest::faction(1537, $change_amount);
			}
			elsif ($text=~/\b1538\b/) {	#:: Spirits of Katta Castellum
				quest::faction(1538, $change_amount);
			}
			elsif ($text=~/\b1539\b/) {	#:: Netherbians
				quest::faction(1539, $change_amount);
			}
			elsif ($text=~/\b1540\b/) {	#:: Troglodytes
				quest::faction(1540, $change_amount);
			}
			elsif ($text=~/\b1541\b/) {	#:: Hand Legionnaries
				quest::faction(1541, $change_amount);
			}
			elsif ($text=~/\b1542\b/) {	#:: Haven Smugglers
				quest::faction(1542, $change_amount);
			}
			elsif ($text=~/\b1543\b/) {	#:: Servants of Aero
				quest::faction(1543, $change_amount);
			}
			elsif ($text=~/\b1544\b/) {	#:: Servants of Terra
				quest::faction(1544, $change_amount);
			}
			elsif ($text=~/\b1545\b/) {	#:: Servants of Inferno
				quest::faction(1545, $change_amount);
			}
			elsif ($text=~/\b1546\b/) {	#:: Servants of Hydro
				quest::faction(1546, $change_amount);
			}
			elsif ($text=~/\b1547\b/) {	#:: Vornol Transon
				quest::faction(1547, $change_amount);
			}
			elsif ($text=~/\b1548\b/) {	#:: The Vas Ren Clan
				quest::faction(1548, $change_amount);
			}
			elsif ($text=~/\b1549\b/) {	#:: The Grol Baku Clan
				quest::faction(1549, $change_amount);
			}
			elsif ($text=~/\b1550\b/) {	#:: The Cral Ligi Clan
				quest::faction(1550, $change_amount);
			}
			elsif ($text=~/\b1551\b/) {	#:: The Tro Jeg Clan
				quest::faction(1551, $change_amount);
			}
			elsif ($text=~/\b1552\b/) {	#:: Vah Shir Crusaders
				quest::faction(1552, $change_amount);
			}
			elsif ($text=~/\b1553\b/) {	#:: Netherbian Ambush
				quest::faction(1553, $change_amount);
			}
			elsif ($text=~/\b1554\b/) {	#:: Netherbian Caravan
				quest::faction(1554, $change_amount);
			}
			elsif ($text=~/\b1555\b/) {	#:: Grieg
				quest::faction(1555, $change_amount);
			}
			elsif ($text=~/\b1556\b/) {	#:: Luclin
				quest::faction(1556, $change_amount);
			}
			elsif ($text=~/\b1557\b/) {	#:: Dark Sendings
				quest::faction(1557, $change_amount);
			}
			elsif ($text=~/\b1558\b/) {	#:: Grimling Captives
				quest::faction(1558, $change_amount);
			}
			elsif ($text=~/\b1559\b/) {	#:: Lake Recondite Bandits
				quest::faction(1559, $change_amount);
			}
			elsif ($text=~/\b1560\b/) {	#:: Kanaad
				quest::faction(1560, $change_amount);
			}
			elsif ($text=~/\b1561\b/) {	#:: Concilium Universus
				quest::faction(1561, $change_amount);
			}
			elsif ($text=~/\b1562\b/) {	#:: Disciples of Rhag`Zadune
				quest::faction(1562, $change_amount);
			}
			elsif ($text=~/\b1563\b/) {	#:: The Sambata Tribe
				quest::faction(1563, $change_amount);
			}
			elsif ($text=~/\b1564\b/) {	#:: Dawnhoppers
				quest::faction(1564, $change_amount);
			}
			elsif ($text=~/\b1565\b/) {	#:: Tarmok Tribe
				quest::faction(1565, $change_amount);
			}
			elsif ($text=~/\b1566\b/) {	#:: Netok Tribe
				quest::faction(1566, $change_amount);
			}
			elsif ($text=~/\b1567\b/) {	#:: Katta Traitors
				quest::faction(1567, $change_amount);
			}
			elsif ($text=~/\b1568\b/) {	#:: Deepshade Collective
				quest::faction(1568, $change_amount);
			}
			elsif ($text=~/\b1569\b/) {	#:: Deklean Korgad
				quest::faction(1569, $change_amount);
			}
			elsif ($text=~/\b1570\b/) {	#:: Order of Autarkic Umbrage
				quest::faction(1570, $change_amount);
			}
			elsif ($text=~/\b1571\b/) {	#:: Shei Vinitras
				quest::faction(1571, $change_amount);
			}
			elsif ($text=~/\b1572\b/) {	#:: Anti Vinitras
				quest::faction(1572, $change_amount);
			}
			elsif ($text=~/\b1573\b/) {	#:: The Bloodtribe
				quest::faction(1573, $change_amount);
			}
			elsif ($text=~/\b1574\b/) {	#:: Minions of the Sunlord
				quest::faction(1574, $change_amount);
			}
			elsif ($text=~/\b1575\b/) {	#:: Imps
				quest::faction(1575, $change_amount);
			}
			elsif ($text=~/\b1576\b/) {	#:: Kingdom of Above and Below
				quest::faction(1576, $change_amount);
			}
			elsif ($text=~/\b1577\b/) {	#:: The Truth
				quest::faction(1577, $change_amount);
			}
			elsif ($text=~/\b1578\b/) {	#:: Deklean Korgad
				quest::faction(1578, $change_amount);
			}
			elsif ($text=~/\b1579\b/) {	#:: Droga Goblins
				quest::faction(1579, $change_amount);
			}
			elsif ($text=~/\b1580\b/) {	#:: Nurga Goblins
				quest::faction(1580, $change_amount);
			}
			elsif ($text=~/\b1581\b/) {	#:: Luclin Friendly Monsters
				quest::faction(1581, $change_amount);
			}
			elsif ($text=~/\b1582\b/) {	#:: Outcasts and Mutants
				quest::faction(1582, $change_amount);
			}
			elsif ($text=~/\b1583\b/) {	#:: Cult of the Great Saprophyte
				quest::faction(1583, $change_amount);
			}
			elsif ($text=~/\b1584\b/) {	#:: Citizens of Shar Vahl
				quest::faction(1584, $change_amount);
			}
			elsif ($text=~/\b1585\b/) {	#:: Fiends of the Grove
				quest::faction(1585, $change_amount);
			}
			elsif ($text=~/\b1586\b/) {	#:: Savage Spirit
				quest::faction(1586, $change_amount);
			}
			elsif ($text=~/\b1587\b/) {	#:: Zordak Ragefire
				quest::faction(1587, $change_amount);
			}
			elsif ($text=~/\b1588\b/) {	#:: Captain Cruikshanks
				quest::faction(1588, $change_amount);
			}
			elsif ($text=~/\b1589\b/) {	#:: Scourge
				quest::faction(1589, $change_amount);
			}
			elsif ($text=~/\b1590\b/) {	#:: Captain Stottal
				quest::faction(1590, $change_amount);
			}
			elsif ($text=~/\b1591\b/) {	#:: Captain Smythe
				quest::faction(1591, $change_amount);
			}
			elsif ($text=~/\b1592\b/) {	#:: Captain Dorian Dulein
				quest::faction(1592, $change_amount);
			}
			elsif ($text=~/\b1593\b/) {	#:: Frogloks of Krup
				quest::faction(1593, $change_amount);
			}
			elsif ($text=~/\b1594\b/) {	#:: Cult of the Arisen
				quest::faction(1594, $change_amount);
			}
			elsif ($text=~/\b1595\b/) {	#:: New Alliance of Stone
				quest::faction(1595, $change_amount);
			}
			elsif ($text=~/\b1596\b/) {	#:: Idelia the Serene
				quest::faction(1596, $change_amount);
			}
			elsif ($text=~/\b1597\b/) {	#:: Residents of Jaggedpine
				quest::faction(1597, $change_amount);
			}
			elsif ($text=~/\b1598\b/) {	#:: Anchorites of Brell Serilis
				quest::faction(1598, $change_amount);
			}
			elsif ($text=~/\b1599\b/) {	#:: Darkpaws of Jaggedpine
				quest::faction(1599, $change_amount);
			}
			elsif ($text=~/\b1600\b/) {	#:: Guardians of the Hatchling
				quest::faction(1600, $change_amount);
			}
			elsif ($text=~/\b1601\b/) {	#:: Pirates of the Pine
				quest::faction(1601, $change_amount);
			}
			elsif ($text=~/\b1602\b/) {	#:: Critters of Jaggedpine
				quest::faction(1602, $change_amount);
			}
			elsif ($text=~/\b1603\b/) {	#:: Dryads of the Grove
				quest::faction(1603, $change_amount);
			}
			elsif ($text=~/\b1604\b/) {	#:: Clan Grikbar
				quest::faction(1604, $change_amount);
			}
			elsif ($text=~/\b1605\b/) {	#:: Haven Smuggler Associates
				quest::faction(1605, $change_amount);
			}
			elsif ($text=~/\b1606\b/) {	#:: KOS to Beta Neutral
				quest::faction(1606, $change_amount);
			}
			elsif ($text=~/\b1607\b/) {	#:: Plague Bringer
				quest::faction(1607, $change_amount);
			}
			elsif ($text=~/\b1608\b/) {	#:: Spirits of Lxanvom
				quest::faction(1608, $change_amount);
			}
			elsif ($text=~/\b1609\b/) {	#:: Askr the Lost
				quest::faction(1609, $change_amount);
			}
			elsif ($text=~/\b1610\b/) {	#:: Greater Jord Giants
				quest::faction(1610, $change_amount);
			}
			elsif ($text=~/\b1611\b/) {	#:: Greater Brann Giants
				quest::faction(1611, $change_amount);
			}
			elsif ($text=~/\b1612\b/) {	#:: Greater Vind Giants
				quest::faction(1612, $change_amount);
			}
			elsif ($text=~/\b1613\b/) {	#:: Greater Vann Giants
				quest::faction(1613, $change_amount);
			}
			elsif ($text=~/\b1614\b/) {	#:: Lesser Jord Giants
				quest::faction(1614, $change_amount);
			}
			elsif ($text=~/\b1615\b/) {	#:: Lesser Brann Giants
				quest::faction(1615, $change_amount);
			}
			elsif ($text=~/\b1616\b/) {	#:: Lesser Vind Giants
				quest::faction(1616, $change_amount);
			}
			elsif ($text=~/\b1617\b/) {	#:: Lesser Vann Giants
				quest::faction(1617, $change_amount);
			}
			elsif ($text=~/\b1618\b/) {	#:: Storm Guardians
				quest::faction(1618, $change_amount);
			}
			elsif ($text=~/\b1619\b/) {	#:: The Rainkeeper
				quest::faction(1619, $change_amount);
			}
			elsif ($text=~/\b1620\b/) {	#:: Treants of Jaggedpine
				quest::faction(1620, $change_amount);
			}
			elsif ($text=~/\b1621\b/) {	#:: Agnarr
				quest::faction(1621, $change_amount);
			}
			elsif ($text=~/\b1622\b/) {	#:: Arboreans of the Faydark
				quest::faction(1622, $change_amount);
			}
			elsif ($text=~/\b1623\b/) {	#:: Disciples of Kerafyrm
				quest::faction(1623, $change_amount);
			}
			elsif ($text=~/\b1624\b/) {	#:: Servants of Saryrn
				quest::faction(1624, $change_amount);
			}
			elsif ($text=~/\b1625\b/) {	#:: Guardians of Justice
				quest::faction(1625, $change_amount);
			}
			elsif ($text=~/\b1626\b/) {	#:: Jacosh Steldenn
				quest::faction(1626, $change_amount);
			}
			elsif ($text=~/\b1627\b/) {	#:: Prisoners of Justice
				quest::faction(1627, $change_amount);
			}
			elsif ($text=~/\b1628\b/) {	#:: Creatures of Justice
				quest::faction(1628, $change_amount);
			}
			elsif ($text=~/\b1629\b/) {	#:: Gralloks
				quest::faction(1629, $change_amount);
			}
			elsif ($text=~/\b1630\b/) {	#:: Burning Dead
				quest::faction(1630, $change_amount);
			}
			elsif ($text=~/\b1631\b/) {	#:: KOS All PC And Beta Neutral
				quest::faction(1631, $change_amount);
			}
			elsif ($text=~/\b1632\b/) {	#:: Denizens of Water
				quest::faction(1632, $change_amount);
			}
			elsif ($text=~/\b1633\b/) {	#:: Minions of Coirnav
				quest::faction(1633, $change_amount);
			}
			elsif ($text=~/\b1634\b/) {	#:: Fish Lords
				quest::faction(1634, $change_amount);
			}
			elsif ($text=~/\b1635\b/) {	#:: Dwellers of the Deep
				quest::faction(1635, $change_amount);
			}
			elsif ($text=~/\b1636\b/) {	#:: Inhabitants of Tanaan
				quest::faction(1636, $change_amount);
			}
			elsif ($text=~/\b1637\b/) {	#:: Truespirit Companion
				quest::faction(1637, $change_amount);
			}
			elsif ($text=~/\b1638\b/) {	#:: Rallos Zek, The Warlord
				quest::faction(1638, $change_amount);
			}
			elsif ($text=~/\b1639\b/) {	#:: Tallon Zek
				quest::faction(1639, $change_amount);
			}
			elsif ($text=~/\b1640\b/) {	#:: Vallon Zek
				quest::faction(1640, $change_amount);
			}
			elsif ($text=~/\b1641\b/) {	#:: Eriak
				quest::faction(1641, $change_amount);
			}
			elsif ($text=~/\b1642\b/) {	#:: The Damned of Narikor
				quest::faction(1642, $change_amount);
			}
			elsif ($text=~/\b1643\b/) {	#:: The Diaku
				quest::faction(1643, $change_amount);
			}
			elsif ($text=~/\b1644\b/) {	#:: The Gindan
				quest::faction(1644, $change_amount);
			}
			elsif ($text=~/\b1645\b/) {	#:: The Hendin
				quest::faction(1645, $change_amount);
			}
			elsif ($text=~/\b1646\b/) {	#:: The Decorus
				quest::faction(1646, $change_amount);
			}
			elsif ($text=~/\b1647\b/) {	#:: Gladiators of Drunder
				quest::faction(1647, $change_amount);
			}
			elsif ($text=~/\b1648\b/) {	#:: Denizens of Fire
				quest::faction(1648, $change_amount);
			}
			elsif ($text=~/\b1649\b/) {	#:: Minions of Fennin Ro
				quest::faction(1649, $change_amount);
			}
			elsif ($text=~/\b1650\b/) {	#:: Inhabitants of Tranquility
				quest::faction(1650, $change_amount);
			}
			elsif ($text=~/\b1651\b/) {	#:: Victim of Torment
				quest::faction(1651, $change_amount);
			}
			elsif ($text=~/\b1652\b/) {	#:: Stampeding War Boar
				quest::faction(1652, $change_amount);
			}
			elsif ($text=~/\b1653\b/) {	#:: War Boar Piglet
				quest::faction(1653, $change_amount);
			}
			elsif ($text=~/\b1654\b/) {	#:: Inhabitants of Disease
				quest::faction(1654, $change_amount);
			}
			elsif ($text=~/\b1655\b/) {	#:: Inhabitants of Valor
				quest::faction(1655, $change_amount);
			}
			elsif ($text=~/\b1656\b/) {	#:: Battalion of Marr
				quest::faction(1656, $change_amount);
			}
			elsif ($text=~/\b1657\b/) {	#:: Rats of Justice
				quest::faction(1657, $change_amount);
			}
			elsif ($text=~/\b1658\b/) {	#:: Denizens of Storm
				quest::faction(1658, $change_amount);
			}
			elsif ($text=~/\b1659\b/) {	#:: Lost Kingdom of Lok
				quest::faction(1659, $change_amount);
			}
			elsif ($text=~/\b1660\b/) {	#:: Koka'Vor Tribe
				quest::faction(1660, $change_amount);
			}
			elsif ($text=~/\b1661\b/) {	#:: Inhabitants of Air
				quest::faction(1661, $change_amount);
			}
			elsif ($text=~/\b1662\b/) {	#:: Guardians of the Living Earth
				quest::faction(1662, $change_amount);
			}
			elsif ($text=~/\b1663\b/) {	#:: The Protectorate of the Twelve
				quest::faction(1663, $change_amount);
			}
			elsif ($text=~/\b1664\b/) {	#:: Eino
				quest::faction(1664, $change_amount);
			}
			elsif ($text=~/\b1665\b/) {	#:: Frogloks of Sebilis
				quest::faction(1665, $change_amount);
			}
			elsif ($text=~/\b1666\b/) {	#:: Frogloks of Ykesha
				quest::faction(1666, $change_amount);
			}
			elsif ($text=~/\b1667\b/) {	#:: Fallen Follies of Mischief
				quest::faction(1667, $change_amount);
			}
			elsif ($text=~/\b1668\b/) {	#:: Lhranc the Disgraced
				quest::faction(1668, $change_amount);
			}
			elsif ($text=~/\b1669\b/) {	#:: Minions of Enmity
				quest::faction(1669, $change_amount);
			}
			elsif ($text=~/\b1670\b/) {	#:: Minions of Hope
				quest::faction(1670, $change_amount);
			}
			elsif ($text=~/\b1671\b/) {	#:: Agents of the Pillars
				quest::faction(1671, $change_amount);
			}
			elsif ($text=~/\b1672\b/) {	#:: Friends of Zordak Ragefire
				quest::faction(1672, $change_amount);
			}
			elsif ($text=~/\b1673\b/) {	#:: Enemies of Zordak Ragefire
				quest::faction(1673, $change_amount);
			}
			elsif ($text=~/\b1674\b/) {	#:: Kyle Bayle
				quest::faction(1674, $change_amount);
			}
			elsif ($text=~/\b1675\b/) {	#:: Kyle Bayle's Royal Guard
				quest::faction(1675, $change_amount);
			}
			elsif ($text=~/\b1676\b/) {	#:: Hills Revenant
				quest::faction(1676, $change_amount);
			}
			elsif ($text=~/\b1677\b/) {	#:: Dead Hills Archaeologists
				quest::faction(1677, $change_amount);
			}
			elsif ($text=~/\b1678\b/) {	#:: Xulous of the Dead Hills
				quest::faction(1678, $change_amount);
			}
			elsif ($text=~/\b1679\b/) {	#:: The Kromtus
				quest::faction(1679, $change_amount);
			}
			elsif ($text=~/\b1680\b/) {	#:: Bloodfeather Aviaks
				quest::faction(1680, $change_amount);
			}
			elsif ($text=~/\b1681\b/) {	#:: The Thaell Ew
				quest::faction(1681, $change_amount);
			}
			elsif ($text=~/\b1682\b/) {	#:: Faction1682
				quest::faction(1682, $change_amount);
			}
			elsif ($text=~/\b1683\b/) {	#:: Faction1683
				quest::faction(1683, $change_amount);
			}
			elsif ($text=~/\b1684\b/) {	#:: Faction1684
				quest::faction(1684, $change_amount);
			}
			elsif ($text=~/\b1685\b/) {	#:: Faction1685
				quest::faction(1685, $change_amount);
			}
			elsif ($text=~/\b1686\b/) {	#:: Faction1686
				quest::faction(1686, $change_amount);
			}
			elsif ($text=~/\b1687\b/) {	#:: Faction1687
				quest::faction(1687, $change_amount);
			}
			elsif ($text=~/\b1688\b/) {	#:: Faction1688
				quest::faction(1688, $change_amount);
			}
			elsif ($text=~/\b1689\b/) {	#:: Faction1689
				quest::faction(1689, $change_amount);
			}
			elsif ($text=~/\b1690\b/) {	#:: Faction1690
				quest::faction(1690, $change_amount);
			}
			elsif ($text=~/\b1691\b/) {	#:: Faction1691
				quest::faction(1691, $change_amount);
			}
			elsif ($text=~/\b1692\b/) {	#:: Faction1692
				quest::faction(1692, $change_amount);
			}
			elsif ($text=~/\b1693\b/) {	#:: Faction1693
				quest::faction(1693, $change_amount);
			}
			elsif ($text=~/\b1694\b/) {	#:: Faction1694
				quest::faction(1694, $change_amount);
			}
			elsif ($text=~/\b1695\b/) {	#:: Faction1695
				quest::faction(1695, $change_amount);
			}
			elsif ($text=~/\b1696\b/) {	#:: Faction1696
				quest::faction(1696, $change_amount);
			}
			elsif ($text=~/\b1697\b/) {	#:: Faction1697
				quest::faction(1697, $change_amount);
			}
			elsif ($text=~/\b1698\b/) {	#:: Faction1698
				quest::faction(1698, $change_amount);
			}
			elsif ($text=~/\b1699\b/) {	#:: Faction1699
				quest::faction(1699, $change_amount);
			}
			elsif ($text=~/\b1700\b/) {	#:: Torgiran
				quest::faction(1700, $change_amount);
			}
			elsif ($text=~/\b1701\b/) {	#:: Warlord Ngrub
				quest::faction(1701, $change_amount);
			}
			elsif ($text=~/\b1702\b/) {	#:: Resistance Miners
				quest::faction(1702, $change_amount);
			}
			elsif ($text=~/\b1703\b/) {	#:: Nadox Initiate
				quest::faction(1703, $change_amount);
			}
			elsif ($text=~/\b1704\b/) {	#:: Cursed Frogloks of Gukta
				quest::faction(1704, $change_amount);
			}
			elsif ($text=~/\b1705\b/) {	#:: Creatures of Gunthak
				quest::faction(1705, $change_amount);
			}
			elsif ($text=~/\b1706\b/) {	#:: Undead of Gunthak
				quest::faction(1706, $change_amount);
			}
			elsif ($text=~/\b1707\b/) {	#:: Residents of Gunthak
				quest::faction(1707, $change_amount);
			}
			elsif ($text=~/\b1708\b/) {	#:: Crew of the Scorned Maiden
				quest::faction(1708, $change_amount);
			}
			elsif ($text=~/\b1709\b/) {	#:: Protectors of Gukta
				quest::faction(1709, $change_amount);
			}
			elsif ($text=~/\b1710\b/) {	#:: Innothule Monster
				quest::faction(1710, $change_amount);
			}
			elsif ($text=~/\b1711\b/) {	#:: Clerics of Gutka
				quest::faction(1711, $change_amount);
			}
			elsif ($text=~/\b1712\b/) {	#:: Warriors of Gukta
				quest::faction(1712, $change_amount);
			}
			elsif ($text=~/\b1713\b/) {	#:: Paladins of Gukta
				quest::faction(1713, $change_amount);
			}
			elsif ($text=~/\b1714\b/) {	#:: Wizards of Gukta
				quest::faction(1714, $change_amount);
			}
			elsif ($text=~/\b1715\b/) {	#:: Shaman of Gukta
				quest::faction(1715, $change_amount);
			}
			elsif ($text=~/\b1716\b/) {	#:: High Council of Gukta
				quest::faction(1716, $change_amount);
			}
			elsif ($text=~/\b1717\b/) {	#:: Lorekeepers of Gukta
				quest::faction(1717, $change_amount);
			}
			elsif ($text=~/\b1718\b/) {	#:: Guktan Elders
				quest::faction(1718, $change_amount);
			}
			elsif ($text=~/\b1719\b/) {	#:: Citizens of Gukta
				quest::faction(1719, $change_amount);
			}
			elsif ($text=~/\b1720\b/) {	#:: Guktan Suppliers
				quest::faction(1720, $change_amount);
			}
			elsif ($text=~/\b1721\b/) {	#:: Troll Raiders
				quest::faction(1721, $change_amount);
			}
			elsif ($text=~/\b1722\b/) {	#:: Exiled Frogloks
				quest::faction(1722, $change_amount);
			}
			elsif ($text=~/\b1723\b/) {	#:: Grimling Bandits
				quest::faction(1723, $change_amount);
			}
			elsif ($text=~/\b1724\b/) {	#:: Newbie Monster
				quest::faction(1724, $change_amount);
			}
			elsif ($text=~/\b1725\b/) {	#:: Syrik Iceblood
				quest::faction(1725, $change_amount);
			}
			elsif ($text=~/\b1726\b/) {	#:: Inhabitants of Time
				quest::faction(1726, $change_amount);
			}
			elsif ($text=~/\b1727\b/) {	#:: City Vermin
				quest::faction(1727, $change_amount);
			}
			elsif ($text=~/\b1728\b/) {	#:: Betrayers of Di`Zok
				quest::faction(1728, $change_amount);
			}
			elsif ($text=~/\b1729\b/) {	#:: Followers of Korucust
				quest::faction(1729, $change_amount);
			}
			elsif ($text=~/\b1730\b/) {	#:: LDoNGood
				quest::faction(1730, $change_amount);
			}
			elsif ($text=~/\b1731\b/) {	#:: LDoNEvil
				quest::faction(1731, $change_amount);
			}
			elsif ($text=~/\b1732\b/) {	#:: Tribe Vrodak
				quest::faction(1732, $change_amount);
			}
			elsif ($text=~/\b1733\b/) {	#:: Witnesses of Hate
				quest::faction(1733, $change_amount);
			}
			elsif ($text=~/\b1734\b/) {	#:: Forgotten Guktan Spirits
				quest::faction(1734, $change_amount);
			}
			elsif ($text=~/\b1735\b/) {	#:: Innoruuk's Curse of the Cauldron
				quest::faction(1735, $change_amount);
			}
			elsif ($text=~/\b1736\b/) {	#:: Frostfoot Goblins
				quest::faction(1736, $change_amount);
			}
			elsif ($text=~/\b1737\b/) {	#:: Lost Minions of Miragul
				quest::faction(1737, $change_amount);
			}
			elsif ($text=~/\b1738\b/) {	#:: Planar Collective
				quest::faction(1738, $change_amount);
			}
			elsif ($text=~/\b1739\b/) {	#:: Synarcana
				quest::faction(1739, $change_amount);
			}
			elsif ($text=~/\b1740\b/) {	#:: Agents of the Synarcana
				quest::faction(1740, $change_amount);
			}
			elsif ($text=~/\b1741\b/) {	#:: Orphans
				quest::faction(1741, $change_amount);
			}
			elsif ($text=~/\b1742\b/) {	#:: Sustainers
				quest::faction(1742, $change_amount);
			}
			elsif ($text=~/\b1743\b/) {	#:: Loyals
				quest::faction(1743, $change_amount);
			}
			elsif ($text=~/\b1744\b/) {	#:: Progeny
				quest::faction(1744, $change_amount);
			}
			elsif ($text=~/\b1745\b/) {	#:: Rujarkian Slavers
				quest::faction(1745, $change_amount);
			}
			elsif ($text=~/\b1746\b/) {	#:: The Broken
				quest::faction(1746, $change_amount);
			}
			elsif ($text=~/\b1747\b/) {	#:: Steelcrown
				quest::faction(1747, $change_amount);
			}
			elsif ($text=~/\b1748\b/) {	#:: Spiritbound
				quest::faction(1748, $change_amount);
			}
			elsif ($text=~/\b1749\b/) {	#:: Steelslaves
				quest::faction(1749, $change_amount);
			}
			elsif ($text=~/\b1750\b/) {	#:: Citizens of Takish-Hiz
				quest::faction(1750, $change_amount);
			}
			elsif ($text=~/\b1751\b/) {	#:: Geomantic Compact
				quest::faction(1751, $change_amount);
			}
			elsif ($text=~/\b1752\b/) {	#:: Royal Attendants
				quest::faction(1752, $change_amount);
			}
			elsif ($text=~/\b1753\b/) {	#:: Flowkeepers
				quest::faction(1753, $change_amount);
			}
			elsif ($text=~/\b1754\b/) {	#:: Architects of Sand
				quest::faction(1754, $change_amount);
			}
			elsif ($text=~/\b1755\b/) {	#:: Sandworkers
				quest::faction(1755, $change_amount);
			}
			elsif ($text=~/\b1756\b/) {	#:: LDoN Hostages
				quest::faction(1756, $change_amount);
			}
			elsif ($text=~/\b1757\b/) {	#:: Servants of the First Witness
				quest::faction(1757, $change_amount);
			}
			elsif ($text=~/\b1758\b/) {	#:: Guktan Scouts
				quest::faction(1758, $change_amount);
			}
			elsif ($text=~/\b1759\b/) {	#:: Wayfarers Brotherhood
				quest::faction(1759, $change_amount);
			}
			elsif ($text=~/\b1760\b/) {	#:: Minions of Mischief
				quest::faction(1760, $change_amount);
			}
			elsif ($text=~/\b1761\b/) {	#:: Nihil
				quest::faction(1761, $change_amount);
			}
			elsif ($text=~/\b1762\b/) {	#:: Trusik Tribe
				quest::faction(1762, $change_amount);
			}
			elsif ($text=~/\b1763\b/) {	#:: Legion of Mata Muram
				quest::faction(1763, $change_amount);
			}
			elsif ($text=~/\b1764\b/) {	#:: Tunat`Muram
				quest::faction(1764, $change_amount);
			}
			elsif ($text=~/\b1765\b/) {	#:: Zun`Muram
				quest::faction(1765, $change_amount);
			}
			elsif ($text=~/\b1766\b/) {	#:: Pixtt
				quest::faction(1766, $change_amount);
			}
			elsif ($text=~/\b1767\b/) {	#:: Hexxt
				quest::faction(1767, $change_amount);
			}
			elsif ($text=~/\b1768\b/) {	#:: Rav
				quest::faction(1768, $change_amount);
			}
			elsif ($text=~/\b1769\b/) {	#:: Creatures of Taelosia
				quest::faction(1769, $change_amount);
			}
			elsif ($text=~/\b1770\b/) {	#:: Yunjo Slave Resistance
				quest::faction(1770, $change_amount);
			}
			elsif ($text=~/\b1771\b/) {	#:: Gladiators of Mata Muram
				quest::faction(1771, $change_amount);
			}
			elsif ($text=~/\b1772\b/) {	#:: The Sun
				quest::faction(1772, $change_amount);
			}
			elsif ($text=~/\b1773\b/) {	#:: The Moon
				quest::faction(1773, $change_amount);
			}
			elsif ($text=~/\b1774\b/) {	#:: Orcakar Players
				quest::faction(1774, $change_amount);
			}
			elsif ($text=~/\b1775\b/) {	#:: Citizens of Argath
				quest::faction(1775, $change_amount);
			}
			elsif ($text=~/\b1776\b/) {	#:: Living Steel
				quest::faction(1776, $change_amount);
			}
			elsif ($text=~/\b1777\b/) {	#:: Argathian Looters
				quest::faction(1777, $change_amount);
			}
			elsif ($text=~/\b1778\b/) {	#:: Citizens of Arelis
				quest::faction(1778, $change_amount);
			}
			elsif ($text=~/\b1779\b/) {	#:: Farmers of the Lunanyn
				quest::faction(1779, $change_amount);
			}
			elsif ($text=~/\b1780\b/) {	#:: Minions of War
				quest::faction(1780, $change_amount);
			}
			elsif ($text=~/\b1781\b/) {	#:: Minions of the Sun
				quest::faction(1781, $change_amount);
			}
			elsif ($text=~/\b1782\b/) {	#:: Dominion of Beasts
				quest::faction(1782, $change_amount);
			}
			elsif ($text=~/\b1783\b/) {	#:: Citizens of Sarith
				quest::faction(1783, $change_amount);
			}
			elsif ($text=~/\b1784\b/) {	#:: Devout of Oseka
				quest::faction(1784, $change_amount);
			}
			elsif ($text=~/\b1785\b/) {	#:: Minions of Prexus
				quest::faction(1785, $change_amount);
			}
			elsif ($text=~/\b1786\b/) {	#:: Seekers of Splendor
				quest::faction(1786, $change_amount);
			}
			elsif ($text=~/\b1787\b/) {	#:: Order of Radiance
				quest::faction(1787, $change_amount);
			}
			elsif ($text=~/\b1788\b/) {	#:: Devotees of Decay
				quest::faction(1788, $change_amount);
			}
			elsif ($text=~/\b1789\b/) {	#:: Purity of Alra
				quest::faction(1789, $change_amount);
			}
			elsif ($text=~/\b1790\b/) {	#:: Paragons of Purity
				quest::faction(1790, $change_amount);
			}
			elsif ($text=~/\b1791\b/) {	#:: Shades of Alra
				quest::faction(1791, $change_amount);
			}
			elsif ($text=~/\b1792\b/) {	#:: Paragons of Shadows
				quest::faction(1792, $change_amount);
			}
			elsif ($text=~/\b1793\b/) {	#:: Arcanists of Alra
				quest::faction(1793, $change_amount);
			}
			elsif ($text=~/\b1794\b/) {	#:: Paragons of the Arcane
				quest::faction(1794, $change_amount);
			}
			elsif ($text=~/\b1795\b/) {	#:: Living Will of Alra
				quest::faction(1795, $change_amount);
			}
			elsif ($text=~/\b1796\b/) {	#:: Paragons of Will
				quest::faction(1796, $change_amount);
			}
			elsif ($text=~/\b1797\b/) {	#:: Servants of the Song
				quest::faction(1797, $change_amount);
			}
			elsif ($text=~/\b1798\b/) {	#:: Citizens of Erillion
				quest::faction(1798, $change_amount);
			}
			elsif ($text=~/\b1799\b/) {	#:: Disciples of Order
				quest::faction(1799, $change_amount);
			}
			elsif ($text=~/\b1800\b/) {	#:: The Godblooded
				quest::faction(1800, $change_amount);
			}
			elsif ($text=~/\b1801\b/) {	#:: Iceshard Manor
				quest::faction(1801, $change_amount);
			}
			elsif ($text=~/\b1802\b/) {	#:: Dragon Death Keep
				quest::faction(1802, $change_amount);
			}
			elsif ($text=~/\b1803\b/) {	#:: Apparitions of Fear
				quest::faction(1803, $change_amount);
			}
			elsif ($text=~/\b1804\b/) {	#:: Beetles of Shard's Landing
				quest::faction(1804, $change_amount);
			}
			elsif ($text=~/\b1805\b/) {	#:: Oashim of Shard's Landing
				quest::faction(1805, $change_amount);
			}
			elsif ($text=~/\b1806\b/) {	#:: Pests of Shard's Landing
				quest::faction(1806, $change_amount);
			}
			elsif ($text=~/\b1807\b/) {	#:: Scavengers of Shard's Landing
				quest::faction(1807, $change_amount);
			}
			elsif ($text=~/\b1808\b/) {	#:: Kangon of Shard's Landing
				quest::faction(1808, $change_amount);
			}
			elsif ($text=~/\b1809\b/) {	#:: Braxi of Shard's Landing
				quest::faction(1809, $change_amount);
			}
			elsif ($text=~/\b1810\b/) {	#:: Wyverns of Shard's Landing
				quest::faction(1810, $change_amount);
			}
			elsif ($text=~/\b1811\b/) {	#:: Selyrah of Shard's Landing
				quest::faction(1811, $change_amount);
			}
			elsif ($text=~/\b1812\b/) {	#:: Goral of Shard's Landing
				quest::faction(1812, $change_amount);
			}
			elsif ($text=~/\b1813\b/) {	#:: Snakes of Shard's Landing
				quest::faction(1813, $change_amount);
			}
			elsif ($text=~/\b1814\b/) {	#:: Pumas of Shard's Landing
				quest::faction(1814, $change_amount);
			}
			elsif ($text=~/\b1815\b/) {	#:: Grendlaen of Shard's Landing
				quest::faction(1815, $change_amount);
			}
			elsif ($text=~/\b1816\b/) {	#:: Wolves of Shard's Landing
				quest::faction(1816, $change_amount);
			}
			elsif ($text=~/\b1817\b/) {	#:: Hunters of Shard's Landing
				quest::faction(1817, $change_amount);
			}
			elsif ($text=~/\b1818\b/) {	#:: Forsaken Believers
				quest::faction(1818, $change_amount);
			}
			elsif ($text=~/\b1819\b/) {	#:: The Believers
				quest::faction(1819, $change_amount);
			}
			elsif ($text=~/\b1820\b/) {	#:: The Conscripted
				quest::faction(1820, $change_amount);
			}
			elsif ($text=~/\b1821\b/) {	#:: Heralds of the Unspoken
				quest::faction(1821, $change_amount);
			}
			elsif ($text=~/\b1822\b/) {	#:: Harbingers of Thule
				quest::faction(1822, $change_amount);
			}
			elsif ($text=~/\b1823\b/) {	#:: Va`Ker
				quest::faction(1823, $change_amount);
			}
			elsif ($text=~/\b1824\b/) {	#:: Terrorwing
				quest::faction(1824, $change_amount);
			}
			elsif ($text=~/\b1825\b/) {	#:: Crystal Circle Builders
				quest::faction(1825, $change_amount);
			}
			elsif ($text=~/\b1826\b/) {	#:: The Unearthers
				quest::faction(1826, $change_amount);
			}
			elsif ($text=~/\b1827\b/) {	#:: The Displaced
				quest::faction(1827, $change_amount);
			}
			elsif ($text=~/\b1828\b/) {	#:: The Sol'Dal
				quest::faction(1828, $change_amount);
			}
			elsif ($text=~/\b1829\b/) {	#:: The Ember
				quest::faction(1829, $change_amount);
			}
			elsif ($text=~/\b1830\b/) {	#:: Defenders of Decay
				quest::faction(1830, $change_amount);
			}
			elsif ($text=~/\b1831\b/) {	#:: Warriors of Rodcet
				quest::faction(1831, $change_amount);
			}
			elsif ($text=~/\b1832\b/) {	#:: Faction1832
				quest::faction(1832, $change_amount);
			}
			elsif ($text=~/\b1833\b/) {	#:: Faction1833
				quest::faction(1833, $change_amount);
			}
			elsif ($text=~/\b1834\b/) {	#:: Faction1834
				quest::faction(1834, $change_amount);
			}
			elsif ($text=~/\b1835\b/) {	#:: Harrowing Horde
				quest::faction(1835, $change_amount);
			}
			elsif ($text=~/\b1836\b/) {	#:: Western Plains Bandits
				quest::faction(1836, $change_amount);
			}
			elsif ($text=~/\b1837\b/) {	#:: Ursarachnids
				quest::faction(1837, $change_amount);
			}
			elsif ($text=~/\b1838\b/) {	#:: Doomscale Cultists
				quest::faction(1838, $change_amount);
			}
			elsif ($text=~/\b1839\b/) {	#:: Nature Soul - Fire
				quest::faction(1839, $change_amount);
			}
			elsif ($text=~/\b1840\b/) {	#:: Nature Soul - Water
				quest::faction(1840, $change_amount);
			}
			elsif ($text=~/\b1841\b/) {	#:: Nature Soul - Earth
				quest::faction(1841, $change_amount);
			}
			elsif ($text=~/\b1842\b/) {	#:: Nature Soul - Wood
				quest::faction(1842, $change_amount);
			}
			elsif ($text=~/\b1843\b/) {	#:: Flaming Jacks
				quest::faction(1843, $change_amount);
			}
			elsif ($text=~/\b1844\b/) {	#:: Ethernere Revenants
				quest::faction(1844, $change_amount);
			}
			elsif ($text=~/\b1845\b/) {	#:: Ethernere Spirits
				quest::faction(1845, $change_amount);
			}
			elsif ($text=~/\b1846\b/) {	#:: King Naythox Thex Loyalists
				quest::faction(1846, $change_amount);
			}
			elsif ($text=~/\b1847\b/) {	#:: Queen Cristanos Thex Loyalists
				quest::faction(1847, $change_amount);
			}
			elsif ($text=~/\b1848\b/) {	#:: Neriak Fourth Gate Residents
				quest::faction(1848, $change_amount);
			}
			elsif ($text=~/\b1849\b/) {	#:: Qeynos Guards of West Karana
				quest::faction(1849, $change_amount);
			}
			elsif ($text=~/\b1850\b/) {	#:: Fellowship of the Peacock
				quest::faction(1850, $change_amount);
			}
			elsif ($text=~/\b1851\b/) {	#:: Damsel of Decay's Denizens
				quest::faction(1851, $change_amount);
			}
			elsif ($text=~/\b1852\b/) {	#:: Enemies of Tranquility
				quest::faction(1852, $change_amount);
			}
			elsif ($text=~/\b1853\b/) {	#:: Legion of the Overking
				quest::faction(1853, $change_amount);
			}
			elsif ($text=~/\b1854\b/) {	#:: Empire of the Di`Zok
				quest::faction(1854, $change_amount);
			}
			elsif ($text=~/\b1855\b/) {	#:: Kar`Zok
				quest::faction(1855, $change_amount);
			}
			elsif ($text=~/\b1856\b/) {	#:: Flamescale Legion
				quest::faction(1856, $change_amount);
			}
			elsif ($text=~/\b1857\b/) {	#:: Guardians of Konikor
				quest::faction(1857, $change_amount);
			}
			elsif ($text=~/\b1858\b/) {	#:: Clan Droga
				quest::faction(1858, $change_amount);
			}
			elsif ($text=~/\b1859\b/) {	#:: Majestic Centurion Alliance
				quest::faction(1859, $change_amount);
			}
			elsif ($text=~/\b1860\b/) {	#:: The Clawdigger Clan
				quest::faction(1860, $change_amount);
			}
			elsif ($text=~/\b1861\b/) {	#:: Scorpiki
				quest::faction(1861, $change_amount);
			}
			elsif ($text=~/\b1862\b/) {	#:: Denizens of Veeshan's Peak
				quest::faction(1862, $change_amount);
			}
			elsif ($text=~/\b1863\b/) {	#:: Servants of Esianti
				quest::faction(1863, $change_amount);
			}
			elsif ($text=~/\b1864\b/) {	#:: Servants of Aalishai
				quest::faction(1864, $change_amount);
			}
			elsif ($text=~/\b1865\b/) {	#:: Servants of Mearatas
				quest::faction(1865, $change_amount);
			}
			elsif ($text=~/\b1866\b/) {	#:: Servants of Loruella
				quest::faction(1866, $change_amount);
			}
			elsif ($text=~/\b1867\b/) {	#:: Contingent of the Alabaster Owl
				quest::faction(1867, $change_amount);
			}
			elsif ($text=~/\b1868\b/) {	#:: Brass Phoenix Brigade
				quest::faction(1868, $change_amount);
			}
			elsif ($text=~/\b1869\b/) {	#:: Company of the Alabaster Owl
				quest::faction(1869, $change_amount);
			}
			elsif ($text=~/\b1870\b/) {	#:: Brass Phoenix Legion
				quest::faction(1870, $change_amount);
			}
			elsif ($text=~/\b1871\b/) {	#:: Lords of Esianti
				quest::faction(1871, $change_amount);
			}
			elsif ($text=~/\b1872\b/) {	#:: Lords of Aalishai
				quest::faction(1872, $change_amount);
			}
			elsif ($text=~/\b1873\b/) {	#:: Bloodmoon Night-Orcs
				quest::faction(1873, $change_amount);
			}
			elsif ($text=~/\b1874\b/) {	#:: Faction1874
				quest::faction(1874, $change_amount);
			}
			elsif ($text=~/\b1875\b/) {	#:: Faction1875
				quest::faction(1875, $change_amount);
			}
			elsif ($text=~/\b1876\b/) {	#:: Faction1876
				quest::faction(1876, $change_amount);
			}
			elsif ($text=~/\b1877\b/) {	#:: Faction1877
				quest::faction(1877, $change_amount);
			}
			elsif ($text=~/\b1878\b/) {	#:: Faction1878
				quest::faction(1878, $change_amount);
			}
			elsif ($text=~/\b1879\b/) {	#:: Faction1879
				quest::faction(1879, $change_amount);
			}
			elsif ($text=~/\b1880\b/) {	#:: Faction1880
				quest::faction(1880, $change_amount);
			}
			elsif ($text=~/\b1881\b/) {	#:: Faction1881
				quest::faction(1881, $change_amount);
			}
			elsif ($text=~/\b1882\b/) {	#:: Faction1882
				quest::faction(1882, $change_amount);
			}
			elsif ($text=~/\b1883\b/) {	#:: Faction1883
				quest::faction(1883, $change_amount);
			}
			elsif ($text=~/\b1884\b/) {	#:: Faction1884
				quest::faction(1884, $change_amount);
			}
			elsif ($text=~/\b1885\b/) {	#:: Faction1885
				quest::faction(1885, $change_amount);
			}
			elsif ($text=~/\b1886\b/) {	#:: Faction1886
				quest::faction(1886, $change_amount);
			}
			elsif ($text=~/\b1887\b/) {	#:: Faction1887
				quest::faction(1887, $change_amount);
			}
			elsif ($text=~/\b1888\b/) {	#:: Faction1888
				quest::faction(1888, $change_amount);
			}
			elsif ($text=~/\b1889\b/) {	#:: Faction1889
				quest::faction(1889, $change_amount);
			}
			elsif ($text=~/\b1890\b/) {	#:: Faction1890
				quest::faction(1890, $change_amount);
			}
			elsif ($text=~/\b1891\b/) {	#:: Faction1891
				quest::faction(1891, $change_amount);
			}
			elsif ($text=~/\b1892\b/) {	#:: Faction1892
				quest::faction(1892, $change_amount);
			}
			elsif ($text=~/\b1893\b/) {	#:: Faction1893
				quest::faction(1893, $change_amount);
			}
			elsif ($text=~/\b1894\b/) {	#:: Faction1894
				quest::faction(1894, $change_amount);
			}
			elsif ($text=~/\b1895\b/) {	#:: Faction1895
				quest::faction(1895, $change_amount);
			}
			elsif ($text=~/\b1896\b/) {	#:: Faction1896
				quest::faction(1896, $change_amount);
			}
			elsif ($text=~/\b1897\b/) {	#:: Faction1897
				quest::faction(1897, $change_amount);
			}
			elsif ($text=~/\b1898\b/) {	#:: Faction1898
				quest::faction(1898, $change_amount);
			}
			elsif ($text=~/\b1899\b/) {	#:: Faction1899
				quest::faction(1899, $change_amount);
			}
			elsif ($text=~/\b1900\b/) {	#:: Faction1900
				quest::faction(1900, $change_amount);
			}
			elsif ($text=~/\b1901\b/) {	#:: Faction1901
				quest::faction(1901, $change_amount);
			}
			elsif ($text=~/\b1902\b/) {	#:: Faction1902
				quest::faction(1902, $change_amount);
			}
			elsif ($text=~/\b1903\b/) {	#:: Faction1903
				quest::faction(1903, $change_amount);
			}
			elsif ($text=~/\b1904\b/) {	#:: Faction1904
				quest::faction(1904, $change_amount);
			}
			elsif ($text=~/\b1905\b/) {	#:: Faction1905
				quest::faction(1905, $change_amount);
			}
			elsif ($text=~/\b1906\b/) {	#:: Faction1906
				quest::faction(1906, $change_amount);
			}
			elsif ($text=~/\b1907\b/) {	#:: Faction1907
				quest::faction(1907, $change_amount);
			}
			elsif ($text=~/\b1908\b/) {	#:: Faction1908
				quest::faction(1908, $change_amount);
			}
			elsif ($text=~/\b1909\b/) {	#:: Faction1909
				quest::faction(1909, $change_amount);
			}
			elsif ($text=~/\b1910\b/) {	#:: Faction1910
				quest::faction(1910, $change_amount);
			}
			elsif ($text=~/\b1911\b/) {	#:: Faction1911
				quest::faction(1911, $change_amount);
			}
			elsif ($text=~/\b1912\b/) {	#:: Faction1912
				quest::faction(1912, $change_amount);
			}
			elsif ($text=~/\b1913\b/) {	#:: Faction1913
				quest::faction(1913, $change_amount);
			}
			elsif ($text=~/\b1914\b/) {	#:: Faction1914
				quest::faction(1914, $change_amount);
			}
			elsif ($text=~/\b1915\b/) {	#:: Faction1915
				quest::faction(1915, $change_amount);
			}
			elsif ($text=~/\b1916\b/) {	#:: Faction1916
				quest::faction(1916, $change_amount);
			}
			elsif ($text=~/\b1917\b/) {	#:: Faction1917
				quest::faction(1917, $change_amount);
			}
			elsif ($text=~/\b1918\b/) {	#:: Faction1918
				quest::faction(1918, $change_amount);
			}
			elsif ($text=~/\b1919\b/) {	#:: Faction1919
				quest::faction(1919, $change_amount);
			}
			elsif ($text=~/\b1920\b/) {	#:: Faction1920
				quest::faction(1920, $change_amount);
			}
			elsif ($text=~/\b1921\b/) {	#:: Faction1921
				quest::faction(1921, $change_amount);
			}
			elsif ($text=~/\b1922\b/) {	#:: Faction1922
				quest::faction(1922, $change_amount);
			}
			elsif ($text=~/\b1923\b/) {	#:: Faction1923
				quest::faction(1923, $change_amount);
			}
			elsif ($text=~/\b1924\b/) {	#:: Faction1924
				quest::faction(1924, $change_amount);
			}
			elsif ($text=~/\b1925\b/) {	#:: Faction1925
				quest::faction(1925, $change_amount);
			}
			elsif ($text=~/\b1926\b/) {	#:: Faction1926
				quest::faction(1926, $change_amount);
			}
			elsif ($text=~/\b1927\b/) {	#:: Faction1927
				quest::faction(1927, $change_amount);
			}
			elsif ($text=~/\b1928\b/) {	#:: Faction1928
				quest::faction(1928, $change_amount);
			}
			elsif ($text=~/\b1929\b/) {	#:: Faction1929
				quest::faction(1929, $change_amount);
			}
			elsif ($text=~/\b1930\b/) {	#:: Faction1930
				quest::faction(1930, $change_amount);
			}
			elsif ($text=~/\b1931\b/) {	#:: Faction1931
				quest::faction(1931, $change_amount);
			}
			elsif ($text=~/\b1932\b/) {	#:: Faction1932
				quest::faction(1932, $change_amount);
			}
			elsif ($text=~/\b1933\b/) {	#:: Faction1933
				quest::faction(1933, $change_amount);
			}
			elsif ($text=~/\b1934\b/) {	#:: Faction1934
				quest::faction(1934, $change_amount);
			}
			elsif ($text=~/\b1935\b/) {	#:: Faction1935
				quest::faction(1935, $change_amount);
			}
			elsif ($text=~/\b1936\b/) {	#:: Faction1936
				quest::faction(1936, $change_amount);
			}
			elsif ($text=~/\b1937\b/) {	#:: Faction1937
				quest::faction(1937, $change_amount);
			}
			elsif ($text=~/\b1938\b/) {	#:: Faction1938
				quest::faction(1938, $change_amount);
			}
			elsif ($text=~/\b1939\b/) {	#:: Faction1939
				quest::faction(1939, $change_amount);
			}
			elsif ($text=~/\b1940\b/) {	#:: Faction1940
				quest::faction(1940, $change_amount);
			}
			elsif ($text=~/\b1941\b/) {	#:: Faction1941
				quest::faction(1941, $change_amount);
			}
			elsif ($text=~/\b1942\b/) {	#:: Faction1942
				quest::faction(1942, $change_amount);
			}
			elsif ($text=~/\b1943\b/) {	#:: Faction1943
				quest::faction(1943, $change_amount);
			}
			elsif ($text=~/\b1944\b/) {	#:: Faction1944
				quest::faction(1944, $change_amount);
			}
			elsif ($text=~/\b1945\b/) {	#:: Faction1945
				quest::faction(1945, $change_amount);
			}
			elsif ($text=~/\b1946\b/) {	#:: Faction1946
				quest::faction(1946, $change_amount);
			}
			elsif ($text=~/\b1947\b/) {	#:: Faction1947
				quest::faction(1947, $change_amount);
			}
			elsif ($text=~/\b1948\b/) {	#:: Faction1948
				quest::faction(1948, $change_amount);
			}
			elsif ($text=~/\b1949\b/) {	#:: Faction1949
				quest::faction(1949, $change_amount);
			}
			elsif ($text=~/\b1950\b/) {	#:: Faction1950
				quest::faction(1950, $change_amount);
			}
			elsif ($text=~/\b1951\b/) {	#:: Faction1951
				quest::faction(1951, $change_amount);
			}
			elsif ($text=~/\b1952\b/) {	#:: Faction1952
				quest::faction(1952, $change_amount);
			}
			elsif ($text=~/\b1953\b/) {	#:: Faction1953
				quest::faction(1953, $change_amount);
			}
			elsif ($text=~/\b1954\b/) {	#:: Faction1954
				quest::faction(1954, $change_amount);
			}
			elsif ($text=~/\b1955\b/) {	#:: Faction1955
				quest::faction(1955, $change_amount);
			}
			elsif ($text=~/\b1956\b/) {	#:: Faction1956
				quest::faction(1956, $change_amount);
			}
			elsif ($text=~/\b1957\b/) {	#:: Faction1957
				quest::faction(1957, $change_amount);
			}
			elsif ($text=~/\b1958\b/) {	#:: Faction1958
				quest::faction(1958, $change_amount);
			}
			elsif ($text=~/\b1959\b/) {	#:: Faction1959
				quest::faction(1959, $change_amount);
			}
			elsif ($text=~/\b1960\b/) {	#:: Faction1960
				quest::faction(1960, $change_amount);
			}
			elsif ($text=~/\b1961\b/) {	#:: Faction1961
				quest::faction(1961, $change_amount);
			}
			elsif ($text=~/\b1962\b/) {	#:: Faction1962
				quest::faction(1962, $change_amount);
			}
			elsif ($text=~/\b1963\b/) {	#:: Faction1963
				quest::faction(1963, $change_amount);
			}
			elsif ($text=~/\b1964\b/) {	#:: Faction1964
				quest::faction(1964, $change_amount);
			}
			elsif ($text=~/\b1965\b/) {	#:: Faction1965
				quest::faction(1965, $change_amount);
			}
			elsif ($text=~/\b1966\b/) {	#:: Faction1966
				quest::faction(1966, $change_amount);
			}
			elsif ($text=~/\b1967\b/) {	#:: Faction1967
				quest::faction(1967, $change_amount);
			}
			elsif ($text=~/\b1968\b/) {	#:: Faction1968
				quest::faction(1968, $change_amount);
			}
			elsif ($text=~/\b1969\b/) {	#:: Faction1969
				quest::faction(1969, $change_amount);
			}
			elsif ($text=~/\b1970\b/) {	#:: Faction1970
				quest::faction(1970, $change_amount);
			}
			elsif ($text=~/\b1971\b/) {	#:: Faction1971
				quest::faction(1971, $change_amount);
			}
			elsif ($text=~/\b1972\b/) {	#:: Faction1972
				quest::faction(1972, $change_amount);
			}
			elsif ($text=~/\b1973\b/) {	#:: Faction1973
				quest::faction(1973, $change_amount);
			}
			elsif ($text=~/\b1974\b/) {	#:: Faction1974
				quest::faction(1974, $change_amount);
			}
			elsif ($text=~/\b1975\b/) {	#:: Faction1975
				quest::faction(1975, $change_amount);
			}
			elsif ($text=~/\b1976\b/) {	#:: Faction1976
				quest::faction(1976, $change_amount);
			}
			elsif ($text=~/\b1977\b/) {	#:: Faction1977
				quest::faction(1977, $change_amount);
			}
			elsif ($text=~/\b1978\b/) {	#:: Faction1978
				quest::faction(1978, $change_amount);
			}
			elsif ($text=~/\b1979\b/) {	#:: Faction1979
				quest::faction(1979, $change_amount);
			}
			elsif ($text=~/\b1980\b/) {	#:: Faction1980
				quest::faction(1980, $change_amount);
			}
			elsif ($text=~/\b1981\b/) {	#:: Faction1981
				quest::faction(1981, $change_amount);
			}
			elsif ($text=~/\b1982\b/) {	#:: Faction1982
				quest::faction(1982, $change_amount);
			}
			elsif ($text=~/\b1983\b/) {	#:: Faction1983
				quest::faction(1983, $change_amount);
			}
			elsif ($text=~/\b1984\b/) {	#:: Faction1984
				quest::faction(1984, $change_amount);
			}
			elsif ($text=~/\b1985\b/) {	#:: Faction1985
				quest::faction(1985, $change_amount);
			}
			elsif ($text=~/\b1986\b/) {	#:: Faction1986
				quest::faction(1986, $change_amount);
			}
			elsif ($text=~/\b1987\b/) {	#:: Faction1987
				quest::faction(1987, $change_amount);
			}
			elsif ($text=~/\b1988\b/) {	#:: Faction1988
				quest::faction(1988, $change_amount);
			}
			elsif ($text=~/\b1989\b/) {	#:: Faction1989
				quest::faction(1989, $change_amount);
			}
			elsif ($text=~/\b1990\b/) {	#:: Faction1990
				quest::faction(1990, $change_amount);
			}
			elsif ($text=~/\b1991\b/) {	#:: Faction1991
				quest::faction(1991, $change_amount);
			}
			elsif ($text=~/\b1992\b/) {	#:: Faction1992
				quest::faction(1992, $change_amount);
			}
			elsif ($text=~/\b1993\b/) {	#:: Faction1993
				quest::faction(1993, $change_amount);
			}
			elsif ($text=~/\b1994\b/) {	#:: Faction1994
				quest::faction(1994, $change_amount);
			}
			elsif ($text=~/\b1995\b/) {	#:: Faction1995
				quest::faction(1995, $change_amount);
			}
			elsif ($text=~/\b1996\b/) {	#:: Faction1996
				quest::faction(1996, $change_amount);
			}
			elsif ($text=~/\b1997\b/) {	#:: Faction1997
				quest::faction(1997, $change_amount);
			}
			elsif ($text=~/\b1998\b/) {	#:: Faction1998
				quest::faction(1998, $change_amount);
			}
			elsif ($text=~/\b1999\b/) {	#:: Faction1999
				quest::faction(1999, $change_amount);
			}
			elsif ($text=~/\b2000\b/) {	#:: Faction2000
				quest::faction(2000, $change_amount);
			}
			elsif ($text=~/\b2001\b/) {	#:: Faction2001
				quest::faction(2001, $change_amount);
			}
			elsif ($text=~/\b2002\b/) {	#:: Faction2002
				quest::faction(2002, $change_amount);
			}
			elsif ($text=~/\b2003\b/) {	#:: Faction2003
				quest::faction(2003, $change_amount);
			}
			elsif ($text=~/\b2004\b/) {	#:: Faction2004
				quest::faction(2004, $change_amount);
			}
			elsif ($text=~/\b2005\b/) {	#:: Faction2005
				quest::faction(2005, $change_amount);
			}
			elsif ($text=~/\b2006\b/) {	#:: Faction2006
				quest::faction(2006, $change_amount);
			}
			elsif ($text=~/\b2007\b/) {	#:: Faction2007
				quest::faction(2007, $change_amount);
			}
			elsif ($text=~/\b2008\b/) {	#:: Faction2008
				quest::faction(2008, $change_amount);
			}
			elsif ($text=~/\b2009\b/) {	#:: Faction2009
				quest::faction(2009, $change_amount);
			}
			elsif ($text=~/\b2010\b/) {	#:: Faction2010
				quest::faction(2010, $change_amount);
			}
			elsif ($text=~/\b2011\b/) {	#:: Faction2011
				quest::faction(2011, $change_amount);
			}
			elsif ($text=~/\b2012\b/) {	#:: Faction2012
				quest::faction(2012, $change_amount);
			}
			elsif ($text=~/\b2013\b/) {	#:: Faction2013
				quest::faction(2013, $change_amount);
			}
			elsif ($text=~/\b2014\b/) {	#:: Faction2014
				quest::faction(2014, $change_amount);
			}
			elsif ($text=~/\b2015\b/) {	#:: Faction2015
				quest::faction(2015, $change_amount);
			}
			elsif ($text=~/\b2016\b/) {	#:: Faction2016
				quest::faction(2016, $change_amount);
			}
			elsif ($text=~/\b2017\b/) {	#:: Faction2017
				quest::faction(2017, $change_amount);
			}
			elsif ($text=~/\b2018\b/) {	#:: Faction2018
				quest::faction(2018, $change_amount);
			}
			elsif ($text=~/\b2019\b/) {	#:: Faction2019
				quest::faction(2019, $change_amount);
			}
			elsif ($text=~/\b2020\b/) {	#:: Faction2020
				quest::faction(2020, $change_amount);
			}
			elsif ($text=~/\b2021\b/) {	#:: Faction2021
				quest::faction(2021, $change_amount);
			}
			elsif ($text=~/\b2022\b/) {	#:: Faction2022
				quest::faction(2022, $change_amount);
			}
			elsif ($text=~/\b2023\b/) {	#:: Faction2023
				quest::faction(2023, $change_amount);
			}
			elsif ($text=~/\b2024\b/) {	#:: Faction2024
				quest::faction(2024, $change_amount);
			}
			elsif ($text=~/\b2025\b/) {	#:: Faction2025
				quest::faction(2025, $change_amount);
			}
			elsif ($text=~/\b2026\b/) {	#:: Faction2026
				quest::faction(2026, $change_amount);
			}
			elsif ($text=~/\b2027\b/) {	#:: Faction2027
				quest::faction(2027, $change_amount);
			}
			elsif ($text=~/\b2028\b/) {	#:: Faction2028
				quest::faction(2028, $change_amount);
			}
			elsif ($text=~/\b2029\b/) {	#:: Faction2029
				quest::faction(2029, $change_amount);
			}
			elsif ($text=~/\b2030\b/) {	#:: Faction2030
				quest::faction(2030, $change_amount);
			}
			elsif ($text=~/\b2031\b/) {	#:: Faction2031
				quest::faction(2031, $change_amount);
			}
			elsif ($text=~/\b2032\b/) {	#:: Faction2032
				quest::faction(2032, $change_amount);
			}
			elsif ($text=~/\b2033\b/) {	#:: Faction2033
				quest::faction(2033, $change_amount);
			}
			elsif ($text=~/\b2034\b/) {	#:: Faction2034
				quest::faction(2034, $change_amount);
			}
			elsif ($text=~/\b2035\b/) {	#:: Faction2035
				quest::faction(2035, $change_amount);
			}
			elsif ($text=~/\b2036\b/) {	#:: Faction2036
				quest::faction(2036, $change_amount);
			}
			elsif ($text=~/\b2037\b/) {	#:: Faction2037
				quest::faction(2037, $change_amount);
			}
			elsif ($text=~/\b2038\b/) {	#:: Faction2038
				quest::faction(2038, $change_amount);
			}
			elsif ($text=~/\b2039\b/) {	#:: Faction2039
				quest::faction(2039, $change_amount);
			}
			elsif ($text=~/\b2040\b/) {	#:: Faction2040
				quest::faction(2040, $change_amount);
			}
			elsif ($text=~/\b2041\b/) {	#:: Faction2041
				quest::faction(2041, $change_amount);
			}
			elsif ($text=~/\b2042\b/) {	#:: Faction2042
				quest::faction(2042, $change_amount);
			}
			elsif ($text=~/\b2043\b/) {	#:: Faction2043
				quest::faction(2043, $change_amount);
			}
			elsif ($text=~/\b2044\b/) {	#:: Faction2044
				quest::faction(2044, $change_amount);
			}
			elsif ($text=~/\b2045\b/) {	#:: Faction2045
				quest::faction(2045, $change_amount);
			}
			elsif ($text=~/\b2046\b/) {	#:: Faction2046
				quest::faction(2046, $change_amount);
			}
			elsif ($text=~/\b2047\b/) {	#:: Faction2047
				quest::faction(2047, $change_amount);
			}
			else {
				quest::say("Are you sure you're giving me the right name or number?  CaPiTaLiZaTiOn CoUnTs, so don't tell me 'banker' if you mean 'Banker'.");
			}
		}
		else {
			quest::say("Be sure to turn off your GM flag or I cannot make certain changes.");
		}
	}
	else {
		$client->Message(15,"You lack sufficient status to make use of this NPC.");
	}
}
