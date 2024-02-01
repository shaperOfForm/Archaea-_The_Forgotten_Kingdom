// A class to create Luca objects (cells) and provide all of its functionality
class Luca
{
  // Attributes
  float cell_w;
  float cell_h;
  PVector loc;
  PVector vel;
  PVector acc;
  float speed;
  float stam;
  float rep_rate;
  int species_num;
  
  Luca parent;
  Luca child;
  
  // For split method
  Luca l2;
  // For moveRandom method
  PVector dest;
  PVector dir;
  float rand;
 
 // Default constructor
  public Luca()
  {
    // Spawns in center of screen
    this.loc = new PVector(w/2, h/2);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(.5, -.5);
    this.speed = .01;
    this.stam = 50;
    this.cell_w = 50;
    this.cell_h = 50;
    //this.cell_center_x = (cell_x + cell_w)/2;
    //this.cell_center_y = (cell_y + cell_h)/2;
    this.rep_rate = 1;
    this.species_num = 0;
    this.parent = null;
    this.child = null;
    this.dest = null;
  }
  // Constructor with parameters
  public Luca(float x, float y, float cell_w, float cell_h, int species_num, float speed, float rep_rate)
  {
    this.loc = new PVector(x, y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.speed = speed;
    this.stam = 50;
    this.cell_w = cell_w;
    this.cell_h = cell_h;
    //this.cell_center_x = (loc.x + cell_w)/2;
    //this.cell_center_y = (loc.y + cell_h)/2;
    this.rep_rate = rep_rate;
    this.species_num = species_num;
    this.dest = null;
    // Adds the new Luca to the static ArrayList
    all.add(this);
  }
  //
  // Sets the current Luca object as the parent of another
  public void setParent(Luca l)
  {
    this.parent = l;
  }
  // Set a cell's child attribute
  public void setChild(Luca l)
  {
    this.child = l;
  }  
  // Spawns a cell in the center of the environment
  public void spawn()
  {
    // Set new Luca's x and y values, and their PVector location
    this.loc = new PVector(w/2, h/2);
    // Add this Luca to the static ArrayList
    all.add(this);
    // If this is the first Luca spawned
    if(Species.num_species == 0)
    {
      // Increment number of species
      Species.num_species++;
    }
  }
  public Luca spawn(Luca l)
  {
    l2 = new Luca(l.loc.x, l.loc.y, l.cell_w+1, l.cell_h+1, 0, l.speed, l.rep_rate);
    all.add(this);
    return this;
  }
  
  void checkEdges() {

    if (loc.x > width) {
      loc.x = 0;
    } else if (loc.x < 0) {
      loc.x = width;
    }

    if (loc.y > height) {
      loc.y = 0;
    } else if (loc.y < 0) {
      loc.y = height;
    }

  }
  
  
  /*// Move to designated PVector location at a set rate
  public void move(float angle)
  {
    
    dest = PVector.fromAngle(angle) ;
    //random(this.loc.x - vel.x, this.loc.x + vel.x), random(this.loc.y - vel.y, this.loc.y + this.loc.y
    dest.normalize();
    print(dest.mag());
    this.vel.add(dest);
    vel.limit(stam);
    this.loc.add(vel);
  }
  */
  public void setDest(PVector l, PVector v)
  {
    this.dest = PVector.add(l, v);
  }
  
  public void applyForce(PVector force)
  {
    this.acc = force;
  }
  
  public void move(PVector point)
  {
    draw_back();
    if(this.dest == null)
    {
      this.setDest(point, this.vel);
    }
    if(this.dest != this.loc)
    {
      this.dir = PVector.sub(this.dest, this.loc);
      this.moveDir(this.dir);
      //println("DEST " + this.dest);
      //println("LOC: " + this.loc);
      this.loc = new PVector(this.loc.x, this.loc.y);
      this.move();
      println("DIRECTION: " + this.dir);
      
      
      
      if(PVector.dist(this.loc, this.dest) <=2)
      {
        this.acc.mult(0);
        this.loc = point;
        this.dest = null;
        //this.vel = new PVector(0, 0);
        return;
      } //<>//
    }
    
      this.vel.add(this.acc);
      this.vel.limit(this.stam);
      this.loc.add(this.vel);
      //noLoop();
    }
    public void move()
    {
      this.vel.add(this.acc);
      this.vel.limit(this.stam);
      this.loc.add(this.vel);
    }
  public void moveDir(PVector d)
  {
    d.normalize();
    d.mult(this.speed);
    this.dir = d;
    this.acc = this.dir;
  }
  // Move to designated location on the screen at a set speed
  /*public void move(float dest_x, float dest_y, float speed)
  {   
    /*
    // While the Luca is the the LEFT of its destination x-coordinate
    if(this.loc.x < dest_x)
    {
      // If is still to the LEFT of its destination x-coordinate
      if(this.cell_x < dest_x)
      {
        // Increment x-location by speed
        this.cell_x = this.cell_x + speed;
      }
    }
    // While the Luca is the the RIGHT of its destination x-coordinate
    if(this.cell_x > dest_x)
    {
      // If is still to the RIGHT of its destination x-coordinate
      if(this.cell_x > dest_x)
      {
        // Decrement x-location by speed
        this.cell_x = this.cell_x - speed;
      }
    }
    // While the Luca is the the ABOVE of its destination y-coordinate
    if(this.cell_y < dest_y)
    {
      // If is still to the ABOVE of its destination x-coordinate
      if(this.cell_y < dest_y)
      {
        // Increment y-location by speed
        this.cell_y = this.cell_y + speed;
      }
    }
    // While the Luca is the the BELOW of its destination y-coordinate
    if(this.cell_y > dest_y)
    {
      // If is still to the BELOW of its destination x-coordinate
      if(this.cell_y > dest_y)
      {
        // Decrement y-location by speed
        this.cell_y = this.cell_y - speed;
      }
    }
    
  }*/
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

  // Split one Luca into two
  public Luca split()
  {
    // if Luca 2 is not yet stored
    if(l2 == null)
    {
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
    
    

    // Set children of parent of both Lucas
    l2.setParent(this);
    this.setChild(l2);
    this.setParent(l2);
    l2.setChild(this);
    
    //set this.dest back to null
    
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

    
    //if(distance < max(this.cell_x, l2.cell_x))
    //{
    //  this.cell_x--;
    //  distance = abs(l2.cell_x - this.cell_x);
    //  print(distance , " ");
    //}
    //l2.env.draw_luca(l2);
    
    // If the distance between the two cells' centers is greater than the largest dimension of the larger cell
    //  return lucas;
  
  public void phage(PApplet sketch, Luca prey)
  {
    sketch.stroke(0, 0, 0);
    sketch.fill(255);
    sketch.ellipse(this.loc.x, this.loc.y, cell_w, cell_h);
    //sketch.ellipse(prey.getCellW(), prey.getCellH(), prey.getCellX(), prey.getCelly());
  }
    public PVector getCellX()
  {
    return this.loc;
  }
  public void setCellX(PVector loc)
  {
    this.loc = loc;
  }
  public float getCellW()
  {
    return this.cell_w;
  }
  public void setCellW(float cell_w)
  {
    this.cell_w = cell_w;
  }
    public float getCellH()
  {
    return this.cell_h;
  }
  public void setCellH(float cell_h)
  {
    this.cell_h = cell_h;
  }
    public int getSpeciesNum()
  {
    return this.species_num;
  }
  public void setSpecies(int species_num)
  {
    this.species_num = species_num;
  }
  
  
  public void setRepRate(float r)
  {
    this.rep_rate = r;
  }
  /*
  public static Luca getLast()
  {
    return Luca.all.get(Luca.all.size()-1);
  }
  */
  /*
  public static void viewAll()
  {
    for(int i = 0; i<Luca.all.size(); i++)
    {
      
      println(Luca.all.get(i));
    }
  }
  */
  public String toString()
  {
    String str = "Species number: " + this.getSpeciesNum() + "\n";
    return str;
  }
}
