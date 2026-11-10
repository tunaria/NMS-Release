-- ============================================================================
-- NMS content health check - verifies the DATA every custom-manifest version
-- (v18 through v26) is supposed to deliver, without trusting db_version.
--
-- Why this exists: we have now twice found servers whose custom_version was
-- stamped PAST an entry whose content never landed (a half-apply healed by a
-- later resync; a wholesale-skip healed by the v23-25 repairs). The version
-- number is a claim; this file is the audit. Every line prints its own
-- expectation - anything that misses its expected value identifies exactly
-- which payload is absent.
--
-- Run (akk-stack):
--   docker exec -i <mariadb-container> mariadb -u eqemu -p'<password>' peq \
--     < nms_content_health_check.sql
-- Or from any mysql/mariadb client: source nms_content_health_check.sql
--
-- READ-ONLY: SELECT/SHOW only. Safe on any server, any number of times.
-- ============================================================================

SELECT 'db_version (expect 26 once current)' AS what, custom_version AS value FROM db_version LIMIT 1;

-- ---- v18 / v23: Beastlord spell merchant + scrolls -------------------------
SELECT 'v23 bl merchant npc (expect 1)' AS what, COUNT(*) AS value FROM npc_types WHERE id = 1120001300;
SELECT 'v23 bl scrolls (expect 38)' AS what, COUNT(*) AS value FROM merchantlist WHERE merchantid = 1120001300;

-- ---- v18 / v24: merchant spawns --------------------------------------------
SELECT 'v24 spawngroups (expect 2)' AS what, COUNT(*) AS value FROM spawngroup WHERE name IN ('fv_Beastlord_Spell_Merchant','ot_Beastlord_Spell_Merchant');
SELECT 'v24 spawn2 rows (expect 2)' AS what, COUNT(*) AS value FROM spawn2 WHERE spawngroupID IN (SELECT id FROM spawngroup WHERE name IN ('fv_Beastlord_Spell_Merchant','ot_Beastlord_Spell_Merchant'));

-- ---- v18 / v25: data payload ------------------------------------------------
SELECT 'v25 whitelist has aa516 (expect 1)' AS what, COUNT(*) AS value FROM rule_values WHERE rule_name = 'Custom:AA339Whitelist' AND rule_value LIKE '%aa516%';
SELECT 'v25 bl GMs class (expect 34,34)' AS what, GROUP_CONCAT(class) AS value FROM npc_types WHERE id IN (93152, 84202);

-- ---- v19 / v22: factions + rules --------------------------------------------
SELECT 'v19 factions (expect 929,929,929,929)' AS what, GROUP_CONCAT(npc_faction_id) AS value FROM npc_types WHERE id IN (46016,46017,46061,46089);
SELECT 'v19 faction 2000507 (expect 79)' AS what, npc_faction_id AS value FROM npc_types WHERE id = 2000507;
SELECT 'v19 buy cost mod (expect 1.0)' AS what, rule_value AS value FROM rule_values WHERE rule_name = 'Merchant:BuyCostMod';
SELECT 'v19 db_str 15594 fixed (expect 1)' AS what, COUNT(*) AS value FROM db_str WHERE id = 15594 AND type = 4 AND value LIKE '%additional damage%';

-- ---- v20: Sateal in the Bazaar -----------------------------------------------
SELECT 'v20 sateal titled (expect 1)' AS what, COUNT(*) AS value FROM npc_types WHERE name = 'Sateal_Deirosap' AND lastname = 'Smithing Supplies';

-- ---- v21 / v22: data payload --------------------------------------------------
SELECT 'v22 bazaar cancombat (expect 0,0)' AS what, GROUP_CONCAT(cancombat) AS value FROM zone WHERE short_name = 'bazaar';
SELECT 'v22 bazaar safe_x (expect -134.13 x2)' AS what, GROUP_CONCAT(safe_x) AS value FROM zone WHERE short_name = 'bazaar';
SELECT 'v22 hastened AA (expect 1600,2000)' AS what, GROUP_CONCAT(base1) AS value FROM aa_rank_effects WHERE rank_id IN (12899,12900) AND slot = 1 AND base2 = 57;
SELECT 'v22 aa next_id (expect -1)' AS what, next_id AS value FROM aa_ranks WHERE id = 12900;
SELECT 'v22 quegmor moved (expect -76.12)' AS what, ROUND(z,2) AS value FROM spawn2 WHERE id = 14745;

-- ---- v26: Dailifyer challenges ------------------------------------------------
SELECT 'v26 carles npc (expect 1)' AS what, COUNT(*) AS value FROM npc_types WHERE id = 1120001301 AND lastname = 'The Dailifyer';
SELECT 'v26 carles spawn2 (expect 1)' AS what, COUNT(*) AS value FROM spawn2 WHERE spawngroupID IN (SELECT id FROM spawngroup WHERE name = 'bazaar_Carles_Seregwyn');
SELECT 'v26 fragments of truth (expect 12)' AS what, COUNT(*) AS value FROM lootdrop_entries WHERE lootdrop_id = 807181;
SELECT 'v26 dailifyer loottables (expect 6)' AS what, COUNT(*) AS value FROM loottable_entries WHERE loottable_id IN (794331, 794332, 794333, 794334);

-- Plunder drift: the plunder loot tables copy the bosses' roll parameters, so a change on the boss
-- side does not reach Plunder by itself (see Release-NMS-Plugins/NMS_dailifyer_utils.pl).
-- Bosses still roll the loot tables the plunder tables mirror.
SELECT 'v26 boss loottables (expect 128089:794316,159691:13516,223238:794330)' AS what,
       GROUP_CONCAT(CONCAT(id, ':', loottable_id) ORDER BY id) AS value
FROM npc_types WHERE id IN (128089, 159691, 223238);
-- Each plunder row has the same multiplier/droplimit/mindrop/probability as the boss's row.
-- Lists plunder_loottable/lootdrop pairs that drifted or lost a side.
SELECT 'v26 plunder rows matching the bosses (expect none)' AS what,
       IFNULL(GROUP_CONCAT(CONCAT(m.plunder, '/', m.lootdrop)), 'none') AS value
FROM (
	SELECT 794332 AS plunder, 794316 AS boss, 807163 AS lootdrop	-- Kerafyrm: Prismatic Scales
	UNION ALL SELECT 794333, 13516,  23223			-- Lord Inquisitor Seru: Glamour - 'Sword of Truth'
	UNION ALL SELECT 794333, 794331, 807181		-- Lord Inquisitor Seru: Fragments of Truth (Praesertum reward)
	UNION ALL SELECT 794334, 794330, 807178		-- Zebuxoruk: Splinters of Time
	UNION ALL SELECT 794334, 794330, 807179		-- Zebuxoruk: Glamour - 'Whip of the Forsaken One', Vortex of the Past
) m
LEFT JOIN loottable_entries p ON p.loottable_id = m.plunder AND p.lootdrop_id = m.lootdrop
LEFT JOIN loottable_entries b ON b.loottable_id = m.boss AND b.lootdrop_id = m.lootdrop
WHERE p.lootdrop_id IS NULL OR b.lootdrop_id IS NULL
   OR p.multiplier <> b.multiplier OR p.droplimit <> b.droplimit
   OR p.mindrop <> b.mindrop OR p.probability <> b.probability;
-- Item count of each reward lootdrop. A new item also needs adding to plunder_items in the plugin,
-- or Plunder discards it.
SELECT 'v26 reward lootdrop items (expect 23223:2,807163:15,807178:12,807179:2,807181:12)' AS what,
       GROUP_CONCAT(CONCAT(lootdrop_id, ':', n) ORDER BY lootdrop_id) AS value
FROM (SELECT lootdrop_id, COUNT(*) AS n FROM lootdrop_entries
      WHERE lootdrop_id IN (23223, 807163, 807178, 807179, 807181) GROUP BY lootdrop_id) c;
