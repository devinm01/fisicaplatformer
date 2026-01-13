class FPlayer extends FGameObject {

  int frame;
  int direction;

  FPlayer() {
    super();
    direction = R;
    setPosition(100, 0);
    setName("player");
    setRotatable(false);
    setFillColor(red);
  }

  void act() {
    handleInput();
    collisions();
    animate();
  }

  void handleInput() {
    float vy = getVelocityY();
    float vx = getVelocityX();
    if (abs(vy) < 0.1) {
      action = idle;
    }
    if (akey) {
      setVelocity(-250, vy);
      action = run;
      direction = L;
    }
    if (dkey) {
      setVelocity(250, vy);
      action = run;
      direction = R;
    }
    if (wkey) setVelocity(vx, -400);
    if (abs(vy) > 0.1) {
      action = jump;
    }
  }

  void collisions() {
    if (isTouching("spike")) {
      setPosition(0, 0);
    }
    if (isTouching("lava")) {
      setPosition(0, 0);
    }
  }

  void animate() {
    if (frame >= action.length) frame = 0;
    if (frameCount % 5 == 0) {
      if (direction == R) attachImage(action[frame]);
      if (direction == L) attachImage(reverseImage(action[frame]));
      frame++;
    }
  }
}
