static int num_species = 0;

class Species
{
  color col = color(random(255), random(255), random(255));
  String diet;
  float width_min;
  float width_max;
  float height_min;
  float height_max;
  float rep_rate_min;
  float rep_rate_max;
  float top_speed_min;
  float top_speed_max;
  boolean nucleus = false;
  float lifespan_min;
  float lifespan_max;
  int num_organisms = 0;
  String movement = null;
  boolean gene_flow = false;
  float speed_min;
  float speed_max;
  
  float mut_rate = .2;
  
  ArrayList<Luca> all_in_species;
  
  ArrayList<Species> known_species;

  Species()
  {
    this.col= color(random(255), random(255), random(255));
    this.diet = "Filter";
    this.width_min = 10;
    this.width_max = 20;
    this.height_min = 10;
    this.height_max = 20;
    this.rep_rate_min = 5;
    this.rep_rate_max = 15;
    this.speed_min = .8;
    this.speed_max = 1.2;
    this.lifespan_min = 15;
    this.lifespan_max = 30;
    this.nucleus = false;
    this.movement = null;
    this.gene_flow = false;
    this.all_in_species = new ArrayList<Luca>();
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
    this.diet = "Filter";
    this.width_min = 10;
    this.width_max = 20;
    this.height_min = 10;
    this.height_max = 20;
    this.rep_rate_min = 5;
    this.rep_rate_max = 15;
    this.speed_min = .8;
    this.speed_max = 1.2;
    this.lifespan_min = 15;
    this.lifespan_max = 30;
    this.nucleus = false;
    this.movement = null;
    this.gene_flow = false;
    this.all_in_species = new ArrayList<Luca>();
    // Create initial luca
    Luca predator = new Predator();
    predator.spec = this;
    this.all_in_species.add(predator);
    // Spawn first luca
    predator.spawn();
    predator.loc = new PVector(300, 300);
  }
  
  Species(
  color col, 
  String diet, 
  float width_min, 
  float width_max,
  float height_min, 
  float height_max,
  float rep_rate_min, 
  float rep_rate_max, 
  float speed_min, 
  float speed_max,
  float lifespan_min,
  float lifespan_max,
  boolean nucleus,
  String movement,
  boolean gene_flow
  )
  {
    this.col = color(random(255), random(255), random(255));
    this.diet = diet;
    this.width_min = width_min;
    this.width_max = width_max;
    this.height_min = height_min;
    this.height_max = height_max;
    this.rep_rate_min = rep_rate_min;
    this.rep_rate_max = rep_rate_max;
    this.speed_min = speed_min;
    this.speed_max = speed_max;
    this.lifespan_min = lifespan_min;
    this.lifespan_max = lifespan_max;
    this.nucleus = nucleus;
    this.movement = movement;
    this.gene_flow = gene_flow;
    known_species.add(this);
    num_species++;
  }

  void run()
  {
    Luca new_luca = null;
    
    // First loop: Update state of all Luca instances
    for(Luca l : all_in_species)
    {
      // Detect contact constantly
      l.detectContact();

      l.lifespan--;
      l.hunger++;
      //l.timex += .01;
      //l.timey += .01;

      l.fric = l.vel.copy().normalize().mult(-1).mult(l.fricMag);
      l.applyForce(l.fric);

      PVector gravity = new PVector(0, 0, -0.1*l.mass);
      l.applyForce(gravity);
      // Move to its destination

      // Increase stamina constantly
      l.stam++;

      // If there are less lucas than the limit
      if(all.size() <= limit && l.stam > 100 && l.hunger < 50)
      {
        // Replicate
        new_luca = l.split();
      }
      if(l instanceof Predator)
      {
        ((Predator)l).applyBehaviors();
      }
      else
      {
        l.applyBehaviors();
      }
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
      if(l.hunger >= 150 || l.lifespan <= 0 || (!(l instanceof Predator) && l.eaten()))
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

    if(new_luca != null)
    {
      all.add(new_luca);
      this.all_in_species.add(new_luca);
    }
  }
}
