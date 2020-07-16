# GoDotFizzle design paper

## Purpose of this document

This paper is written to describe the basic game mechanics of GoDotFizzle and explain its concepts to developers and artists.
It is not a legal text but a collection of ideas and suggestions on how to create a fun game from the basic mechanics.
Feel free to contribute to this document if you want an aspect of the game to be changed or discussed.

## GoDotFizzle basic description

GoDotFizzle is a game inspired by games like "Overcooked" and "Moving Out". Each player ( up to 4 ) controls a factory worker and has to assemble products from raw mertials and intermediate products. The player figure can move arround in the level ( including jumps ), pick and drop items and interact with things placed in the level, e.g. a workbench to assemble an item. Correctly crafted items must be placed on the conveyor belt transporting these products out of the level. Each conveyor slot leaving the level is checked for a finished product from which a score is calculated. This score is multiplied with a combo mulitpicator and then added to total score. Each level playthrought is limited by a timer. When it times out the level is completed and the total score is shown.

The graphics of GoDotFizzle shoud be comic- or cartoon-like, all items should be drawn and rendered in a simple manner.

## GoDotFizzle Basic features and mechanics

Describe basic features of the game here.

### Camera ( Game scene )

The camera shows the current level in an "overview perspective". It's static and does not follow the players.

**Future idea**: Add a static ray to camera to zoom in and out depending on player positions.

### Player movement

Players can move horizontally ( X- and Z-axis ) and jump ( Y-axis ). This allows quite complex 3D level layouts to be found. Slopes might become a technical problem to be handled.

### Item pick up and drop

Player figures use a collision area in front of them to monitor interactable objects. When a pickable item appears in this collision area, it can be picked up, carried arround and dropped elsewhere. It is possible to drop an item directly into a CraftingSpot. Items may also be thrown, their trajectory depends on the items weight and the players throwing power. CraftingSpots have a "sticky zone" to catch thrown items.

### Crafting

Items to be crafted are called RecipeItems. These items have a property to describe a collection of items from which to craft this item.

Example:
```
A "Woodplank" is a recipe item, it's crafted from a "Woodblock".
```

Crafting is done on special places - CraftingSpots. Each CraftingSpot in a level is linked to a recipe item.

Example:
```
A "Woodplank" is made from a "Woodblock" on the "Woodsaw".
```

A RecipeItem can be crafted from other RecipeItems as well as contain more than one item to be crafted from.

Example:
```
A "Woodchest" is made from "3 x Woodplank" ( made from Woodblocks ... ) and "1 x Screw" on a "Workbench".
```

### Scoring and Combos

The players score increases for each finished item from the build list. The build list shows the assembly orders to be done by the player. Each RecipeItem has a score property which is multiplied with the current combo state to calculate the score increment.

Example:

```
Current score is 50, combo state is "1.5", a RecipeItem with a score of 50 is finished - the new score is 50 + 1.5 x 50 = 125.
```

Each order from the build list is represented by a conveyor slot in the game level. The clocked conveyor belt runs continously, limiting the time for each order to be done. When an order reaches the end of the conveyor belt unfinished, the combo state is decreased ( can't fall below 1 ), if it's finished the combo state gets increased. The intention is to get a much higher score from finishing orders "in a combo" than finishing only one by a time.

### PowerUps

The current player movement profile ( speed, turning speed, throwing power ... ) can be manipulated and excahnged to implement powerup effects.

Example:
```
Drinking coffee triples your movement and turning speed and doubles your throwing power.
```

### Menus and UI

**TO BE DONE**
**Scene transition handling must be checked first!**

## GoDotFizzle Levels

Describe level aspects in detail to give ideas on how to build fun levels.

Good levels must force the player to think about the assembly process and plan its steps carefully. This will force players to communicate on their strategy to reach a maximum score, strongly depending on the player count and skill. 

Levels should not take longer than 5 Minutes to play through.

### The output conveyor belt

A conveyor belt running through the whole level. A number of conveyor slots can be found running on them, representing the assembly orders. These can be built directly on the slot or on another CraftingSpot having the same recipe. Remember that CraftingSpots have a "sticky zone", in a very difficult level the player may be forced to throw the assembled items onto this conveyor belt.

### CraftingSpots

Machines placed in the level for the player to craft items on. A CraftingSpot is linked to one RecipeItem to be crafted on it.

### ItemDispenser

Players can order raw items here by interacting with them. The number of items dispensed can be randomized, items can even be thrown out.

### PowerUp places

Players can get into a powerup state by interacting with them.

## GoDotFizzle Game progression

Describe aspects of the game progression creating long term fun / motivation.

Each level of this game should be fun for itself, nevertheless some aspects must be included to encourage multiple playthroughs of each level, making the player think "i need to get this done better!".

### Unlocking new levels

By reaching higher scores the players gets a better rating for a finished level. New levels are unlocked by overall rating collected by a player.

Unlocking level scheme by ratings may look like:
```
lvl2: Silver with any count of players in lvl#1
lvl3: ( Silver with any count of players in lvl#2 ) OR ( 1 Gold rating  )
lvl4: ( Silver with any count of players in lvl#3 ) OR ( 2 Gold ratings )
...
```

### Challenging the player

Aspects of the game that motivate to replay a level

#### Level Rating

Level rating depends on score reached **and** number of players. There are three ratings to be reached for each level: bronze, silver, gold.

Rating for first level may look like:
```
1 Player : Bronze 100, Silver 200, Gold 300
2 Players: Bronze 150, Silver 300, Gold 500
3 Players: Bronze 200, Silver 400, Gold 700
4 Players: Bronze 250, Silver 500, Gold 900
```

#### Random events

**TO BE DONE - YOUR IDEAS HERE**

### Career mode / Campaign

Unlock all levels, reach gold rating for all levels!

**Story??**

## GoDotFizzle Game experience

Describe aspects of the overall game experience, e.g. the graphics style, colors used, sound effects and overall appereance.

**TO BE DONE - YOUR IDEAS HERE**

### Items sets?

**TO BE DONE - YOUR IDEAS HERE**

### Themes?

**TO BE DONE - YOUR IDEAS HERE**
