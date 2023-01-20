#load "module.jai";

// -----------------------------------------------------------------
//
// State Tracker is a system that allows the user to use an enum as a
// state machine and the tools to query the current status of all the
// states known by the system. Initial inspiration for the basic API of
// this system came from the game developers of Heaven's Vault, where
// their branching narritive design can query what states the given
// player is in to display the proper dialog.
//
// -----------------------------------------------------------------

#run {
    WolfQuest :: enum {
        DontKnowAboutWolf;
        KnowAboutWolf;
        SeenWolf;
        BattledWolf;
        KilledWolf;
    }

    RedRidingHood :: enum {
        HasntFoundHome;
        ToldYouAboutWolf;
        GaveYouReward;
    }

    //
    // If you try and set a quest value that isn't an enum the system will complain
    // uncomment to see the error
    // has_reached_state("DontKnowAboutWolf");

    //
    // The first time the system sees an enum value it will store it into its memory.
    // The first state of the enum will be the default state.
    //
    // Lets say that in your game you start off as an adventurer. You dont know about
    // the big bad wolf hiding in the woods. When you query the system for if the player
    // knows about the wolf, it will say 'no'
    //
    log("has_reached_state: KnowsAboutWolf: %",
        has_reached_state(WolfQuest.KnowAboutWolf)); // false

    //
    // Now you start exploring the areas around town and you run into a big wolf.
    //
    move_to_state(WolfQuest.SeenWolf);

    //
    // You run away because you're not really ready to fight the wolf. You go back
    // to town in order to gain info about the wolf. Since you've already seen the
    // wolf, you obviously know about the wolf.. so the towns'folk can have different
    // conversations with you.
    //
    log("has_reached_state: KnowsAboutWolf: %", has_reached_state(WolfQuest.KnowAboutWolf)); // true
    log("is_at_state: KnowsAboutWolf: %", is_at_state(WolfQuest.KnowAboutWolf)); // false
    log("is_at_state: SeenWolf: %", is_at_state(WolfQuest.SeenWolf)); // true

    //
    // On your quest you find a little girl dressed in red. She tells you about the big
    // bad wolf.
    //
    move_to_state(RedRidingHood.ToldYouAboutWolf);

    //
    // Now that we have two different states that sort of track the same data, but
    // for different things, we can query them both to see if you're in a specific
    // state in the system.
    //
    // Since we've seen both of these states, we're not between them...
    //
    log("is_between_state: SeenWolf .. RedRidingHood.ToldYouAboutWolf: %",
        is_between_state(WolfQuest.SeenWolf, RedRidingHood.ToldYouAboutWolf)); // false

    //
    // However, we haven't battled the wolf
    //
    log("is_between_state: BattledWolf .. RedRidingHood.ToldYouAboutWolf: %",
        is_between_state(WolfQuest.BattledWolf, RedRidingHood.ToldYouAboutWolf)); // true

    //
    // These basic state transformations should be good enough to give you a
    // decent way to letting your NPCs treat you differently based on the state
    // of the system.
    //
    // One limitation of the system is that the states are global, not per entity.
    // This hasn't been something I've needed to take on at this point, but I can
    // see if you wanted to use this for some AI and have each entity be able to track
    // their own states, it would have to be tied to some sort of entity id.
    //
}
