#include "../client.h"

void command_resetaa_timer(Client *c, const Seperator *sep)
{
	const auto arguments = sep->argnum;
	if (!arguments) {
		c->Message(Chat::White, "Usage: #resetaa_timer all - Reset all Alternate Advancement timers");
		// NMS: takes the AA ID that #find aa shows; with dynamic AA timers a timer ID differs per character
		c->Message(Chat::White, "Usage: #resetaa_timer [AA ID] - Reset one Alternate Advancement timer (AA ID from #find aa)");
		return;
	}

	auto t = c;
	if (c->GetTarget() && c->GetTarget()->IsClient()) {
		t = c->GetTarget()->CastToClient();
	}

	const bool is_all = !strcasecmp(sep->arg[1], "all");

	if (is_all) {
		c->Message(
			Chat::White,
			fmt::format(
				"Reset all Alternate Advancement timers for {}.",
				c->GetTargetDescription(t)
			).c_str()
		);

		t->ResetAlternateAdvancementTimers();

		return;
	} else if (sep->IsNumber(1)) {
		// NMS: the argument is an AA (rank) ID, and the reply says whether there was a timer to reset
		const auto rank_id = Strings::ToInt(sep->arg[1]);
		const auto rank    = zone->GetAlternateAdvancementRank(rank_id);
		if (!rank || !rank->base_ability) {
			c->Message(
				Chat::White,
				fmt::format(
					"AA {} does not exist. Use #find aa [name] to get its ID.",
					rank_id
				).c_str()
			);
			return;
		}

		if (!t->ResetAlternateAdvancementTimer(rank_id)) {
			c->Message(
				Chat::White,
				fmt::format(
					"No timer to reset for AA {} ({}) on {}.",
					rank_id,
					rank->base_ability->name,
					c->GetTargetDescription(t)
				).c_str()
			);
			return;
		}

		c->Message(
			Chat::White,
			fmt::format(
				"Reset the timer of AA {} ({}) for {}.",
				rank_id,
				rank->base_ability->name,
				c->GetTargetDescription(t)
			).c_str()
		);
	}
}
