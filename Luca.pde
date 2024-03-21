class Luca extends FBlob
{
 
  FCircle bound;
  float size = 50;
  float stam = 0;
  
  
  Luca(float x, float y)
  {
    
    this.setAsCircle(x, y, size);
    this.setFilterBits(1);
    this.setCategoryBits(1);
    this.stam = 0.0;
    this.bound = new FCircle(70);
    this.bound.setFilterBits((int)random(4, 7));
    this.bound.setPosition(x, y);
    //this.bound.setPosition(x, y);
    //this.bound.setStatic(false);
    
    world.add(this);
    circles.add(this.bound);
    world.add(this.bound);
    
    all.add(this);
    
  }
  // Override the setPosition method of FBlob to automatically update the FCircle position
  @Override
  void setPosition(float x, float y) {
    super.setPosition(x, y);
    this.bound.setPosition(x, y); // Update FCircle position
  }
  
  void drawCircle(PApplet p)
  {
    //this.bound.setFilterBits(2);
    this.bound.draw(p);
  }
  
}









/*
// A class to create Luca objects (cells) and provide all of its functionality
class Luca extends FBlob
{
  // Attributes
  float size;
  PVector loc;
  PVector vel;
  PVector acc;
  float speed;
  float max_stam;
  float stam;
  float rep_rate;
  int species_num;
  String diet;
  Luca parent;
  Luca child;
  
  // For split method
  Luca l2;
  // For moveRandom method
  PVector dest;
  float rand;
  
  // Luca ID number
  int count = 1;
  
  float mass;
  
  
  float forceX = 0;
  float forceY = 0;
  float accX = 0;
  float accY = 0;
  float velX = 0;
  float velY = 0;
  float posX = 500;
  float posY = 500;
  
  
  Species spec;
  
  float range;
  boolean can_move = true;
  
 
 // Default constructor
  Luca()
  {
    super();
    // Spawns in center of screen
    this.posX = 500;
    this.posY = 500;
    this.velX = 0;
    this.velY = 0;
    this.accX = 0;
    this.accY = 0;
    this.forceX = 0;
    this.forceX = 0;
    this.vel = new PVector(0, 0);
    this.acc = new PVector(.5, -.5);
    this.speed = .9;
    this.stam = 0;
    //this.cell_center_x = (cell_x + cell_w)/2;
    //this.cell_center_y = (cell_y + cell_h)/2;
    this.rep_rate = 1;
    this.species_num = 0;
    this.parent = null;
    this.child = null;
    this.dest = null;
    this.mass = 1;
    this.count = count;
    count++;
    this.size = 50;
    this.setAsCircle(500, 500, this.size);
    this.setPosition(500, 500);
    this.spec = new Species();
    this.rand = (float)random(0, 1);
    this.range = 50;
    
  }
  
  Luca(float x, float y)
  {
    super();
    this.posX = x;
    this.posY = y;
    this.velX = 0;
    this.velY = 0;
    this.accX = 0;
    this.accY = 0;
    this.forceX = 0;
    this.forceY = 0;
    // Spawns in center of screen
    this.loc = new PVector(width/2, height/2);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(.5, -.5);
    this.speed = .9;
    this.stam = 0;
    this.rep_rate = 1;
    this.species_num = 0;
    this.parent = null;
    this.child = null;
    this.dest = null;
    this.mass = 1;
    count++;
    this.size = 50;
    this.setAsCircle(x, y, this.size);
    if(parent != null)
    {
    this.spec = parent.spec;
    }
    this.range = 50;
    //this.setPosition(x, y);
  }
  /*
  // Constructor with parameters
  Luca(float x, float y, float cell_w, float cell_h, int species_num, float speed, float rep_rate)
  {
    super();
    this.posX = x;
    this.posY = y;
    this.velX = 0;
    this.velY = 0;
    this.accX = 0;
    this.accY = 0;
    this.forceX = 0;
    this.forceY = 0;
    this.loc = new PVector(x, y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.speed = speed;
    this.stam = 0;
    this.cell_w = cell_w;
    this.cell_h = cell_h;
    //this.cell_center_x = (loc.x + cell_w)/2;
    //this.cell_center_y = (loc.y + cell_h)/2;
    this.rep_rate = rep_rate;
    this.species_num = species_num;
    this.dest = null;
    this.mass = 1;
    count++;
  }
  */
  
  /*
  // Set Luca's stamina attribute
  void setStam(float stam)
  {
    this.stam = stam;
  }
  */
  
  /*
  // I need the Species to be a base, and the Luca class to add offsets to it when they mutate
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
  
  // Spawn a child Luca in the same position as its parent
  Luca spawn()
  {
    // Create new Luca object
    // this.getX() and this.getY() are not updating, so they spawn in the center
    Luca child = new Luca(this.getVertexX(0), this.getVertexY(0));
    
    // Using get methods, it spawns the first and second lucas in the center, then they start spawning on the edges
    // Luca child = new Luca(this.getX(), this.getY());
    
    // For each vertex of the parent
    for (int i = 0; i < this.getVertexBodies().size(); i++) 
    {
      // Create the same vertex for the child
      child.vertex(this.getVertexX(i), this.getVertexY(i));
    }
    // Set the new Luca (Blob) as a circle
    child.setAsCircle(this.posX, this.posY, 50);
    child.setParent(this);
    this.child = child;
    // Add it to the ArrayList
    all.add(child);
    // Add it to the world
    world.add(child);
    // Return the new Luca
    return child;
  }
  int s = 0;
  //int d = 0;
  // Move to given (x, y) coordinates
  void move(float x, float y)
  {
    //if(d < 50)
    //{
    // Set force attributes
    this.forceX = x;
    this.forceY = y;
    
    if(s < 5000)
    {
    // Add the force
    this.addForce(this.forceX, this.forceY);
    //this.adjustVelocity(this.forceX, this.forceY);
    //this.adjustVelocity(10, 10);
    //d++;
    //}
    // Update position and velocity attributes
    this.update();
    s++;
    this.stam--;
    // Print tracked values
    //println("posX: " + this.posX + " | posY: " + this.posY + " | velX: " + this.velX + " | velY: " + this.velY);
    //println("getX(): " + this.getX() + " | getY(): " + this.getY() + " | getVelocityX(): " + this.getVelocityX() + " | getVelocityY: " + this.getVelocityY());
    }
    //this.adjustPosition(this.getVelocityX(), this.getVelocityY());
    
  }
  int j = 0;
  // Update position and velocity attributes
  void update()
  {
    if(j == 0)
    {
    // Calculate acceleration based on the forces applied
    this.accX = this.forceX / this.mass;
    this.accY = this.forceY / this.mass;
    
    // Update velocity based on acceleration
    this.velX += this.accX;
    this.velY += this.accY;
    
    }
  }
    
    /*
    if(j == 0)
    {
    // Adjust to new velocity
    //this.adjustVelocity(this.accX, this.accY);
    j++;
    }
    */

    /*
    //this.addForce(-2, -5);
    //this.adjustVelocity(10, 10);
    
    println("X:" +this.getX()); //<>//
    j++;
    // Adjust to position
    //this.adjustPosition(this.getVelocityX(), this.getVelocityY());
    }
        // Update position based on velocity
    this.posX += this.velX;
    this.posY += this.velY;
  }
  
  /*
  // Sets the current Luca object as the parent of another
  void setParent(Luca l)
  {
    this.parent = l;
  }
  
  // Set a cell's child attribute
  void setChild(Luca l)
  {
    this.child = l;
  }  
  */
  
  //~~~~~~~~SPAWNING~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /*
  // Spawns a cell in the center of the environment
  void spawn()
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
  
  // Spawn a Luca on top of an existing one
  Luca spawn(Luca l)
  {
    l2 = new Luca(l.loc.x, l.loc.y, l.cell_w+1, l.cell_h+1, 0, l.speed, l.rep_rate);
    all.add(this);
    return this;
  }
  */
  //~~~~~~~~MOVEMENT~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  /*
  
  // Check if Luca touches edge
  void checkEdges() {
    
    // Will change
    /*
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
  /*
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
  //************Helpers**********
  // Helper method for helper method to set the direction of the acceleration vector
  private void moveDir(PVector dest, PVector loc)
  {
    
    // Set direction of acceleration vector
    PVector dir = PVector.sub(dest, loc);
    
    // Set speed - normalize and scale
    this.setSpeed();

    // Assign vector to acceleration
    this.acc = dir;
  }
  
  // Helper method to set the direction of the acceleration vector
  private void moveDir()
  {
    // Set direction of acceleration vector
    this.moveDir(this.dest, this.loc);
  }
   
  // Helper function to initiate motion
  private void move()
  {
    // Scale the velocity by its speed
    this.vel.mult(this.speed);
  
    // Add the acceleration vector to the velocity vector
    this.vel.add(this.acc);
    // Add the velocity vector to the location vector
    this.loc.add(this.vel);
    // Clear acceleration each frame
    this.acc.mult(0);
  }
  
  // To decelerate a Luca to stop at a specified location
  void arrive(PVector target)
  {
    
    // Desired velocity
    PVector des_vel = PVector.sub(target, this.loc);
    
    // Distance is the magnitude of the velocity vector
    float distance = des_vel.mag();
    // Normalize between 0 and 1
    des_vel.normalize();
    
    // If closer than 100 pixels
    if(distance<100)
    {
      // Set magnitude of desired velocity vector according to how close it is
      float m = map(distance, 0 ,200, 0, this.speed);
      des_vel.mult(m);
    }
    else
    {
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
      
    // If not set...
    if(orig_loc == null || PVector.dist(orig_loc, this.loc) < 1)
    {
      // Set original location
      orig_loc = this.loc.copy();
    }
    
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
    // Move Luca to it, this will limit the radius to the available stamina
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
    
    this.dest = dir;
    
    // Set direction of acceleration vector
    this.moveDir();
    // If it has not yet reached its destination, move
    if(this.dest != this.loc)
    {
      this.move();
      drawBack();
    }
  }
  
  // Move a specified Luca in a specified location
  void move(float degrees, Luca l)
  {
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
  */
  
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //<>//
  /*
  void phage(Luca prey)
  {
    
  }
  */
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  /*
  PVector getCellX()
  {
    return this.loc;
  }
  void setCellX(PVector loc)
  {
    this.loc = loc;
  }
  float getCellW()
  {
    return this.cell_w;
  }
  void setCellW(float cell_w)
  {
    this.cell_w = cell_w;
  }
  float getCellH()
  {
    return this.cell_h;
  }
  void setCellH(float cell_h)
  {
    this.cell_h = cell_h;
  }
  int getSpeciesNum()
  {
    return this.species_num;
  }
  void setSpecies(int species_num)
  {
    this.species_num = species_num;
  }
  void setRepRate(float r)
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
  /*
  String toString()
  {
    String str = "Luca number: " + this.count + "\n";
    return str;
  }
}
*/
