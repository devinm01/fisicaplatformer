class FLava extends FGameObject {
  
  int lavaFrame;
  
  FLava(float x, float y, int n) {
    super();
    setPosition(x, y);
    setName("lava");
    lavaFrame = n;
    attachImage(lava[lavaFrame]);
    setStatic(true);
  }
  
  void act(){
    if (frameCount % 10 == 0)lavaFrame++;
    if (lavaFrame == numlavaframes) lavaFrame = 0;
    attachImage(lava[lavaFrame]);
  }
}
