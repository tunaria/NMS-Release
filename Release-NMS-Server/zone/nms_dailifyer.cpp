// NMS: Dailifyer challenge window (Carles Seregwyn in the Bazaar).
//
// The rules (challenges, flags, lockouts, plunder) live in Release-NMS-Plugins/NMS_dailifyer_utils.pl.
// This file only carries the window the script builds to the client, and the player's button press
// back to the script of the NPC that opened it.

#include "../common/eq_packet_structs.h"
#include "../common/rulesys.h"
#include "../common/strings.h"

#include "client.h"
#include "entity.h"
#include "npc.h"
#include "quest_parser_collection.h"

#include "nms_dailifyer.h"

#include <algorithm>

// The client allocates no list beyond this; a script sending more rows only loses the extra ones.
constexpr size_t DAILIFYER_MAX_CHALLENGES = 32;

void Client::SendDailifyerWindow(uint32 npc_id, const std::vector<DailifyerChallenge>& challenges)
{
	if (!RuleB(Custom, DailifyerEnabled)) {
		return;
	}

	const size_t count  = std::min(challenges.size(), DAILIFYER_MAX_CHALLENGES);
	auto         outapp = new EQApplicationPacket(
		OP_DailifyerWindow,
		sizeof(DailifyerWindow_Struct) + count * sizeof(DailifyerChallenge_Struct)
	);

	auto w = reinterpret_cast<DailifyerWindow_Struct*>(outapp->pBuffer);

	w->npc_id          = npc_id;
	w->challenge_count = static_cast<uint32>(count);

	const auto npc = entity_list.GetNPCByID(npc_id);
	if (npc) {
		strn0cpy(w->npc_name, npc->GetCleanName(), sizeof(w->npc_name));
	}

	for (size_t i = 0; i < count; ++i) {
		const auto& c = challenges[i];
		auto&       e = w->challenges[i];

		e.challenge_id    = c.id;
		e.status          = c.status;
		e.completed       = c.completed ? 1 : 0;
		e.lockout_seconds = c.lockout_seconds;
		strn0cpy(e.name, c.name.c_str(), sizeof(e.name));
		strn0cpy(e.objective, c.objective.c_str(), sizeof(e.objective));
	}

	FastQueuePacket(&outapp);
}

void Client::Handle_OP_DailifyerRequest(const EQApplicationPacket* app)
{
	if (app->size != sizeof(DailifyerRequest_Struct)) {
		LogError(
			"Received OP_DailifyerRequest packet. Expected size [{}], received size [{}].",
			sizeof(DailifyerRequest_Struct),
			app->size
		);
		return;
	}

	if (!RuleB(Custom, DailifyerEnabled)) {
		return;
	}

	const auto r = reinterpret_cast<const DailifyerRequest_Struct*>(app->pBuffer);

	std::string verb;
	switch (static_cast<DailifyerAction>(r->action)) {
		case DailifyerAction::Challenge:
			verb = "challenge";
			break;
		case DailifyerAction::Plunder:
			verb = "plunder";
			break;
		default:
			return;
	}

	// The window is a shortcut for talking to the NPC, not a way around it: same conditions as a
	// say reaching an NPC in Client::ChannelMessageReceived.
	auto npc = entity_list.GetNPCByID(r->npc_id);
	if (
		!npc ||
		IsInvisible(npc) ||
		npc->IsEngaged() ||
		DistanceNoZ(m_Position, npc->GetPosition()) > RuleI(Range, Say)
	) {
		Message(Chat::Red, "You are too far away to do that.");
		return;
	}

	// Delivered like a silent saylink, so the NPC's EVENT_SAY applies every rule.
	parse->EventNPC(
		EVENT_SAY,
		npc,
		this,
		fmt::format("dailifyer-{} {}", verb, r->challenge_id),
		Language::CommonTongue
	);
}
