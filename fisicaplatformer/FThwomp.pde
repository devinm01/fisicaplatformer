class FThwomp extends FGameObject {

  boolean falling, rising;

  FThwomp(float x, float y) {
    super();
    setPosition(x, y);
    setName("thwomp");
    falling = false;
    rising = false;
    setRotatable(false);
    setStatic(true);
  }

  void act() {
    move();
    animate();
    collision();
    println(falling, rising);
  }
  
  //-----------maybe use ints to make thwompmodes (waiting, falling rising) (?) idk
  // if (player.getX() - getX() thwompmode = 1 idk
  // if thwompmode = 1 then blah blah
  void move() {
    if (!falling && !rising) {
      if (abs(player.getX() - getX()) < gridSize) {
        falling = true;
        rising = false;
      }
    }
    if (falling) {
      setStatic(false);
      if (isTouching("wall")) {
        rising = true;
        falling = false;
      }
    }
    if (rising) {
      setVelocity(0, -300);
      if (isTouching("stone")) {
        setStatic(true);
        rising = false;
      }
    }
    if (!falling && !rising && (isTouching("wall"))) {
      setStatic(false);
      rising = true;
    }

    if (abs(player.getX() - getX()) < gridSize && !(player.getY() < getY() - gridSize / 1.5)) {
      rising = false;
      falling = true;
    }
  }

  void animate() {
    if (falling == false) {
      attachImage(thwomp[0]);
    } else {
      attachImage(thwomp[1]);
    }
  }

  void collision() {
    if (isTouching("player")) {
      player.setPosition(0, 0);
    }
  }
}
