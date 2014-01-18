/*
 * IDMT Mini-Assignment 2
 *
 * Better Tank Wars: An improved version of the
 * Tank wars games used in the assignment. 
 *  Changes included:
 *   - The game has been maded object-oriented.
 *   - Players can play simultaniously.
 *   - Multiple Projectiles can be shot at the same time.
 *   - Tanks can move on their playforms.
 *   - Screen wrapping of Projectiles being fired.
 *   - Tanks have health bars.
 * 
 * Code from the original assignment has been 
 * copied/re-coded/moved/removed as needed for the 
 * functionality of the game.
 *  
 *  Controls for tank1:
 *      a = turn cannon left
 *      d = turn cannon right
 *      s = move away from enemy tank
 *      w = move towards enemy tank
 *      g = press to start charging, release to fire a shot.
 *
 *  Controls for Tank2:
 *      Left arrow key = turn cannon right
 *      Right arrow key = turn cannon right
 *      Up arrow key = move towards enemy tank
 *      Down arrow key = move away from enemy tank
 *      0 = press to start charging, release to fire a shot.
 *
 */

// Objects
Tank tank1;
Tank tank2;
Ground ground;

// Basic information on the terrain and the tanks

float[] groundLevel;  // Y coordinate of the ground for each X coordinate
float tankDiameter = 30;  // Diameter of the tanks
float cannonLength = 20;  // How long the cannon on each tank extends
float gravity = 0.05;      // Strength of gravity

// Current state of the game

float tank1CannonAngle = PI/2, tank2CannonAngle = PI/2; // Direction the tank cannons are pointing
float tank1CannonStrength = 3, tank2CannonStrength = 3; // Strength of intended projectile launch
boolean gameOver = false;

// Keeping track of key presses

boolean keyA = false;
boolean keyD = false;
boolean keyS = false;
boolean keyW = false;
boolean keyG = false;
boolean keyUP = false;
boolean keyDOWN = false;
boolean keyLEFT = false;
boolean keyRIGHT = false;
boolean key0 = false;



void setup() {
  size(960, 480);  // Set the screen size

  // Makes the ground object
  ground = new Ground();

  // make the tanks and place them in the centre of each platform on the ground.
  tank1 = new Tank(ground.getPlatform1Pos(), ground.getPlatform1Height(), ground.platformWidth/2, color(0, 0, 255), tank1CannonAngle, tank1CannonStrength, gravity);
  tank2 = new Tank(ground.getPlatform2Pos(), ground.getPlatform2Height(), ground.platformWidth/2, color(255, 0, 0), tank2CannonAngle, tank2CannonStrength, gravity);

  // draw welcome message
  text("Ready...and...FIGHT!", width/2, 30);
}

void draw() {

  background(200);

  // if game has not finished
  // check for collisions and 
  // update player input.
  if (!gameOver) {
    checkForCollision();
    updatePlayersInput();
  }

  // draw the game components
  drawGround();
  drawTanks();
  drawStatus();
}

void drawGround() {
  ground.draw();
}

// Draw the two tanks
void drawTanks() {

  tank1.draw();
  tank2.draw();
}

void updatePlayersInput() {
  updatePlayer1Input();
  updatePlayer2Input();
}


// Draw the status text on the top of the screen
void drawStatus() {
  textSize(24);
  textAlign(CENTER);
  fill(0);

  if (tank1.health <= 0) {
    text("PLAYER 2 HAS WON!", width/2, 30);
    gameOver = true;
  }
  else if (tank2.health <= 0) {
    text("PLAYER 1 HAS WON!", width/2, 30);
    gameOver = true;
  } 
  else if (tank1.health == 0 && tank2.health == 0) {
    text("DRAW!", width/2, 30);
    gameOver = true;
  } 
  else if ((tank1.health == 100) && (tank2.health == 100))
    text("Ready...and...FIGHT!", width/2, 30);
  else  if (tank1.health > tank2.health)
    text("Player 1 has the lead!", width/2, 30);
  else if (tank1.health < tank2.health)
    text("Player 2 has the lead!", width/2, 30);
}

// check for collisions
void checkForCollision() {

  // Check if tank 1 has hit itself.
  for (int i = 0; i < tank1.projectiles.size(); i++) {
    Projectile projectile1 = tank1.projectiles.get(i);
    if (dist(projectile1.posX, projectile1.posY, tank1.posX, tank1.posY) <= tank1.tankDiameter/2) {
      // tank is hit
      // stop moving the projectile.
      projectile1.inMotion = false;
      tank1.projectiles.set(i, projectile1);

      // tell the tank it was hit
      tank1.hasBeenHit(projectile1.damage);
    }

    // check if tank 1 as hit tank 2
    if (dist(projectile1.posX, projectile1.posY, tank2.posX, tank2.posY) <= tank2.tankDiameter/2) {
      // tank is hit
      // stop moving the projectile.
      projectile1.inMotion = false;
      tank1.projectiles.set(i, projectile1);

      // tell the tank it was hit
      tank2.hasBeenHit(projectile1.damage);
    }

    // Check if projectiles from tank1 have hit eachother.
    for (int k = 0; k < tank1.projectiles.size(); k++) {
      // stops a projectile colliding with itself
      if (i != k) {
        Projectile projectile2 = tank1.projectiles.get(k);

        if (abs(dist(projectile1.posX, projectile1.posY, projectile2.posX, projectile2.posY)) < ((projectile1.diameter + projectile2.diameter)/2)) {
          // projectiles have hit - so they are stopped.
          projectile1.inMotion = false;
          projectile2.inMotion = false;
          tank1.projectiles.set(i, projectile1);
          tank1.projectiles.set(k, projectile2);
        }
      }
    }


    // check if projectiles shot from each tank have hit each other.
    for (int j = 0; j < tank2.projectiles.size(); j++) {
      Projectile projectile2 = tank2.projectiles.get(j);
      //check if the projectiles from each tank have collided together
      if (dist(projectile1.posX, projectile1.posY, projectile2.posX, projectile2.posY) <= (projectile1.diameter + projectile2.diameter)) {
        // projectiles have hit - so they are stopped.
        projectile1.inMotion = false;
        projectile2.inMotion = false;
        tank1.projectiles.set(i, projectile1);
        tank2.projectiles.set(j, projectile2);
      }
    }
  }

  // check what the projectiles from tank2 have hit
  for (int i = 0; i < tank2.projectiles.size(); i++) {
    Projectile projectile1 = tank2.projectiles.get(i);

    // check if tank2 has hit itself.
    if (dist(projectile1.posX, projectile1.posY, tank2.posX, tank2.posY) < tank2.tankDiameter/2) {
      // tank is hit
      // stop moving the projectile.
      projectile1.inMotion = false;
      tank2.projectiles.set(i, projectile1);

      // tell the tank it was hit
      tank2.hasBeenHit(projectile1.damage);
    }

    // check if tank2 has hit tank 1
    if (dist(projectile1.posX, projectile1.posY, tank1.posX, tank1.posY) <= tank1.tankDiameter/2) {
      // tank is hit
      // stop moving the projectile.
      projectile1.inMotion = false;
      tank2.projectiles.set(i, projectile1);

      // tell the tank it was hit
      tank1.hasBeenHit(projectile1.damage);
    }

    // Check if projectiles from tank2 have hit eachother.
    for (int l = 0; l < tank2.projectiles.size(); l++) {
      // stops a projectile colliding with itself
      if (i != l) {
        Projectile projectile2 = tank2.projectiles.get(l);

        if (abs(dist(projectile1.posX, projectile1.posY, projectile2.posX, projectile2.posY)) < ((projectile1.diameter + projectile2.diameter)/2)) {
          // projectiles have hit - so they are stopped.
          projectile1.inMotion = false;
          projectile2.inMotion = false;
          tank2.projectiles.set(i, projectile1);
          tank2.projectiles.set(l, projectile2);
        }
      }
    }
  }
}

// Turn the variable checking if a key has been pressed true
void keyPressed() {
  if (key == 'a')
    keyA = true;
  if (key == 'd')
    keyD = true;
  if (key == 's')
    keyS = true;
  if (key == 'w')
    keyW = true;
  if (key == 'g')
    keyG = true;  

  if (key == CODED) {
    if (keyCode == UP)
      keyUP = true;
    if (keyCode == DOWN)
      keyDOWN = true;
    if (keyCode == LEFT)
      keyLEFT = true;
    if (keyCode == RIGHT)
      keyRIGHT = true;
  }
  if ( key == '0')
    key0 = true;
}

// when a key is released the vairable tracking presses is set to false.
void keyReleased() {

  if (key == 'a')
    keyA = false;
  if (key == 'd')
    keyD = false;
  if (key == 's')
    keyS = false;
  if (key == 'w')
    keyW = false;
  if (key == 'g');
  keyG = false;

  if (key == CODED) {
    if (keyCode == UP)
      keyUP = false;
    if (keyCode == DOWN)
      keyDOWN = false;
    if (keyCode == LEFT)
      keyLEFT = false;
    if (keyCode == RIGHT)
      keyRIGHT = false;
  }
  if ( key == '0')
    key0 = false;
}

// input controls for player1's tank
void updatePlayer1Input() {
  if (keyA)
    tank1.turnCannonLeft();
  if (keyD)
    tank1.turnCannonRight();
  if (keyS)
    tank1.moveLeft();
  if (keyW)
    tank1.moveRight(); 
  if (keyG)
    tank1.chargeCannon();
  else 
    tank1.fireProjectile();
}

// input controls for player2's tank
void updatePlayer2Input() {

  if (keyLEFT)
    tank2.turnCannonLeft();
  if (keyRIGHT)
    tank2.turnCannonRight();
  if (keyDOWN)
    tank2.moveRight();
  if (keyUP)
    tank2.moveLeft();
  if (key0)
    tank2.chargeCannon();
  else 
    tank2.fireProjectile();
}


