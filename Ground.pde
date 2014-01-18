class Ground {

  // ******** variables ********
  float platform1Height;
  float platform2Height;
  float platform1MidXCoord;
  float platform2MidXCoord;
  float[] groundLevel;
  float platformWidth;

  // ******** Constructor ********
  Ground() {

    // sets each platform to a random height.
    platform1Height = random(height/2, height-5);
    platform2Height = random(height/2, height-5);

    platformWidth = random(0.1, 0.2);

    // Initialize the ground level
    groundLevel = new float[width];

    // due to having the screen loop
    // platform positions need to be set
    // equally appart, but the screen is setup
    // to be asymetrical. This randomises the visual asymetry.
    // the platforms will always start 1/2 a screen width apart from
    // each other.

    // Makes a random int from 1 to 4.
    // converts it to a random float between 0.1 and 0.4
    int x = (int)random(1, 5);
    float platform1PosX = platformWidth/2 * (float)x;
    float platform2PosX = platform1PosX + 0.5;

    // sets platform 1 and platform 2 x coordinate positions
    platform1MidXCoord = width*platform1PosX;
    platform2MidXCoord = width*(platform1PosX+0.5);

    //println(platform1MidXCoord);

    // set all values in the gorundLevel array to max.
    for (float i = 0; i < width; i++) {
      groundLevel[(int)i] = height;
    }

    // calculates and sets the values for platforms 1 to the right height.
    for (float i = width*(platform1PosX - platformWidth/2) ; i < width * (platform1PosX + platformWidth/2); i++) {
      groundLevel[(int)i] = platform1Height;
    }

    // calculates and sets the values for platforms 1 to the right height.
    for (float i = width *(platform2PosX - platformWidth/2); i < width *(platform2PosX + platformWidth/2); i++) {
      groundLevel[(int)i] = platform2Height;
    }  


    // fill in the areas between the two platforms
    // with a slope connecting them.
    for (float i = width * (platform1PosX + platformWidth/2); i < width * (platform2PosX - platformWidth/2); i++) {
      groundLevel[(int)i] = platform1Height + (platform2Height - platform1Height) * (i - width*(platform1PosX + platformWidth/2))/(width*((platform2PosX - platformWidth/2) - (platform1PosX + platformWidth/2)));
    }

    // works out the distance from right edge of platform 2 to the left edge of platform 1 (assuming continous screen)
    // then iterates over that distance.
    for (float i = 0; i < (width - width*(platform2PosX + platformWidth/2) + width*(platform1PosX - platformWidth/2)); i++) {

      // calculate the index value from the offset
      // accounting for the fact that it will loop
      // back to the start.
      float indexOffset = width*(platform2PosX + platformWidth/2); 
      float index = (i + indexOffset );
      
      // calculate correct ground levels.
      //groundLevel[(int)index] = platform2Height + (platform1Height - platform2Height) * index;

      groundLevel[(int)index % width] = platform2Height + (platform1Height - platform2Height) * (index - width*(platform2PosX + platformWidth/2))/ (width - width*(platform2PosX + platformWidth/2) + width*(platform1PosX - platformWidth/2));
    }
  } 


  // ******** Functions ********
  void draw() {

    // Uses a for loop to run through the groundLevel matrix
    // and draw a line at each x coordinate that is the height
    // of the value specified by the groundLevel value.

    stroke(100);
    for (int i = 0; i < width; i++) {
      line(i, height, i, groundLevel[i]);
    }
  }

  float getPlatform1Pos() {
    return platform1MidXCoord;
  }

  float getPlatform1Height() {
    return platform1Height;
  }


  float getPlatform2Pos() {
    return platform2MidXCoord;
  }

  float getPlatform2Height() {
    return platform2Height;
  }
}

