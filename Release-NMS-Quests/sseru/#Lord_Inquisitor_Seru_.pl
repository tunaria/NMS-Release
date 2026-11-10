sub EVENT_SPAWN {
  quest::settimer(1,1);
}

sub EVENT_TIMER {
 my $x = $npc->GetX();
 my $y = $npc->GetY();
 if($timer == 1 && ($x < -353 || $x > -109 || $y < -549 || $y > -310)) {
    quest::shout("No! I must not leave the time chamber! If I do, I'll age and die!");
    $npc->GMMove(-231.464005,-432.937469,202.375946,0.25);
 }
}

# NMS: the Fragments of Truth drop only while the four Praesertums live (NMS_dailifyer_utils.pl).
# Must return 0: any other value cancels the death.
sub EVENT_DEATH {
  plugin::AddSeruPraesertumReward($npc);
  return 0;
}

sub EVENT_DEATH_COMPLETE {
  quest::stoptimer(1);
}
