#include "../common/repositories/nms_waypoints_repository.h"
#include "../common/repositories/nms_waypoints_categories_repository.h"
#include "../common/repositories/nms_waypoints_default_repository.h"
#include "../common/repositories/nms_waypoints_account_repository.h"
#include "../common/repositories/nms_waypoints_character_repository.h"

#include "client.h"
#include "zone.h"
#include "dynamic_zone.h"
#include "groups.h"

#include "nms_waypoints.h"

std::vector<NmsWaypointsRepository::NmsWaypoints> &Zone::GetAllWaypoints(bool force_reload)
{
	if (force_reload || m_all_waypoints.empty())
	{
		LogWaypointsDetail("Cache Miss or Reload, Loading Waypoints for Zone");
		m_all_waypoints = NmsWaypointsRepository::All(content_db);
	}

	return m_all_waypoints;
}

const NmsWaypointsRepository::NmsWaypoints *Zone::WaypointGetSpawn(std::string zone_shortname)
{
	for (const auto &wp : GetAllWaypoints())
	{
		if (wp.shortname == zone_shortname)
		{
			return &wp;
		}
	}

	return nullptr;
}

bool Zone::SpawnWaypointNPC()
{
#define WAYPOINT_NPC_ID 26999

	auto waypoint = WaypointGetSpawn(short_name);
	auto present = entity_list.GetNPCByID(26999);

	if (!waypoint)
	{
		if (present) {
			present->Depop();
			LogWaypoints("Despawning Waypoint which is no longer configured in database.");
		}

		LogWaypointsDetail("Skipping spawning Waypoint, not required.");
		return false;
	}

	if (present)
	{
		LogWaypointsDetail("Skipping spawning Waypoint, already present.");
		return false;
	}

	glm::vec4 position = glm::vec4(waypoint->x, waypoint->y, waypoint->z, waypoint->heading);
	if (auto waypoint_npctype = content_db.LoadNPCTypesData(WAYPOINT_NPC_ID))
	{
		LogWaypointsDetail("Spawning Waypoint for zone [{}], instance [{}], version [{}]", GetShortName(), GetInstanceID(), GetInstanceVersion());
		auto waypoint_npc = new NPC(waypoint_npctype, nullptr, position, GravityBehavior::Water);
		entity_list.AddNPC(waypoint_npc, true, true);
	}

	return true;
}

std::vector<NmsWaypointsRepository::NmsWaypoints> &Client::GetUnlockedWaypoints(bool force_reload)
{
	if (!force_reload && !m_unlocked_waypoints.empty())
	{
		return m_unlocked_waypoints;
	}

	LogWaypointsDetail("Cache Miss, Loading Waypoints for Client");

	m_unlocked_waypoints.clear();

	auto all_waypoints = NmsWaypointsRepository::All(content_db);
	std::set<int32> unlocked_ids;

	// Load character or account waypoints
	const auto &waypoint_ids = AllowAccountWaypoints()
								? NmsWaypointsAccountRepository::GetWaypointIds(database, AccountID())
								: NmsWaypointsCharacterRepository::GetWaypointIds(database, CharacterID());

	unlocked_ids.insert(waypoint_ids.begin(), waypoint_ids.end());

	// Load race/class/level based defaults
	auto race_waypoints = NmsWaypointsDefaultRepository::GetWaypointIdsForCharacter(content_db, GetBaseRace(), GetClassesBits(), GetLevel());

	unlocked_ids.insert(race_waypoints.begin(), race_waypoints.end());

	// Filter unlocked waypoints
	for (const auto &wp : all_waypoints)
	{
		if (unlocked_ids.count(wp.id))
		{
			m_unlocked_waypoints.push_back(wp);
		}
	}

	return m_unlocked_waypoints;
}

bool Client::IsWaypointUnlocked(int32 waypoint_id)
{
	for (const auto &wp : GetUnlockedWaypoints())
	{
		if (wp.id == waypoint_id)
		{
			return true;
		}
	}

	return false;
}

bool Client::IsWaypointUnlocked(std::string waypoint_shortname)
{
	for (const auto &wp : GetUnlockedWaypoints())
	{
		if (wp.shortname == waypoint_shortname)
		{
			return true;
		}
	}

	return false;
}

const NmsWaypointsRepository::NmsWaypoints *Client::GetWaypoint(int waypoint_id)
{
	for (const auto &wp : GetUnlockedWaypoints())
	{
		if (wp.id == waypoint_id)
		{
			return &wp;
		}
	}

	return nullptr;
}

bool Client::UnlockWaypoint(std::string waypoint_shortname)
{
	for (const auto &waypoint : zone->GetAllWaypoints())
	{
		if (waypoint.shortname == waypoint_shortname)
		{
			return UnlockWaypoint(waypoint.id);
		}
	}

	return false;
}

bool Client::UnlockWaypoint(int32 waypoint_id)
{
	if (IsWaypointUnlocked(waypoint_id))
	{
		return false;
	}

	LogWaypointsDetail("Unlocking waypoint [{}] for [{}]", waypoint_id, GetCleanName());

	bool added = false;

	if (AllowAccountWaypoints())
	{
		added |= NmsWaypointsAccountRepository::AddWaypoint(database, AccountID(), waypoint_id);
	}
	else
	{
		added |= NmsWaypointsCharacterRepository::AddWaypoint(database, CharacterID(), waypoint_id);
	}

	if (added)
	{
		m_unlocked_waypoints.clear();
	}

	return added;
}

// Default waypoints (nms_waypoints_default) are never stored, so they cannot be forgotten: returns false for them.
bool Client::ForgetWaypoint(int32 waypoint_id)
{
	bool removed = false;

	if (AllowAccountWaypoints())
	{
		removed = NmsWaypointsAccountRepository::RemoveWaypoint(database, AccountID(), waypoint_id);
	}
	else
	{
		removed = NmsWaypointsCharacterRepository::RemoveWaypoint(database, CharacterID(), waypoint_id);
	}

	if (removed)
	{
		LogWaypointsDetail("Forgot waypoint [{}] for [{}]", waypoint_id, GetCleanName());
		m_unlocked_waypoints.clear();
	}

	return removed;
}

void Client::SendWaypointList(bool force)
{
	auto &all_waypoints = zone->GetAllWaypoints();
	auto &unlocked_waypoints = GetUnlockedWaypoints();

	std::set<int32> unlocked_ids;
	for (const auto &wp : unlocked_waypoints)
	{
		unlocked_ids.insert(wp.id);
	}

	size_t e = all_waypoints.size();
	size_t packet_size = sizeof(WaypointList_Struct) + (e * sizeof(WaypointListEntry_Struct));

	auto outapp = new EQApplicationPacket(OP_WaypointList, packet_size);

	WaypointList_Struct *wl = reinterpret_cast<WaypointList_Struct *>(outapp->pBuffer);

	wl->group_enabled = CheckWaypointGroupFeature();
	wl->expedition_enabled = (CheckWaypointGroupFeature() && GetExpedition());
	wl->group_selected = GetWaypointGroupFeatureState();
	wl->autoconfirm_selected = GetWaypointAutoTransportState();
	wl->entry_count = e;
	wl->force_show = force;

	// Interleave all waypoints with unlocked status
	for (size_t i = 0; i < e; i++)
	{
		const auto &wp = all_waypoints[i];
		WaypointListEntry_Struct &entry = wl->entries[i];

		entry.category_id = wp.category;
		entry.waypoint_id = wp.id;
		bool is_enabled = (unlocked_ids.find(wp.id) != unlocked_ids.end());
		entry.enabled = is_enabled ? 1 : 0;

		if (wp.shortname == std::string(zone->GetShortName()))
		{
			std::string modified_name = wp.long_name + " [Current Zone]";
			strncpy(entry.name, modified_name.c_str(), sizeof(entry.name) - 1);
			entry.enabled = 0;
		}
		else
		{
			strncpy(entry.name, wp.long_name.c_str(), sizeof(entry.name) - 1);
		}
		entry.name[sizeof(entry.name) - 1] = '\0';
	}

	LogWaypoints("Sent {} waypoints to client {} (Group: {}, Expedition: {})",
				 e,
				 GetName(),
				 wl->group_enabled ? "Enabled" : "Disabled",
				 wl->expedition_enabled ? "Enabled" : "Disabled");

	QueuePacket(outapp);
	safe_delete(outapp);
}

void Client::TransportToWaypoint(uint32 waypoint_id)
{
	uint32 zone_id = Zones::BAZAAR; // Default to bazaar
	uint32 instance_id = 0;
	float x = 0.0f;
	float y = 0.0f;
	float z = 0.0f;
	float h = 0.0f;
	ZoneMode zone_mode = ZoneSolicited;

	if (!waypoint_id)
	{
		if (GetExpedition())
		{
			zone_id = GetExpedition()->GetZoneID();
			instance_id = GetExpedition()->GetInstanceID();
			zone_mode = ZoneMode::ZoneToSafeCoords;

			auto safe_coords = ZoneStore::Instance()->GetZoneSafeCoordinates(zone_id, database.GetInstanceVersion(instance_id));

			x = safe_coords.x;
			y = safe_coords.y;
			z = safe_coords.z;
			h = safe_coords.w;
		}
	}
	else if (auto waypoint = GetWaypoint(waypoint_id))
	{
		x = waypoint->x;
		y = waypoint->y;
		z = waypoint->z;
		h = waypoint->heading;

		zone_mode = ZoneSolicited;
		zone_id = ZoneStore::Instance()->GetZoneID(waypoint->shortname);
	}
	else
	{
		LogDebug("Waypoint [{}] not found", waypoint_id);
		return;
	}

	LogWaypoints("Teleport to Waypoint for [{}] -> Zone: [{}], Instance: [{}], X: [{}], Y: [{}], Z: [{}], H: [{}]", GetCleanName(), zone_id, instance_id, x, y, z, h);

	auto group = GetGroup();
	if (GetWaypointGroupFeatureState() && group)
	{
		for (const auto &gm : group->members)
		{
			if (!gm || !gm->IsClient())
			{
				continue;
			}

			auto gmc = gm->CastToClient();

			if (gmc->GetWaypointAutoTransportState())
			{
				gmc->WaypointTransport(zone_id, instance_id, x, y, z, h, zone_mode);
				continue;
			}

			gmc->PromptWaypointTransport(zone_id, instance_id, x, y, z, h);
		}
		return;
	}

	if (GetWaypointAutoTransportState())
	{
		WaypointTransport(zone_id, instance_id, x, y, z, h, zone_mode);
		return;
	}

	PromptWaypointTransport(zone_id, instance_id, x, y, z, h);
}

void Client::PromptWaypointTransport(uint32 zoneID, uint32 instance_id, float x, float y, float z, float heading)
{
	if (PendingTranslocate)
		return;

	auto outapp = new EQApplicationPacket(OP_Translocate, sizeof(Translocate_Struct));
	Translocate_Struct *ts = (Translocate_Struct *)outapp->pBuffer;

	strn0cpy(ts->Caster, "The Magic Map", sizeof(ts->Caster));
	ts->SpellID = 0;

	PendingTranslocateData.spell_id = 0;
	PendingTranslocateData.zone_id = ts->ZoneID = zoneID;
	PendingTranslocateData.instance_id = instance_id;
	PendingTranslocateData.x = ts->x = x;
	PendingTranslocateData.y = ts->y = y;
	PendingTranslocateData.z = ts->z = z;
	PendingTranslocateData.heading = heading;

	ts->unknown008 = 0;
	ts->Complete = 0;

	PendingTranslocate = true;
	TranslocateTime = time(nullptr);

	QueuePacket(outapp);
	safe_delete(outapp);

	return;
}

void Client::WaypointTransport(uint32 zoneID, uint32 instance_id, float x, float y, float z, float heading, ZoneMode zm)
{
	MovePC(zoneID, instance_id, x, y, z, heading, 0, zm);
	return;
}

bool Client::AllowAccountWaypoints()
{
	// Can adjust this for Self-Found, Hardcore, etc.
	return true;
}

bool Client::GetWaypointGroupFeatureState()
{
	if (!CheckWaypointGroupFeature())
	{
		return false;
	}

	if (m_group_feature_state == -1)
	{
		std::string bucket_val = GetBucket("waypoints.group_feature_state");
		m_group_feature_state = (bucket_val == "enabled") ? 1 : 0;
	}

	return m_group_feature_state;
}

void Client::SetWaypointGroupFeatureState(bool val)
{
	m_group_feature_state = val ? 1 : 0;

	if (val)
	{
		SetBucket("waypoints.group_feature_state", "enabled");
	}
	else
	{
		SetBucket("waypoints.group_feature_state", "disabled");
	}
}

bool Client::GetWaypointAutoTransportState()
{
	if (m_auto_transport_state == -1)
	{
		std::string bucket_val = GetBucket("waypoints.auto_transport_state");
		m_auto_transport_state = (bucket_val == "enabled") ? 1 : 0;
	}

	return (m_auto_transport_state == 1);
}

void Client::SetWaypointAutoTransportState(bool val)
{
	m_auto_transport_state = val ? 1 : 0;

	if (val)
	{
		SetBucket("waypoints.auto_transport_state", "enabled");
	}
	else
	{
		SetBucket("waypoints.auto_transport_state", "disabled");
	}
}

bool Client::CheckWaypointGroupFeature()
{
	if (GetGM())
	{
		return true;
	}

	if (m_expanded_waypoints == -1)
	{
		std::string bucket_val = GetAccountBucket("waypoints.group_feature");

		if (!bucket_val.empty())
		{
			m_expanded_waypoints = 1;
		}
		else
		{
			m_expanded_waypoints = 0;
		}
	}

	return m_expanded_waypoints;
}

void Client::EnableWaypointGroupFeature()
{
	m_expanded_waypoints = 1;
	SetAccountBucket("waypoints.group_feature", "true");

	SendWaypointList(false);
}