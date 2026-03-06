### Project Documentation: "Paint Battle"

**Overview**
"Paint Battle" is a local multiplayer game where 2 to 4 players compete to cover the largest area of a 1200x800 canvas with their specific color . Players move continuously and can only control their direction by rotating left or right.

**Core Components & Architecture**

**Game States**: The project uses an `enum` to manage three distinct states: `MENU`, `PLAYING`, and `GAMEOVER`.
 
**Menu & Customization**: The `MenuScreen` class handles player count selection (2-4 players) and allows for fully customizable keyboard controls for each player.
 
**Game Logic (`GameScreen`)**: This class manages the session, including initializing players, checking for collisions, updating the countdown timer, and calculating the final pixel count for each color at the end of the match.

**Player Mechanics**:
 
**Movement**: Players have a constant velocity magnitude and move continuously.
 
**Painting**: As players move, they draw ellipses of their color directly onto a `PGraphics` canvas.
 
**Physics**: Includes circle-to-circle collision detection with restitution (bouncing) and rotational impact when players collide.
 
**Board & UI**: The `Board` class manages the `PGraphics` drawing layer , while a generic `Button` class handles UI interactions in the menus.

**Check out ROADMAP.md to see the upcoming features, including Mystery Boxes and Dynamic Arenas !!!**

