static int num_species = 0;
long restStartTime = 0;
boolean resting = false;

color new_spec_col;

boolean speciate = false;


class Species
{
  color col;
  //String diet;
  float width_avg;
  float rep_rate_avg;
  float top_speed_avg;
  float max_hunger_avg;
  float split_thresh_avg;
  float lifespan_avg;
  float mut_rate_avg;

  float width_var;
  float rep_rate_var;
  float top_speed_var;
  float max_hunger_var;
  float split_thresh_var;
  float lifespan_var;
  float mut_rate_var;
  //String movement = null;
  //boolean gene_flow = false;
  
  //float mut_rate = .2;
  
  ArrayList<Luca> all_in_species;


  float sq_of_width_avg;
  float sq_of_rep_rate_avg;
  float sq_of_top_speed_avg;
  float sq_of_max_hunger_avg;
  float sq_of_split_thresh_avg;
  float sq_of_lifespan_avg;
  float sq_of_mut_rate_avg;
  

  Species()
  {
    this.col= color(random(255), random(255), random(255));
    new_spec_col = col;
    this.all_in_species = new ArrayList<Luca>();
    //this.diet = "Filter";
    this.width_avg = 0;
    this.rep_rate_avg = 0;
    this.top_speed_avg = 0;
    this.lifespan_avg = 0;
    this.max_hunger_avg = 0;
    this.split_thresh_avg = 0;
    this.mut_rate_avg = 0;
    //this.gene_flow = false;
    
    // Create initial luca
    Luca luca = new Luca();
    luca.spec = this;
    this.all_in_species.add(luca);
    // Spawn first luca
    luca.spawn();

  }

  Species(int n)
  {
    this.col= color(random(255), random(255), random(255));
    new_spec_col = col;
    //this.diet = "Filter";
    this.width_avg = 0;
    this.rep_rate_avg = 0;
    this.top_speed_avg = 0;
    this.lifespan_avg = 0;
    this.max_hunger_avg = 0;
    this.split_thresh_avg = 0;
    this.mut_rate_avg = 0;
    this.all_in_species = new ArrayList<Luca>();
    // Create initial luca
    Luca predator = new Predator();
    predator.spec = this;
    this.all_in_species.add(predator);
    // Spawn first luca
    predator.spawn();
    predator.loc = new PVector(100, 100);
  }
  
Species(Luca l)
{
  speciate = true;
  this.col= color(random(255), random(255), random(255));
  new_spec_col = col;
  this.all_in_species = new ArrayList<Luca>();

  // Create a new Luca instance based on l
  Luca l2 = l.spawn(l);

  // Remove l2 from its current species and add it to the new species
  if (l2.spec != null) 
  {
    l2.spec.all_in_species.remove(l2);
  }
  l2.spec = this;
  this.all_in_species.add(l2);

  // Remove l from its current species and add it to the new species
  if (l.spec != null) {
      l.spec.all_in_species.remove(l);
  }
  l.spec = this;
  this.all_in_species.add(l);

  println("Species created from Luca");
}

  void run()
  {
    ArrayList<Luca> new_lucas = new ArrayList<Luca>();
    // Reset averages
    this.width_avg = 0;
    this.rep_rate_avg = 0;
    this.top_speed_avg = 0;
    this.lifespan_avg = 0;
    this.max_hunger_avg = 0;
    this.split_thresh_avg = 0;
    this.mut_rate_avg = 0;
    // First loop: Update state of all Luca instances
    for(Luca l : this.all_in_species)
    {
      l.fitness();

      // Detect contact constantly
      l.detectContact();
      l.checkEdges();

      l.life_remaining--;
      l.hunger += .5;
      l.rep_prog++;
      //l.timex += .01;
      //l.timey += .01;

      l.fric = l.vel.copy().normalize().mult(-1).mult(l.fricMag);
      l.applyForce(l.fric);

      PVector gravity = new PVector(0, 0, -0.1*l.mass);
      //l.applyForce(gravity);
      // Move to its destination

      // Increase stamina constantly
      //l.stam++;
      l.stam = constrain(l.stam, 0.0, l.split_thresh + 1);
/*
      this.width_avg += l.cell_w;
      this.rep_rate_avg += l.rep_rate;
      this.top_speed_avg += l.top_speed;
      this.lifespan_avg += l.lifespan;
      this.max_hunger_avg += l.max_hunger;
      this.split_thresh_avg += l.split_thresh;
      this.mut_rate_avg += l.mut_rate;
    }

    int numMembers = this.all_in_species.size();
    this.width_avg /= numMembers;
    this.rep_rate_avg /= numMembers;
    this.top_speed_avg /= numMembers;
    this.lifespan_avg /= numMembers;
    this.max_hunger_avg /= numMembers;
    this.split_thresh_avg /= numMembers;
    this.mut_rate_avg /= numMembers;

      // Calculate variance for each attribute

      
// Second loop: Calculate variance for each attribute
for(Luca l : this.all_in_species)
{
  this.width_var += sq(l.cell_w - this.width_avg);
  this.rep_rate_var += sq(l.rep_rate - this.rep_rate_avg);
  this.top_speed_var += sq(l.top_speed - this.top_speed_avg);
  this.lifespan_var += sq(l.lifespan - this.lifespan_avg);
  this.max_hunger_var += sq(l.max_hunger - this.max_hunger_avg);
  this.split_thresh_var += sq(l.split_thresh - this.split_thresh_avg);
  this.mut_rate_var += sq(l.mut_rate - this.mut_rate_avg);
  */
  // If there are less lucas than the limit
  if(all.size() < limit && l.stam > l.split_thresh && l.hunger < (l.max_hunger * .75) && l.life_remaining < l.lifespan - 20 && l.rep_prog >= l.rep_rate)
  {
    // Replicate
    Luca new_luca = l.split();
    new_lucas.add(new_luca);
    l.rep_prog = 0;
  }
}
/*
  this.width_var /= numMembers;
  this.rep_rate_var /= numMembers;
  this.top_speed_var /= numMembers;
  this.lifespan_var /= numMembers;
  this.max_hunger_var /= numMembers;
  this.split_thresh_var /= numMembers;
  this.mut_rate_var /= numMembers;

  this.sq_of_width_avg = sq(this.width_avg);
  this.sq_of_rep_rate_avg = sq(this.rep_rate_avg);
  this.sq_of_top_speed_avg = sq(this.top_speed_avg);
  this.sq_of_lifespan_avg = sq(this.lifespan_avg);
  this.sq_of_max_hunger_avg = sq(this.max_hunger_avg);
  this.sq_of_split_thresh_avg = sq(this.split_thresh_avg);
  this.sq_of_mut_rate_avg = sq(this.mut_rate_avg);
*/
  if(new_lucas.size() > 0)
  {
    for(Luca l : new_lucas)
    {
      all.add(l);
      this.all_in_species.add(l);
    }
  }
    
  for(Luca l: this.all_in_species)
  {
    if(true)
    //if(l.stam > 0 && !resting)
    {
      if(l instanceof Predator)
      {
        ((Predator)l).applyBehaviors();
        //print(((Predator)l).closest_prey);
      }
      else
      {
        l.applyBehaviors();
      }
    }
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
    l.move();
    //all.get(i).move();
    // Display the luca
    if(l != null)
    {
      l.drawLuca();
    }
  }

    // Second loop: Check if any Luca instances should be removed
    Iterator<Luca> it = all_in_species.iterator();
    while(it.hasNext())
    {
      Luca l = it.next();
      if(l.hunger >= l.max_hunger || l.life_remaining <= 0 || (!(l instanceof Predator) && l.eaten()))
      {
        it.remove();
        if(l instanceof Predator)
        {
          all_predators.remove(l);
        }
        else
        {
          all_prey.remove(l);
        }
        all.remove(l);
        l = null;
      }
    }
  }
  Species speciate(Luca l)
  {
    println("Speciating from Luca");
    Species s = new Species(l);
    return s;
  }
}
