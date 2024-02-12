/*
class Luca
  Luca l2;
  // For moveRandom method
  PVector dest;
  PVector dir;
  float rand;
 
 // Default constructor
  public Luca()
  Luca()
  {
    // Spawns in center of screen
    this.loc = new PVector(w/2, h/2);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(.5, -.5);
    this.speed = .01;
    this.stam = 50;
    this.speed = .9;
    this.stam = 100;
    this.cell_w = 50;
    this.cell_h = 50;
    //this.cell_center_x = (cell_x + cell_w)/2;

@@ -41,14 +40,15 @@ class Luca
    this.child = null;
    this.dest = null;
  }
  
  // Constructor with parameters
  public Luca(float x, float y, float cell_w, float cell_h, int species_num, float speed, float rep_rate)
  Luca(float x, float y, float cell_w, float cell_h, int species_num, float speed, float rep_rate)
  {
    this.loc = new PVector(x, y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.speed = speed;
    this.stam = 50;
    this.stam = 200;
    this.cell_w = cell_w;
    this.cell_h = cell_h;
    //this.cell_center_x = (loc.x + cell_w)/2;

@@ -56,22 +56,27 @@ class Luca
    this.rep_rate = rep_rate;
    this.species_num = species_num;
    this.dest = null;
    
    // Adds the new Luca to the static ArrayList
    all.add(this);
  }
  //
  
  // Sets the current Luca object as the parent of another
  public void setParent(Luca l)
  void setParent(Luca l)
  {
    this.parent = l;
  }
  
  // Set a cell's child attribute
  public void setChild(Luca l)
  void setChild(Luca l)
  {
    this.child = l;
  }  
  
  //~~~~~~~~SPAWNING~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  // Spawns a cell in the center of the environment
  public void spawn()
  void spawn()
  {
    // Set new Luca's x and y values, and their PVector location
    this.loc = new PVector(w/2, h/2);

@@ -84,15 +89,24 @@ class Luca
      Species.num_species++;
    }
  }
  public Luca spawn(Luca l)
  
  // Spawn a Luca on top of an existing one
  Luca spawn(Luca l)
  {
    l2 = new Luca(l.loc.x, l.loc.y, l.cell_w+1, l.cell_h+1, 0, l.speed, l.rep_rate);
    all.add(this);
    return this;
  }
  
  //~~~~~~~~MOVEMENT~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  
  
  // Check if Luca touches edge
  void checkEdges() {

    
    // Will change
    /*
    if (loc.x > width) {
      loc.x = 0;
    } else if (loc.x < 0) {

@@ -104,80 +118,210 @@ class Luca
    } else if (loc.y < 0) {
      loc.y = height;
    }

    */
    /*
  }
     
  // Set speed (magnitude of acceleration vector)
  void setSpeed()
  {
    // Normalize and scale the vector
    this.acc.normalize();
    this.acc.mult(this.speed);
  }
  
  // Set the distance a Luca travels, based on its stamina
  void setDist(PVector point)
  {
    // If the destination is not set
    if(this.dest == null)
    {
      // Set it to the desgnated point
      this.dest = point;
    }
    // If the destination is set and the distance between the point
    // and the original location is less than the Luca's stamina
    else if(PVector.dist(orig_loc, point) > this.stam)
    {
      // Create a new vector with the same direction as the current destination
      PVector new_dest = PVector.sub(this.dest, orig_loc);
      // Set the magnitude of the new vector to the stamina
      new_dest.setMag(this.stam);
      // Set the destination to the sum of the original location vector and the
      // new destination vector
      this.dest = PVector.add(orig_loc, new_dest);
    }
  }
  
    // Apply a force to a Luca
  void applyForce(PVector force)
  {
    // Add force vector to acceleration vector
    this.acc.add(force);
  }
  
  /*
  // Move to designated PVector location at a set rate
  public void move(float angle)
  //************Helpers**********
  // Helper method for helper method to set the direction of the acceleration vector
  private void moveDir(PVector dest, PVector loc)
  {
    
    dest = PVector.fromAngle(angle) ;
    //random(this.loc.x - vel.x, this.loc.x + vel.x), random(this.loc.y - vel.y, this.loc.y + this.loc.y
    dest.normalize();
    print(dest.mag());
    this.vel.add(dest);
    vel.limit(stam);
    this.loc.add(vel);
    // Set direction of acceleration vector
    PVector dir = PVector.sub(dest, loc);
    
    // Set speed - normalize and scale
    this.setSpeed();

    // Assign vector to acceleration
    this.acc = dir;
  }
  */
  /*
  public void setDest(PVector l, PVector v)
  
  // Helper method to set the direction of the acceleration vector
  private void moveDir()
  {
    this.dest = PVector.add(l, v);
    // Set direction of acceleration vector
    this.moveDir(this.dest, this.loc);
  }
  
  public void applyForce(PVector force)
   
  // Helper function to initiate motion
  private void move()
  {
    this.acc = force;
    // Scale the velocity by its speed
    this.vel.mult(this.speed);
  
    // Add the acceleration vector to the velocity vector
    this.vel.add(this.acc);
    // Add the velocity vector to the location vector
    this.loc.add(this.vel);
    // Clear acceleration each frame
    this.acc.mult(0);
  }
  
  public void move(PVector point)
  // To decelerate a Luca to stop at a specified location
  void arrive(PVector target)
  {
    draw_back();
    if(this.dest == null)
    
    // Desired velocity
    PVector des_vel = PVector.sub(target, this.loc);
    
    // Distance is the magnitude of the velocity vector
    float distance = des_vel.mag();
    // Normalize between 0 and 1
    des_vel.normalize();
    
    // If closer than 100 pixels
    if(distance<100)
    {
      this.setDest(point, this.vel);
      // Set magnitude of desired velocity vector according to how close it is
      float m = map(distance, 0 ,200, 0, this.speed);
      des_vel.mult(m);
    }
    if(this.dest != this.loc)
    else
    {
      this.dir = PVector.sub(this.dest, this.loc);
      this.moveDir(this.dir);
      //println("DEST " + this.dest);
      //println("LOC: " + this.loc);
      this.loc = new PVector(this.loc.x, this.loc.y);
      this.move();
      println("DIRECTION: " + this.dir);
      
      
      // Otherwise maintain velocity
      des_vel.mult(this.speed);
    }
    // Steering = desired_velocity - velocity
    PVector steer = PVector.sub(des_vel, this.vel);
    // .5 = max force. May change
    steer.limit(.5);
    // Apply force
    applyForce(steer);
  }
  
  //*********************************
  
  //*******Methods-to-move***********
  
  // Copy of start location vector
  PVector orig_loc;
  
  // Move to a designated location
  void move(PVector point)
  {
    // Draw background
    drawBack();
      
      if(PVector.dist(this.loc, this.dest) <=2)
      {
        this.acc.mult(0);
        this.loc = point;
        this.dest = null;
        //this.vel = new PVector(0, 0);
        return;
      } //<>//
    // If not set...
    if(orig_loc == null || PVector.dist(orig_loc, this.loc) < 1)
    {
      // Set original location
      orig_loc = this.loc.copy();
    }
    
      this.vel.add(this.acc);
      this.vel.limit(this.stam);
      this.loc.add(this.vel);
      //noLoop();
    // Set the distance it will travel, based on its stamina
    this.setDist(point); //<>//
    
    // Set direction of acceleration vector
    this.moveDir();
    
    // Set speed - normalize and scale
    this.setSpeed();
    
    // Decelerate
    this.arrive(this.dest);
    
    // Move
    this.move();
  }
  
  // Move this Luca a random distance within its movement radius(stam attribute) in a random direction
  void moveRandom()
  {
    // If the destination is null or the Luca has reached its destination
    if(this.dest==null || PVector.dist(this.loc, this.dest) < 1)
    {
      // Set a new destination
      this.dest = new PVector(random(this.loc.x - this.stam, this.loc.x + this.stam), random(this.loc.y - this.stam, this.loc.y + this.stam));
    }
    public void move()
    // Move Luca to it
    this.move(this.dest);
  }
  
  // Move Luca the a single random location
  // To use when learning to hunt
  void moveOnceRandom()
  {
    // Create destination within stamina range
    this.dest = new PVector(random(this.loc.x - this.stam, this.loc.x + this.stam), random(this.loc.y - this.stam, this.loc.y + this.stam));
    // Move Luca to it
    this.move(this.dest);
  }
  
  // Move a Luca in a direction, specified in degrees
  void move(float degrees)
  {
    // Convert to radians
    float radians = degrees * PI/180;
    // Create vector from angle
    
    PVector dir = PVector.fromAngle(radians);
    
    // Set direction of acceleration vector
    this.moveDir();
    // If it has not yet reached its destination, move
    if(this.dest != this.loc)
    {
      this.vel.add(this.acc);
      this.vel.limit(this.stam);
      this.loc.add(this.vel);
      this.move();
      drawBack();
    }
  public void moveDir(PVector d)
  }
  
  // Move a specified Luca in a specified location
  void move(float degrees, Luca l)
  {
    d.normalize();
    d.mult(this.speed);
    this.dir = d;
    this.acc = this.dir;
    float radians = degrees * PI/180;
    PVector dir = PVector.fromAngle(radians);
    
    // Set direction of acceleration vector
    l.moveDir();
    
    // If it has not yet reached its destination, move
    if(l.dest != l.loc)
    {
      l.move();
      drawBack();
    }
  }
  
  // Move to designated location on the screen at a set speed
  /*public void move(float dest_x, float dest_y, float speed)
  {   


@@ -222,161 +366,93 @@ class Luca
        this.cell_y = this.cell_y - speed;
      }
    }
    
  }*/
  /*
  // Move this Luca a random distance with-in its' movement radius(stam attribute) in a random direction
  public void moveRandom()
  {
    // If the destination is not yet stored
    if(dest==null)
    {
      // Create a random 
      this.dest = new PVector(random(this.loc.x - this.stam, this.loc.x + this.stam), random(this.loc.y - this.stam, this.loc.y + this.stam));
      
  }
    
    // Move Luca to new PVector at a certain rate
    this.move(dest);
  }
  
  public void move(float degrees)
  {
    float radians = degrees * PI/180;
    this.dir = PVector.fromAngle(radians);
    this.moveDir(this.dir);
    
    if(this.dest != this.loc)
    {
      this.move();
      background(220, 55, 55);
    }
  }
  public void move(float degrees, Luca l)
  {
    float radians = degrees * PI/180;
    this.dir = PVector.fromAngle(radians);
    l.moveDir(this.dir);
    if(l.dest != l.loc)
    {
      l.move();
      background(220, 55, 55);
    }
    
  }

  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  // Replication
  // Split one Luca into two
  public Luca split()
  Luca split()
  {
    // if Luca 2 is not yet stored
    if(l2 == null)
    {
      // Spawn second Luca on top of the first
      l2 = this.spawn(this);
      // Create new luca in same location as original and store it in l2
      this.rand = random(360);
      float rand2 = rand + 180;
      float radians = 360 * PI/180;
      this.dir = PVector.fromAngle(radians);
      println("Parent: " + this.dir);
      
      l2.dir = this.dir.copy().rotate(radians+PI);
      
      l2.moveDir(l2.dir);
      println("Child: " + l2.dir);
    }
    this.move(90);
    l2.move(180);
    
    // Move parent in random direction
    rand = random(360);
    this.move(rand);
    

    // Set children of parent of both Lucas
    l2.setParent(this);
    this.setChild(l2);
    this.setParent(l2);
    l2.setChild(this);
    
    //set this.dest back to null
    
    // Add to ArrayList if not already there
    if(!all.contains(l2))
    {
      all.add(l2);
    }
    return l2;
  }
  
    //

    
    //float[] values = {this.getCellW()+1, l2.getCellW()+1};
    //l2 = getLast()
    // Distance equals the difference of the x-coordinates of the two cells
    // |x2 - x1| 
    //float distance = abs(this.cell_x - getLast().cell_x);
    //if(distance < this.cell_x + this.cell_w + 1)
    //{
    //  this.cell_x--; //<>//
    //  l2.cell_x++;
    //  println(this.cell_x);
    //  println(l2.cell_x);
    //  print("Distance: ", distance, " MAX: ",  max(values));
    //}

    // Move child in random direction
    all.get(1).move(rand-180);
    
    //if(distance < max(this.cell_x, l2.cell_x))
    //{
    //  this.cell_x--;
    //  distance = abs(l2.cell_x - this.cell_x);
    //  print(distance , " ");
    //}
    //l2.env.draw_luca(l2);
    // Set children and parent of both Lucas
    l2.setParent(this);
    this.setChild(l2);
    this.setParent(l2);
    l2.setChild(this);
    
    // If the distance between the two cells' centers is greater than the largest dimension of the larger cell
    //  return lucas;
    // Return child
    return l2;
  }
  
  public void phage(PApplet sketch, Luca prey)
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //<>//
  /*
  void phage(Luca prey)
  {
    sketch.stroke(0, 0, 0);
    sketch.fill(255);
    sketch.ellipse(this.loc.x, this.loc.y, cell_w, cell_h);
    //sketch.ellipse(prey.getCellW(), prey.getCellH(), prey.getCellX(), prey.getCelly());
    
  }
    public PVector getCellX()
  */
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /*
  PVector getCellX()
  {
    return this.loc;
  }
  public void setCellX(PVector loc)
  void setCellX(PVector loc)
  {
    this.loc = loc;
  }
  public float getCellW()
  float getCellW()
  {
    return this.cell_w;
  }
  public void setCellW(float cell_w)
  void setCellW(float cell_w)
  {
    this.cell_w = cell_w;
  }
    public float getCellH()
  float getCellH()
  {
    return this.cell_h;
  }
  public void setCellH(float cell_h)
  void setCellH(float cell_h)
  {
    this.cell_h = cell_h;
  }
    public int getSpeciesNum()
  int getSpeciesNum()
  {
    return this.species_num;
  }
  public void setSpecies(int species_num)
  void setSpecies(int species_num)
  {
    this.species_num = species_num;
  }
  
  
  public void setRepRate(float r)
  void setRepRate(float r)
  {
    this.rep_rate = r;
  }
  
  /*
  public static Luca getLast()
  {

@@ -393,10 +469,11 @@
    }
  }
  */
  /*
  public String toString()
  
  String toString()
  {
    String str = "Species number: " + this.getSpeciesNum() + "\n";
    return str;
  }
}
*/


/*
import fisica.*;
import java.lang.Math.*;
static int h;
static int w;
static PVector dest1;
static PVector origin = new PVector(w, h);
static float center_x = w/2;
static float center_y = h/2;
static ArrayList<Luca> all = new ArrayList<Luca>();
static float rand = 0;
static float rand2 = 0;
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
/*
  h = height;
  w = width;
  Luca l = new Luca();
  l.spawn();
  display(l);
  dest1 = new PVector(300, 300);
  rand = random(0, 360);
}

void draw() 
{
  //drawBack();
  //world.step();
  //world.draw();
  //for(int i = 0; i<Luca.all.size(); i++)
  //{
    
    Luca l = all.get(0);
    //if(l2 == null)
    //{
      int count = 0;
      if(count<1)
      {
        //l2 = l.split();
        l2 = l.spawn(l);
        l.move(rand);
        
        all.get(1).move(rand-180);
        count++;
        display(l);
        display(all.get(1));
      }
      
      //if(l.loc.dist(l2.loc) < max(max(l.loc.x, l.loc.y, l2.loc.x), l2.loc.y))
      //{
      //  print("HELLO");

      //}
      else
      {
        print("HELLO");
        l.acc.x = 0; l.acc.y = 0;
        l.vel.x = 0; l.vel.y = 0;
      }
      // Uncomment one at a time to see result
      /*
      l2 = l.split();
      display(l);
      display(all.get(1));
      */
      
      //println("BEFORE" + l2.acc);
    //l2.acc = l2.acc.rotate(180);
    //println(l2.acc);
    //}
    //all.set(1, l2);
    //display(l);
    //display(l2);
    //if(Species.num_species == 1)
    /*
    if(Species.num_species == 1)
    {
       //<>//
      PVector dest1 = new PVector(600, 240);
      
      //print(Luca.all.get(0)); //<>//
      //l.move(900, 700, l.speed);
      //dest1 = new PVector(600, 240);
      //l.move(dest1);
      // Uncomment one at a time to see result
      l.move(dest1);
      
      // Uncomment one at a time to see result
      //l.moveRandom();
      //l.move((3*PI)/2);
      
      // Uncomment one at a time to see result
      //l.move(270);
      display(l);
      
      //l.move(dest1);
      //display(l);
      //print(Luca.lucas.get(0));
      //print(lucas[1].cell_x);
      //display(l2);

      //Luca.all.set(i, l);
      //Luca.all.set(i+1, l2);
      //display(l2);
      //display(Luca.all.get(Luca.all.size()-1));
      //lucas[0].cell_x++;
      //lucas[1].move(900, 300, 1);
    }
    if(Species.num_species == 2)
    {
      //l.move(330, 260);
      display(l);
    }
    //println(Luca.lucas.size());
    //Luca.viewAll();
    //l.phage(this);
  //}
}
// Draw Luca
void display(Luca l)
{
  // Will change for Box2D
  ellipse(l.loc.x, l.loc.y, l.cell_w, l.cell_h);
}
void draw_back()
// Draw background
void drawBack()
{
  background(220, 55, 55);
}
static void move(Luca l, float deg)
{
  l.move(deg);
}*/
