// I don't think these variablles are used
static int num_species = 0;
long restStartTime = 0;
boolean resting = false;

color new_spec_col;

/**
  *Species class
  This class is used to create species of lucas. It contains a list of all lucas in the species and the functionality to run them.
 */
class Species
{
  // Attributes
  color col;
  //String diet;
  // Not yet implemented
  /*
  float width_avg;
  float rep_rate_avg;
  float top_speed_avg;
  float max_hunger_avg;
  float split_thresh_avg;
  float lifespan_avg;
  float mut_rate_avg;
  */
  // Not yet implemented
  /*
  float width_var;
  float rep_rate_var;
  float top_speed_var;
  float max_hunger_var;
  float split_thresh_var;
  float lifespan_var;
  float mut_rate_var;
  */
  //String movement = null;
  //boolean gene_flow = false;
  
  ArrayList<Luca> all_in_species;

  boolean speciate = false;

  // Not yet implemented
  /*
  float sq_of_width_avg;
  float sq_of_rep_rate_avg;
  float sq_of_top_speed_avg;
  float sq_of_max_hunger_avg;
  float sq_of_split_thresh_avg;
  float sq_of_lifespan_avg;
  float sq_of_mut_rate_avg;
  */

  /**
    *Constructor for prey species
   */
  Species()
  {
    // Initialize attributes
    this.col= color(random(255), random(255), random(255));
    new_spec_col = col;
    this.all_in_species = new ArrayList<Luca>();
    //this.diet = "Filter";

    /*// Not yet implemented
    
    this.width_avg = 0;
    this.rep_rate_avg = 0;
    this.top_speed_avg = 0;
    this.lifespan_avg = 0;
    this.max_hunger_avg = 0;
    this.split_thresh_avg = 0;
    this.mut_rate_avg = 0;
    */
    //this.gene_flow = false;
    
    // Create initial prey
    Luca luca = new Luca();
    //Set prey's species
    luca.spec = this;
    // Add prey to species
    this.all_in_species.add(luca);
    // Add species to biome arraylist
    e.biome.b.add(this);
    // Spawn first prey
    luca.spawn();

  }

  /**
    *Constructor for predators (n is arbitrary, just to differentiate from the other constructor)
   */
  Species(int n)
  {
    // Initialize attributes
    this.col= color(random(255), random(255), random(255));
    new_spec_col = col;
    //this.diet = "Filter";

    // Not yet implemented
    /*
    this.width_avg = 10;
    this.rep_rate_avg = 5;
    this.top_speed_avg = .8;
    this.lifespan_avg = 15;
    this.max_hunger_avg = 50;
    this.split_thresh_avg = 25;
    this.mut_rate_avg = .2;
    */
    this.all_in_species = new ArrayList<Luca>();
    // Create initial predator
    Luca predator = new Predator();
    // Set predator's species to this
    predator.spec = this;
    // Add predator to species
    this.all_in_species.add(predator);
    // Spawn first predator
    predator.spawn();
    // Set predator's location
    predator.loc = new PVector(100, 100);
  }
  
  /**
    *Constructor for speciation
   */
  Species(Luca l)
  {
    // Initialize attributes
    this.col= color(random(255), random(255), random(255));
    this.all_in_species = new ArrayList<Luca>();
    // Store random color
    new_spec_col = col;
    //this.all_in_species.add(l);
    Luca l2 = l.spawn(l);
    // Set l2's species to this
    l2.spec = this;
    // Remove l2 from its current species and add it to the new species
    if (l2.spec != null) 
    {
      l2.spec.all_in_species.remove(l2);
    }
    // Add l2 to the new species
    this.all_in_species.add(l2);
    //println("Species created from Luca");
  }
  
  /**
    *Method to run each luca in a species
    @return void
   */
  void run()
  {
    // Create a temporary list to store new lucas before adding them
    ArrayList<Luca> new_lucas = new ArrayList<Luca>();
    // First loop: Update state of all Luca instances using an iterator
    Iterator<Luca> it = this.all_in_species.iterator();
    while(it.hasNext()) {
      Luca l = it.next();
      // Check fitness
      l.fitness();
      // Detect contact constantly
      l.detectContact();
      // Check if the luca is touching an edge
      l.checkEdges();
      // Update the luca's state
      l.life_remaining--;
      l.rep_prog++;
      l.hunger += .5;
      l.hunger = constrain(l.hunger, 0, l.max_hunger);
      
      // Not currently used
      //l.timex += .01;
      //l.timey += .01;
      
      // Apply friction
      l.fric = l.vel.copy().normalize().mult(-1).mult(l.fricMag);
      l.applyForce(l.fric);

      // Increase stamina constantly
      //l.stam++;
      l.stam = constrain(l.stam, 0.0, l.split_thresh);

      // Create a variable and set it to the prey limit      
      int limit = luca_limit;
      // Create an arraylist and set it to the all_prey arraylist
      ArrayList<Luca> temp = all_prey;
      // If the luca is a predator
      if(l instanceof Predator)
      {
        // Set the limit to the predator limit
        limit = pred_limit;
        // Set the arraylist to the all_predators arraylist
        temp = new ArrayList<Luca>(all_predators);
      }
      // If there are less lucas than the limit and the luca has enough stamina and its been long enough in between replications
      if(temp.size() < limit && l.stam >= l.split_thresh && l.rep_prog >= l.rep_rate)
      {
        // Create a new luca variable
        Luca new_luca;
        // If the luca is a predator
        if(l instanceof Predator)
        {
          // Have it replicate and store the new predator in the new_luca variable
          new_luca = (Predator)l.split();
          // Set the new predator's stamina to 0
          new_luca.stam = 0;
          // Set the new predator's replication progress to 0
          new_luca.rep_prog = 0;
        }
        // If the luca is not a predator
        else
        {
          // Have it replicate and store the new prey in the new_luca variable
          new_luca = l.split();
        }
        // Add the new lucas to the temporary new_lucas arraylist
        new_lucas.add(new_luca);
        // Set the luca's replication progress to 0
        l.rep_prog = 0;
        // Set the luca's stamina to a value between 0 and 1 (So they don't all split at once)
        l.stam = random(0, 2);
      }
    }
    // If there are new lucas
    if(new_lucas.size() > 0)
    {
      // For each new luca
      for(Luca l : new_lucas)
      {
        // Add the new luca to the all arraylist
        all.add(l);
        // Add the new luca to the all_in_species arraylist
        this.all_in_species.add(l);
      }
    }
    /*
    // Create a temporary list to store new lucas before adding them
    ArrayList<Luca> new_lucas = new ArrayList<Luca>();
    // First loop: Update state of all Luca instances
    for(Luca l : this.all_in_species)
    {
      // Check fitness
      l.fitness();
      // Detect contact constantly
      l.detectContact();
      // Check if the luca is touching an edge
      l.checkEdges();
      // Update the luca's state
      l.life_remaining--;
      l.rep_prog++;
      l.hunger += .5;
      l.hunger = constrain(l.hunger, 0, l.max_hunger);
      
      // Not currently used
      //l.timex += .01;
      //l.timey += .01;
      
      // Apply friction
      l.fric = l.vel.copy().normalize().mult(-1).mult(l.fricMag);
      l.applyForce(l.fric);

      // Increase stamina constantly
      //l.stam++;
      l.stam = constrain(l.stam, 0.0, l.split_thresh);

      // Create a variable and sset it to the prey limit      
      int limit = luca_limit;
      // Create an arraylist and set it to the all_prey arraylist
      ArrayList<Luca> temp = all_prey;
      // If the luca is a predator
      if(l instanceof Predator)
      {
        // Set the limit to the predator limit
        limit = pred_limit;
        // Set the arraylist to the all_predators arraylist
        temp = new ArrayList<Luca>(all_predators);
      }
      // If there are less lucas than the limit and the luca has enough stamina and its been long enough in betweem replications
      if(temp.size() < limit && l.stam >= l.split_thresh && l.rep_prog >= l.rep_rate)
      {
        // Crate a new luca variable
        Luca new_luca;
        // If the luca is a predator
        if(l instanceof Predator)
        {
          // Have it replicate and store the new predator in the new_luca variable
          new_luca = (Predator)l.split();
          // Set the new predators stamina to 0
          new_luca.stam = 0;
          // Set the new predators replication progress to 0
          new_luca.rep_prog = 0;
        }
        // If the luca is not a predator
        else
        {
          // Have it replicate and store the new prey in the new_luca variable
          new_luca = l.split();
        }
        // Add thenew lucas to the temporary new_lucas arraylist
        new_lucas.add(new_luca);
        // Set the luca's replication progress to 0
        l.rep_prog = 0;
        // Set the luca's stamina to a value between 0 and 1 (So they don't all split at once)
        l.stam = random(0, 2);
      }
    }
    // If there are new lucas
    if(new_lucas.size() > 0)
    {
      //For each new luca
      for(Luca l : new_lucas)
      {
        // Add the new luca to the all arraylist
        all.add(l);
        // Add the new luca to the all_in_species arraylist
        this.all_in_species.add(l);
      }
    }
    */
    it = this.all_in_species.iterator();
    while(it.hasNext()) 
    {
      Luca l = it.next();
      // Conditional not currently used
      //if(true)
      //if(l.stam > 0 && !resting)
      //{
        // If the luca is a predator
        if(l instanceof Predator)
        {
          // Apply its internal forces
          ((Predator)l).applyBehaviors();
        }
        // If the luca is not a predator
        else
        {
          // Apply its internal forces
          l.applyBehaviors();
        }
        /*
      }
      // Else statement body is not currently relevant
      else
      {
        if(!resting)
        {
          resting = true;
          restStartTime = millis();
        }
        else if(millis() - restStartTime > 10000)
        {
          resting = false;
        }
        else
        {
          l.vel = new PVector(0, 0);
        }
      }
      */
      //Not currently used
      /*
      // If there is no contact
      if(l.contacts.size() == 0)
      {
        // If the luca has no destination or is at its destination
        if(l.dest == null || PVector.dist(l.dest, l.loc) < 1)
        {
          // Set a new destination
          l.setDest(new PVector(random(width), random(height)));
        }
      }
      */
      // Initiate motion (update)
      l.move();
      // If the luca is not null
      if(l != null)
      {
        // Display the luca
        l.drawLuca();
      }
    }
    /*
    // For each luca in the species
    for(Luca l : this.all_in_species)
    {
      // Conditional not currently used
      //if(true)
      //if(l.stam > 0 && !resting)
      //{
        // If the luca is a predator
        if(l instanceof Predator)
        {
          // Apply its internal forces
          ((Predator)l).applyBehaviors();
        }
        // If the luca is not a predator
        else
        {
          // Apply its internal forces
          l.applyBehaviors();
        }
        */
        /*
      }
      // Else statement body is not currently relevant
      else
      {
        if(!resting)
        {
          resting = true;
          restStartTime = millis();
        }
        else if(millis() - restStartTime > 10000)
        {
          resting = false;
        }
        else
        {
          l.vel = new PVector(0, 0);
        }
      }
      */
      //Not currently used
      /*
      // If there is no contact
      if(l.contacts.size() == 0)
      {
        // If the luca has no destination or is at its destination
        if(l.dest == null || PVector.dist(l.dest, l.loc) < 1)
        {
          // Set a new destination
          l.setDest(new PVector(random(width), random(height)));
        }
      }
      */
      /*
      // Initiate motion (update)
      l.move();
      // If the luca is not null
      if(l != null)
      {
        // Display the luca
        l.drawLuca();
      }
    }
    */
    // Second loop: Check if any Luca instances should be removed
    //Create an iterator for the all_in_species arraylist
    it = all_in_species.iterator();
    // While there are more lucas
    while(it.hasNext())
    {
      // Create a luca variable and set it to the next luca
      Luca l = it.next();
      // If the lluca's hunger reaches its maximum, its remaining life runs out, or it has been eaten
      if(l.hunger >= l.max_hunger || l.life_remaining <= 0 || (!(l instanceof Predator) && l.eaten()))
      {
        // Remove the luca from the all arraylist
        it.remove();
        // If the luca is a predator
        if(l instanceof Predator)
        {
          // Remove the luca from the all_predators arraylist
          all_predators.remove(l);
        }
        // If the luca is not a predator
        else
        {
          // Remove the luca from the all_prey arraylist
          all_prey.remove(l);
        }
        // Remove the luca from the all arraylist
        all.remove(l);
        // Set the luca to null
        l = null;
      }
    }
  }
  /**
    *A method to split one species into two
    @param l The luca to split from the species
    @return Species The new species
   */
  Species speciate(Luca l)
  {
    ellipse(100, 100, 100, 100);
    // Create a new species from a luca from the old species
    Species s = new Species(l);
    // Return the new species
    return s;
  }
}