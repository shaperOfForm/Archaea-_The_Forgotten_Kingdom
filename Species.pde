static int num_species = 0;
long restStartTime = 0;
boolean resting = false;

color new_spec_col;

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

  boolean speciate = false;

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
    this.width_avg = 10;
    this.rep_rate_avg = 5;
    this.top_speed_avg = .8;
    this.lifespan_avg = 15;
    this.max_hunger_avg = 50;
    this.split_thresh_avg = 25;
    this.mut_rate_avg = .2;
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
    this.col= color(random(255), random(255), random(255));
    new_spec_col = col;
    this.all_in_species = new ArrayList<Luca>();
    //this.all_in_species.add(l);
    Luca l2 = l.spawn(l);

    println("Species created from Luca");
    //l.spec.all_in_species.remove(l);
    //this.all_in_species.add(l);
  }

  void run()
  {
    ArrayList<Luca> new_lucas = new ArrayList<Luca>();
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
      
      // If there are less lucas than the limit
      if(all.size() < limit && l.stam > l.split_thresh && l.hunger < (l.max_hunger * .75) && l.life_remaining < l.lifespan - 20 && l.rep_prog >= l.rep_rate)
      {
        // Replicate
        Luca new_luca = l.split();
        new_lucas.add(new_luca);
        speciate = true;
        l.rep_prog = 0;
      }
    }
    if(new_lucas.size() > 0)
    {
      for(Luca l : new_lucas)
      {
        all.add(l);
        this.all_in_species.add(l);
      }
    }
    
    for(Luca l : this.all_in_species)
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
