# SMWRL

I will attempt to outline how things currently work at a high level, or plan future features that will be needed.

## Perks

Things like jump height, ability to carry items, etc.

The bonus game levels (`level 00` and `level 100`, depending on level entrance number) are used to provide a place to select a choice of powerups/abilities.

The bonus game is triggered manually by `bonus_level.asm` uberasm on a per level basis. Bonus stars totaling 100 currently still will also trigger a bonus game, but this may change. I need to think about how I want this to work, i.e. on specific levels, by collecting some amount of...something, or something else entirely.

The abilities themselves are a sprite `perk.asm` that looks like a Yoshi coin. Collecting one will despawn any other sprites of the same type so that more than one cannot be collected. The end bonus game timer will also be set at this point so that the player can exit the level.

`extra_byte_1` determines which perk and graphics to use. Probably will need a value that indicates a random perk will spawn, and ideally with a specific rarity: Common, Rare, Epic, Legendary.

**TODO:** Come up with a system to classify perks with a defined probability, remove them from availability after collecting, and prevent duplicate spawns.

Upon game over, the current save file is deleted. File of interest: `tools/asar/patches/permadeath.asm`

**TODO:** To decheese, the deletion of the save file should happen immediately upon death, rather than at the game over screen. Reseting the console before actually dying is cheese that cannot be avoided (unless pausing removes a life, but I think the bad outways the good on that idea).

Probably should let retry handle what it can here.

## Autosave

**TODO**

Retry uberasm should handle this. Also disable manual save or at least don't allow "continue without save" option.

Add a saving icon (disk).

## Single player only

**TODO**

Single player Mario/Luigi select, perhaps only after unlocking. On that note, look into saving across all save files, a la Jump 1/2 costumes. Investigate how this works.

[One File, OnePlayer](https://www.smwcentral.net/?p=section&a=details&id=40641)