import fisica.*;
import java.lang.Math.*;
static int h;
static int w;
static PVector origin;
static float center_x = w/2;
static float center_y = h/2;
//static ArrayList<Luca> all = new ArrayList<Luca>();
static ArrayList<FBlob> all = new ArrayList<FBlob>();
static Luca l2 = null;
FWorld world;


void setup() 
{
  
  size(1000, 1000);
  background(220, 55, 55);
  
  Fisica.init(this);
  //Luca l = new Luca();
  FBlob luca = new FBlob();
  luca.setAsCircle(500, 500, 50);
  
  luca.setPosition(500, 500);
  
  world = new FWorld();
  world.setEdges();
  world.setGravity(0, 0);
  luca.setFillColor(color(68, 56, 98));
  world.add(luca);
  all.add(luca);
  

  h = height;
  w = width;
  
  origin = new PVector(w, h);
  
  //l.spawn();
  //display(l);
  
  
}
static boolean made = false;
void draw() 
{
  
  drawBack();
  world.step();
  world.draw();
  
  FBlob child = new FBlob();
  
  if(!made && all.size() > 0)
  {
    for(int i = 0; i < all.get(0).getVertexBodies().size(); i++) {
      float x = all.get(0).getVertexX(i);
      float y = all.get(0).getVertexY(i);
      
      child.vertex(x, y);
    }
    child.setPosition(all.get(0).getX(), all.get(0).getY());
    all.add(child);
      
    world.add(child);
    made = true;
  }  
  if(all.size() >= 2)
  {
    float rand = random(200, 400);
    float rand2 = random(200, 400);
    println(all.get(1).getX());
    
    //if(all.get(0).isTouchingBody(all.get(1)))
    if(abs(all.get(0).getX()) - all.get(1).getX() < 10 || abs(all.get(0).getY()) - all.get(1).getY() < 10)
  {
    all.get(0).addForce(rand, rand2);
    all.get(1).addForce(rand*(-1), rand2*(-1));
    print(all.get(1).getVelocityX());
  }
  
    if(all.get(0).getVelocityX() < -.01)
    {
      all.get(0).setVelocity(0, 0);
      all.get(1).setVelocity(0, 0);
    }
  }
  
  //println(child.getVertexX(50));
  
  
  /*
  //for(int i = 0; i<Luca.all.size(); i++)
  //{
    
    Luca l = all.get(0);
      
      // Uncomment one at a time to see result
      
      l2 = l.split();
      display(l);
      display(all.get(1));
      
      
    if(Species.num_species == 1)
    {
       //<>//
      PVector dest1 = new PVector(600, 240);
      
      // Uncomment one at a time to see result
      //l.move(dest1);
      
      // Uncomment one at a time to see result
      //l.moveRandom();
      
      // Uncomment one at a time to see result
      //l.move(270);
      
      //display(l);
    }
  //}
  */
}

/*
// Draw Luca
void display(Luca l)
{
  world.draw();
  // Will change for Box2D
  //ellipse(l.loc.x, l.loc.y, l.cell_w, l.cell_h);
}
*/
// Draw background
void drawBack()
{
  background(220, 55, 55);
}
