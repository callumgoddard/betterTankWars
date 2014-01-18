class Projectile {

  // ******** variables ********
  float posX, posY; // centre coordinate possitions of the projectile
  float velocityX, velocityY;
  float gravity;
  float diameter = 8; // size of the projectile
  float damage = 10; // the damage the proejectile does when it hits a tank.
  boolean inMotion = false;
  color c;

  // ******** Constructor ********

  Projectile (float startPosX, float startPosY, float startVelocityX, float startVelocityY, float g, color tankColour) {
    posX = startPosX;
    posY = startPosY;
    velocityX = startVelocityX;
    velocityY = startVelocityY;
    gravity = g;
    c = tankColour;
  }


  // ******** Functions ********

  void draw() {
    if (!inMotion)  // Don't draw anything if there's no projectile in motion
        return;
    noStroke();
    fill(c);
    ellipse(posX, posY, diameter, diameter);
  }

  void update() {
    if (!inMotion)
      return;


    // if projectile goes off the screen warp it round so that it appears on the other side.
    if ((int)posX < 0)
      posX = width;

    if ((int)posX > width)
      posX = 0;  

    // update the projectiles position
    posX -= velocityX;
    posY -= velocityY;

    // update gravity variable.
    velocityY -= gravity;

    // check for collisions with the ground.
    checkGroundCollisions();
  }

  void checkGroundCollisions() {
    // stop out of bound exceptions
    // when checking the ground array
    if ((int)posX > 0) {
      if ((int)posX < width) {
        // check which projectiles have hit the ground.
        // if it has stop the projectile.
        if (posY >= ground.groundLevel[(int)posX]) 
          inMotion = false;
      }
    }
  }
}

