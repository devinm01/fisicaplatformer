class FHammerBro extends FGameObject {

  int speed = 40;
  int direction = L;
  int frame = 0;

  FHammerBro(float x, float y) {
    super();
    setPosition(x, y);
    setName("hammerbro");
    setRotatable(false);
  }

  void act() {
    animate();
    move();
    collide();
  }

  void animate() {
    if (frame >= hammerbro.length) frame = 0;
    if (frameCount % 5 == 0) {
      if (direction == R) attachImage(hammerbro[frame]);
      if (direction == L) attachImage(reverseImage(hammerbro[frame]));
      frame++;
    }
  }

  void move() {
    float vy = getVelocityY();
    setVelocity(speed*direction, vy);
  }

  void collide() {
    if (isTouching("wall")) {
      direction *= -1;
      setPosition(getX()+direction, getY());
    }
    
    if (isTouching("player")) {
      if (player.getY() < getY()-gridSize*0.9) {
        world.remove(this);
        enemies.remove(this);
        player.setVelocity(player.getVelocityX(), -300);
      } else {
        //player.lives--;
        player.setPosition(100, 0);
      }
    }
  }
}
