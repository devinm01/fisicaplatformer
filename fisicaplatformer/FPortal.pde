class FPortal extends FGameObject {

  FPortal(float x, float y) {
    super();
    setPosition(x, y);
    setName("portal");
    attachImage(portalblock);
    setStatic(true);
  }

  void act() {
    teleport();
  }

  void teleport() {
    if (isTouching("player")) {
      player.setPosition(tp.getX(), tp.getY());
    }
  }
}
