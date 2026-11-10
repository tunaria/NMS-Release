#include "database_update.h"

std::vector<ManifestEntry> manifest_entries_custom = {
	ManifestEntry{
		.version = 1,
		.description = "2025_05_16_new_database_check_test",
		.check = "SHOW TABLES LIKE 'new_table'",
		.condition = "empty",
		.match = "",
		.sql = R"(
CREATE TABLE `new_table`  (
  `id` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
);
)",
		.content_schema_update = false,
	},

	// Content schema tables
	ManifestEntry{
		.version = 2,
		.description = "2025_05_16_nms_waypoints_content_tables",
		.check = "SHOW TABLES LIKE 'nms_waypoints_categories'",
		.condition = "empty",
		.match = "",
		.sql = R"(
CREATE TABLE nms_waypoints_categories (
    id INT PRIMARY KEY,
    name VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE nms_waypoints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shortname VARCHAR(32) UNIQUE NOT NULL,
    long_name VARCHAR(64) NOT NULL,
    category INT NOT NULL,
    x FLOAT NOT NULL,
    y FLOAT NOT NULL,
    z FLOAT NOT NULL,
    heading FLOAT NOT NULL,
    INDEX idx_nms_waypoints_shortname (shortname),
    INDEX idx_nms_waypoints_category (category)
);

CREATE TABLE nms_waypoints_default (
    id INT AUTO_INCREMENT PRIMARY KEY,
    waypoint_id INT NOT NULL,
    race_id INT NOT NULL DEFAULT 0,
    class_mask INT UNSIGNED NOT NULL DEFAULT 65535,
    min_level INT NOT NULL DEFAULT 1,
    max_level INT NOT NULL DEFAULT 255,
    UNIQUE KEY unique_default_waypoint (waypoint_id, race_id, class_mask, min_level),
    INDEX idx_nms_waypoints_default_race (race_id),
    INDEX idx_nms_waypoints_default_class (class_mask),
    INDEX idx_nms_waypoints_default_level (min_level, max_level)
);
)",
		.content_schema_update = true,
	},

	// PEQ schema tables
	ManifestEntry{
		.version = 3,
		.description = "2025_05_16_nms_waypoints_peq_tables",
		.check = "SHOW TABLES LIKE 'nms_waypoints_character'",
		.condition = "empty",
		.match = "",
		.sql = R"(
CREATE TABLE nms_waypoints_character (
    id INT AUTO_INCREMENT PRIMARY KEY,
    character_id BIGINT UNSIGNED NOT NULL,
    waypoint_id INT NOT NULL,
    unlock_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_character_waypoint (character_id, waypoint_id),
    INDEX idx_nms_waypoints_character_id (character_id)
);

CREATE TABLE nms_waypoints_account (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id BIGINT UNSIGNED NOT NULL,
    waypoint_id INT NOT NULL,
    unlock_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_account_waypoint (account_id, waypoint_id),
    INDEX idx_nms_waypoints_account_id (account_id)
);
)",
		.content_schema_update = false,
	},

	ManifestEntry{
		.version = 4,
		.description = "2025_05_20_nms_zone_npc_update_range",
		.check = "SHOW COLUMNS FROM `zone` LIKE 'npc_update_range'",
		.condition = "empty",
		.match = "",
		.sql = R"(
ALTER TABLE `zone` ADD COLUMN `npc_update_range` int(11) NOT NULL DEFAULT 600 AFTER `npc_max_aggro_dist`;
)",
		.content_schema_update = true,
	},

	ManifestEntry{
		.version = 5,
		.description = "2025_05_20_nms_zone_max_movement_range",
		.check = "SHOW COLUMNS FROM `zone` LIKE 'max_movement_update_range'",
		.condition = "empty",
		.match = "",
		.sql = R"(
ALTER TABLE `zone` ADD COLUMN `max_movement_update_range` int(11) NOT NULL DEFAULT 600 AFTER `npc_update_range`;
)",
		.content_schema_update = true,
	},

	ManifestEntry{
		.version = 6,
		.description = "2025_05_20_nms_global_buffs",
		.check = "SHOW TABLES LIKE 'global_buffs'",
		.condition = "empty",
		.match = "",
		.sql = R"(
create table global_buffs(spell_id int(11) primary key, duration int(11));
)",
		.content_schema_update = false,
	},

	ManifestEntry{
		.version = 7,
		.description = "2025_05_20_nms_account_kill_counts",
		.check = "SHOW TABLES LIKE 'account_kill_counts'",
		.condition = "empty",
		.match = "",
		.sql = R"(
create table account_kill_counts(account_id int(11) primary key, race_id int(11), count int(11));
)",
		.content_schema_update = false,
	},

	ManifestEntry{
		.version = 8,
		.description = "2025_05_20_nms_character_pet_class_id",
		.check = "SHOW COLUMNS FROM `character_pet_name` LIKE 'class_id'",
		.condition = "empty",
		.match = "",
		.sql = R"(
	ALTER TABLE `character_pet_name`
		DROP PRIMARY KEY,
		ADD COLUMN `class_id` TINYINT(11) NOT NULL DEFAULT -1,
		ADD PRIMARY KEY (`character_id`, `class_id`);
	)",
		.content_schema_update = false,
	},

	ManifestEntry{
		.version = 9,
		.description = "2025_05_20_nms_account_alt_currency",
		.check = "SHOW TABLES LIKE 'account_alt_currency'",
		.condition = "empty",
		.match = "",
		.sql = R"(
CREATE TABLE `account_alt_currency` (
  `account_id` int(10) unsigned NOT NULL,
  `currency_id` int(10) unsigned NOT NULL,
  `amount` int(10) unsigned NOT NULL,
  PRIMARY KEY (`account_id`, `currency_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO account_alt_currency (account_id, currency_id, amount)
SELECT
  cd.account_id,
  cac.currency_id,
  SUM(cac.amount) AS amount
FROM character_alt_currency cac
JOIN character_data cd ON cd.id = cac.char_id
GROUP BY cd.account_id, cac.currency_id
ON DUPLICATE KEY UPDATE
  amount = VALUES(amount);
)",
		.content_schema_update = false,
	},

	// New familiar_names table
	ManifestEntry{
		.version = 10,
		.description = "2025_05_20_familiar_names_table",
		.check = "SHOW TABLES LIKE 'familiar_names'",
		.condition = "empty",
		.match = "",
		.sql = R"(
	CREATE TABLE `familiar_names` (
	  `spell_id` int(10) NOT NULL,
	  `name_list` text NOT NULL,
	  `size_mod` int(10) NOT NULL DEFAULT -1,
	  PRIMARY KEY (`spell_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
	)",
		.content_schema_update = true,
	},

	// Alter character_pet_name to change class_id from TINYINT to INT
	ManifestEntry{
		.version = 11,
		.description = "2025_05_20_modify_character_pet_name_class_id",
		.check = "SHOW COLUMNS FROM `character_pet_name` WHERE `Field` = 'class_id' AND `Type` LIKE 'tinyint%'",
		.condition = "not_empty",
		.match = "",
		.sql = R"(
			ALTER TABLE `character_pet_name`
			MODIFY COLUMN `class_id` INT NOT NULL DEFAULT 0
			)",
		.content_schema_update = false,
	},

	// Add character_aa_disabled table
	ManifestEntry{
		.version = 12,
		.description = "2025_05_20_nms_character_aa_disabled",
		.check = "SHOW TABLES LIKE 'character_aa_disabled'",
		.condition = "empty",
		.match = "",
		.sql = R"(
	CREATE TABLE `character_aa_disabled` (
	`aa_id` int(10) NOT NULL,
	`character_id` int(10) NOT NULL,
	`disabled` tinyint(4) NOT NULL,
	PRIMARY KEY (`aa_id`,`character_id`),
	KEY `idx_character_id` (`character_id`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	)",
		.content_schema_update = false,
	},

	// Add table for pet command states
	ManifestEntry{
		.version = 13,
		.description = "2025_05_26_character_pet_command_states_table",
		.check = "SHOW TABLES LIKE 'character_pet_command_states'",
		.condition = "empty",
		.match = "",
		.sql = R"(
	CREATE TABLE `character_pet_command_states` (
	`character_id` int(10) NOT NULL,
	`pet_class` tinyint(4) NOT NULL,
	`command_id` tinyint(4) NOT NULL,
	`command_state` tinyint(4) NOT NULL,
	PRIMARY KEY (`character_id`,`pet_class`,`command_id`),
	KEY `idx_char_petclass` (`character_id`,`pet_class`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
	)",
		.content_schema_update = false,
	},

	// Add character_dynamic_aa_timers table
	ManifestEntry{
		.version = 14,
		.description = "2025_05_27_character_dynamic_aa_timers_table",
		.check = "SHOW TABLES LIKE 'character_dynamic_aa_timers'",
		.condition = "empty",
		.match = "",
		.sql = R"(
CREATE TABLE `character_dynamic_aa_timers` (
  `character_id` int(10) NOT NULL,
  `aa_id` int(10) NOT NULL,
  `timer_id` int(10) NOT NULL,
  PRIMARY KEY (`character_id`,`aa_id`),
  UNIQUE KEY `character_id` (`character_id`,`timer_id`),
  KEY `aa_id` (`aa_id`),
  KEY `timer_id` (`timer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
)",
		.content_schema_update = false,
	},

/*
	// Create account_character_sets table
	ManifestEntry{
		.version = 15,
		.description = "2025_05_23_create_account_character_sets_table",
		.check = "SHOW TABLES LIKE 'account_character_sets'",
		.condition = "empty",
		.match = "",
		.sql = R"(
CREATE TABLE `account_character_sets` (
	`account_id` int(11) NOT NULL,
	`set_id` int(11) NOT NULL,
	`set_name` varchar(255) NOT NULL,
	`created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`account_id`, `set_id`),
	UNIQUE KEY `unique_account_set_name` (`account_id`, `set_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
)",
		.content_schema_update = false,
	},

	// Create account_character_set_members table
	ManifestEntry{
		.version = 16,
		.description = "2025_05_23_create_account_character_set_members_table",
		.check = "SHOW TABLES LIKE 'account_character_set_members'",
		.condition = "empty",
		.match = "",
		.sql = R"(
CREATE TABLE `account_character_set_members` (
	`account_id` int(11) NOT NULL,
	`set_id` int(11) NOT NULL,
	`character_id` int(11) NOT NULL,
	PRIMARY KEY (`account_id`, `set_id`, `character_id`),
	INDEX `idx_set_id` (`set_id`),
	INDEX `idx_character_id` (`character_id`),
	INDEX `idx_account_set` (`account_id`, `set_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
)",
		.content_schema_update = false,
	},

	// Create limits table
	ManifestEntry{
		.version = 17,
		.description = "2025_05_23_create_account_character_set_limits_table",
		.check = "SHOW TABLES LIKE 'account_character_set_limits'",
		.condition = "empty",
		.match = "",
		.sql = R"(
CREATE TABLE `account_character_set_limits` (
	`account_id` int(11) NOT NULL,
	`eom_sets` int(11) NOT NULL DEFAULT 0,
	`bonus_sets` int(11) NOT NULL DEFAULT 0,
	`default_set` int(11) NOT NULL DEFAULT 0,
	`eom_slots` int(11) NOT NULL DEFAULT 0,
	`bonus_slots` int(11) NOT NULL DEFAULT 0,
	PRIMARY KEY (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
	)",
	},
*/

	ManifestEntry{
		.version = 18,
		.description = "2026_06_13_update_aa339_whitelist_and_logs.sql",
		.check = "SELECT `rule_value` FROM `rule_values` WHERE `rule_name` = 'Custom:AA339Whitelist'",
		.condition = "missing",
		.match = "aa516",
		.sql = R"(
-- Upsert, not UPDATE: on a DB where the rule row does not exist yet, a bare UPDATE matches
-- zero rows and silently does nothing (this bit us in production - see versions 30-32).
INSERT INTO rule_values (ruleset_id, rule_name, rule_value, notes)
VALUES (1, 'Custom:AA339Whitelist', '16121,16122,16123,16675,16676,16677,30887,30888,30889,aa545,aa516,aa861,aa8332,8165,8166,8167,8168,8169', 'AA339 whitelist')
ON DUPLICATE KEY UPDATE rule_value = VALUES(rule_value);

UPDATE logsys_categories 
SET log_to_file = 0 
WHERE log_category_description NOT IN ('Error', 'Warning', 'Crash', 'MySQL Error', 'QuestErrors');

-- 1. Create the Custom NPC (Female Vah Shir)
INSERT INTO npc_types (id, name, lastname, level, race, class, bodytype, hp, mana, gender, texture, helmtexture, size, hp_regen_rate, hp_regen_per_second, mana_regen_rate, loottable_id, merchant_id, STR, STA, DEX, AGI, _INT, WIS, CHA, npc_faction_id, face)
VALUES (1120001300, 'A_Beastlord_Spell_Merchant', 'Spells 51-60', 60, 130, 41, 1, 1000, 1000, 1, 1, 0, 7, 0, 0, 0, 0, 1120001300, 75, 75, 75, 75, 75, 75, 75, 0, 3)
ON DUPLICATE KEY UPDATE class=VALUES(class), race=VALUES(race), gender=VALUES(gender), texture=VALUES(texture), size=VALUES(size), face=VALUES(face);

-- 2. Populate the Level 51-60 Merchantlist (38 scrolls)
INSERT INTO merchantlist (merchantid, slot, item) VALUES
(1120001300, 1, 15063),  -- Spell: Resist Disease (51)
(1120001300, 2, 15046),  -- Spell: Ultravision (51)
(1120001300, 3, 7740),   -- Spell: Spirit of Wind (51)
(1120001300, 4, 19363),  -- Spell: Summon: Muzzle of Mardu (51)
(1120001300, 5, 19499),  -- Spell: Spiritual Radiance (52)
(1120001300, 6, 7722),   -- Spell: Aid of Khurenz (52)
(1120001300, 7, 15435),  -- Spell: Venom of the Snake (52)
(1120001300, 8, 15161),  -- Spell: Health (52)
(1120001300, 9, 7741),   -- Spell: Spirit of the Storm (53)
(1120001300, 10, 15167), -- Spell: Talisman of Tnarg (53)
(1120001300, 11, 15152), -- Spell: Deftness (53)
(1120001300, 12, 26957), -- Spell: Ice Shard (54)
(1120001300, 13, 19531), -- Spell: Spirit of Snow (54)
(1120001300, 14, 7723),  -- Spell: Spirit of Omakin (54)
(1120001300, 15, 15062), -- Spell: Resist Poison (54)
(1120001300, 16, 15153), -- Spell: Furious Strength (54)
(1120001300, 17, 15145), -- Spell: Chloroplast (55)
(1120001300, 18, 7724),  -- Spell: Sha's Restoration (55)
(1120001300, 19, 15163), -- Spell: Incapacitate (56)
(1120001300, 20, 7726),  -- Spell: Spirit of Zehkes (56)
(1120001300, 21, 15431), -- Spell: Shifting Shield (56)
(1120001300, 22, 19530), -- Spell: Spirit of Flame (56)
(1120001300, 23, 15157), -- Spell: Dexterity (57)
(1120001300, 24, 15158), -- Spell: Stamina (57)
(1120001300, 25, 15015), -- Spell: Greater Healing (57)
(1120001300, 26, 15049), -- Spell: Nullify Magic (58)
(1120001300, 27, 59617), -- Spell: Guard of Calliav (58)
(1120001300, 28, 7727),  -- Spell: Spirit of Khurenz (58)
(1120001300, 29, 15168), -- Spell: Talisman of Altuna (58)
(1120001300, 30, 15510), -- Spell: Blizzard Blast (59)
(1120001300, 31, 7729),  -- Spell: Spiritual Purity (59)
(1120001300, 32, 19507), -- Spell: Chloroblast (59)
(1120001300, 33, 7728),  -- Spell: Sha's Ferocity (59)
(1120001300, 34, 15170), -- Spell: Alacrity (60)
(1120001300, 35, 7730),  -- Spell: Spiritual Strength (60)
(1120001300, 36, 19537), -- Spell: Savagery (60)
(1120001300, 37, 7731),  -- Spell: Spirit of Khati Sha (60)
(1120001300, 38, 19538)
ON DUPLICATE KEY UPDATE item=VALUES(item);

-- 3. Create Spawngroups
INSERT INTO spawngroup (name, spawn_limit, dist, max_x, min_x, max_y, min_y, delay, mindelay, despawn, despawn_timer, wp_spawns)
VALUES ('fv_Beastlord_Spell_Merchant', 1, 0, 0, 0, 0, 0, 45000, 15000, 0, 100, 0),
       ('ot_Beastlord_Spell_Merchant', 1, 0, 0, 0, 0, 0, 45000, 15000, 0, 100, 0)
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- 4. Link Spawngroups to Custom NPC
INSERT INTO spawnentry (spawngroupID, npcID, chance) VALUES
((SELECT id FROM spawngroup WHERE name = 'fv_Beastlord_Spell_Merchant'), 1120001300, 100),
((SELECT id FROM spawngroup WHERE name = 'ot_Beastlord_Spell_Merchant'), 1120001300, 100)
ON DUPLICATE KEY UPDATE chance=VALUES(chance);

-- 5. Place in Zones (spawn2)
INSERT INTO spawn2 (spawngroupID, zone, version, x, y, z, heading, respawntime, variance, pathgrid, path_when_zone_idle, _condition, cond_value, animation) VALUES
((SELECT id FROM spawngroup WHERE name = 'fv_Beastlord_Spell_Merchant'), 'firiona', 0, -3356.63, 388.16, 158.98, 87.75, 640, 0, 0, 0, 0, 1, 0),
((SELECT id FROM spawngroup WHERE name = 'ot_Beastlord_Spell_Merchant'), 'overthere', 0, 2341.93, 2809.66, -51.22, 195, 640, 0, 0, 0, 0, 1, 0)
ON DUPLICATE KEY UPDATE spawngroupID=VALUES(spawngroupID);

-- 6. Update Uggrig Skullchomper to be a Beastlord GM (Class 34)
UPDATE npc_types SET class = 34 WHERE id = 93152;

-- 7. Update Quegmor O`Cranic to be a Beastlord GM (Class 34) and move/ensure spawn
UPDATE npc_types SET class = 34 WHERE id = 84202;
UPDATE spawn2 SET x = -3311.55, y = 415.63, z = 158.89, heading = 373 WHERE id = 14745;
UPDATE spawnentry SET chance = 100 WHERE spawngroupID = 9696 AND npcID = 84202;
)",
		.content_schema_update = false,
	},
	ManifestEntry{
		.version = 19,
		.description = "2026_06_27_fix_broken_npc_factions.sql",
		.check = "SELECT npc_faction_id FROM npc_types WHERE id = 46016",
		.condition = "match",
		.match = "19471",
		.sql = R"(
UPDATE npc_types SET npc_faction_id = 929 WHERE id IN (46016, 46017, 46061, 46089);
UPDATE npc_types SET npc_faction_id = 79 WHERE id = 2000507;
UPDATE rule_values SET rule_value = '1.0' WHERE rule_name = 'Merchant:BuyCostMod';
UPDATE db_str SET value = 'This passive ability grants you a chance to have your damage over time spells hit for additional damage. Each level increases both the chance and amount of damage.' WHERE id = 15594 AND type = 4;
)",
		.content_schema_update = true,
	},
	ManifestEntry{
		.version = 20,
		.description = "2026_07_01_bazaar_spawn_sateal.sql",
		.check = "SELECT id FROM npc_types WHERE name = 'Sateal_Deirosap' AND lastname = 'Smithing Supplies'",
		.condition = "empty",
		.match = "",
		.sql = R"(
-- 1. Spawn Sateal Deirosap in Bazaar version 0 (Classic Bazaar)
INSERT INTO `spawn2` (`spawngroupID`, `zone`, `version`, `x`, `y`, `z`, `heading`, `respawntime`, `variance`, `pathgrid`, `_condition`, `cond_value`)
VALUES (111116, 'bazaar', 0, -38.000000, -676.000000, 4.750000, 126.000000, 640, 0, 0, 0, 1);

-- 2. Update Sateal's title to "Smithing Supplies"
UPDATE `npc_types` SET `lastname` = 'Smithing Supplies' WHERE `name` = 'Sateal_Deirosap';

-- 3. Update Yekan's Quickening scroll base price to target 1p 4g final merchant price (667 copper base)
UPDATE items SET price = 667 WHERE id = 7719;
)",
		.content_schema_update = true,
	},

	ManifestEntry{
		.version = 21,
		.description = "2026_07_12_bazaar_aa_and_data_fixes.sql",
		.check = "SELECT 1",
		.condition = "not_empty",
		.match = "",
		.sql = R"(
-- The Bazaar is a trade hub but was the only hub with combat enabled (cancombat = 1); PoK,
-- Nexus, Guild Lobby and Plane of Tranquility are all cancombat = 0. That let players kill
-- NPCs (and each other) in the Bazaar. Flag it safe like the other hubs (covers both version
-- rows). IsAttackAllowed() gates all melee on zone->CanDoCombat().
UPDATE `zone` SET `cancombat` = 0 WHERE `short_name` = 'bazaar';

-- Hastened Gathering ranks 4 and 5 (custom ranks 12899/12900) reduced Gather Mana to nothing.
--
-- SE_HastenedAASkill (SPA 264) reductions are FLAT SECONDS, and each Hastened Gathering rank carries
-- two effect slots: slot 1 targets Gather Mana (aa_ability 57, base recast 3600s) and slot 2 targets
-- Mana Draw (616), whose upgraded ranks are 8640s. The custom ranks were scaled for the 8640s target
-- -- 3456 is ~40% of 8640, but 96% of 3600. So rank 4 cut Gather Mana to 144s and rank 5 (-4320)
-- exceeded its base entirely, clamping the timer to 0 and making it free.
--
-- Slot 1 only ever affects Gather Mana (GetAlternateAdvancementCooldownReduction filters on
-- limit_value), so rescaling it leaves the Mana Draw side untouched. The vanilla ranks step +400/rank
-- against the 3600s base (400/800/1200); 1600/2000 continue that line, giving 33 and 27 minutes.
-- Vanilla ranks 471/472/473 are deliberately NOT touched -- they are correct.
--
-- Dormant when written (both ranks are level_req 80; the cap is well below that), fixed now so it
-- cannot surprise us at the next expansion bump.
UPDATE `aa_rank_effects` SET `base1` = 1600 WHERE `rank_id` = 12899 AND `slot` = 1 AND `base2` = 57;
UPDATE `aa_rank_effects` SET `base1` = 2000 WHERE `rank_id` = 12900 AND `slot` = 1 AND `base2` = 57;

-- aa_ranks 12900 pointed next_id at rank 12901, which does not exist. Harmless (the chain just ends)
-- but it leaves a dangling reference in the rank list.
UPDATE `aa_ranks` SET `next_id` = -1 WHERE `id` = 12900;

-- Move the Firiona Vie Beastlord trainer and spell merchant out of the drolvarg camp, into the city.
--
-- This REVERSES a placement made by v21's own predecessor. Version 18 (above, "7. Update Quegmor
-- O`Cranic to be a Beastlord GM") made Quegmor a Beastlord GM -- he is not one in stock PEQ -- and
-- parked him at (-3311.55, 415.63, z=158.89), then placed the new Beastlord Spell Merchant beside him
-- at (-3356.63, 388.16, z=158.98).
--
-- Those coordinates are the ABANDONED pre-revamp Firiona Vie outpost. Firiona Vie was revamped and the
-- outpost moved south to z = -76; roughly 30 drolvarg now spawn on the old site. Evidence the south is
-- the live city: it holds 64 of the zone's 68 doors, has ~4x the map geometry, contains the zone's safe
-- point (1440, -2392), and is where 28 of the 30 named city NPCs already stand.
--
-- So Beastlords were the only class that had to fight through a mob camp to train or buy spells -- and
-- this merchant carries ALL 38 Beastlord scrolls, making that camp the only source in the zone. Every
-- other class trains and buys in the city.
--
-- Why v18 chose those coordinates: the common Firiona Vie map packs still label the OLD outpost with
-- the city's NPC names (their geometry was updated after the revamp; their hand-maintained label files
-- never were). The map says "town" there. It is wrong, and it is almost certainly the original source
-- of this bug.
--
-- The two UPDATEs target differently ON PURPOSE -- do not "clean this up" into one style:
--   * Quegmor's spawn2 row is stock PEQ data, so id 14745 is identical on every server. v18 relies on
--     this exact assumption one entry above, so it is proven on real installs.
--   * The merchant's spawn2 row is INSERTed by v18, so its id comes from AUTO_INCREMENT and WILL differ
--     per server (it is 3388065 on dev -- meaningless anywhere else). It must be resolved through its
--     spawngroup name, exactly as v18 inserts it. A hardcoded id here would silently move the wrong
--     spawn, or nothing at all.
--
-- Ordering is safe either way: the manifest applies versions in ascending order, so on a fresh install
-- v18 creates these at the old coordinates and v21 immediately corrects them; on a server already past
-- v18, v21 corrects them in place.
UPDATE spawn2 SET x = 2794.85, y = -3350.75, z = -76.12, heading = 385.5
  WHERE id = 14745;
UPDATE spawn2 SET x = 2810.72, y = -3378.81, z = -76.12, heading = 380.75
  WHERE spawngroupID IN (SELECT id FROM spawngroup WHERE name = 'fv_Beastlord_Spell_Merchant');

-- Remove "Boomerang of Wonders" and its variants. Its model (idfile IT11383) exists in NO RoF2-era
-- client -- not even the newest reference client -- so it always rendered empty-handed. It is also
-- completely unreachable in-game: not in any loot table, merchant, tradeskill recipe, quest, or plugin,
-- and the Purveyor of Glamour cannot produce its glamour. The hand-in path needs the base item, which
-- is unobtainable; the random-glamour path (get_random_glamour) skips it because it is a RANGE-slot
-- (2048) item with itemtype 10, while that query only accepts range items with itemtype 5. So these
-- four rows are pure orphaned data. Deletes base (109036), Enchanted (1109036), Legendary (2109036)
-- and the Glamour ornament (704681).
DELETE FROM items WHERE id IN (109036, 1109036, 2109036, 704681);

-- Move the Bazaar safe point OUT of the PVP arena. Rebuilding the .map files activated the RoF2 client's
-- hardcoded arena PVP region (fun, intended), but the old safe point sat inside it -- so anyone returned
-- to the safe point (AFK camp, /unstuck, failed feign, some ports) landed flagged for PVP in the pit.
-- New spot is by the Shadowhaven entrance, well clear of the arena. Updates BOTH bazaar rows (v0 default
-- and v1 map_file_name='bazaar_old') so whichever version the server boots is safe.
UPDATE zone SET safe_x = -134.13, safe_y = -815.98, safe_z = 3.75, safe_heading = 70.25
  WHERE short_name = 'bazaar';
)",
		.content_schema_update = false,
	},

	// ------------------------------------------------------------------------------------------------
	// Version 22: REPAIR PASS for the v21 rollout.
	//
	// v21 originally shipped as one multi-statement entry whose check only tested its FIRST
	// statement. Any failure after statement 1 - such as a MariaDB-only collation on other
	// engines - killed world mid-update; on restart the check passed, the whole entry was
	// skipped, and custom_version was stamped past it with the rest of the payload silently missing.
	// This entry re-delivers the v19/v21 data payloads behind an always-run check, so a healthy
	// server converges to the same values and a half-applied server gets the missing pieces.
	//
	// RULES (see also the header of this file):
	//  * ONE entry per version. The runner queues one apply-round per matching entry, and each
	//    round runs EVERY entry of that version - two entries sharing a version each execute twice.
	//  * Universal SQL only. No MariaDB-only syntax (uca1400 collations, ADD COLUMN IF NOT EXISTS).
	//  * The check must guard the exact SQL in the same entry, never a neighbor's.
	//  * Additive/idempotent only in repairs - no DROP/TRUNCATE/DELETE of player data.
	// ------------------------------------------------------------------------------------------------

	// DATA RESYNC. Re-delivers every data payload from v19 and v21 that a half-applied server may
	// have lost. The check is "SELECT 1" so it always runs ONCE during the bump to this version -
	// that is safe precisely because every statement here is idempotent DML (INSERT IGNORE or an
	// UPDATE that converges to the same values) and cannot error on any schema state. A server
	// that already has all of it is rewritten to the identical values; a half-applied server gets
	// the missing pieces. NO DDL in this entry, ever - DDL belongs in its own guarded entry.
	//
	// Deliberately NOT re-delivered:
	//   * v21's DELETE of the Boomerang of Wonders items - destructive, each operator's call.
	//   * v18's AA339 whitelist - INSERT IGNORE only, so an operator's tuned value is respected.
	ManifestEntry{
		.version = 22,
		.description = "2026_07_19_resync_v19_v21_data_payload",
		.check = "SELECT 1",
		.condition = "not_empty",
		.match = "",
		.sql = R"(
-- v21: Bazaar is a no-combat hub like PoK/Nexus/Guild Lobby/PoT (covers both version rows).
UPDATE `zone` SET `cancombat` = 0 WHERE `short_name` = 'bazaar';

-- v21: Hastened Gathering ranks 4/5 rescale (custom ranks 12899/12900, Gather Mana slot only -
-- base2 = 57). The old values were scaled against Mana Draw's 8640s base instead of Gather
-- Mana's 3600s, making rank 5 free. Vanilla ranks 471-473 are correct and untouched.
UPDATE `aa_rank_effects` SET `base1` = 1600 WHERE `rank_id` = 12899 AND `slot` = 1 AND `base2` = 57;
UPDATE `aa_rank_effects` SET `base1` = 2000 WHERE `rank_id` = 12900 AND `slot` = 1 AND `base2` = 57;

-- v21: rank 12900 pointed next_id at nonexistent 12901.
UPDATE `aa_ranks` SET `next_id` = -1 WHERE `id` = 12900;

-- v21: Firiona Vie Beastlord trainer + spell merchant out of the drolvarg camp, into the live
-- city (see the v21 entry for the full story). Quegmor's row is stock PEQ so id 14745 is the
-- same everywhere; the merchant's row is v18-inserted so it MUST resolve via spawngroup name
-- (its AUTO_INCREMENT id differs per server). IN, not =, so a duplicated group name can never
-- turn this into a fatal 1242 multi-row error.
UPDATE spawn2 SET x = 2794.85, y = -3350.75, z = -76.12, heading = 385.5
  WHERE id = 14745;
UPDATE spawn2 SET x = 2810.72, y = -3378.81, z = -76.12, heading = 380.75
  WHERE spawngroupID IN (SELECT id FROM spawngroup WHERE name = 'fv_Beastlord_Spell_Merchant');

-- v21: Bazaar safe point out of the PVP arena (both bazaar rows).
UPDATE zone SET safe_x = -134.13, safe_y = -815.98, safe_z = 3.75, safe_heading = 70.25
  WHERE short_name = 'bazaar';

-- v19 orphans: v19's check tests the npc faction its first statement fixes, so on any server
-- whose dump already carried faction 929 the WHOLE entry was skipped and these never applied.
UPDATE npc_types SET npc_faction_id = 929 WHERE id IN (46016, 46017, 46061, 46089);
UPDATE npc_types SET npc_faction_id = 79 WHERE id = 2000507;
UPDATE rule_values SET rule_value = '1.0' WHERE rule_name = 'Merchant:BuyCostMod';
UPDATE db_str SET value = 'This passive ability grants you a chance to have your damage over time spells hit for additional damage. Each level increases both the chance and amount of damage.' WHERE id = 15594 AND type = 4;
)",
		.content_schema_update = false,
	},

	// ------------------------------------------------------------------------------------------------
	// Versions 23-25: REPAIR PASS for the v18 rollout.
	//
	// Found 2026-07-19 on a community server: db_version.custom_version was stamped >= 18 while the
	// DATA predated v18 entirely (baseline dump cut in the window where version stamp and content
	// were out of sync on dev). The runner only evaluates entries ABOVE the stored version, so v18
	// was never looked at again - no Beastlord spell merchant, no scrolls, no spawns, GMs left at
	// stock class, whitelist without aa516. Discovered only because v22's FV-merchant move returned
	// zero rows. These re-deliver v18's payload behind checks that test the CONTENT (never the
	// version), so healthy servers no-op through all of them. Same recipe as the v22 resync above.
	//
	// Same rules as always: one entry per version, universal SQL only, checks guard their own SQL,
	// everything idempotent.
	// ------------------------------------------------------------------------------------------------

	// v18's Beastlord spell merchant NPC + all 38 scrolls (51-60).
	// The check tests the LAST merchantlist row, not the NPC: if a run dies between the two
	// statements, the check still reads missing and the whole entry re-runs (both statements are
	// ON DUPLICATE KEY idempotent), instead of the NPC's existence masking an empty merchant list.
	ManifestEntry{
		.version = 23,
		.description = "2026_07_19_repair_v18_beastlord_merchant_and_scrolls",
		.check = "SELECT item FROM merchantlist WHERE merchantid = 1120001300 AND slot = 38",
		.condition = "empty",
		.match = "",
		.sql = R"(
INSERT INTO npc_types (id, name, lastname, level, race, class, bodytype, hp, mana, gender, texture, helmtexture, size, hp_regen_rate, hp_regen_per_second, mana_regen_rate, loottable_id, merchant_id, STR, STA, DEX, AGI, _INT, WIS, CHA, npc_faction_id, face)
VALUES (1120001300, 'A_Beastlord_Spell_Merchant', 'Spells 51-60', 60, 130, 41, 1, 1000, 1000, 1, 1, 0, 7, 0, 0, 0, 0, 1120001300, 75, 75, 75, 75, 75, 75, 75, 0, 3)
ON DUPLICATE KEY UPDATE class=VALUES(class), race=VALUES(race), gender=VALUES(gender), texture=VALUES(texture), size=VALUES(size), face=VALUES(face);

INSERT INTO merchantlist (merchantid, slot, item) VALUES
(1120001300, 1, 15063),  -- Spell: Resist Disease (51)
(1120001300, 2, 15046),  -- Spell: Ultravision (51)
(1120001300, 3, 7740),   -- Spell: Spirit of Wind (51)
(1120001300, 4, 19363),  -- Spell: Summon: Muzzle of Mardu (51)
(1120001300, 5, 19499),  -- Spell: Spiritual Radiance (52)
(1120001300, 6, 7722),   -- Spell: Aid of Khurenz (52)
(1120001300, 7, 15435),  -- Spell: Venom of the Snake (52)
(1120001300, 8, 15161),  -- Spell: Health (52)
(1120001300, 9, 7741),   -- Spell: Spirit of the Storm (53)
(1120001300, 10, 15167), -- Spell: Talisman of Tnarg (53)
(1120001300, 11, 15152), -- Spell: Deftness (53)
(1120001300, 12, 26957), -- Spell: Ice Shard (54)
(1120001300, 13, 19531), -- Spell: Spirit of Snow (54)
(1120001300, 14, 7723),  -- Spell: Spirit of Omakin (54)
(1120001300, 15, 15062), -- Spell: Resist Poison (54)
(1120001300, 16, 15153), -- Spell: Furious Strength (54)
(1120001300, 17, 15145), -- Spell: Chloroplast (55)
(1120001300, 18, 7724),  -- Spell: Sha's Restoration (55)
(1120001300, 19, 15163), -- Spell: Incapacitate (56)
(1120001300, 20, 7726),  -- Spell: Spirit of Zehkes (56)
(1120001300, 21, 15431), -- Spell: Shifting Shield (56)
(1120001300, 22, 19530), -- Spell: Spirit of Flame (56)
(1120001300, 23, 15157), -- Spell: Dexterity (57)
(1120001300, 24, 15158), -- Spell: Stamina (57)
(1120001300, 25, 15015), -- Spell: Greater Healing (57)
(1120001300, 26, 15049), -- Spell: Nullify Magic (58)
(1120001300, 27, 59617), -- Spell: Guard of Calliav (58)
(1120001300, 28, 7727),  -- Spell: Spirit of Khurenz (58)
(1120001300, 29, 15168), -- Spell: Talisman of Altuna (58)
(1120001300, 30, 15510), -- Spell: Blizzard Blast (59)
(1120001300, 31, 7729),  -- Spell: Spiritual Purity (59)
(1120001300, 32, 19507), -- Spell: Chloroblast (59)
(1120001300, 33, 7728),  -- Spell: Sha's Ferocity (59)
(1120001300, 34, 15170), -- Spell: Alacrity (60)
(1120001300, 35, 7730),  -- Spell: Spiritual Strength (60)
(1120001300, 36, 19537), -- Spell: Savagery (60)
(1120001300, 37, 7731),  -- Spell: Spirit of Khati Sha (60)
(1120001300, 38, 19538)
ON DUPLICATE KEY UPDATE item=VALUES(item);
)",
		.content_schema_update = false,
	},

	// v18's spawn groups / entries / world placement for the merchant, both zones.
	// Every statement is INSERT ... SELECT ... WHERE NOT EXISTS (v18's ON DUPLICATE KEY UPDATE on
	// spawngroup was a NO-OP guard - spawngroup.name has no unique index, so a re-run duplicated
	// rows and then every name-subquery in later entries became a fatal 1242 multi-row error).
	// The Firiona Vie spawn goes DIRECTLY at the corrected city location (v22's coordinates) -
	// re-creating v18's drolvarg-camp placement just for v22 to have already run would plant the
	// merchant in the wrong spot with nothing left to move him.
	// Check = the LAST artifact created (overthere spawn2): any partial death re-runs the entry;
	// WHERE NOT EXISTS makes the re-run clean.
	ManifestEntry{
		.version = 24,
		.description = "2026_07_19_repair_v18_beastlord_merchant_spawns",
		.check = "SELECT s.id FROM spawn2 s WHERE s.spawngroupID IN (SELECT id FROM spawngroup WHERE name = 'ot_Beastlord_Spell_Merchant')",
		.condition = "empty",
		.match = "",
		.sql = R"(
INSERT INTO spawngroup (name, spawn_limit, dist, max_x, min_x, max_y, min_y, delay, mindelay, despawn, despawn_timer, wp_spawns)
SELECT 'fv_Beastlord_Spell_Merchant', 1, 0, 0, 0, 0, 0, 45000, 15000, 0, 100, 0 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM spawngroup WHERE name = 'fv_Beastlord_Spell_Merchant');

INSERT INTO spawngroup (name, spawn_limit, dist, max_x, min_x, max_y, min_y, delay, mindelay, despawn, despawn_timer, wp_spawns)
SELECT 'ot_Beastlord_Spell_Merchant', 1, 0, 0, 0, 0, 0, 45000, 15000, 0, 100, 0 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM spawngroup WHERE name = 'ot_Beastlord_Spell_Merchant');

INSERT INTO spawnentry (spawngroupID, npcID, chance)
SELECT sg.id, 1120001300, 100 FROM spawngroup sg
WHERE sg.name = 'fv_Beastlord_Spell_Merchant'
  AND NOT EXISTS (SELECT 1 FROM spawnentry se WHERE se.spawngroupID = sg.id AND se.npcID = 1120001300);

INSERT INTO spawnentry (spawngroupID, npcID, chance)
SELECT sg.id, 1120001300, 100 FROM spawngroup sg
WHERE sg.name = 'ot_Beastlord_Spell_Merchant'
  AND NOT EXISTS (SELECT 1 FROM spawnentry se WHERE se.spawngroupID = sg.id AND se.npcID = 1120001300);

INSERT INTO spawn2 (spawngroupID, zone, version, x, y, z, heading, respawntime, variance, pathgrid, path_when_zone_idle, _condition, cond_value, animation)
SELECT sg.id, 'firiona', 0, 2810.72, -3378.81, -76.12, 380.75, 640, 0, 0, 0, 0, 1, 0 FROM spawngroup sg
WHERE sg.name = 'fv_Beastlord_Spell_Merchant'
  AND NOT EXISTS (SELECT 1 FROM spawn2 s WHERE s.spawngroupID = sg.id);

INSERT INTO spawn2 (spawngroupID, zone, version, x, y, z, heading, respawntime, variance, pathgrid, path_when_zone_idle, _condition, cond_value, animation)
SELECT sg.id, 'overthere', 0, 2341.93, 2809.66, -51.22, 195, 640, 0, 0, 0, 0, 1, 0 FROM spawngroup sg
WHERE sg.name = 'ot_Beastlord_Spell_Merchant'
  AND NOT EXISTS (SELECT 1 FROM spawn2 s WHERE s.spawngroupID = sg.id);
)",
		.content_schema_update = false,
	},

	// v18's remaining data payload, always-run-once (same pattern as v22): every statement is
	// idempotent DML that converges to the same values, so re-application is harmless and nothing
	// can be skipped by a half-applied state.
	ManifestEntry{
		.version = 25,
		.description = "2026_07_19_resync_v18_data_payload",
		.check = "SELECT 1",
		.condition = "not_empty",
		.match = "",
		.sql = R"(
-- AA339 whitelist as an UPSERT - v18's bare UPDATE silently no-opped on servers where the rule row
-- did not exist, which is exactly how the whitelist ended up without aa516 in the wild.
INSERT INTO rule_values (ruleset_id, rule_name, rule_value, notes)
VALUES (1, 'Custom:AA339Whitelist', '16121,16122,16123,16675,16676,16677,30887,30888,30889,aa545,aa516,aa861,aa8332,8165,8166,8167,8168,8169', 'AA339 whitelist')
ON DUPLICATE KEY UPDATE rule_value = VALUES(rule_value);

-- Uggrig Skullchomper / Quegmor O`Cranic -> Beastlord GMs (class 34), as v18 intended.
UPDATE npc_types SET class = 34 WHERE id IN (93152, 84202);

-- Quegmor's spawn entry always up (v18 step 7). His spawn2 position move is v22's job.
UPDATE spawnentry SET chance = 100 WHERE spawngroupID = 9696 AND npcID = 84202;

-- Log noise reduction (v18 step 2).
UPDATE logsys_categories
SET log_to_file = 0
WHERE log_category_description NOT IN ('Error', 'Warning', 'Crash', 'MySQL Error', 'QuestErrors');
)",
		.content_schema_update = false,
	},

	// NMS: Dailifyer challenges (Release-NMS-Plugins/NMS_dailifyer_utils.pl). Carles Seregwyn in the
	// Bazaar, the Fragments of Truth that Lord Inquisitor Seru drops when the four Praesertums are
	// alive, and one plunder loot table per challenge. The plunder tables point at the bosses' own
	// lootdrops with the bosses' droplimit/mindrop, so a plunder rolls the same loot as a kill. Every
	// statement is idempotent; the check is the last row created (Carles' spawn2).
	// Tested only with the NMS version of Lord Inquisitor Seru's loot (loot table 13516, lootdrop 23223:
	// Black Ornate Chain Bridle / Glamour - 'Sword of Truth'). On another database, check those ids
	// before applying it.
	ManifestEntry{
		.version = 26,
		.description = "2026_11_10_dailifyer_challenges",
		.check = "SELECT s.id FROM spawn2 s WHERE s.spawngroupID IN (SELECT id FROM spawngroup WHERE name = 'bazaar_Carles_Seregwyn')",
		.condition = "empty",
		.match = "",
		.sql = R"(
-- Dark Elf Shadowknight in full plate (texture/helmtexture 3) holding a Blade of Abrogation (item 5430,
-- model IT53) and a Sarnak Battle Shield (item 9205, model IT221). Unattackable, like the soulbinders.
INSERT INTO npc_types (id, name, lastname, level, race, class, bodytype, hp, mana, gender, texture, helmtexture, size, hp_regen_rate, hp_regen_per_second, mana_regen_rate, loottable_id, merchant_id, STR, STA, DEX, AGI, _INT, WIS, CHA, npc_faction_id, face, special_abilities, trackable, show_name, d_melee_texture1, d_melee_texture2, prim_melee_type)
VALUES (1120001301, 'Carles_Seregwyn', 'The Dailifyer', 70, 6, 5, 1, 34500, 0, 0, 3, 3, 6, 0, 0, 0, 0, 0, 75, 75, 75, 75, 80, 75, 75, 0, 1, '12,1^13,1^14,1^15,1^16,1^17,1^18,1^19,1^20,1^21,1^22,1^23,1^24,1^25,1^28,1^31,1^35,1^39,1^46,1', 1, 1, 53, 221, 1)
ON DUPLICATE KEY UPDATE name = VALUES(name), lastname = VALUES(lastname);

-- Fragments of Truth (augments for the Reforged Sword of Truth, recipe 927864): 1 or 2 per kill at
-- equal weight, the same shape as Kerafyrm's Prismatic Scales (lootdrop 807163).
INSERT INTO lootdrop (id, name) VALUES (807181, 'Lord_Inquisitor_Seru_Fragments_of_Truth')
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO lootdrop_entries (lootdrop_id, item_id, item_charges, equip_item, chance, multiplier) VALUES
(807181, 9536, 1, 0, 5, 1), -- Runic Fragment of Truth
(807181, 9537, 1, 0, 5, 1), -- Akhevan Fragment of Truth
(807181, 9538, 1, 0, 5, 1), -- Ssraeshzian Fragment of Truth
(807181, 9539, 1, 0, 5, 1), -- Yttrium Fragment of Truth
(807181, 9540, 1, 0, 5, 1), -- Lethal Fragment of Truth
(807181, 9541, 1, 0, 5, 1), -- Magical Fragment of Truth
(807181, 9542, 1, 0, 5, 1), -- Fiery Fragment of Truth
(807181, 9543, 1, 0, 5, 1), -- Icy Fragment of Truth
(807181, 9544, 1, 0, 5, 1), -- Healing Fragment of Truth
(807181, 9545, 1, 0, 5, 1), -- Hastened Fragment of Truth
(807181, 9547, 1, 0, 5, 1), -- Gelid Fragment of Truth
(807181, 9548, 1, 0, 5, 1)  -- Replenishing Fragment of Truth
ON DUPLICATE KEY UPDATE chance = VALUES(chance);

INSERT INTO loottable (id, name) VALUES
(794331, 'Lord_Inquisitor_Seru_Praesertum_Reward'),
(794332, 'Dailifyer_Plunder_Kerafyrm'),
(794333, 'Dailifyer_Plunder_Lord_Inquisitor_Seru'),
(794334, 'Dailifyer_Plunder_Zebuxoruk')
ON DUPLICATE KEY UPDATE name = VALUES(name);

INSERT INTO loottable_entries (loottable_id, lootdrop_id, multiplier, droplimit, mindrop, probability) VALUES
(794331, 807181, 1, 2, 1, 100), -- Seru with the four Praesertums alive: Fragments of Truth
(794332, 807163, 1, 2, 1, 100), -- Kerafyrm: Prismatic Scales (as in loottable 794316)
(794333, 23223,  1, 1, 0, 100), -- Seru: Glamour - 'Sword of Truth' / Black Ornate Chain Bridle (as in loottable 13516)
(794333, 807181, 1, 2, 1, 100), -- Seru: Fragments of Truth (as in loottable 794331)
(794334, 807178, 1, 3, 1, 100), -- Zebuxoruk: Splinters of Time (as in loottable 794330)
(794334, 807179, 1, 0, 0, 100)  -- Zebuxoruk: Glamour - 'Whip of the Forsaken One', Vortex of the Past (as in loottable 794330)
ON DUPLICATE KEY UPDATE multiplier = VALUES(multiplier), droplimit = VALUES(droplimit), mindrop = VALUES(mindrop), probability = VALUES(probability);

INSERT INTO spawngroup (name, spawn_limit, dist, max_x, min_x, max_y, min_y, delay, mindelay, despawn, despawn_timer, wp_spawns)
SELECT 'bazaar_Carles_Seregwyn', 1, 0, 0, 0, 0, 0, 45000, 15000, 0, 100, 0 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM spawngroup WHERE name = 'bazaar_Carles_Seregwyn');

INSERT INTO spawnentry (spawngroupID, npcID, chance)
SELECT sg.id, 1120001301, 100 FROM spawngroup sg
WHERE sg.name = 'bazaar_Carles_Seregwyn'
  AND NOT EXISTS (SELECT 1 FROM spawnentry se WHERE se.spawngroupID = sg.id AND se.npcID = 1120001301);

-- Classic Bazaar, placed in game with #spawnfix.
INSERT INTO spawn2 (spawngroupID, zone, version, x, y, z, heading, respawntime, variance, pathgrid, path_when_zone_idle, _condition, cond_value, animation)
SELECT sg.id, 'bazaar', 0, 51.30, -755.22, 3.75, 376.50, 640, 0, 0, 0, 0, 1, 0 FROM spawngroup sg
WHERE sg.name = 'bazaar_Carles_Seregwyn'
  AND NOT EXISTS (SELECT 1 FROM spawn2 s WHERE s.spawngroupID = sg.id);
)",
		.content_schema_update = true,
	},

	// Used for testing
	//	ManifestEntry{
	//		.version = 9229,
	//		.description = "new_database_check_test",
	//		.check = "SHOW TABLES LIKE 'new_table'",
	//		.condition = "empty",
	//		.match = "",
	//		.sql = R"(
	// CREATE TABLE `new_table`  (
	//  `id` int NOT NULL AUTO_INCREMENT,
	//  PRIMARY KEY (`id`)
	//);
	// CREATE TABLE `new_table1`  (
	//  `id` int NOT NULL AUTO_INCREMENT,
	//  PRIMARY KEY (`id`)
	//);
	// CREATE TABLE `new_table2`  (
	//  `id` int NOT NULL AUTO_INCREMENT,
	//  PRIMARY KEY (`id`)
	//);
	// CREATE TABLE `new_table3`  (
	//  `id` int NOT NULL AUTO_INCREMENT,
	//  PRIMARY KEY (`id`)
	//);
	//)",
	//	}
};

// see struct definitions for what each field does
// struct ManifestEntry {
// 	int         version{};     // database version of the migration
// 	std::string description{}; // description of the migration ex: "add_new_table" or "add_index_to_table"
// 	std::string check{};       // query that checks against the condition
// 	std::string condition{};   // condition or "match_type" - Possible values [contains|match|missing|empty|not_empty]
// 	std::string match{};       // match field that is not always used, but works in conjunction with "condition" values [missing|match|contains]
// 	std::string sql{};         // the SQL DDL that gets ran when the condition is true
// };
