class Tank {

  // ******** variables ********

  float posX;   // X coordinate of the centre position of the tank
  float posY;   // X coordinate of the centre position of the tank
  float platformMiddle;
  float platformWidth;
  float tankDiameter = 30;
  float cannonLength = 20;
  float cannonAngle = PI/2;
  float cannonStrength = 3;
  float gravity;
  float tankSpeed;
  float maxCannonStrenght = 10;
  float health = 100;

  boolean cannonLoaded = false;

  color c;


  // makes an array to store the projectiles.
  ArrayList<Projectile> projectiles;
  Projectile projectile;



  // ******** Constructor ********
  Tank(float startPosX, float startPosY, float platformWidth, color tankColor, float startAngle, float startStrength, float g) {
    // update class variables.
    platformMiddle = startPosX;
    posX = startPosX;
    posY = startPosY;
    c = tankColor;    
    cannonAngle = startAngle;
    cannonStrength = startStrength;
    gravity = g;
    platformWidth = platformWidth;
    tankSpeed = 7.5;
    
    // initialize the projectile array.
    projectiles = new ArrayList<Projectile>();
  } 


  // ******** Functions ********

  void draw() {

    // if tank has health it is drawn;
    if (health > 0) {

      // draws the main body of the tank
      noStroke();
      fill(c);
      arc(posX, posY, tankDiameter, tankDiameter, PI, 2*PI);

      // draws the cannon of the tank.
      strokeWeight(3);
      stroke(c);
      // Y value offset by tankDiameter/4 to position the cannon in the centre of the drawn tank.
      line(posX, posY-(tankDiameter/4), posX-cannonLength*cos(cannonAngle), posY-(tankDiameter/4)-cannonLength*sin(cannonAngle));
      strokeWeight(1); // stroke weight reset.

      // Iterates through each projectile shot by the tank.
      // retrives the projectile, draws it, updates it
      // then returns it to the projectiles ArrayList
      // unless the projectile is not moving
      // then it is removed from the array.
      for (int i = 0; i < projectiles.size(); i++) {
        projectile = projectiles.get(i);
        if (!projectile.inMotion) {
          projectiles.remove(i);
        }
        else {
          projectile.draw();
          projectile.update();
          projectiles.set(i, projectile);
        }
      }

      // display health bar
      displayHealthBar();
    }
  }  

  void chargeCannon() {
    // loads the cannon and starts
    // charging up the strength of the shot.
    cannonLoaded = true;
    cannonStrength += 0.25;

    // sets a maximum to the cannon strength
    if (cannonStrength >= 10)
      cannonStrength = 10;
  }

  void fireProjectile() {

    // Only fire the Cannon if it has been loaded.
    if (cannonLoaded) {
      // works out the coordinates for
      // where the end of the cannon is
      float endOfCannonX = posX-cannonLength*cos(cannonAngle);
      float endOfCannonY = posY-(tankDiameter/4)-cannonLength*sin(cannonAngle);

      float startVelocityX = cos(cannonAngle)*cannonStrength;
      float startVelocityY = sin(cannonAngle)*cannonStrength;

      // make a new projectile drawn 
      // at the end of the tank cannon
      // set it to be in motion
      // add it to the projectiles ListArray
      projectile = new Projectile(endOfCannonX, endOfCannonY, startVelocityX, startVelocityY, gravity, c);
      projectile.inMotion = true;
      projectiles.add(projectile);

      // reset cannonStrength
      cannonStrength = 3.0;
      cannonLoaded = false;
    }
  } 

  void moveLeft() {    

    // stop out of bound exception
    if (posX-tankDiameter/2 > 0) {
      // stop tank going off of its platform
      if ((posY) == ground.groundLevel[(int)(posX-tankDiameter/2)]) {
        posX -= tankSpeed;
      }
    }
  }

  void moveRight() {

    // stop tank going off of its platform
    if (posX + tankDiameter/2 < width) {
      if ((posY) == ground.groundLevel[(int)(posX+tankDiameter/2)]) {
        posX += tankSpeed;
      }
    }
  }

  void turnCannonLeft() {
    // moves the cannon left.
    cannonAngle -= PI/90;
    // if the cannon goes below the ground undo the cannon move.
    if (posY-(tankDiameter/4)-cannonLength*sin(cannonAngle) > ground.groundLevel[(int)(posX-cannonLength*cos(cannonAngle))%width])
      cannonAngle += PI/90;
  }

  void turnCannonRight() {
    // moves the cannon right.
    cannonAngle += PI/90;
    // if the cannon goes below the ground undo the cannon move.
    if (posY-(tankDiameter/4)-cannonLength*sin(cannonAngle) > ground.groundLevel[(int)(posX-cannonLength*cos(cannonAngle))%width])
      cannonAngle -= PI/90;
  }

  void hasBeenHit(float damage) {
    health -= damage; 
    if (health <= 0)
      health = 0;
  }

  void displayHealthBar() {
    pushMatrix();
    // centre on tank.
    translate(posX, posY);
    // set drawing conditions
    noStroke();
    fill(0, 255, 0);
    rectMode(RADIUS);

    // make Health bar below the tank
    // and the width in proportion to the 
    // tank's health.
    rect(0, 5, 0.3 * health, 2.5);
    popMatrix();
  }
}

