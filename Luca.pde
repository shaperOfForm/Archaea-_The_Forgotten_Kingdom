/**
  *Luca class
  A class to create Luca objects (cells) and provide all of its functionality
 */
class Luca
{
  // Attributes
  //String diet;
  float cell_w;
  float cell_h;
  PVector loc;
  PVector vel;
  PVector acc;
  float speed;
  float stam;
  float rep_rate;
  //boolean can_move = true;
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

  float fitness;

  float food_eaten;
  
  color col;

  float seek_force;

  float sense_range;

  float flock_force;

  float delta_acc;

  DNA dna;

  /**
    *Default constructor
   */
  Luca()
  {
    // Spawns in center of screen
    this.loc = new PVector(width - 100, height - 100);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    // Creeate a new DNA object
    this.dna = new DNA();
    // Set attributes, the mapping is currently unnecessary for these attributes as I temporarily set starting values for them
    this.top_speed = map(dna.genes[0], 0, 1, 26, 26);
    this.cell_w = map(dna.genes[1], 0, 1, 15, 19); // 15
    this.rep_rate = map(dna.genes[2], 0, 1, 10, 10); // 25
    this.lifespan = map(dna.genes[3], 0, 1, 400, 400); // 150
    this.max_hunger = map(dna.genes[4], 0, 1, 55, 55); // 500
    this.mut_rate = map(dna.genes[5], 0, 1, .65, .65); //.25
    this.split_thresh = map(dna.genes[6], 0, 1, 50, 50); // 30
    this.seek_force = map(dna.genes[7], 0, 1, 15, 15);
    this.sense_range = map(dna.genes[8], 0, 1, 500, 500);
    this.flock_force = map(dna.genes[9], 0, 1, 12, 12);
    this.delta_acc = map(dna.genes[9], 0, 1, .2, .2);
    // Set mass (Used a proportion of the average mass of a bacterial cell divided by the average mass of a bacterial cell to the 'volme' of a prey, using its width as the radius)
    this.mass = 64656.70908252886 / (this.cell_w/2 * this.cell_w/2 * this.cell_w/2);
    // High arbitrary value
    this.max_force = 500;
    // Iniialize parent and children
    this.parent = null;
    this.children = new ArrayList<Luca>();
    //this.dest = null;
    // X and y coordinates used in drawing the wavy edges of the cell
    this.xCoor = new ArrayList<Float>();
    this.yCoor = new ArrayList<Float>();
    // Initialize attributes
    this.spec = null;
    this.contacts = new ArrayList<Luca>();
    this.closest_food = null;
    // Setting life_remining to full
    this.life_remaining = lifespan;
    // Setting hunger to zero
    this.hunger = 0;
    //this.can_seek = true;
    // Was used for wandering, but not used
    this.timex = random(1000);
    this.timey = random(1000);
    //this.wanderTheta = random(0, 2*PI);
    // If the Luca is a predator
    if(!(this instanceof Predator))
    {
      // Add the Luca to the prey ArrayList
      all_prey.add(this);
    }
    // Set reproduction progress and stamina for first luca so they don't die right away
    this.rep_prog = 12;
    this.stam = this.split_thresh - 10;
    // Set the color to a random color
    this.col = new_spec_col;
  }
  /**
    *Constructor with parameters for replication
    @param x The x location of the Luca
    @param y The y location of the Luca
    @param parent The parent of the Luca
   */
  
  Luca(float x, float y, Luca parent)
  {
    // Call the default constructor
    this();
    // Set the location of the Luca
    this.loc = new PVector(x, y);
    // Set the parent of the Luca
    this.parent = parent;
    // Add the Luca to the parent's children ArrayList
    parent.children.add(this);
    // Set attributes to parent's attributes
    this.spec = parent.spec;
    this.col = parent.col;
    // Set the DNA of the Luca to the parent's DNA
    this.dna = parent.dna.copy();
    // Mutate the DNA
    this.mutate();
    //The line above and the block below may be redundant, but I don't want to play with it any more than I have to, as it may break the balancing
    if(!(this instanceof Predator))
    {
      // An offset which represents the range of values the attributes can be mutated by
      float offset = 0.1f;
      // Use the parent genes as a base, 'mutate them' by mapping them to a range that is a percentage away from the parent value, as dictated by the offset, and assign them to the attributes
      this.top_speed = map(dna.genes[0], 0, 1, parent.top_speed * (1 - offset), parent.top_speed * (1 + offset));
      this.cell_w = map(dna.genes[1], 0, 1, parent.cell_w * (1 - .5*offset), parent.cell_w * (1 + .5*offset)); // 15
      this.rep_rate = map(dna.genes[2], 0, 1, parent.rep_rate * (1 - offset), parent.rep_rate * (1 + offset)); // 25
      this.lifespan = map(dna.genes[3], 0, 1, parent.lifespan * (1 - offset), parent.lifespan * (1 + offset)); // 150
      this.max_hunger = map(dna.genes[4], 0, 1, parent.max_hunger * (1 - offset), parent.max_hunger * (1 + offset)); // 500
      this.mut_rate = map(dna.genes[5], 0, 1, parent.mut_rate * (1 - offset), parent.mut_rate * (1 + offset)); //.25
      this.split_thresh = map(dna.genes[6], 0, 1, parent.split_thresh * (1 - offset), parent.split_thresh * (1 + offset)); // 30
      this.seek_force = map(dna.genes[7], 0, 1, parent.seek_force * (1 - .1*offset), parent.seek_force * (1 + .1*offset));
      this.sense_range = map(dna.genes[8], 0, 1, parent.sense_range * (1 - .1*offset), parent.sense_range * (1 + .1*offset));
      this.flock_force = map(dna.genes[9], 0, 1, parent.flock_force * (1 - .1*offset), parent.flock_force * (1 + .1*offset));
      this.delta_acc = map(dna.genes[9], 0, 1, parent.delta_acc * (1 - .1*offset), parent.delta_acc * (1 + .1*offset));
      this.rep_prog = random(0, 3);
    }
    // Set the stamina and replication progress to zero
    this.stam = 0;
    this.rep_prog = 0;
  }
  /**
    *Method to mutate the descendant's genes at replication
    @return void
   */
  void mutate()
  {
    // For each gene in the DNA
    for(int i = 0; i < this.dna.genes.length; i++)
    {
      // If a random number between 0 and 1 is less than the mutation rate
      if(random(1) < this.mut_rate)
      {
        // Mutate the gene by adding a random value between -9 and 9
        this.dna.genes[i] = this.dna.genes[i] + random(-9, 9);
        // Constrain the gene to be between 0 and 1. This results in a mutation of eith 0 or 1 most of the time, for the mutations to be observable for the presentation
        this.dna.genes[i] = constrain(this.dna.genes[i], 0, 1);
      }
    }
  }

  /**
    *Method to apply the repel force of a predator to a prey
   */
  void applyRepeller(Predator p)
  {
    // Set force to the repel force
    force = p.repel(this);
    // Apply the force
    this.applyForce(force);
  }
  
  /**
    *Method to check the fitness of a prey
    @return void
   */
  void fitness()
  {
    // Fitness is calculated using the number of food eaten and the number of decsendants
    this.fitness += pow((.25*this.food_eaten), 2);
    this.fitness += pow(this.children.size(), 2);
  }

  /**
    *Method to apply flocking forces
    @return void
   */
  void applyFlockForce()
  {
    // For each of the three flocking forces
    for(int k = 0; k < 3; k++)
    {
      // Get separation, cohesion, and alignment forces
      force = this.flock()[k];
      // Scale the forces
      force.mult(this.flock_force);
      // Apply the forces
      this.applyForce(force);
    }
  }

  /**
    A method to apply separation force from prey of different species
    @return void
   */
  void applySeparation()
  {
    // Have them separate from each other
    force = this.separate();
    // Scale the force
    force.mult(4);
    // Apply the force
    this.applyForce(force);
  }
  
  /**
    *Method to apply a force to seek the closest food
    @return void
   */
  void applySeekFoodForce()
  {
    // Get the seek food force
    force = this.seekClosest();
    // If the force is not null
    if(force != null /*&& this.can_seek*/ && (force.x != 0 && force.y != 0))
    {
      // Map the hunger level to a value between 0 and 1
      float h = map(this.hunger, 0, this.max_hunger, 0, 1);
      // Constrain the hunger level by max hunger and a number below 1
      h = constrain(h, .5, this.max_hunger);
      // Scale the force using the hunger level and the seek force
      force.mult(h*this.seek_force);
      // Apply the force
      this.applyForce(force);
    }
  }

  /**
    *Method to apply a force to evade predators
    @return void
   */
  void applyEvasionForce()
  {
    // Reset force
    if(force != null)
    {
      force.x = 0;
      force.y = 0;
    }
    else
    {
      force = new PVector(0, 0);
    }
    // For each predator
    for(Predator p: all_predators)
    {
      // Add the repel force
      PVector repel = p.repel(this);
      if(repel != null)
      {
        force.add(repel);
      }
    }
    // Limit the force
    force.limit(this.max_force);
    // Scale the force
    // Highest priority
    force.mult(19);
    // Apply the force
    this.applyForce(force);
  }

  /**
    *Method to apply a force to move away from walls
    @return void
   */
  void applyWallForce()
  {
    //Get force from walls
    force = this.wallForce();
    // Scale the force
    force.mult(4);
    // Apply the force
    this.applyForce(force);
  }

  /**
    *Method to apply flocking and separation forces
    @return void
   */
  void flockAndSeparate()
  {
    // Get the grid location of the Luca
    int i = (int)(this.loc.x / this.cell_w);
    int j = (int)(this.loc.y / this.cell_w);
    // Constrain the grid location to the grid size
    i = constrain(i, 0, grid.length - 1);
    j = constrain(j, 0, grid[0].length - 1);
    
    // Get the Luca objects in the same cell
    ArrayList<Luca> temp = grid[i][j];
    // For each Luca in the cell
    for(Luca l2: temp)
    {
      // If the Luca is not the same as the current Luca
      if(this != l2)
      {
        // If the Luca is the same species
        if(this.spec.equals(l2.spec))
        {
          // Apply flocking behavior
          applyFlockForce();
        }
        // If the Luca is not the same species
        else if(!(l2 instanceof Predator))
        {
          // Apply separation
          applySeparation();
        }
      }
    }
  }
  
  /**
    *Method to apply the internal forces of the Luca
    @return void
   */
  void applyBehaviors()
  {
    flockAndSeparate();
    // Seek food
    applySeekFoodForce();

    // Evade predators
    applyEvasionForce();

    // Move away from walls
    applyWallForce();
  }

  /**
    *Method to seek a target location (for cohesion)
    @param target The target location to seek
    @return PVector: The force to seek the target location
   */
  PVector seek(PVector target)
  {
    // Get the desired velocity
    force = PVector.sub(target, this.loc);
    // Normalize the force
    force.normalize();
    // Multiply by the maximum speed
    force.mult(this.top_speed);
    // Get the force by subtracting the current velocity from the desired velocity
    force.sub(this.vel);
    // Limit the force
    force.limit(this.max_force);
    // Return the force
    return force;
  }

  /**
    *Method for flocking behavior
    @return PVector[]: An array of the separation, alignment, and cohesion forces
   */
  PVector[] flock()
  {
    // Get the separation, alignment, and cohesion forces
    PVector sep = separate();
    PVector ali = align();
    PVector coh = cohesion();
    // Scale the forces
    sep.mult(1.9);
    ali.mult(3.5);
    coh.mult(2.0);
    // Return the forces
    return new PVector[]{sep, ali, coh};
  }
  
  /**
    *Method for cohesion
    @return PVector: The force for cohesion
   */
  PVector cohesion()
  {
    // Set the maximum neighbor distance for cohesion
    float neighborDist = 100;
    // Initialize the sum of locations and count
    sum = new PVector(0, 0);
    int count = 0;
    // For each prey
    for(Luca l: all_prey)
    {
      // Calculate the distance between the two lucas
      float d = PVector.dist(this.loc, l.loc);
      // If the distance is greater than 0 and less than the neighbor distance
      if((d > 0) && (d < neighborDist))
      {
        // Add the location of the prey to the sum
        sum.add(l.loc);
        // Increment the count
        count++;
      }
    }
    // If there are any lucas for cohesion
    if(count > 0)
    {
      // Get the average location
      sum.div(count);
      // Return the seek force to the average location
      return this.seek(sum);
    }
    // If there are no lucas for cohesion
    else
    {
      // Return a zero vector
      return new PVector(0, 0);
    }
  }
  
  /**
    *Method for alignment
    @return PVector: The force for alignment
   */
  PVector align()
  {
    // // Set the maximum neighor distance for cohesion
    float neighborDist = 50;
    // Initialize the sum of velocities and count
    sum = new PVector(0, 0);
    int count = 0;
    // For each prey
    for(Luca l: all_prey)
    {
      // Calculate the distance between the two lucas
      float d = PVector.dist(this.loc, l.loc);
      // If the distance is greater than 0 and less than the neighbor distance
      if((d > 0) && (d < neighborDist))
      {
        // Add the velocity of the prey to the sum
        sum.add(l.vel);
        // Increment the count
        count++;
      }
    }
    // If there are any lucas for alignment
    if(count > 0)
    {
      // Get the average velocity
      sum.div(count);
      // Normalize the average
      sum.normalize();
      // Multiply by the maximum speed
      sum.mult(this.top_speed);
      // Get the force by subtracting the current velocity from the average velocity
      force = sum.sub(this.vel);
      // Limit the force
      force.limit(this.max_force);
      // Return the force
      return force;
    }
    // If there are no lucas for alignment
    else
    {
      // Return a zero vector
      return sum;
    }
  }
  /**
    *Method to move away from walls
    @return PVector: The force to move away from walls
   */
  PVector wallForce()
  {
    // Set the distance from the edge at which the force statrs to be applied
    float margin = 100;
    // Reset force
    if(force != null)
    {
      force.x = 0;
      force.y = 0;
    }
    else
    {
      force = new PVector(0, 0);
    }
    // Initialize the count
    int count = 0;
    // If the Luca is close to the right edge
    if(this.loc.x > width - margin)
    {
      // Map the distance to the edge to a force strength
      float forceStrength = map(this.loc.x, width - margin, width, 0, this.max_force*this.mass);
      // Add the force to the force vector
      force.add(new PVector(-forceStrength, 0));
      // Increment the count
      count++;
    }
    // If the Luca is close to the left edge
    else if(this.loc.x < margin)
    {
      // Map the distance to the edge to a force strength
      float forceStrength = map(this.loc.x, 0, margin, this.max_force*this.mass, 0);
      // Add the force to the force vector
      force.add(new PVector(forceStrength, 0));
      // Increment the count
      count++;
    }
    // If the Luca is close to the bottom edge
    if(this.loc.y > height - margin)
    {
      // Map the distance to the edge to a force strength
      float forceStrength = map(this.loc.y, height - margin, height, 0, this.max_force*this.mass);
      // Add the force to the force vector
      force.add(new PVector(0, -forceStrength));
      // Increment the count
      count++;
    }
    // If the Luca is close to the top edge
    else if(this.loc.y < margin)
    {
      // Map the distance to the edge to a force strength
      float forceStrength = map(this.loc.y, 0, margin, this.max_force*this.mass, 0);
      // Add the force to the force vector
      force.add(new PVector(0, forceStrength));
      // Increment the count
      count++;
    }
    // If the count is not zero
    if(count != 0)
    {
      // Get the average force
      force.div(count);
      // Limit the force factoring in the prey's size
      force.limit(this.cell_w/3);
    }
    // Return the force
    return force;
  }
  /**
    *Method to seek the closest food
    @return PVector: The force to seek the closest food
   */
  PVector seekClosest()
  {
    // Initialize the minimum distance
    float min_dist = Float.MAX_VALUE;
    // Initialize the closest food
    Food closest = null;
    // For each food
    for(Food food: e.all_food)
    {
      // If the food is not null
      if(food != null)
      {
        // Calculate the distance between the Luca and the food (divided by the food's mass to make the distance relative to the food's size)
        float dist = PVector.dist(this.loc, food.loc) / food.mass;
        // If the distance is less than the minimum distance, the food is not eaten, and the Luca is larger than the food
        if(dist < min_dist && !food.eaten() && this.cell_w > 2*food.mass)
        {
          // Set the minimum distance to the distance
          min_dist = dist;
          // Set the closest food to the food
          closest = food;
        }
      }
    }
    // Set the closest food to the Luca's closest food
    this.closest_food = closest;
    // Return the seek force to the closest food
    return this.seek(this.closest_food);
  }

  /**
    *Method to seek a specified food
    @param food The food to seek
    @return PVector: The force to seek the food
   */
  PVector seek(Food food)
  {
    // If the food is not null
    if(food != null)
    {
      // Get the force to the food
      force = PVector.sub(food.loc, this.loc);
      // Normalize the force
      force.normalize();
      // Multiply by the maximum speed
      force.mult(this.top_speed);
      // Get the force by subtracting the current velocity from the desired velocity
      force.sub(this.vel);
      // Limit the force
      force.limit(this.max_force);
      // Return the force
      return force;
    }
    // If the food is null
    else
    {
      // Return null
      return null;
    }
  }
  
  /**
    *Method to separate from other lucas
    @return PVector: The force to separate from other lucas
   */
  PVector separate()
  {
    // Initialize the sum of forces
    sum = new PVector();
    // Initialize the count
    int count = 0;
    // Reset force
    if(force != null)
    {
      force.x = 0;
      force.y = 0;
    }
    else
    {
      force = new PVector(0, 0);
    }
    
    // If there is at least one contact
    if(this.contacts.size() > 0)
    {
      // For each contact
      for(int i = 0; i < this.contacts.size(); i++)
      {
        // Get the vector between the two lucas
        force = PVector.sub(this.loc, this.contacts.get(i).loc);
        // Normalize the force
        force.normalize();
        //pull.mult(all.get(i).top_speed);
        // Get the distance between the two lucas
        float dist = PVector.dist(this.loc, this.contacts.get(i).loc);
        
        // Map the distance from 9-20 to 0-3
        float force_mag = map(dist, 0, 20, 0, 3);
        // Multiply the force by the force magnitude
        force.mult(force_mag);
        
        // Add the force to the sum
        sum.add(force);
        // Increment the count
        count++;
      }
      
      // Get the average force
      sum.div(count);
      // Set the magnitude of the force to the maximum force
      sum.setMag(this.top_speed);
      // Get the force by subtracting the current velocity from the desired velocity
      sum.sub(this.vel);
      // Limit the force
      sum.limit(this.max_force);
    }
    // Return the force
    return sum;
  }

  /**
    *Display the luca
    @return void
   */
  void drawLuca()
  {
    // Set the stroke color to black
    stroke(0);
    // Calculate the color based on the life_remaining
    // Start color of the Luca
    color startColor = color(40);
    // Original color of the Luca
    color endColor = this.spec.col;
    // Map the life_remaining to a value between 0 and 1 
    float amt = map(this.life_remaining, 0, this.lifespan, 0, 1);
    // Get the interpolated color
    color interpColor = lerpColor(startColor, endColor, amt);
    // Apply the color fill to the shape
    fill(interpColor); 
    // Create shape
    beginShape();
    // If the program is not paused
    if(!isPaused)
    {
      // Get the x and y coordinates of the wavy edges of the cell
      for (float i = 0; i < TWO_PI; i = i + 0.2)
      {
        // Get the index of the sine and cosine values
        int index = int(degrees(i)) % 360;
        // Create edge of circle using sine and cosine
        float x1 = sin_values[index] * this.cell_w;
        float y1 = cos_values[index] * this.cell_w;
        // Get a random offset
        float xOffset = random(-1.25, 1.25);
        float yOffset = random(-1.25, 1.25);
        // Add the offset to the edge coordinates
        x1 += this.loc.x + xOffset;
        y1 += this.loc.y + yOffset;
        // Create a curved line between the vertices
        curveVertex(x1, y1);
      }
    // End shape creation
    endShape(CLOSE);
    // Set no fill
    noFill();
    }
    
    // Draw a circular progress bar for the hunger level
    // Green color for the progress bar
    stroke(0, 255, 0);
    // Make the progress bar a bit thicker 
    strokeWeight(4);
    // No fill for the progress bar 
    noFill(); 
    // Map the hunger level to an angle
    float hungerAngle = map(this.hunger, 0, this.max_hunger, PI, 0); 
    // Draw the progress bar
    arc(this.loc.x, this.loc.y, this.cell_w * 2, this.cell_w * 2, -HALF_PI, -HALF_PI + hungerAngle); 
    // Reset the stroke weight
    strokeWeight(4);
    // Reset the stroke color 
    stroke(0); 

    // Draw a circular progress bar for the stamina level
    // Yellow color for the progress bar
    stroke(255, 210, 0); 
    // Map the stamina level to an angle
    float staminaAngle = map(this.stam, 0, this.split_thresh, 0, PI); 
    // Draw the progress bar
    arc(this.loc.x, this.loc.y, this.cell_w * 2, this.cell_w * 2, HALF_PI, HALF_PI + staminaAngle); 
    // Reset the stroke weight
    strokeWeight(1); 
    // Reset the stroke color
    stroke(0); 
  }

  /**
    *Method to detect if a luca is making contact with another luca
    @return Luca: The luca that is in contact with the current luca
   */
  Luca detectContact()
  {
    // Create a temporary ArrayList to store the lucas in the same cell
    ArrayList<Luca> temp = new ArrayList<Luca>();
    // If the luca is a predator
    if(this instanceof Predator)
    {
      // Set the temporary ArrayList to the all_predators ArrayList
      temp = (ArrayList<Luca>)all_predators.clone();
    }
    // If the luca is not a predator
    else
    {
      // Get the grid location of the luca
      int i = (int)(this.loc.x / this.cell_w);
      int j = (int)(this.loc.y / this.cell_w);
      // Constrain the grid location to the grid size
      i = constrain(i, 0, grid.length - 1);
      j = constrain(j, 0, grid[0].length - 1);
      // Get the lucas in the same cell
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
            // Remove it from the contacts list
            this.contacts.remove(l);
          }
        }
      }
    }
    // If no contacts are found, return null
    return null;
  }

  /**
    *Spawns an initial luca
   */
  void spawn()
  {
    // Set new Luca's x and y values, and their PVector location
    this.loc = new PVector(width - 100, height - 100);
    // Add this Luca to the static ArrayList
    all.add(this);
  }

  /**
    *Spawn luca on top of another luca
    @param l The luca to spawn
    @return Luca: The new luca
   */
  Luca spawn(Luca l)
  {
    // Create a new Luca
    Luca l2 = null;
    // If the luca is a predator
    if(l instanceof Predator)
    {
      // Create a new predator
      l2 = new Predator(l.loc.x, l.loc.y, (Predator)l);
    }
    // If the luca is not a predator
    else
    {
      // Create a new prey
      l2 = new Luca(l.loc.x, l.loc.y, l);
    }
    // Add the new luca to the static ArrayList
    all.add(l2);
    // Return the new luca
    return l2;
  }

  /**
    *Split one Luca into two
    @return Luca: The new Luca
   */ 
  Luca split()
  {
    // Lower the stamina and replication progress and increase the hunger
    this.stam *= random(0, .1);
    this.hunger += random(15, 25);
    this.rep_prog = random(0, 3);
    // Spawn new luca on top of original
    Luca l2 = this.spawn(this);
    // Set the new luca's stamina and location
    l2.stam = 0;
    l2.loc = new PVector(this.loc.x, this.loc.y);

    // Set child and parent
    if(this.children != null)
    {
      l2.parent = this;
      this.children.add(l2);
    }
    // Set the new luca's species
    l2.spec = this.spec;
    // Return the new luca
    return l2;
  }
  
  /**
    *Method to check if a luca is eaten
    @return boolean: Whether the luca is eaten
   */
  boolean eaten()
  {
    // If the luca is not a predator
    if(!(this instanceof Predator))
    { 
      // For each predator
      for(Luca pred: all_predators)
      {
        // If the distance between the luca and the predator is less than the predator's cell width
        if(PVector.dist(this.loc, pred.loc) <= pred.cell_w && pred.cell_w > this.cell_w)
        {
          // Lower the predator's hunger and increase its stamina
          pred.hunger -= this.cell_w;
          pred.stam += this.cell_w;
          // Increase the predator's prey eaten count
          ((Predator)pred).prey_eaten++;
          // Limit hunger to zero
          constrain(pred.hunger, 0, pred.max_hunger);
          // Return true
          return true;
        }
      }
    }
    // If not eaten, return false
    return false;
  }
  
  /**
    *Check if a luca touches an edge
    @return void
   */
  void checkEdges()
  { 
    // If the luca is touching the right edge
    if(this.loc.x > width)
    {
      // Set the x location to the width
      this.loc.x = width;
      // Set the x velocity to 0
      this.vel.x *= 0;
    }
    // If a luca is touching the left edge
    else if(this.loc.x < 0)
    {
      // Set the x location to 0
      this.loc.x = 0;
      // Set the x velocity to 0
      this.vel.x *= 0;
    }
    // If a luca is touching the bottom edge
    if(this.loc.y > height)
    {
      // Set the y location to the height
      this.loc.y = height;
      // Set the y velocity to 0
      this.vel.y *= 0;
    }
    // If a luca is touching the top edge
    else if(this.loc.y < 50)
    {
      // Set the y location to 50 (top edge)
      this.loc.y = 50;
      // Set the y velocity to 0
      this.vel.y *= 0;
    }
  }

  /**
    *Apply force to luca
    @param f The force to apply
    @return void
   */
  void applyForce(PVector f)
  {
    // Divide the force by the mass
    f = f.div(this.mass);
    // Add the force to the acceleration
    this.acc.add(f);
  }

  /**
    *Inititate motion (update location and velocity)
    @return void
   */
  void move()
  {
    // Limit the aceeleration
    this.acc.limit(max_force / mass);
    // Add the acceleration to the velocity
    force = PVector.add(this.vel, this.acc);
    // Slow down the change in velocity
    this.vel = PVector.lerp(this.vel, force, this.delta_acc);
    // Limit the velocity
    this.vel.limit(this.top_speed);
    // Add the velocity to the location
    this.loc.add(this.vel);
    // Reset the acceleration
    this.acc.mult(0);
  }

  /*
  // Copilot helped with this method
  PVector reynoldsWander()
  {
    // Set the wander circle radius and distance
    float wanderR = 50; // Radius for our "wander circle"
    float wanderD = 200; // Distance for our "wander circle"
    // Set the change in wander theta
    float change = 0.3;
    // Randomly change wander theta
    wanderTheta += random(-change,change); // Randomly change wander theta

    // Calculate the new location to steer towards on the wander circle
    // Start with velocity
    PVector circleloc = this.vel.copy();
    // Normalize
    circleloc.normalize();
    // Multiply by distance
    circleloc.mult(wanderD);
    // Make it relative to prey's location
    circleloc.add(this.loc);
    // We could be moving in any direction so this is irrelevant
    float h = this.vel.heading();
    
    // Calculate the new target point on the circle, which is offset using wanderTheta
    PVector target = circleloc.add(wanderR*cos(wanderTheta+h), wanderR*sin(wanderTheta+h));

    // And steer towards it
    PVector steer = PVector.sub(target, this.loc);
    // Limit to maximum steering force
    steer.limit(.2);
    // Return the force
    return steer;
  }
  */

  /*
    // A method to wander in randomly changing directions according to a noise function (Perlin noise) and time, using the map fuction to map the noise value to a range of angles
    PVector wander()
    {    
      // Get the force using the mapping Perlin noise
      force = new PVector(map(noise(this.timex), 0, 1, -width/2, width/2), map(noise(this.timey), 0, 1, -height/2, height/2));
      // Normalize the force
      force.normalize();
      // Multiply by the maximum force
      force.mult(this.max_force);

      // Increment the time values
      this.timex += 1.5;
      this.timey += 1.5;

      // Return the force
      return force;
    }
  */

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

 /* String toString()
  {
    String str = "Luca number: " + t + "\n";
    return str;
  }
  */
}
