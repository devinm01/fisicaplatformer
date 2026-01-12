import fisica.*;
FWorld world;
//---------------------TIMESTAMP VIDEO 10a; 3:17
color red = #FF0000;
color white = #FFFFFF;
color black = #000000;
color blueice = #0af3ff;
color treebrown = #ad6500;
color treegreen = #58d627;
color purple = #ad03ad;
color yellow = #ffd106;
color orange = #ff7a06;
color redlava = #ff0606;
color wall = #7d7d7d;
color goomba = #00ffbf;

//terrain images
PImage map, ice, stone, treetrunk, treetopintersect, treetopcenter, treetopl, treetopr;
PImage bridge, spike, trampoline;

int gridSize = 32;
float zoom = 1.5;

boolean upkey, downkey, leftkey, rightkey, wkey, akey, skey, dkey, spacekey;

ArrayList<FGameObject> terrain;
ArrayList<FGameObject> enemies;
FPlayer player;

PImage[] lava;
//images for character animations
PImage[] idle, jump, run, action;

int  numlavaframes;

void setup() {
  size(600, 600);
  Fisica.init(this);
  terrain = new ArrayList<FGameObject>();
  map = loadImage("terrainmap1.png");
  
  //lava code---------------------------------
  numlavaframes = 6;
  lava = new PImage[numlavaframes];
  int i = 0;
  while (i < numlavaframes) {
    lava[i] = loadImage("timages/lava" + i + ".png");
    lava[i].resize(gridSize, gridSize);
    i++;
  }
  //load stuff---------------------------------
  loadterrains();
  loadWorld(map);
  loadPlayer();
}

void loadWorld(PImage img) {
  world = new FWorld(-2000, -2000, 2000, 2000);
  world.setGravity(0, 900);

  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      color c = img.get(x, y);
      color s = img.get(x, y+1); //c below pixel
      color w = img.get(x-1, y); //c west pixel
      color e = img.get(x+1, y); //c east pixel
      FBox b = new FBox(gridSize, gridSize);
      b.setPosition(x*gridSize, y*gridSize);
      b.setStatic(true);
      if (c == black) {
        b.attachImage(stone);
        b.setFriction(4);
        b.setName("stone");
        world.add(b);
      } else if (c == blueice) {
        b.attachImage(ice);
        b.setFriction(0.125);
        b.setName("ice");
        world.add(b);
      } else if (c == treebrown) {
        b.attachImage(treetrunk);
        b.setSensor(true);
        b.setName("treeTrunk");
        world.add(b);
      } else if (c == treegreen && s == treebrown) { //intersection
        b.attachImage(treetopintersect);
        b.setFriction(4);
        b.setName("treetop");
        world.add(b);
      } else if (c == treegreen && e == treegreen & w == treegreen) {
        b.attachImage(treetopcenter);
        b.setFriction(4);
        b.setName("treetop");
        world.add(b);
      } else if (c == treegreen && e != treegreen ) {
        b.attachImage(treetopl);
        b.setFriction(4);
        b.setName("treetop");
        world.add(b);
      } else if (c == treegreen && w != treegreen) {
        b.attachImage(treetopr);
        b.setFriction(4);
        b.setName("treetop");
        world.add(b);
      } else if (c == purple) {
        b.attachImage(spike);
        b.setName("spike");
        world.add(b);
      } else if (c == orange) {
        b.attachImage(trampoline);
        b.setName("trampoline");
        b.setRestitution(2);
        world.add(b);
      } else if (c == yellow) {
        FBridge br = new FBridge(x*gridSize, y*gridSize);
        terrain.add(br);
        world.add(br);
      } else if (c == redlava) {
        FLava la = new FLava(x*gridSize, y*gridSize, int(random(0, 6)));
        terrain.add(la);
        world.add(la);
      }
      //} else if (c == goomba) 
        
    }
  }
}

void loadPlayer() {
  player = new FPlayer();
  world.add(player);
}

void draw() {
  background(white);
  drawWorld();
  actWorld();
  println(player.getVelocityY());
}

void actWorld() {
  player.act();
  for (int i = 0; i < terrain.size(); i++) {
    FGameObject b = terrain.get(i);
    b.act();
  }
}


void drawWorld() {
  pushMatrix();
  translate(-player.getX()*zoom+width/2, -player.getY()*zoom+height/2);
  scale(zoom);
  world.step();
  world.draw();
  popMatrix();
}

void loadterrains() {
  trampoline = loadImage("timages/trampoline.png");
  bridge = loadImage("timages/bridge_center.png");
  spike = loadImage("timages/spike.png");
  ice = loadImage("timages/blueBlock.png");
  ice.resize(gridSize, gridSize);
  stone = loadImage("timages/brick.png");
  treetrunk = loadImage("timages/tree_trunk.png");
  treetopintersect = loadImage("timages/tree_intersect.png");
  treetopcenter = loadImage("timages/treetop_center.png");
  treetopr = loadImage("timages/treetop_w.png");
  treetopl = loadImage("timages/treetop_e.png");
  
  //load character actions--------------------------
  idle = new PImage[2];
  idle[0] = loadImage("mario/idle0.png");
  idle[1] = loadImage("mario/idle1.png");
  
  jump = new PImage[1];
  jump[0] = loadImage("mario/jump0.png");
  
  run = new PImage[3];
  run[0] = loadImage("mario/runright0.png");
  run[1] = loadImage("mario/runright1.png");
  run[2] = loadImage("mario/runright2.png");
  
  action = idle;
}
