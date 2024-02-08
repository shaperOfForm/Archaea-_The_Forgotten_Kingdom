import fisica.*;
import java.lang.Math.*;
static int h;
static int w;
static PVector origin = new PVector(w, h);
static float center_x = w/2;
static float center_y = h/2;
static ArrayList<Luca> all = new ArrayList<Luca>();
static Luca l2 = null;
FWorld world;
FBlob myBlob = new FBlob();

void setup() 
{
  size(1000, 1000);
  background(220, 55, 55);
  /*
  Fisica.init(this);
  myBlob.setAsCircle(500, 500, 150);
  world = new FWorld();
  world.setEdges();
  world.setGravity(0, 0);
  myBlob.setFillColor(color(68, 56, 98));
  world.add(myBlob);
  */

  h = height;
  w = width;
  Luca l = new Luca();
  l.spawn();
  display(l);
}

void draw() 
{
  //drawBack();
  //world.step();
  //world.draw();
  //for(int i = 0; i<Luca.all.size(); i++)
  //{
    
    Luca l = all.get(0);
      
      // Uncomment one at a time to see result
      /*
      l2 = l.split();
      display(l);
      display(all.get(1));
      */
      
    if(Species.num_species == 1)
    {
       //<>//
      PVector dest1 = new PVector(600, 240);
      
      // Uncomment one at a time to see result
      l.move(dest1);
      
      // Uncomment one at a time to see result
      //l.moveRandom();
      
      // Uncomment one at a time to see result
      //l.move(270);
      
      display(l);
    }
  //}
}
// Draw Luca
void display(Luca l)
{
  // Will change for Box2D
  ellipse(l.loc.x, l.loc.y, l.cell_w, l.cell_h);
}
// Draw background
void drawBack()
{
  background(220, 55, 55);
}
