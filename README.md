# SMWRL

I will attempt to outline how things currently work at a high level, or plan future features that will be needed.

## Powerups/Abilities

Things like jump height, ability to carry items, etc.

The bonus game levels (`level 00` and `level 100`, depending on level entrance number) are used to provide a place to select a choice of powerups/abilities.

The bonus game is triggered manually by `bonus_level.asm` uberasm on a per level basis. Bonus stars totaling 100 currently still will also trigger a bonus game, but this may change. I need to think about how I want this to work, i.e. on specific levels, by collecting some amount of...something, or something else entirely.

The abilities themselves are a sprite `inc_jump.asm` (currently) that looks like a Yoshi coin. Collecting one will despawn any other sprites of the same type so that more than one cannot be collected. The end bonus game timer will also be set at this point so that the player can exit the level.

TODO: Extend the sprite extra properties to have multiple abilities depending on the properties set.

TODO: Figure out how to randomize the sprites that spawn when the level loads, e.g. the options of abilities presented to the player.

## Permadeath

Upon game over, the current save file is deleted. File of interest: `tools/asar/patches/permadeath.asm`

TODO: To decheese, the deletion of the save file should happen immediately upon death, rather than at the game over screen. Reseting the console before actually dying is cheese that cannot be avoided (unless pausing removes a life, but I think the bad outways the good on that idea).