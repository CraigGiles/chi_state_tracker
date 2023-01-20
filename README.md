# State Tracker

This is a system inspired by Inkle's GDC talks for Heaven's Vault, 80
days, and Sorcery. This system will allow the game to query the states
of the system to be able to make informed decisions on how to act,
which dialog to display, or however else you may act on this
knowledge.

For a complete breakdown and example of how to use this module, look
into the 'example.jai' and compile it using `jai example.jai` command.

One limitation to the system that isn't outlined in the example.jai is
the lack of serializing the state of the system so it can be saved and
restored. Because the games I've made up to this point haven't needed
this functionality, it just hasn't been created. It is on the roadmap
for my current project and will be added at a later date.
