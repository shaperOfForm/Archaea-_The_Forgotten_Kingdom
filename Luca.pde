// A class to create Luca objects (cells) and provide all of its functionality
static int id_count = 0;
static ArrayList<Luca> all = new ArrayList<Luca>();

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

  ArrayList<Luca> children;
  Luca parent;

  // For moveRandom method
  PVector dest;
  PVector dir;
  float rand;

  ArrayList<Float> xCoor;
  ArrayList<Float> yCoor;

  PVector split_dir;
  
  ArrayList<Luca> contacts;
  
  PVector fric;
  float c = 0.01;
  float normal = 1;
  float fricMag = c*normal;
  
  float split_speed;

  Food closest_food;

  float lifespan;

  float hunger;

  boolean can_seek;

  float timex;
  float timey;

  float mut_rate;

  float top_speed;

  float wanderTheta;

  float max_force;

  // Default constructor
  Luca()
  {
    // Spawns in center of screen
    this.loc = new PVector(width/2, height/2);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.top_speed = 12;
    this.max_force = 3;
    this.stam = 50;
    this.cell_w = 20;
    this.cell_h = 20;
    this.mass = 64656.70908252886 / (this.cell_w/2 * this.cell_w/2 * this.cell_w/2);
    //this.mass = (.25/this.cell_w)/.65;
    //this.cell_center_x = (cell_x + cell_w)/2;
    //this.cell_center_y = (cell_y + cell_h)/2;
    this.rep_rate = 1;
    this.species_num = 0;
    this.parent = null;
    this.children = new ArrayList<Luca>();
    this.dest = null;
    this.id = id_count;
    id_count++;
    this.xCoor = new ArrayList<Float>();
    this.yCoor = new ArrayList<Float>();
    this.spec = null;
    this.split_speed = 1;
    this.split_dir = new PVector(random(-1, 1), random(-1, 1));
    this.split_dir.normalize().mult(this.split_speed);
    this.contacts = new ArrayList<Luca>();
    this.closest_food = null;
    this.lifespan = 500;
    this.hunger = 0;
    this.can_seek = true;
    this.timex = random(1000);
    this.timey = random(1000);
    this.mut_rate = .25;
    this.wanderTheta = random(0, 2*PI);
    if(!(this instanceof Predator))
    {
      all_prey.add(this);
    }
  }
  // Constructor with parameters
  Luca(float x, float y, float cell_w, float cell_h, int species_num, float top_speed, float rep_rate)
  {
    this.loc = new PVector(x, y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.top_speed = top_speed;
    this.max_force = 3;
    this.stam = 50;
    this.cell_w = cell_w;
    this.cell_h = cell_h;
    this.mass = 64656.70908252886 / (this.cell_w/2 * this.cell_w/2 * this.cell_w/2);
    //this.cell_center_x = (loc.x + cell_w)/2;
    //this.cell_center_y = (loc.y + cell_h)/2;
    this.rep_rate = rep_rate;
    this.species_num = species_num;
    this.parent = null;
    this.children = new ArrayList<Luca>();
    this.dest = null;
    this.id = id_count;
    id_count++;
    this.xCoor = new ArrayList<Float>();
    this.yCoor = new ArrayList<Float>();
    this.spec = null;
    this.split_speed = 1;
    this.contacts = new ArrayList<Luca>();
    this.closest_food = null;
    this.lifespan = 500;
    this.hunger = 0;
    this.can_seek = true;
    this.timex = random(1000);
    this.timey = random(1000);
    this.mut_rate = .25;
    this.wanderTheta = random(0, 2*PI+1);
    if(!(this instanceof Predator))
    {
      all_prey.add(this);
    }
  }

  void applyRepeller(Predator p)
  {
    PVector force = p.repel(this);
    this.applyForce(force);
  }
  
  // Copilot helped with this method
  PVector reynoldsWander()
  {
    float wanderR = 50; // Radius for our "wander circle"
    float wanderD = 200; // Distance for our "wander circle"
    float change = 0.3;
    wanderTheta += random(-change,change); // Randomly change wander theta

    // Now we have to calculate the new location to steer towards on the wander circle
    PVector circleloc = this.vel.copy(); // Start with velocity
    circleloc.normalize(); // Normalize to get heading
    circleloc.mult(wanderD); // Multiply by distance
    circleloc.add(this.loc); // Make it relative to boid's location
    
    float h = this.vel.heading(); // We could be moving in any direction so this is irrelevant
    
    // Now calculate the new target point on the circle, which is offset using wanderTheta
    PVector target = circleloc.add(wanderR*cos(wanderTheta+h), wanderR*sin(wanderTheta+h));

    // And steer towards it
    PVector steer = PVector.sub(target, this.loc);
    steer.limit(.2);
    return steer;
  }

  // A method to wander in randomly changing directions according to a noise function (Perlin noise) and time, using the map fuction to map the noise value to a range of angles
  PVector wander()
  {    
    PVector force = new PVector(map(noise(this.timex), 0, 1, -width/2, width/2), map(noise(this.timey), 0, 1, -height/2, height/2));
    
    force.normalize();
    force.mult(this.max_force);

    this.timex += 1.5;
    this.timey += 1.5;

    return force;
  }

  // The wander method that instead applys a force to the Luca

  void applyBehaviors()
  {

    PVector separateForce = this.separate().setMag(5000);
    separateForce.limit(.25*this.top_speed);
    this.applyForce(separateForce);
    
    PVector seekForce = this.seekClosest();

    if(seekForce != null && this.can_seek && (seekForce.x != 0 && seekForce.y != 0))
    {
        seekForce.setMag(50000);
        //seekForce.mult(7*this.max_force);
        seekForce.limit(25*this.top_speed);
        this.applyForce(seekForce);
    }
    else
    {
        println("Wandering");
    }
    PVector repelForce = new PVector();
    for(Predator p: all_predators)
    {
      if (PVector.dist(this.loc, p.loc) < 500)
      {
        repelForce.add(p.repel(this));
      }
    }
    repelForce.setMag(50000);
    repelForce.limit(10*this.top_speed);

    this.applyForce(repelForce);
    //this.moveRandom();
  }

  // BARD Google like ChatGPT
  // Display the luca
  void drawLuca()
  {
    noFill();
    beginShape();
    stroke(0, 0, 0);
    fill(this.spec.col);
    if(this.id == 0)
    {
      fill(this.spec.col);
    }
    for (float i = 0; i < TWO_PI; i = i + 0.2)
    {
      // Create edge of circle using sine and cosine
      float x1 = sin(i) * this.cell_w;
      float y1 = cos(i) * this.cell_w;

      // Get a random offset
      float xOffset = random(-1.25, 1.25);
      float yOffset = random(-1.25, 1.25);

      // Add the offset to the edge coordinates
      x1 += this.loc.x + xOffset;
      y1 += this.loc.y + yOffset;

      // Create a curved line between the vertices
      curveVertex(x1, y1);
    }
    endShape(CLOSE);
    stroke(this.spec.col);
    //ellipse(0,0,radius*2,radius*2);
  }

  // The switch-case for mutations
  void mutate(String mutation)
  {
    if (this.spec.mut_rate > rand)
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
      case "can_seek":
        this.can_seek = true;
        break;
      default:
        println("ERROR: Check the mutate parameter");
      }
    }
  }

  void mutate()
  {
    this.mutate("size");
    if(!this.can_seek && random(1) <= this.mut_rate)
    {
      this.mutate("can_seek");
    }
  }

  // Method to detect if a luca is making contact with another luca
  // Returns the luca it is making contact with
  Luca detectContact()
  {
    // For every luca
    for(int i = 0; i < all.size(); i++)
    {
      // If it is not the luca we're checking
      if(!this.equals(all.get(i)))
      {
        
        // Calculate the distance between the lucas
        float distance = dist(this.loc.x, this.loc.y, all.get(i).loc.x, all.get(i).loc.y);
        // If they are touching
        if(distance < (this.cell_w + all.get(i).cell_w + 1))
        {
          // If not already on the contacts list
          if(!this.contacts.contains(all.get(i)))
          {
            // Add it to the contacts list
            this.contacts.add(all.get(i));
          }
          // Return the luca it is touching
          return all.get(i);
        }
        // If they are not touching
        else
        {
          // If the other luca is on the contacts list
          if(this.contacts.contains(all.get(i)))
          {
            //println(this.id + " is no longer touching " + i);
            // Remove it from the contacts list
            this.contacts.remove(all.get(i));
          }
        }
      }
    }
    // If no contacts are found, return null
    return null;
  }
  
  // Method to view all lucas a luca is contacting
  void viewContacts()
  {
    // For each luca being contacted
    for(int i = 0; i < this.contacts.size(); i++)
    {
      // Display the luca
      println("Luca # " + this.id + ": Contact with " + all.indexOf(this.contacts.get(i)));
    }
  }
  
  // Spawns a cell in the center of the environment
  void spawn()
  {
    // Set new Luca's x and y values, and their PVector location
    this.loc = new PVector(width/2, height/2);
    // Add this Luca to the static ArrayList
    all.add(this);
    
    // If this is the first Luca spawned
    /*
    if (num_species == 0)
    {
      // Increment number of species
      num_species++;
    }
    */
  }

  boolean eaten()
  {
    for(Luca pred: all_predators)
    {
      if(PVector.dist(this.loc, pred.loc) <= pred.cell_w)
      {
        pred.hunger -= 100;
        // Limit hunger to zero
        if(pred.hunger < 0)
        {
          pred.hunger = 0;
        }
        return true;
      }
    }
    return false;
  }

  // Spawn luca on top of another luca
  Luca spawn(Luca l)
  {
    Luca l2 = null;
    if(l instanceof Predator)
    {
      l2 = new Predator(l.loc.x, l.loc.y, l.cell_w, l.cell_h, 0, l.top_speed, l.rep_rate);
    }
    else
    {
      l2 = new Luca(l.loc.x, l.loc.y, l.cell_w, l.cell_h, 0, l.top_speed, l.rep_rate);
    }
    
    l2.parent = l;
    l.children.add(l2);
    
    return l2;
  }

  // Split one Luca into two
  Luca split()
  {
    
    // Spawn new luca on top of original
    Luca l2 = this.spawn(this);

    l2.loc = new PVector(this.loc.x, this.loc.y);

    // Set child and parent
    if(this.children != null)
    {
      l2.parent = this;
      this.children.add(l2);
    }

    l2.spec = this.spec;
    
    /*
    // Set split direction of new Luca
    l2.split_dir = this.split_dir.mult(-1).normalize().mult(this.split_speed);
    
    this.acc = this.split_dir;
    l2.acc = l2.split_dir;
    */

    this.stam *= .60;
    this.hunger += 20;
    
    return l2;
  }

  PVector seekClosest()
  {
    float min_dist = Float.MAX_VALUE;
    for(Food food: e.all_food)
    {
      if(food != null)
      {
      float dist = PVector.dist(this.loc, food.loc);
        if(dist < min_dist)
        {
          min_dist = dist;
          this.closest_food = food;
        }
      }
    }
    return this.seek(this.closest_food);
  }

  PVector seek(Food food)
  {
    if(food != null)
    {
      PVector desired = PVector.sub(food.loc, this.loc);
      desired.normalize();
      desired.mult(this.top_speed);
      PVector steer = PVector.sub(desired, this.vel);
      steer.limit(this.max_force);
      return steer;
    }
    else
    {
      return null;
    }
  }
  
  PVector separate()
  {
    PVector sum = new PVector();
    int count = 0;
    
    PVector steer = new PVector();
    
    // For each contact
    if(this.contacts.size() > 0)
    {
      for(int i = 0; i < this.contacts.size(); i++)
      {
        // Set a new destination
        this.move(new PVector(random(width), random(height)));
        // Get the vector between the two lucas
        PVector pull = PVector.sub(this.loc, this.contacts.get(i).loc);
        
        pull.normalize();
        //pull.mult(all.get(i).top_speed);
        
        float dist = PVector.dist(this.loc, this.contacts.get(i).loc);
        
        /*if(dist > 0 && dist < (all.get(i).cell_w + all.get(i).contacts.get(n).cell_w))
        {
          pull.div(dist);
        }
        */
        
        sum.add(pull);
        count++;
        
      }
      sum.div(count);
      sum.setMag(this.max_force);
      steer = PVector.sub(sum, this.vel);
      steer.limit(1);
    }
    return steer;
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

  void arrive(PVector target)
  {
    // Desired velocity
    PVector des_vel = PVector.sub(target, this.loc);

    // Distance is the magnitude of the velocity vector
    float distance = des_vel.mag();
    // Normalize between 0 and 1
    des_vel.normalize();

    // If closer than 20 pixels
    if (distance < 20)
    {
      // Set magnitude of desired velocity vector according to how close it is
      float m = map(distance, 0, 20, 0, this.top_speed);
      des_vel.mult(m);
    } 
    else
    {
      // Otherwise maintain velocity
      des_vel.mult(this.max_force);
    }
    // Steering = desired_velocity - velocity
    PVector steer = PVector.sub(des_vel, this.vel);
    // 1 = max force. May change
    // Play with this value
    //*************************************
    steer.limit(1);
    // Apply force
    this.applyForce(steer);
  }

  /*
  // Set luca's destination
   public void setDest(PVector l, PVector v)
   {
   this.dest = PVector.add(l, v);
   }
   */

  // Apply force to luca
  void applyForce(PVector force)
  {
    force = force.div(this.mass);
    this.acc.add(force);
  }

  // Set the distance a Luca travels, based on its stamina
  void setDist(PVector point)
  {
    // If the destination is not set
    if (this.dest == null)
    {
      // Set it to the desgnated point
      this.dest = point;
    }
    // If the destination is set and the distance between the point
    // and the original location is less than the Luca's stamina
    else if (PVector.dist(orig_loc, point) > this.stam)
    {
      // Create a new vector with the same direction as the current destination0
      PVector new_dest = PVector.sub(this.dest, orig_loc);
      // Set the magnitude of the new vector to the stamina
      new_dest.setMag(this.stam);
      // new destination vector
      this.dest = PVector.add(orig_loc, new_dest);
    }
  }

  void moveDir(PVector d)
  {
    // Normalize and scale the vector
    d.normalize();
    d.mult(this.max_force);

    // Set direction of acceleration
    this.dir = d;
    this.acc = this.dir;
  }
  void setDest(PVector point)
  {
    if (this.dest != this.loc)
    {
      this.dest = point;
    }
  }
  
  void moveRandom()
  {
    if(this.contacts.size() == 0)
    {
      // If the luca has no destination or is at its destination
      if(this.dest == null || PVector.dist(this.dest, this.loc) < 1)
      {
        // Set a new destination
        this.setDest(new PVector(random(width), random(height)));
      }
      this.move(this.dest);
    }
  }
  
  PVector orig_loc;
  // Move luca to specified location
  void move(PVector point)
  {

    this.setDest(point);

    if (this.dest != null && !this.dest.equals(this.loc))
    {
      this.dir = PVector.sub(this.dest, this.loc);
      this.moveDir(this.dir);

      this.loc = new PVector(this.loc.x, this.loc.y);
      this.arrive(this.dest);

      this.move();
    }


    /*
    // If not set...
     if(orig_loc == null || PVector.dist(orig_loc, this.loc) < 1)
     {
     // Set original location
     orig_loc = this.loc.copy();
     }
     if(this.dest == null)
     {
     this.setDest(point, this.vel);
     }
     
     // Set destination
     this.setDist(point);
     
     //this.setDest(point, this.vel);
     // If the luca hasn't reached its destination
     //if(this.dest != this.loc)
     // {
     
     this.moveDir();
     
     // Update location and initiate movement
     this.loc = new PVector(this.loc.x, this.loc.y);
     //this.move();
     
     this.setSpeed();
     
     this.arrive(point);
     
     */

    /*
      // Stop luca at its destination
     if(PVector.dist(this.loc, this.dest) <=8)
     {
     this.acc.mult(0);
     this.loc = point;
     this.dest = null;
     //this.vel = new PVector(0, 0);
     return;
     }
     */
    // }
    // Initiate motion
    //this.move();
  }

  // Inititate motion
  void move()
  {
    this.acc.limit(max_force);
    PVector desiredVel = PVector.add(this.vel, this.acc);
    this.vel = PVector.lerp(this.vel, desiredVel, 0.1);
    this.vel.limit(this.top_speed);
    this.loc.add(this.vel);
    this.acc.mult(0);
  }

  void setSpeed()
  {
    this.acc.normalize();
    this.acc.mult(this.max_force);
  }

  // Set direction of acceleration
  void moveDir(PVector dest, PVector loc)
  {
    if (this.dest != null)
    {
      PVector dir = PVector.sub(this.dest, this.loc);
    }
    this.dir = dir;
    this.acc = dir;

    /*
    
     // Set the direction of acceleration
     this.dir = d;
     this.acc = this.dir;
     */
  }
  void moveDir()
  {
    this.moveDir(this.dest, this.loc);
  }

  // Move in a specified direction
  void move(float degrees)
  {
    
    float radians = degrees * PI/180;
    this.dir = PVector.fromAngle(radians);

    // Set direction
    this.moveDir();
    this.setSpeed();
    // If the luca hasn't reached its destination
    if (this.dest != this.loc)
    {
      
      // Initiate motion
      this.move();
    }
  }

  // Move a specified luca in a specified direction
  void move(float degrees, Luca l)
  {
    float radians = degrees * PI/180;
    this.dir = PVector.fromAngle(radians);
    // Set direction
    l.moveDir();
    if (l.dest != l.loc)
    {
      // Intitiate motion
      l.move();
      drawBack();
    }
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
    String str = "Luca number: " + this.id + "\n";
    return str;
  }
}
