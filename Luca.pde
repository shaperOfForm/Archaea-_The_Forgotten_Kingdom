// A class to create Luca objects (cells) and provide all of its functionality
static int id_count = 0;
static ArrayList<Luca> all = new ArrayList<Luca>();

// Display the luca
void drawLuca(Luca luca)
{
  if(luca!=null)
    {
    noFill();
    beginShape();
    stroke(0,0,0);
    fill(0,0,255);
    for(float i = 0; i < TWO_PI; i = i + 0.2){
    
      // Create wave using sine and cosine
      float x1 = sin(i) * luca.cell_w;
      float y1 = cos(i) * luca.cell_w;
      
      // Get a random offset
      float xOffset = random(-1, 1);
      float yOffset = random(-1, 1);
      
      // Add the offset to the wave coordinates
      x1 += luca.loc.x + xOffset;
      y1 += luca.loc.y + yOffset;
      
      // Create a curved line between the vertices
      curveVertex(x1,y1);
    }
  }
  
  endShape(CLOSE);
  stroke(255,0,0);
  //ellipse(0,0,radius*2,radius*2);
}

class Luca
{
  // Attributes
  float size;
  float max_stam;
  String diet;
  float cell_w;
  float cell_h;
  PVector loc;
  PVector vel;
  PVector acc;
  float speed;
  float stam;
  float rep_rate;
  int species_num;
  int id;
  boolean can_move = true;
  float mass;
  
  Species spec;
  
  Luca parent;
  Luca child;
  
  // For moveRandom method
  PVector dest;
  PVector dir;
  float rand;
  
  ArrayList<Float> xCoor;
  ArrayList<Float> yCoor;
 
 // Default constructor
  public Luca()
  {
    // Spawns in center of screen
    this.loc = new PVector(width/2, height/2);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(.5, -.5);
    this.speed = .01;
    this.stam = 50;
    this.cell_w = 30;
    this.cell_h = 30;
    //this.cell_center_x = (cell_x + cell_w)/2;
    //this.cell_center_y = (cell_y + cell_h)/2;
    this.rep_rate = 1;
    this.species_num = 0;
    this.parent = null;
    this.child = null;
    this.dest = null;
    this.id = 0;
    id_count++;
    this.xCoor = new ArrayList<Float>();
    this.yCoor = new ArrayList<Float>();
    this.spec = new Species();
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
    this.id = id_count;
    this.xCoor = new ArrayList<Float>();
    this.yCoor = new ArrayList<Float>();
    if(parent != null)
    {
      this.spec = parent.spec;
    }
    id_count++;
  }
  
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
  
  // The switch-case for mutations
  void mutate(String mutation)
  {
    if(this.spec.mut_rate > rand)
    {
      float rand;
      switch(mutation)
      {
        case "canmove":
          this.can_move = true;
          break;
        case "size":
          rand = random(-20, 20);
          this.size += rand;
          this.mass += rand*.05;
          break;
        case "max_stam":
          rand = random(-40, 40);
          this.max_stam += rand;
          break;
        case "rep_rate":
          rand = random(-10, 10);
          this.rep_rate += rand;
          break;
        default:
          println("ERROR: Check the mutate parameter");
      }
    }
  }
  
  // Spawns a cell in the center of the environment
  public void spawn()
  {
    // Set new Luca's x and y values, and their PVector location
    this.loc = new PVector(width/2, height/2);
    // Add this Luca to the static ArrayList
    all.add(this);
    // If this is the first Luca spawned
    if(Species.num_species == 0)
    {
      // Increment number of species
      Species.num_species++;
    }
  }
  
  // Spawn luca on top of another luca
  public Luca spawn(Luca l)
  {
    Luca l2 = new Luca(l.loc.x, l.loc.y, l.cell_w+1, l.cell_h+1, 0, l.speed, l.rep_rate);
    all.add(l2);
    return l2;
  }
  
  // Check if luca touches edges
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
  
  // Set luca's destination
  public void setDest(PVector l, PVector v)
  {
    this.dest = PVector.add(l, v);
  }
  
  // Apply force to luca
  public void applyForce(PVector force)
  {
    this.acc = force;
  }
  
  // Move luca to specified location
  public void move(PVector point)
  {
    drawBack();
    if(this.dest == null)
    {
      // Set destination
      this.setDest(point, this.vel);
    }
    // If the luca hasn't reached its destination
    if(this.dest != this.loc)
    {
      
      // Set direction to move in
      this.dir = PVector.sub(this.dest, this.loc);
      this.moveDir(this.dir);
      
      // Update location and initiate movement
      this.loc = new PVector(this.loc.x, this.loc.y);
      this.move();
      
      // Stop luca at its destination
      if(PVector.dist(this.loc, this.dest) <=2)
      {
        this.acc.mult(0);
        this.loc = point;
        this.dest = null;
        //this.vel = new PVector(0, 0);
        return;
      }
    }
    // Initiate motion
    this.move();
  }
    
  // Inititate motion
  public void move()
  {
    this.vel.add(this.acc);
    this.vel.limit(this.stam);
    this.loc.add(this.vel);
  }
    
  // Set direction of acceleration
  public void moveDir(PVector d)
  {
    // Normalize and scale the vector
    d.normalize();
    d.mult(this.speed);
    
    // Set the direction of acceleration
    this.dir = d;
    this.acc = this.dir;
  }
  
  // Move this Luca a random distance with-in its' movement radius(stam attribute) in a random direction
  public void moveRandom()
  {
    // If the destination is not yet stored
    if(dest==null)
    {
      // Create a random vector
      this.dest = new PVector(random(this.loc.x - this.stam, this.loc.x + this.stam), random(this.loc.y - this.stam, this.loc.y + this.stam));  
    }
    // Move Luca to new PVector at a certain rate
    this.move(dest);
  }
  
  // Move in a specified direction
  public void move(float degrees)
  {
    float radians = degrees * PI/180;
    this.dir = PVector.fromAngle(radians);
    
    // Set direction
    this.moveDir(this.dir);
    
    // If the luca hasn't reached its destination
    if(this.dest != this.loc)
    {
      // Initiate motion
      this.move();
    }
  }
  
  // Move a specified luca in a specified direction
  public void move(float degrees, Luca l)
  {
    float radians = degrees * PI/180;
    this.dir = PVector.fromAngle(radians);
    // Set direction
    l.moveDir(this.dir);
    if(l.dest != l.loc)
    {
      // Intitiate motion
      l.move();
      drawBack();
    }
    
  }

  // Split one Luca into two
  public Luca split()
  {
    // Spawn new luca on top of original
    Luca l2 = this.spawn(this);
    
    l2.loc = new PVector(this.loc.x, this.loc.y);
  
    // Set children of parent of both Lucas
    l2.setParent(this);
    this.setChild(l2);
    this.setParent(l2);
    l2.setChild(this);
    
    return l2;
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
    String str = "Species number: " + this.species_num + "\n";
    return str;
  }
}
