// A class to create Luca objects (cells) and provide all of its functionality

PVector force = new PVector();
PVector sum;

class Luca
{
  // Attributes
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
  
  ArrayList<Luca> contacts;
  
  PVector fric;
  float c = 0.01;
  float normal = 1;
  float fricMag = c*normal;

  Food closest_food;

  float lifespan;

  float hunger;

  //boolean can_seek;

  float timex;
  float timey;

  float mut_rate;

  float top_speed;

  float wanderTheta;

  float max_force;

  float max_hunger;

  float split_thresh;

  float life_remaining;

  float rep_prog;

  float mut_range = 5;
  
  color col;

  // Default constructor
  Luca()
  {
    // Spawns in center of screen
    this.loc = new PVector(width - 100, height - 100);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.top_speed = 32;
    this.max_force = 999999999;
    
    // If the luca's go in circles around food, increase max_force

    this.stam = random(0, 5);
    this.cell_w = 15;
    this.cell_h = 15;
    this.mass = 64656.70908252886 / (this.cell_w/2 * this.cell_w/2 * this.cell_w/2);
    this.rep_rate = 25;
    this.parent = null;
    this.children = new ArrayList<Luca>();
    //this.dest = null;
    this.xCoor = new ArrayList<Float>();
    this.yCoor = new ArrayList<Float>();
    this.spec = null;
    this.contacts = new ArrayList<Luca>();
    this.closest_food = null;
    this.lifespan = 150;
    this.life_remaining = lifespan;
    this.hunger = 0;
    //this.can_seek = true;
    this.timex = random(1000);
    this.timey = random(1000);
    this.mut_rate = .25;
    //this.wanderTheta = random(0, 2*PI);
    if(!(this instanceof Predator))
    {
      all_prey.add(this);
    }
    this.max_hunger = 500;
    this.max_stam = 150;
    this.split_thresh = 30;
    this.rep_prog = 0;
    this.col = new_spec_col;
  }
  // Constructor with parameters
  Luca(float x, float y, float cell_w, float top_speed, float rep_rate, float max_force, float max_hunger, float max_stam, float split_thresh, float lifespan)
  {
    super();
    this.loc = new PVector(x, y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.top_speed = top_speed + random(-1, 1);
    this.max_force = max_force + random(-mut_range, mut_range);
    this.stam = random(0, 5);
    this.cell_w = cell_w + random(-2, 2);
    this.cell_h = cell_h + random(-1, 1);
    this.mass = 64656.70908252886 / (this.cell_w/2 * this.cell_w/2 * this.cell_w/2);
    this.rep_rate = rep_rate + random(-1, 1);
    this.parent = null;
    this.children = new ArrayList<Luca>();
    //this.dest = null;
    this.xCoor = new ArrayList<Float>();
    this.yCoor = new ArrayList<Float>();
    this.spec = null;
    this.contacts = new ArrayList<Luca>();
    this.closest_food = null;
    this.lifespan = lifespan + random(-mut_range, mut_range);
    this.life_remaining = lifespan;
    this.hunger = 0;
    //this.can_seek = true;
    this.timex = random(1000);
    this.timey = random(1000);
    this.mut_rate = .25 + random(-.1, .1);
    this.wanderTheta = random(0, 2*PI+1);
    if(!(this instanceof Predator))
    {
      all_prey.add(this);
    }
    this.max_hunger = max_hunger + random(-mut_range, mut_range);
    this.max_stam = max_stam + random(-mut_range, mut_range);
    this.split_thresh = split_thresh + random(-mut_range, mut_range);
    this.rep_prog = 0;
    this.col = new_spec_col;
  }

  void applyRepeller(Predator p)
  {
    force = p.repel(this);
    this.applyForce(force);
  }
  
  /*
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
  */

/*
  // A method to wander in randomly changing directions according to a noise function (Perlin noise) and time, using the map fuction to map the noise value to a range of angles
  PVector wander()
  {    
    force = new PVector(map(noise(this.timex), 0, 1, -width/2, width/2), map(noise(this.timey), 0, 1, -height/2, height/2));
    
    force.normalize();
    force.mult(this.max_force);

    this.timex += 1.5;
    this.timey += 1.5;

    return force;
  }
*/

  // The wander method that instead applys a force to the Luca

  void applyBehaviors()
  {
    // Flock
    int i = (int)(this.loc.x / this.cell_w);
    int j = (int)(this.loc.y / this.cell_w);
    i = min(i, grid.length - 1);
    j = min(j, grid[0].length - 1);
    
    ArrayList<Luca> temp = grid[i][j];
    for(Luca l2: temp)
    {
      if(this != l2)
      {
        for(int k = 0; k < 3; k++)
        {
          force = this.flock()[k];
          force.mult(2);
          this.applyForce(force);
        }
      }
    }
    // Seek food
    force = this.seekClosest();
    if(force != null /*&& this.can_seek*/ && (force.x != 0 && force.y != 0))
    {
        force.mult(15);
        this.applyForce(force);
    }

    // Evade predators
    force = new PVector();
    for(Predator p: all_predators)
    {
        force.add(p.repel(this));
    }

    force.limit(this.max_force * this.mass);

    // Highest priority
    force.mult(16);
    this.applyForce(force);

    // Move away from walls
    force = this.wallForce();
    if(!(this instanceof Predator))
    {

      //********** Bigger wall force */

      force.mult(5);
      this.applyForce(force);
    }
  }

  PVector seek(PVector target)
  {
    force = PVector.sub(target, this.loc);
    force.normalize();
    force.mult(this.top_speed);
    force.sub(this.vel);
    force.limit(this.max_force);
    return force;
  }

PVector[] flock()
{
  PVector sep = separate();
  PVector ali = align();
  PVector coh = cohesion();

  sep.mult(1.5);
  ali.mult(1.0);
  coh.mult(1.0);

  return new PVector[]{sep, ali, coh};
}

PVector cohesion()
{
  float neighborDist = 50;
  sum = new PVector(0, 0);
  int count = 0;
  for(Luca l: all_prey)
  {
    float d = PVector.dist(this.loc, l.loc);
    if((d > 0) && (d < neighborDist))
    {
      sum.add(l.loc);
      count++;
    }
  }
  if(count > 0)
  {
    sum.div(count);
    return this.seek(sum);
  }
  else
  {
    return new PVector(0, 0);
  }
}

PVector align()
{
  float neighborDist = 50; // Make range attribute

  sum = new PVector(0, 0);
  int count = 0;
  for(Luca l: all_prey)
  {
    float d = PVector.dist(this.loc, l.loc);
    if((d > 0) && (d < neighborDist))
    {
      sum.add(l.vel);
      count++;
    }
  }
  if(count > 0)
  {
    sum.div(count);
    sum.normalize();
    sum.mult(this.top_speed);

    force = sum.sub(this.vel);
    force.limit(this.max_force);
    return force;
  }
  else
  {
    return new PVector(0, 0);
  }
}

PVector wallForce()
{
  float margin = 100; // Distance from the edges of the screen

  force = new PVector(0, 0);

  int count = 0;

  if(this.loc.x > width - margin)
  {
    float forceStrength = map(this.loc.x, width - margin, width, 0, this.max_force);
    force.add(new PVector(-forceStrength, 0));
    count++;
  }
  else if(this.loc.x < margin)
  {
    float forceStrength = map(this.loc.x, 0, margin, this.max_force, 0);
    force.add(new PVector(forceStrength, 0));
    count++;
  }
  if(this.loc.y > height - margin)
  {
    float forceStrength = map(this.loc.y, height - margin, height, 0, this.max_force);
    force.add(new PVector(0, -forceStrength));
    count++;
  }
  else if(this.loc.y < margin)
  {
    float forceStrength = map(this.loc.y, 0, margin, this.max_force, 0);
    force.add(new PVector(0, forceStrength));
    count++;
  }
  if(count != 0)
  {
    force.div(count);
    force.limit(this.cell_w/3);
  }
  return force;
}

  PVector seekClosest()
  {
    float min_dist = Float.MAX_VALUE;
    Food closest = null;
    for(Food food: e.all_food)
    {
      if(food != null)
      {
        float dist = PVector.dist(this.loc, food.loc) / food.mass;
        if(dist < min_dist && !food.eaten() && this.cell_w > 2*food.mass)
        {
          min_dist = dist;
          closest = food;
        }
      }
    }
    this.closest_food = closest;
    return this.seek(this.closest_food);
  }

  PVector seek(Food food)
  {
    if(food != null)
    {
      force = PVector.sub(food.loc, this.loc);
      force.normalize();
      force.mult(this.top_speed);
      force.sub(this.vel);
      force.limit(4*this.max_force*this.mass);
      return force;
    }
    else
    {
      return null;
    }
  }
  
  PVector separate()
  {
    sum = new PVector();
    int count = 0;
    
    force = new PVector();
    
    // For each contact
    if(this.contacts.size() > 0)
    {
      for(int i = 0; i < this.contacts.size(); i++)
      {
        // Set a new destination
        //this.move(new PVector(random(width), random(height)));
        // Get the vector between the two lucas
        force = PVector.sub(this.loc, this.contacts.get(i).loc);
        
        force.normalize();
        //pull.mult(all.get(i).top_speed);
        
        float dist = PVector.dist(this.loc, this.contacts.get(i).loc);
        
        /*if(dist > 0 && dist < (all.get(i).cell_w + all.get(i).contacts.get(n).cell_w))
        {
          pull.div(dist);
        }
        */

        float force_mag = map(dist, 0, 20, 0, 3);
        force.mult(force_mag);
        /*if(dist > 0 && dist < (all.get(i).cell_w + all.get(i).contacts.get(n).cell_w))
        {
        pull.div(dist);
        }
        */
        
        sum.add(force);
        count++;
        
      }
      sum.div(count);
      sum.setMag(this.top_speed);
      sum.sub(this.vel);
      sum.limit(this.max_force*this.mass);
    }
    return sum;
  }

  // Display the luca
  void drawLuca()
  {
    beginShape();
    stroke(0, 0, 0);
    fill(this.spec.col);
    if(!isPaused)
    {
      for (float i = 0; i < TWO_PI; i = i + 0.2)
      {
        int index = int(degrees(i)) % 360;
        // Create edge of circle using sine and cosine
        float x1 = sin_values[index] * this.cell_w;
        float y1 = cos_values[index] * this.cell_w;
  /*
        // Map the relative position of the vertex within the shape to the exact range of the image dimensions
              float u = map(x1, -1.2*this.cell_w, 1.2*this.cell_w, 0, this.cell_w);
              float v = map(y1, -1.2*this.cell_w, 1.2*this.cell_w, 0, this.cell_w-0); // Use height instead of width

              // Add noise to the texture coordinates
              u += sin(u * 0.001) * 100; // Scale down the value passed into the noise function
              v += sin(v * 0.001) * 100; // Scale down the value passed into the noise function
  */
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
    }
    //stroke(this.spec.col);
    //ellipse(0,0,radius*2,radius*2);
  }

  /*
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
  */

  // Method to detect if a luca is making contact with another luca
  // Returns the luca it is making contact with
  Luca detectContact()
  {
    ArrayList<Luca> temp = new ArrayList<Luca>();
    if(this instanceof Predator)
    {
      temp = (ArrayList<Luca>)all_predators.clone();
    }
    else
    {
      int i = (int)(this.loc.x / this.cell_w);
      int j = (int)(this.loc.y / this.cell_w);
      // Apply forces only to Luca objects in the same cell
      i = min(i, grid.length - 1);
      j = min(j, grid[0].length - 1);

      temp = grid[i][j];
    }
    // For every luca
    for(Luca l: temp)
    {
      // If it is not the luca we're checking
      if(!this.equals(l))
      {
        
        // Calculate the distance between the lucas
        float distance = dist(this.loc.x, this.loc.y, l.loc.x, l.loc.y);
        // If they are touching
        if(distance < (this.cell_w + l.cell_w + 1))
        {
          // If not already on the contacts list
          if(!this.contacts.contains(l))
          {
            // Add it to the contacts list
            this.contacts.add(l);
          }
          // Return the luca it is touching
          return l;
        }
        // If they are not touching
        else
        {
          // If the other luca is on the contacts list
          if(this.contacts.contains(l))
          {
            //println(this.id + " is no longer touching " + i);
            // Remove it from the contacts list
            this.contacts.remove(l);
          }
        }
      }
    }
    // If no contacts are found, return null
    return null;
  }
  /*
  // Method to view all lucas a luca is contacting
  void viewContacts()
  {
    // For each luca being contacted
    for(int i = 0; i < this.contacts.size(); i++)
    {
      // Display the luca
      println("Luca # " + all.indexOf(this) + ": Contact with " + all.indexOf(this.contacts.get(i)));
    }
  }
  */
  // Spawns a cell in the center of the environment
  void spawn()
  {
    // Set new Luca's x and y values, and their PVector location
    this.loc = new PVector(width - 100, height - 100);
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

  // Spawn luca on top of another luca
  Luca spawn(Luca l)
  {
    Luca l2 = null;
    if(l instanceof Predator)
    {
      l2 = new Predator(l.loc.x, l.loc.y, l.cell_w, l.top_speed, l.rep_rate, l.max_force, l.max_hunger, l.max_stam, l.split_thresh, l.lifespan);
    }
    else
    {
      l2 = new Luca(l.loc.x, l.loc.y, l.cell_w, l.top_speed, l.rep_rate, l.max_force, l.max_hunger, l.max_stam, l.split_thresh, l.lifespan);
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

    this.stam *= random(0, .2);
    this.hunger += random(15, 25);
    this.rep_prog *= random(0, .2);

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
    
    return l2;
  }

  boolean eaten()
  {
    if(!(this instanceof Predator))
    {
      for(Luca pred: all_predators)
      {
        if(PVector.dist(this.loc, pred.loc) <= pred.cell_w)
        {
          pred.hunger -= this.cell_w;
          pred.stam += this.cell_w;
          // Limit hunger to zero
          constrain(pred.hunger, 0, pred.max_hunger);
          return true;
        }
      }
    }
    return false;
  }
  
    // Check if a luca touches an edge
  void checkEdges()
  {
    if(this.loc.x > width)
    {
      this.loc.x = width;
      this.vel.x *= 0;
      //this.acc.x *= 0;
    }
    else if(this.loc.x < 0)
    {
      this.loc.x = 0;
      this.vel.x *= 0;
      //this.acc.x *= 0;
    }
    if(this.loc.y > height)
    {
      this.loc.y = height;
      this.vel.y *= 0;
      //this.acc.y *= 0;
    }
    else if(this.loc.y < 50)
    {
      this.loc.y = 50;
      this.vel.y *= 0;
      //this.acc.y *= 0;
    }
  }

/*
  void arrive(PVector target)
  {
    // Desired velocity
    force = PVector.sub(target, this.loc);

    // Distance is the magnitude of the velocity vector
    float distance = force.magSq();
    // Normalize between 0 and 1
    force.normalize();

    // If closer than 20 pixels
    if (distance < 400)
    {
      // Set magnitude of desired velocity vector according to how close it is
      float m = map(distance, 0, 20, 0, this.top_speed);
      force.mult(m);
    } 
    else
    {
      // Otherwise maintain velocity
      force.mult(this.max_force);
    }
    // Steering = desired_velocity - velocity
    force.sub(this.vel);
    // 1 = max force. May change
    // Play with this value
    //*************************************
    force.limit(this.max_force * this.mass);
    // Apply force
    this.applyForce(force);
  }
  */

  /*
  // Set luca's destination
   public void setDest(PVector l, PVector v)
   {
   this.dest = PVector.add(l, v);
   }
   */

  // Apply force to luca
  void applyForce(PVector f)
  {
    f = f.div(this.mass);
    this.acc.add(f);
  }

/*
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
*/
/*
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

*/
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
  //}

  // Inititate motion
  void move()
  {
    this.acc.limit(max_force * mass);
    force = PVector.add(this.vel, this.acc);
    this.vel = PVector.lerp(this.vel, force, 0.2);
    //this.vel.limit(this.top_speed);
    this.loc.add(this.vel);
    this.acc.mult(0);
  }
/*
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
      force = PVector.sub(this.dest, this.loc);
    }
    this.dir = force;
    this.acc = dir;
*/
    /*
    
     // Set the direction of acceleration
     this.dir = d;
     this.acc = this.dir;
     */
  //}
  /*
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
  */

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
