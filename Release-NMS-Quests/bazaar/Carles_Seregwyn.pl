# NMS: Carles Seregwyn <The Dailifyer>. The challenges, their rules and the window live in
# Release-NMS-Plugins/NMS_dailifyer_utils.pl.

sub EVENT_SAY {
	plugin::DailifyerSay();
}

sub EVENT_ITEM {
	plugin::return_items(\%itemcount);
}
