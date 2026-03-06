// --- GameScreen Class ---
class GameScreen {
  final float PLAYERS_SIZE = 30, PLAYERS_MAGNITUDE = 2.5;
  Timer timer;
  Board board;
  Player[] players;
  boolean gameOver = false;
  boolean paused = false;
  Button continueButton, restartButton, menuButton;
  int[] playerAreas; // Track area covered by each player
  
  GameScreen(int numPlayers) {
    board = new Board(width, height, color(255));
    timer = new Timer(60, width - 100, 0, 100, 50);  
    timer.run();
    
    // Initialize players array based on number of players
    players = new Player[numPlayers];
    playerAreas = new int[numPlayers];
    
    for (int i = 0; i < numPlayers; i++) {
      players[i] = new Player(
        random(PLAYERS_SIZE, width - PLAYERS_SIZE),
        random(PLAYERS_SIZE, height - PLAYERS_SIZE), 
        PLAYERS_SIZE, 
        PLAYERS_MAGNITUDE, 
        menuScreen.getPlayerColor(i)
      );
    }
    
    // Initialize pause menu buttons
    continueButton = new Button(width/2, height/2 - 60, 200, 50, "Continue");
    restartButton = new Button(width/2, height/2, 200, 50, "Restart Game");
    menuButton = new Button(width/2, height/2 + 60, 200, 50, "Main Menu");
  }
  
  void update() {
    if (paused) {
      // Check for pause menu button clicks
      if (continueButton.isClicked()) {
        resumeGame();
      } else if (restartButton.isClicked()) {
        restartGame();
      } else if (menuButton.isClicked()) {
        currentState = GameState.MENU;
      }
      return;
    }
    
    if (timer.finished && !gameOver) {
      gameOver = true;
      calculateWinner();
      currentState = GameState.GAMEOVER;
      return;    
    }
    
    timer.update();
    
    // Update players and check controls for continuous rotation
    for (int i = 0; i < players.length; i++) {
      if (players[i] != null) {
        // First check controls (this allows continuous rotation)
        players[i].checkControls(
          menuScreen.playerControls[i][0], 
          menuScreen.playerControls[i][1]
        );
      }
    }
    
    // Check for collisions between players
    for (int i = 0; i < players.length; i++) {
      for (int j = i + 1; j < players.length; j++) {
        if (players[i] != null && players[j] != null) {
          checkCollision(players[i], players[j]);
        }
      }
    }
    
  // Update positions after handling collisions
    for (int i = 0; i < players.length; i++) {
      if (players[i] != null) {
        // Calculate next position
        PVector nextPosition = PVector.add(players[i].position, players[i].velocity);
        
        // Check wall collision
        if (!players[i].checkWallCollision(nextPosition)) {
          // Update position if no wall collision
          players[i].position = nextPosition;
        } else {
          // Handle wall bounce - reflect velocity based on which wall was hit
          if (nextPosition.x - players[i].diameter/2 < 0 || nextPosition.x + players[i].diameter/2 > width) {
            // Horizontal wall hit - reverse X component
            players[i].velocity.x *= -1;
          }
          if (nextPosition.y - players[i].diameter/2 < 0 || nextPosition.y + players[i].diameter/2 > height) {
            // Vertical wall hit - reverse Y component
            players[i].velocity.y *= -1;
          }
        }
        
        // Ensure player stays within bounds (safety check)
        ensurePlayerInBounds(players[i]);
        
        // Draw on canvas
        players[i].update(board.canvas);
      }
    }
  }
  
  // Keep player within screen boundaries
  void ensurePlayerInBounds(Player player) {
    float r = player.diameter / 2;
    player.position.x = constrain(player.position.x, r, width - r);
    player.position.y = constrain(player.position.y, r, height - r);
  }
  
  void checkCollision(Player p1, Player p2) {
    // Calculate distance between centers
    float distance = PVector.dist(p1.position, p2.position);
    float minDist = (p1.diameter + p2.diameter) / 2;
    
    // If players are colliding
    if (distance < minDist) {
      // Calculate collision normal (direction from p1 to p2)
      PVector normal = PVector.sub(p2.position, p1.position);
      normal.normalize();
      
      // Calculate tangent vector (perpendicular to normal)
      PVector tangent = new PVector(-normal.y, normal.x);
      
      // Separate players to prevent sticking - but with boundary checking
      float overlap = minDist - distance + 1; // Reduced extra separation
      
      // Calculate separation vectors
      PVector p1Sep = PVector.mult(normal, -overlap * 0.5f);
      PVector p2Sep = PVector.mult(normal, overlap * 0.5f);
      
      // Temporary positions for boundary checking
      PVector p1NewPos = PVector.add(p1.position, p1Sep);
      PVector p2NewPos = PVector.add(p2.position, p2Sep);
      
      // Only apply separation if it doesn't push players out of bounds
      if (!isOutOfBounds(p1NewPos, p1.diameter)) {
        p1.position.add(p1Sep);
      }
      
      if (!isOutOfBounds(p2NewPos, p2.diameter)) {
        p2.position.add(p2Sep);
      }
      
      // Calculate impact force based on velocity alignment with collision normal
      float p1VelDotNormal = PVector.dot(p1.velocity, normal);
      float p2VelDotNormal = PVector.dot(p2.velocity, normal);
      
      // Calculate impulse with moderate restitution
      float restitution = 0.9f; // Reduced for less extreme bouncing
      float impulseStrength = (p2VelDotNormal - p1VelDotNormal) * restitution;
      
      // Apply velocity changes
      PVector p1Impulse = PVector.mult(normal, impulseStrength);
      PVector p2Impulse = PVector.mult(normal, -impulseStrength);
      
      p1.velocity.add(p1Impulse);
      p2.velocity.add(p2Impulse);
      
      // Add a bit of tangential force for some "scraping" effect - reduced
      float scrapeEffect = 0.3f;
      p1.velocity.add(PVector.mult(tangent, scrapeEffect * random(-0.5f, 0.5f)));
      p2.velocity.add(PVector.mult(tangent, scrapeEffect * random(-0.5f, 0.5f)));
      
      // Apply rotational effect - adjust the rotation speed based on collision angle
      float rotationImpact = 0.2f; // Reduced for more control
      float p1RotationEffect = PVector.dot(tangent, p2.velocity) * rotationImpact;
      float p2RotationEffect = PVector.dot(tangent, p1.velocity) * rotationImpact;
      
      // Apply a small rotation based on impact
      p1.rotationOffset += p1RotationEffect;
      p2.rotationOffset += p2RotationEffect;
      
      // Maintain consistent speed
      p1.velocity.normalize().mult(PLAYERS_MAGNITUDE);
      p2.velocity.normalize().mult(PLAYERS_MAGNITUDE);
    }
  }
  
  // Helper method to check if a position is out of bounds
  boolean isOutOfBounds(PVector pos, float diameter) {
    float radius = diameter / 2;
    return (pos.x - radius < 0 || pos.x + radius > width || 
            pos.y - radius < 0 || pos.y + radius > height);
  }
  
  void render() {
    board.render();
    
    // Only show timer and players during gameplay
    if (!gameOver) {
      timer.render();
      
      for (Player p : players) {
        if (p != null)
          p.render();
      }
    } else {
      showGameOver();
    }
    
    // Show pause menu if paused
    if (paused) {
      showPauseMenu();
    }
  }
  
  void pauseGame() {
    paused = true;
    timer.pause(); // Stop the timer
  }
  
  void resumeGame() {
    paused = false;
    timer.pause(); // Resume the timer (toggling pause state)
  }
  
  void restartGame() {
    // Create a new game with the same number of players
    gameScreen = new GameScreen(players.length);
    paused = false;
  }
  
  void showPauseMenu() {
    // Darken background
    fill(0, 0, 0, 150);
    rect(0, 0, width, height);
    
    // Draw title
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(40);
    text("PAUSED", width/2, height/3 - 50);
    
    // Render buttons
    continueButton.render();
    restartButton.render();
    menuButton.render();
  }
  
  void calculateWinner() {
    // Count pixels for each player color
    board.canvas.loadPixels();
    
    for (int i = 0; i < board.canvas.pixels.length; i++) {
      color c = board.canvas.pixels[i];
      
      for (int p = 0; p < players.length; p++) {
        if (c == players[p].colour) {
          playerAreas[p]++;
        }
      }
    }
  }
  
  void showGameOver() {
    fill(0, 0, 0, 150);
    rect(0, 0, width, height);
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(50);
    text("GAME OVER", width/2, height/3);
    
    textSize(30);
    int maxArea = 0;
    int winnerIndex = 0;
    
    for (int i = 0; i < playerAreas.length; i++) {
      fill(players[i].colour);
      text("Player " + (i+1) + ": " + playerAreas[i] + " pixels", width/2, height/2 + i*40);
      
      if (playerAreas[i] > maxArea) {
        maxArea = playerAreas[i];
        winnerIndex = i;
      }
    }
    
    fill(players[winnerIndex].colour);
    textSize(40);
    text("Player " + (winnerIndex+1) + " WINS!", width/2, height*3/4);
    
    fill(255);
    textSize(20);
    text("Press ENTER to return to menu", width/2, height*7/8);
  }
}
