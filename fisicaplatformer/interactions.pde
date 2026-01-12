void keyPressed() {
  if (keyCode == UP) upkey = true;
  if (keyCode == DOWN) downkey = true;
  if (keyCode == LEFT) leftkey = true;
  if (keyCode == RIGHT) rightkey = true;
  if (key == 'w') wkey = true;
  if (key == 'a') akey = true;
  if (key == 's') skey = true;
  if (key == 'd') dkey = true;
  if (key == ' ') spacekey = true;
}

void keyReleased() {
  if (keyCode == UP) upkey = false;
  if (keyCode == DOWN) downkey = false;
  if (keyCode == LEFT) leftkey = false;
  if (keyCode == RIGHT) rightkey = false;
  if (key == 'w') wkey = false;
  if (key == 'a') akey = false;
  if (key == 's') skey = false;
  if (key == 'd') dkey = false;
  if (key == ' ') spacekey = false;
}
