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
color gray = #7d7d7d;
color aquamarine = #00ffbf;
color pink = #ff06e2;
color hbgreen = #44ff00;
color sbpink = #ff0088;
color doorpink = #7a0041;
color tpblock = #8800ff;

//terrain images
PImage ice, stone, treetrunk, treetopintersect, treetopcenter, treetopl, treetopr;
PImage bridge, spike, trampoline, hammer, openblock, portalblock;

int gridsize = 32;
float zoom = 1.5;

boolean upkey, downkey, leftkey, rightkey, wkey, akey, skey, dkey, spacekey, switchmap, dooropen;

ArrayList<FGameObject> terrain;
ArrayList<FGameObject> enemies;
FPlayer player;

PImage[] lava;
//images for character animations
PImage[] idle, jump, run, action;
PImage[] goomba, thwomp, hammerbro, door;

PImage[] map;
int numofmaps = 3;
int currentmap = 0;

int  numlavaframes;

void setup() {
  size(600, 600);
  Fisica.init(this);
  terrain = new ArrayList<FGameObject>();
  enemies = new ArrayList<FGameObject>();
  map = new PImage[numofmaps];
  map[1] = loadImage("terrainmap1.png");
  map[0] = loadImage("map2.png");
  map[2] = loadImage("thwomprun.png");

  //lava code---------------------------------
  numlavaframes = 6;
  lava = new PImage[numlavaframes];
  int i = 0;
  while (i < numlavaframes) {
    lava[i] = loadImage("timages/lava" + i + ".png");
    lava[i].resize(gridsize, gridsize);
    i++;
  }
  //load stuff---------------------------------
  loadterrains();
  loadWorld(map[0]);
  loadPlayer();
  
  dooropen = false;
}

void loadWorld(PImage img) {
  world = new FWorld(-2000, -2000, 2000, 2000);
  world.setGravity(0, 1000);

  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      color c = img.get(x, y);
      color s = img.get(x, y+1); //c below pixel
      color w = img.get(x-1, y); //c west pixel
      color e = img.get(x+1, y); //c east pixel
      FBox b = new FBox(gridsize, gridsize);
      b.setPosition(x*gridsize, y*gridsize);
      b.setStatic(true);
      if (c == black) {
        b.attachImage(stone);
        b.setFriction(4);
        b.setName("stone");
        world.add(b);
      } else if (c == gray) {
        b.attachImage(stone);
        b.setFriction(4);
        b.setName("wall");
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
        b.setRestitution(1.5);
        world.add(b);
      } else if (c == yellow) {
        FBridge br = new FBridge(x*gridsize, y*gridsize);
        terrain.add(br);
        world.add(br);
      } else if (c == redlava) {
        FLava la = new FLava(x*gridsize, y*gridsize, int(random(0, 6)));
        terrain.add(la);
        world.add(la);
      } else if (c == aquamarine) {
        FGoomba gmb = new FGoomba(x*gridsize, y*gridsize);
        enemies.add(gmb);
        world.add(gmb);
      } else if (c == pink) {
        FThwomp thw = new FThwomp(x*gridsize, y*gridsize);
        enemies.add(thw);
        world.add(thw);
      } else if (c == hbgreen) {
        FHammerBro hb = new FHammerBro(x*gridsize, y*gridsize);
        enemies.add(hb);
        world.add(hb);
      } else if (c == sbpink) {
        FOpenblock ob = new FOpenblock(x*gridsize, y*gridsize);
        terrain.add(ob);
        world.add(ob);
      } else if (c == doorpink) {
        FDoor dr = new FDoor(x*gridsize, y*gridsize);
        terrain.add(dr);
        world.add(dr);
      } else if (c == tpblock) {
        FPortal tp = new FPortal(x*gridsize, y*gridsize);
        terrain.add(tp);
        world.add(tp);
      }
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
  //switchmap();
}

void actWorld() {
  player.act();
  for (int i = 0; i < terrain.size(); i++) {
    FGameObject b = terrain.get(i);
    b.act();
  }
  for (int i = 0; i < enemies.size(); i++) {
    FGameObject e = enemies.get(i);
    e.act();
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

//void switchmap() {
//  currentmap = (currentmap + 1) % numofmaps;

//  terrain.clear();
//  enemies.clear();

//  loadWorld(map[currentmap]);

//  player.setPosition(0,0);
//  player.setVelocity(0,0);
//  world.add(player);
//}

void loadterrains() {
  trampoline = loadImage("timages/trampoline.png");
  bridge = loadImage("timages/bridge_center.png");
  spike = loadImage("timages/spike.png");
  ice = loadImage("timages/blueBlock.png");
  ice.resize(gridsize, gridsize);
  stone = loadImage("timages/brick.png");
  treetrunk = loadImage("timages/tree_trunk.png");
  treetopintersect = loadImage("timages/tree_intersect.png");
  treetopcenter = loadImage("timages/treetop_center.png");
  treetopr = loadImage("timages/treetop_w.png");
  treetopl = loadImage("timages/treetop_e.png");
  openblock = loadImage("timages/switchblock.png");
  openblock.resize(gridsize, gridsize);
  portalblock = loadImage("timages/portalblock.png");
  portalblock.resize(gridsize, gridsize);

  //load door state----
  door = new PImage[2];
  door[0] = loadImage("timages/doortile.png");
  door[1] = loadImage("timages/opendoortile.png");

  //load mario actions--------------------------
  idle = new PImage[2];
  idle[0] = loadImage("characters/idle0.png");
  idle[1] = loadImage("characters/idle1.png");

  jump = new PImage[1];
  jump[0] = loadImage("characters/jump0.png");

  run = new PImage[3];
  run[0] = loadImage("characters/runright0.png");
  run[1] = loadImage("characters/runright1.png");
  run[2] = loadImage("characters/runright2.png");

  action = idle;

  //load enemies actions----------
  goomba = new PImage[2];
  goomba[0] = loadImage("characters/goomba0.png");
  goomba[0].resize(gridsize, gridsize);
  goomba[1] = loadImage("characters/goomba1.png");
  goomba[1].resize(gridsize, gridsize);

  thwomp = new PImage[2];
  thwomp[0] = loadImage("characters/thwomp0.png");
  thwomp[0].resize(gridsize*2, gridsize*2);
  thwomp[1] = loadImage("characters/thwomp1.png");
  thwomp[1].resize(gridsize*2, gridsize*2);

  hammerbro = new PImage[2];
  hammerbro[0] = loadImage("characters/hammerbro0.png");
  hammerbro[0].resize(gridsize, gridsize);
  hammerbro[1] = loadImage("characters/hammerbro1.png");
  hammerbro[1].resize(gridsize, gridsize);
  hammer = loadImage("characters/hammer.png");
}
