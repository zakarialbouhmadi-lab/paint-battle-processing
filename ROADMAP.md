## 🗺️ Paint Battle Implementation Roadmap

### Phase 1: The "Gambler" Update (Mystery Boxes)

**Goal:** Introduce RNG (Random Number Generation) elements to disrupt the static flow of the game.

* 
**Box Spawner Logic**: Create a manager that triggers every $X$ seconds using the existing `Timer` class logic.


* **The "Warning" Phase**:
* When a box is slated to appear, render a low-opacity ghost image or a pulsing circle at the target `PVector` coordinates for 3 seconds.




* **Power-up Registry**:
* 
**Speed/Slow**: Modify the `PLAYERS_MAGNITUDE` variable in the `Player` class.


* 
**Size Alteration**: Dynamically change the `diameter` for a set duration, ensuring `checkCollision` scales with the new size.


* 
**Inversion**: A boolean flag in `checkControls` that swaps the `rotateLeft()` and `rotateRight()` calls.




* 
**The Paint Bomb**: A special box type that triggers a one-time `canvas.ellipse()` call with a massive diameter at the box's location.



---

### Phase 2: The "Arena" Update (Dynamic Environment)

**Goal:** Make the board itself an opponent.

* **Static Obstacles**: Add an array of `Obstacle` objects. The `checkWallCollision` logic will be expanded to check these internal boundaries, not just the screen edges.


* **Moving Bumpers**: Use `PVector` math to move obstacles. If a player hits a moving bumper, apply a modified version of the `checkCollision` impulse.


* 
**The "Shrinking Circle"**: Gradually increase the `r` (radius) offset in `ensurePlayerInBounds` to force players toward the center as the timer runs down.



---

### Phase 3: The "Pro" Update (Polish & Optimization)

**Goal:** Improve performance and user feedback.

* 
**Real-time Scoring**: The current `calculateWinner` function loops through every pixel, which is heavy. Optimization involves calculating this only once per second or using a sampling method (checking every 4th pixel) to show a live leaderboard.


* **Visual Juice**: Add "Trails" or "Particles" when a player picks up a mystery box.
* 
**Persistent Settings**: Use SQL or file-handling to save player control configurations so they don't reset every time the app starts .

