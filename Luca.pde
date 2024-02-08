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
  float rand;
 
 // Default constructor
  Luca()
  {
    // Spawns in center of screen
    this.loc = new PVector(w/2, h/2);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(.5, -.5);
    this.speed = .9;
    this.stam = 100;
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
  Luca(float x, float y, float cell_w, float cell_h, int species_num, float speed, float rep_rate)
  {
    this.loc = new PVector(x, y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.speed = speed;
    this.stam = 200;
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
  
  //~~~~~~~~SPAWNING~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
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
  
  //~~~~~~~~MOVEMENT~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  
  
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
  
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
  // Replication
  // Split one Luca into two
  Luca split()
  {
    // if Luca 2 is not yet stored
    if(l2 == null)
    {
      // Spawn second Luca on top of the first
      l2 = this.spawn(this);
    }
    
    // Move parent in random direction
    rand = random(360);
    this.move(rand);
    
    // Add to ArrayList if not already there
    if(!all.contains(l2))
    {
      all.add(l2);
    }
    
    // Move child in random direction
    all.get(1).move(rand-180);
    
    // Set children and parent of both Lucas
    l2.setParent(this);
    this.setChild(l2);
    this.setParent(l2);
    l2.setChild(this);
    
    // Return child
    return l2;
  }
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //<>//
  /*
  void phage(Luca prey)
  {
    
  }
  */
  
  //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
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
  
  String toString()
  {
    String str = "Species number: " + this.getSpeciesNum() + "\n";
    return str;
  }
}
