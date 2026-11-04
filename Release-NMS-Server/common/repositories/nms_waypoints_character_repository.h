#ifndef EQEMU_NMS_WAYPOINTS_CHARACTER_REPOSITORY_H
#define EQEMU_NMS_WAYPOINTS_CHARACTER_REPOSITORY_H

#pragma once

#include "../database.h"
#include "../strings.h"
#include "base/base_nms_waypoints_categories_repository.h"
#include "base/base_nms_waypoints_repository.h"
#include "base/base_nms_waypoints_default_repository.h"
#include "base/base_nms_waypoints_account_repository.h"
#include "base/base_nms_waypoints_character_repository.h"

#include "nms_waypoints_repository.h"
#include "nms_waypoints_categories_repository.h"
#include "nms_waypoints_default_repository.h"
#include "nms_waypoints_account_repository.h"

class NmsWaypointsCharacterRepository: public BaseNmsWaypointsCharacterRepository {
public:

    // Check if a character has a specific waypoint
    static bool HasWaypoint(Database& db, uint64 character_id, int32 waypoint_id) {
        auto count = Count(
            db,
            fmt::format(
                "character_id = {} AND waypoint_id = {}",
                character_id,
                waypoint_id
            )
        );

        return count > 0;
    }

    // Add a waypoint for a character (with duplicate check)
    static bool AddWaypoint(Database& db, uint64 character_id, int32 waypoint_id) {
        if (HasWaypoint(db, character_id, waypoint_id)) {
            return true; // Already has it
        }

        NmsWaypointsCharacter e = NewEntity();
        e.character_id = character_id;
        e.waypoint_id = waypoint_id;
        e.unlock_time = std::time(nullptr);

        auto result = InsertOne(db, e);
        return result.id > 0;
    }

    // Remove a waypoint from a character; false when the character did not have it
    static bool RemoveWaypoint(Database& db, uint64 character_id, int32 waypoint_id) {
        return DeleteWhere(
            db,
            fmt::format(
                "character_id = {} AND waypoint_id = {}",
                character_id,
                waypoint_id
            )
        ) > 0;
    }

    // Get all waypoint IDs for a character
    static std::vector<int32> GetWaypointIds(Database& db, uint64 character_id) {
        std::vector<int32> waypoint_ids;

        auto results = db.QueryDatabase(
            fmt::format(
                "SELECT waypoint_id FROM {} WHERE character_id = {}",
                TableName(),
                character_id
            )
        );

        if (results.Success()) {
            for (auto row = results.begin(); row != results.end(); ++row) {
                waypoint_ids.push_back(Strings::ToInt(row[0]));
            }
        }

        return waypoint_ids;
    }
};

#endif //EQEMU_NMS_WAYPOINTS_CHARACTER_REPOSITORY_H