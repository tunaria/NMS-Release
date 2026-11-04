#ifndef EQEMU_NMS_WAYPOINTS_ACCOUNT_REPOSITORY_H
#define EQEMU_NMS_WAYPOINTS_ACCOUNT_REPOSITORY_H

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
#include "nms_waypoints_character_repository.h"

class NmsWaypointsAccountRepository: public BaseNmsWaypointsAccountRepository {
public:

    // Check if an account has a specific waypoint
    static bool HasWaypoint(Database& db, uint64 account_id, int32 waypoint_id) {
        auto count = Count(
            db,
            fmt::format(
                "account_id = {} AND waypoint_id = {}",
                account_id,
                waypoint_id
            )
        );

        return count > 0;
    }

    // Add a waypoint for an account (with duplicate check)
    static bool AddWaypoint(Database& db, uint64 account_id, int32 waypoint_id) {
        if (HasWaypoint(db, account_id, waypoint_id)) {
            return true; // Already has it
        }

        NmsWaypointsAccount e = NewEntity();
        e.account_id = account_id;
        e.waypoint_id = waypoint_id;
        e.unlock_time = std::time(nullptr);

        return InsertOne(db, e).id > 0;
    }

    // Remove a waypoint from an account; false when the account did not have it
    static bool RemoveWaypoint(Database& db, uint64 account_id, int32 waypoint_id) {
        return DeleteWhere(
            db,
            fmt::format(
                "account_id = {} AND waypoint_id = {}",
                account_id,
                waypoint_id
            )
        ) > 0;
    }

    // Get all waypoint IDs for an account
    static std::vector<int32> GetWaypointIds(Database& db, uint64 account_id) {
        std::vector<int32> waypoint_ids;

        auto results = db.QueryDatabase(
            fmt::format(
                "SELECT waypoint_id FROM {} WHERE account_id = {}",
                TableName(),
                account_id
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

#endif //EQEMU_NMS_WAYPOINTS_ACCOUNT_REPOSITORY_H