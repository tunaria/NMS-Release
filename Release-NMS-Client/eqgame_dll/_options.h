#include "core_models.h"
#ifndef OPTIONS_H
#define OPTIONS_H

// isGammaRestoreOnCrashEnabled. When eqgame crashes, this restores your gamma. future EQ clients have this enabled.
// This also may fix eq trying to modify your gamma settings
bool isGammaRestoreOnCrashEnabled = true;

// isEQGOverrideEnabled if set to true will look for two new options files, eqg.ini and dirs.ini in eq path. This allows eqg route overriding, used by rof2plus
bool isEQGOverrideEnabled = true;

// isCpuSpeedFixEnabled was removed because of side effects. Instead check out https://github.com/xackery/eq-core-dll/releases/tag/v0.0.1 and distribute EQGraphicsDX9.dll

// isMQInjectsEnabled if set to true will cause some edge-inspired features to work:
// MQ2Spawns, MQ2Maps, MQ2Commands, MQ2Pulse, MQ2Spawns, MapPlugin, MQ2ItemDisplay, MQ2Labels
// NOT RECOMMENDED. Known to cause memory leaks due to mq2maps strings
bool isMQInjectsEnabled = true;

// isFovEnabled if set to true will enable the /fov and /camera commands for custom max zoom distance
bool isFovEnabled = true;

// isMapWindowDisabled if set to true will do a soft patch to disable the map in game. If disabled, I suggest isMQInjectsEnabled being false as well, else npc data is still populated
bool isMapWindowDisabled = false;

// areLuclinModelsDisabled if set to true disables the ability for luclin models to load, forcing classic models
bool areLuclinModelsDisabled = false;

// isBazaarWindowDisabled if set to true will disable the bazaar window in game by doing a soft patch.
bool isBazaarWindowDisabled = false;

// isHeroicDisabled if set to true will make heroic stats not display
bool isHeroicDisabled = false;

// isMaxHPFixEnabled if set to true allows hp beyond 10 million, this is a rare situation for custom servers
// It also applies fixes where hp/mana/endurance state is more believed from server than client, this can cause strange status bar reports if client is out of sync
bool isMaxHPFixEnabled = false;

// isPatchmeDisabled if set to true will let you double click eqgame.exe and not get the "Please run EverQuest" message, will start properly
bool isPatchmeDisabled = true;

// isSaylinkFixEnabled if set to true, expands the item/say-link parser from 5 to 8 digit IDs so this
// server's Bazaar/trader/quest saylinks render as clickable links instead of [00000...] garbage.
// Required for this server (stock RoF2 only parses 5-digit link IDs); leave true.
bool isSaylinkFixEnabled = true;

// isFoodDrinkSpamDisabled if set to true will stop you are hungry/thirsty messages to display on client. If server side isn't disabled, you can still get negative effects.
bool isFoodDrinkSpamDisabled = false;

// isMQ2PreventionEnabled if set to true will do basic prevention of mq2 by randomizing the version string, primitive anticheat
bool isMQ2PreventionEnabled = false;

// isSpellDataCRCEnabled if set to true will send spell data to the server as a CRC check, needs a server side modification not yet supported by eqemu master
bool isSpellDataCRCEnabled = false;

// isCombatDamageDoubleAppliedFixEnabled if set to true fixes a bug in rof2 where combat damage applied to client state is applied twice.
// it is the main cause of players falling unconsious while the server still thinks they're alive
// also can help with bouncing healthbar issues
bool isCombatDamageDoubleAppliedFixEnabled = false;

// isChecksumFixEnabled if set to true will override the normal checksum logic, if your server is not supporting checksums, can be left false
bool isChecksumFixEnabled = false;

// isOldModelHorseSupportEnabled if set to true enables horses while using old models
// quality of life for those that don't enjoy Luclin models but want their benefits
bool isOldModelHorseSupportEnabled = false;

// isAllowIllegalAugmentsEnabled if set to true will allow inserting augments which create combinations that the player cannot use.
// This allows you to bypass an error of "The result of this combine would be both NO TRADE and unusable by you.". If you don't get this error, unlikely needed.
bool isAllowIllegalAugmentsEnabled = false;

// isAAEnabledAtLvl1 if set to true will bypass the level requirements for purchasing AAs via memory patching
bool isAAEnabledAtLvl1 = true;

// isToggleSpellBookOnScribeEnabled if set to true will automatically open the spell book window when a player
// right-clicks a spell scroll to scribe it. Requires Spells:AllowSpellMemorizeFromItem=true on the server.
// Change the value in Hooks.cpp - Search for SCRIBE_DURATION_MS
bool isToggleSpellBookOnScribeEnabled = true;

// isDailifyerWindowEnabled if set to true shows the Dailifyer challenge window (NMS_DailifyerWnd.xml) when the
// server sends it (OP_DailifyerWindow 0x140A, Carles Seregwyn in the Bazaar). Requires Custom:DailifyerEnabled on the server.
bool isDailifyerWindowEnabled = true;


// **** ITEM *******

// areDefaultShieldsIgnored if set to true will ignore default shields and only honor custom shields listed
bool areDefaultShieldsIgnored = false;

// areCustomShieldsEnabled if set to true will allow the shields defined in Shields[] to be injected in game
bool areCustomShieldsEnabled = false;
static int Shields[] = {
    123,
};


// ***** NPC *******

// areCustomNPCsEnabled if set to true will allow the NPCs defined in NPCs[] to be injected in game
bool areCustomNPCsEnabled = false;

// NPC Entry:
// raceID is the index. If it's a new NPC, start at 733. You'll need to update the rule NPC:MaxRaceID
// GenderID ranges from 0 to 2 usually
// modelName is the race's shortname tag
// raceMask is a range of flags, typically using 8 is safe for most NPCs, but e.g. 1 = drivable boat, 2 = ridable boat, etc
// dbStrID if left to 1 reverts to raceID as it's ID, otherwise you can custom set one, and it'll look up dbStr for info
static NPCEntry NPCs[] = {
    // raceID, genderID, modelName, raceMask, dbStrID
    NPCEntry(0, 0, "DUMMY", 0, 0),
};

// areCustomAnimationsEnabled if set to true will allow custom animations defined in Animations[] to be injected in game
// NOTE: Must be exactly 2 or 3 characters long, e.g. "BET" or "OK", if only 2 characters, it will replace the first 2 characters of the animation
bool areCustomOldAnimationsEnabled = false;
static AnimationEntry CustomAnimations[] = {
    // originalName, replacementName
    AnimationEntry("DA", "DW"),
};

// ***** ZONE *******

// areCustomZonesEnabled if set to true will allow custom zones defined in Zones[] to be injected in game (or replaced)
bool areCustomZonesEnabled = false;

static ZoneEntry Zones[] = {
    // zoneType, zoneID, zoneShortName, zoneLongName, eqStrID, zoneFlags2, x, y, z
    ZoneEntry(0, 787, "hollows", "Darkened Hollows", 35154, 4, 0, 0, 0),
};
#endif