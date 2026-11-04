#include "../client.h"
#include "../zone.h"
#include "../../common/content/world_content_service.h"
#include "../../common/zone_store.h"

#include <algorithm>
#include <cctype>
#include <map>

// Returned by MapGetWaypointExpansion when the waypoint's zone is not in the zone table.
constexpr int MAP_UNKNOWN_EXPANSION = -1;

// Expansion keywords accepted by #map, mapped to zone.expansion.
static const std::map<std::string, int> MAP_EXPANSION_KEYWORDS = {
	{ "classic", Expansion::Classic },
	{ "kunark",  Expansion::TheRuinsOfKunark },
	{ "rok",     Expansion::TheRuinsOfKunark },
	{ "velious", Expansion::TheScarsOfVelious },
	{ "sov",     Expansion::TheScarsOfVelious },
	{ "luclin",  Expansion::TheShadowsOfLuclin },
	{ "sol",     Expansion::TheShadowsOfLuclin },
	{ "power",   Expansion::ThePlanesOfPower },
	{ "pop",     Expansion::ThePlanesOfPower },
	{ "discord", Expansion::GatesOfDiscord },
	{ "god",     Expansion::GatesOfDiscord },
	{ "omens",   Expansion::OmensOfWar },
	{ "oow",     Expansion::OmensOfWar },
};

// The waypoints selected by a #map argument, and how to name them in messages.
struct MapSelection {
	std::string label;
	bool        is_single_zone = false;
	std::vector<NmsWaypointsRepository::NmsWaypoints> waypoints;
};

// Short names of the waypoints a #map add/remove went through, grouped by outcome.
struct MapResult {
	std::vector<std::string> changed;   // unlocked (add) or removed (remove)
	std::vector<std::string> unchanged; // already unlocked (add) or not unlocked (remove)
	std::vector<std::string> defaults;  // remove only: default waypoints, which cannot be removed
	std::vector<std::string> failed;    // add only: the insert failed
};

static void MapSendUsage(Client *c)
{
	c->Message(Chat::White, "Usage: #map add [Zone Short Name|Expansion|all] - Unlock waypoints for the account of your target (or yourself)");
	c->Message(Chat::White, "Usage: #map remove [Zone Short Name|Expansion|all] - Remove waypoints from the account of your target (or yourself)");
	c->Message(Chat::White, "Expansions: classic, kunark|rok, velious|sov, luclin|sol, power|pop, discord|god, omens|oow");
}

// The Legacy of Ykesha zones (dulak, gunthak, chardokb) count as Kunark: the progression atlas in
// NMS_progression_utils.pl opens them with the Ruins of Kunark stage.
static int MapGetWaypointExpansion(const NmsWaypointsRepository::NmsWaypoints &waypoint)
{
	const auto z = ZoneStore::Instance()->GetZone(waypoint.shortname);
	if (!z) {
		return MAP_UNKNOWN_EXPANSION;
	}

	if (z->expansion == Expansion::TheLegacyOfYkesha) {
		return Expansion::TheRuinsOfKunark;
	}

	return z->expansion;
}

// Accepts "all", an expansion keyword or a zone short name; keywords win over zone short names
// ("discord" is also Korafax, which has no waypoint).
static MapSelection MapSelect(const std::string &input)
{
	MapSelection selection;
	const auto &all_waypoints = zone->GetAllWaypoints();

	if (input == "all") {
		selection.label     = "all expansions";
		selection.waypoints = all_waypoints;
		return selection;
	}

	const auto keyword = MAP_EXPANSION_KEYWORDS.find(input);
	if (keyword != MAP_EXPANSION_KEYWORDS.end()) {
		selection.label = Expansion::ExpansionName[keyword->second];
		for (const auto &wp : all_waypoints) {
			if (MapGetWaypointExpansion(wp) == keyword->second) {
				selection.waypoints.push_back(wp);
			}
		}
		return selection;
	}

	for (const auto &wp : all_waypoints) {
		if (wp.shortname == input) {
			selection.label          = fmt::format("{} ({})", wp.long_name, wp.shortname);
			selection.is_single_zone = true;
			selection.waypoints.push_back(wp);
			break;
		}
	}

	return selection;
}

// Sends "<title> (<count>): a, b, c." when there is anything to list.
static void MapSendList(Client *c, uint16 type, const std::string &title, const std::vector<std::string> &names)
{
	if (names.empty()) {
		return;
	}

	c->Message(type, fmt::format("{} ({}): {}.", title, names.size(), Strings::Join(names, ", ")).c_str());
}

static void MapAdd(Client *c, Client *t, const MapSelection &selection)
{
	MapResult r;
	for (const auto &wp : selection.waypoints) {
		if (t->IsWaypointUnlocked(wp.id)) {
			r.unchanged.push_back(wp.shortname);
		} else if (t->UnlockWaypoint(wp.id)) {
			r.changed.push_back(wp.shortname);
		} else {
			r.failed.push_back(wp.shortname);
		}
	}

	if (!r.changed.empty()) {
		LogInfo(
			"Waypoints [{}] unlocked by [{}] for [{}] (account [{}])",
			Strings::Join(r.changed, ", "),
			c->GetCleanName(),
			t->GetCleanName(),
			t->AccountID()
		);

		// Same text as walking into a waypoint (global/#TPTriggerN.pl).
		t->Message(
			Chat::Emote,
			r.changed.size() == 1 ?
			"This place seems familiar. You are sure to remember it later." :
			"These places seem familiar. You are sure to remember them later."
		);
	}

	if (selection.is_single_zone) {
		if (!r.changed.empty()) {
			c->Message(Chat::White, fmt::format("Unlocked the waypoint to {} for {}.", selection.label, c->GetTargetDescription(t)).c_str());
		} else if (!r.unchanged.empty()) {
			c->Message(
				Chat::White,
				fmt::format(
					"{} already {} the waypoint to {}.",
					c->GetTargetDescription(t, TargetDescriptionType::UCYou),
					c == t ? "have" : "has",
					selection.label
				).c_str()
			);
		} else {
			c->Message(Chat::Red, fmt::format("Failed to unlock the waypoint to {} for {}.", selection.label, c->GetTargetDescription(t)).c_str());
		}
		return;
	}

	if (r.changed.empty() && r.failed.empty()) {
		c->Message(
			Chat::White,
			fmt::format(
				"{} already {} every waypoint of {}.",
				c->GetTargetDescription(t, TargetDescriptionType::UCYou),
				c == t ? "have" : "has",
				selection.label
			).c_str()
		);
		return;
	}

	MapSendList(c, Chat::White, fmt::format("Unlocked waypoints of {} for {}", selection.label, c->GetTargetDescription(t)), r.changed);
	MapSendList(c, Chat::White, "Already unlocked", r.unchanged);
	MapSendList(c, Chat::Red, "Failed to unlock", r.failed);
}

static void MapRemove(Client *c, Client *t, const MapSelection &selection)
{
	MapResult r;
	for (const auto &wp : selection.waypoints) {
		if (!t->IsWaypointUnlocked(wp.id)) {
			r.unchanged.push_back(wp.shortname);
		} else if (t->ForgetWaypoint(wp.id) && !t->IsWaypointUnlocked(wp.id)) {
			r.changed.push_back(wp.shortname);
		} else {
			// Still unlocked after removing the stored row: it comes from nms_waypoints_default.
			r.defaults.push_back(wp.shortname);
		}
	}

	if (!r.changed.empty()) {
		LogInfo(
			"Waypoints [{}] removed by [{}] from [{}] (account [{}])",
			Strings::Join(r.changed, ", "),
			c->GetCleanName(),
			t->GetCleanName(),
			t->AccountID()
		);

		if (c != t) {
			t->Message(
				Chat::Yellow,
				r.changed.size() == 1 ?
				"You no longer remember the way to a place you once visited." :
				"You no longer remember the way to places you once visited."
			);
		}
	}

	if (selection.is_single_zone) {
		if (!r.changed.empty()) {
			c->Message(Chat::White, fmt::format("Removed the waypoint to {} from {}.", selection.label, c->GetTargetDescription(t)).c_str());
		} else if (!r.defaults.empty()) {
			c->Message(Chat::White, fmt::format("The waypoint to {} is a default waypoint and cannot be removed.", selection.label).c_str());
		} else {
			c->Message(
				Chat::White,
				fmt::format(
					"{} {} not have the waypoint to {}.",
					c->GetTargetDescription(t, TargetDescriptionType::UCYou),
					c == t ? "do" : "does",
					selection.label
				).c_str()
			);
		}
		return;
	}

	if (r.changed.empty()) {
		c->Message(Chat::White, fmt::format("No waypoint of {} was removed from {}.", selection.label, c->GetTargetDescription(t)).c_str());
	}

	MapSendList(c, Chat::White, fmt::format("Removed waypoints of {} from {}", selection.label, c->GetTargetDescription(t)), r.changed);
	MapSendList(c, Chat::White, "Default waypoints, cannot be removed", r.defaults);
	MapSendList(c, Chat::White, "Not unlocked", r.unchanged);
}

void command_map(Client *c, const Seperator *sep)
{
	if (sep->argnum < 2) {
		MapSendUsage(c);
		return;
	}

	const bool is_add    = !strcasecmp(sep->arg[1], "add");
	const bool is_remove = !strcasecmp(sep->arg[1], "remove");
	if (!is_add && !is_remove) {
		MapSendUsage(c);
		return;
	}

	// Zone short names and keywords are alphanumeric; anything else is never echoed back, since
	// Client::Message treats its text as a printf format.
	const auto input = Strings::ToLower(sep->arg[2]);
	if (!std::all_of(input.begin(), input.end(), [](unsigned char ch) { return std::isalnum(ch) || ch == '_'; })) {
		MapSendUsage(c);
		return;
	}

	const auto selection = MapSelect(input);
	if (selection.waypoints.empty()) {
		c->Message(
			Chat::White,
			fmt::format(
				"No waypoint exists for '{}'. Use a zone short name, an expansion (classic, kunark|rok, velious|sov, luclin|sol, power|pop, discord|god, omens|oow) or all.",
				input
			).c_str()
		);
		return;
	}

	auto t = c;
	if (c->GetTarget() && c->GetTarget()->IsClient()) {
		t = c->GetTarget()->CastToClient();
	}

	if (is_add) {
		MapAdd(c, t, selection);
	} else {
		MapRemove(c, t, selection);
	}
}
