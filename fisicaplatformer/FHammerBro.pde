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
    throwhammer();
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
      if (player.getY() < getY()-gridsize*0.9) {
        world.remove(this);
        enemies.remove(this);
        player.setVelocity(player.getVelocityX(), -300);
      } else {
        //player.lives--;
        player.setPosition(100, 0);
      }
    }
  }

  void throwhammer() {
    if (frameCount % 80 == 0) {
      FBox h = new FBox(gridsize, gridsize);
      h.setName("hammer");
      h.setPosition(getX(), getY());
      h.attachImage(hammer);

      if (direction == R) h.setVelocity(400, -400);
      if (direction == L) h.setVelocity(-400, -400);
      
      if(isTouching("player")) {
        world.remove(this);
        player.setPosition(100,0);
      }

      h.setAngularVelocity(20);
      h.setSensor(true);
      world.add(h);
    }
  }
}
