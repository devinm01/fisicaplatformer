class FDoor extends FGameObject {
  
  FDoor(float x, float y){
    super();
    setPosition(x,y);
    setName("door");
    setStatic(true);
  }
  
  void act() {
    if (!dooropen) {
      attachImage(door[0]);
      setSensor(false);
    } else if (dooropen) {
      attachImage(door[1]);
      setSensor(true);
    }
  }
}
