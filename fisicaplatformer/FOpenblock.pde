class FOpenblock extends FGameObject {

  int opentimer;

  FOpenblock(float x, float y) {
    super();
    setPosition(x, y);
    setName("openblock");
    attachImage(openblock);
    setStatic(true);
  }

  void act() {
    animate();
  }

  void animate() { 
    if (isTouching("player")) {
      dooropen = true;
      opentimer = 240;
    }
    if (dooropen) {
      opentimer--;
      if (opentimer <= 0) {
        dooropen = false;
      }
    }
  }
}
