#include "../client.h"

#include <bitset>

static void MulticlassSendUsage(Client *c)
{
	c->Message(Chat::White, "Usage: #multiclass list - List the classes of your target (or yourself)");
	c->Message(Chat::White, "Usage: #multiclass add [Class ID|Name|Abbreviation] - Add a class to your target (or yourself)");
	c->Message(Chat::White, "Usage: #multiclass forceadd [Class ID|Name|Abbreviation] - Same as add, even past the class limit (rule Custom:MaxPlayerClasses)");
	c->Message(Chat::White, "Usage: #multiclass remove [Class ID|Name|Abbreviation] - Remove a class from your target (or yourself)");
}

// Accepts "12", "WIZ", "Wizard", "Shadow Knight" or "shadowknight"; returns Class::None if nothing matches.
static uint8 MulticlassParseClassID(const std::string &input)
{
	if (Strings::IsNumber(input)) {
		const auto class_id = Strings::ToUnsignedInt(input);
		return EQ::ValueWithin(class_id, Class::Warrior, Class::Berserker) ? static_cast<uint8>(class_id) : Class::None;
	}

	const auto wanted = Strings::Replace(input, " ", "");
	for (uint8 class_id = Class::Warrior; class_id <= Class::Berserker; class_id++) {
		if (
			Strings::EqualFold(wanted, GetPlayerClassAbbreviation(class_id)) ||
			Strings::EqualFold(wanted, Strings::Replace(GetClassIDName(class_id), " ", ""))
		) {
			return class_id;
		}
	}

	return Class::None;
}

static void MulticlassList(Client *c, Client *t)
{
	const auto classes_bits = t->GetClassesBits();

	std::vector<std::string> class_names;
	for (uint8 class_id = Class::Warrior; class_id <= Class::Berserker; class_id++) {
		if (classes_bits & GetPlayerClassBit(class_id)) {
			class_names.emplace_back(fmt::format("{} ({})", GetClassIDName(class_id), class_id));
		}
	}

	c->Message(
		Chat::White,
		fmt::format(
			"{} {} {}/{} classes: {}.",
			c->GetTargetDescription(t, TargetDescriptionType::UCYou),
			c == t ? "have" : "has",
			class_names.size(),
			RuleI(Custom, MaxPlayerClasses),
			Strings::Join(class_names, ", ")
		).c_str()
	);
}

static void MulticlassAdd(Client *c, Client *t, uint8 class_id, bool ignore_limit)
{
	if (t->HasClass(class_id)) {
		c->Message(
			Chat::White,
			fmt::format(
				"{} already {} the {} class.",
				c->GetTargetDescription(t, TargetDescriptionType::UCYou),
				c == t ? "have" : "has",
				GetClassIDName(class_id)
			).c_str()
		);
		return;
	}

	// AddExtraClass owns the class limit, so with the checks above a failure means the limit was reached.
	if (!t->AddExtraClass(class_id, ignore_limit)) {
		c->Message(
			Chat::White,
			fmt::format(
				"{} already {} the maximum of {} classes (rule Custom:MaxPlayerClasses). Remove one first.",
				c->GetTargetDescription(t, TargetDescriptionType::UCYou),
				c == t ? "have" : "has",
				RuleI(Custom, MaxPlayerClasses)
			).c_str()
		);
		return;
	}

	const int  max_classes = RuleI(Custom, MaxPlayerClasses);
	const bool past_limit  = static_cast<int>(std::bitset<32>(t->GetClassesBits()).count()) > max_classes;

	LogInfo(
		"Class [{}] ([{}]) added by [{}] to [{}]{}",
		GetClassIDName(class_id),
		class_id,
		c->GetCleanName(),
		t->GetCleanName(),
		past_limit ? fmt::format(" past the class limit [{}]", max_classes) : ""
	);

	c->Message(
		Chat::White,
		fmt::format(
			"Added the {} class to {}{}.",
			GetClassIDName(class_id),
			c->GetTargetDescription(t),
			past_limit ? fmt::format(", past the class limit of {}", max_classes) : ""
		).c_str()
	);

	if (c != t) {
		t->Message(Chat::Yellow, fmt::format("You have gained the {} class.", GetClassIDName(class_id)).c_str());
	}

	MulticlassList(c, t);
}

static void MulticlassRemove(Client *c, Client *t, uint8 class_id)
{
	if (!t->HasClass(class_id)) {
		c->Message(
			Chat::White,
			fmt::format(
				"{} {} not have the {} class.",
				c->GetTargetDescription(t, TargetDescriptionType::UCYou),
				c == t ? "do" : "does",
				GetClassIDName(class_id)
			).c_str()
		);
		return;
	}

	// RemoveExtraClass does not guard this: an empty class bitmask is saved and breaks the character.
	if (std::bitset<32>(t->GetClassesBits()).count() <= 1) {
		c->Message(Chat::White, "Cannot remove the last class. Add another class first.");
		return;
	}

	if (!t->RemoveExtraClass(class_id)) {
		c->Message(Chat::Red, fmt::format("Failed to remove the {} class.", GetClassIDName(class_id)).c_str());
		return;
	}

	LogInfo(
		"Class [{}] ([{}]) removed by [{}] from [{}]",
		GetClassIDName(class_id),
		class_id,
		c->GetCleanName(),
		t->GetCleanName()
	);

	c->Message(
		Chat::White,
		fmt::format(
			"Removed the {} class from {}.",
			GetClassIDName(class_id),
			c->GetTargetDescription(t)
		).c_str()
	);

	if (c != t) {
		t->Message(
			Chat::Yellow,
			fmt::format(
				"You are no longer a {} and have lost the spells, disciplines, skills and abilities of that class.",
				GetClassIDName(class_id)
			).c_str()
		);
	}

	MulticlassList(c, t);
}

void command_multiclass(Client *c, const Seperator *sep)
{
	if (!RuleB(Custom, MulticlassingEnabled)) {
		c->Message(Chat::White, "Multiclassing is disabled (rule Custom:MulticlassingEnabled).");
		return;
	}

	const auto arguments = sep->argnum;
	if (!arguments) {
		MulticlassSendUsage(c);
		return;
	}

	auto t = c;
	if (c->GetTarget() && c->GetTarget()->IsClient()) {
		t = c->GetTarget()->CastToClient();
	}

	const bool is_list      = !strcasecmp(sep->arg[1], "list");
	const bool is_add       = !strcasecmp(sep->arg[1], "add");
	const bool is_force_add = !strcasecmp(sep->arg[1], "forceadd");
	const bool is_remove    = !strcasecmp(sep->arg[1], "remove");

	if (is_list) {
		MulticlassList(c, t);
		return;
	}

	if ((!is_add && !is_force_add && !is_remove) || arguments < 2) {
		MulticlassSendUsage(c);
		return;
	}

	std::string class_input = sep->argplus[2];
	Strings::Trim(class_input);

	const auto class_id = MulticlassParseClassID(class_input);
	if (class_id == Class::None) {
		c->Message(
			Chat::White,
			fmt::format("Unknown class '{}'. Use a class ID (1-16), a name or an abbreviation (WAR, CLR, WIZ, ...).", class_input).c_str()
		);
		return;
	}

	if (is_add || is_force_add) {
		MulticlassAdd(c, t, class_id, is_force_add);
	} else {
		MulticlassRemove(c, t, class_id);
	}
}
