# SMWRL

I will attempt to outline how things currently work at a high level, or plan future features that will be needed.

## Perks

Things like jump height, ability to carry items, additional lives, etc.

The bonus game levels (`level 00` and `level 100`, depending on level entrance number) are used to provide a place to select a choice of powerups/abilities. This will change: see the How it works section.

### Current Perks

- 00: Enable all jumps (rare) - the intent is to start out with only one at random
- 01: Increase normal jump height (common)
- 02: Increase spin jump height (common)
- 03: Increase boost height - (height gained from stomping on an enemy)
- 04: Ability to carry items (rare)
- 05: 1up (rare)
- 06: 3up (epic)

Rarity is not programmed yet.

### How it works

The bonus game is triggered on each every level by `uberasm/rogue/level.asm`. May move this back into a per level basis. I may have different bonus rooms that are determined by level type, e.g. a castle may give more rare perks than a regular level. I need to think about how I want this to work, i.e. on specific levels, by collecting some amount of...something, or something else entirely.

**TODO:** Bonus stars totaling 100 currently still will also trigger a bonus game, but this should be removed.

The abilities themselves are a sprite `perk.asm` that looks like a Yoshi coin. Collecting one will despawn any other sprites of the same type so that more than one cannot be collected. The end bonus game timer will also be set at this point so that the player can exit the level.

**TODO:** Rework graphics from Yoshi coins into 16x16 with orb sparkle and rarity colors.

`extra_byte_1` determines which perk and graphics to use. Probably will need a value that indicates a random perk will spawn, and ideally with a specific rarity: Common, Rare, Epic, Legendary.

**TODO:** Come up with a system to classify perks with a defined probability, remove them from availability after collecting, and prevent duplicate spawns.

**TODO:** Prevent Yoshi from eating perks without it. Currently it gives a one up, but it should either not be able to be eaten, or should give the perk inside.

## Permadeath

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

## Other

Need to make lives more rare. Remove lives from enemy streaks. Maybe remove coins from giving lives or otherwise just place very few coins.