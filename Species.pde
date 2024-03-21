/*
static class Species
{
  int[] col = {255, 0, 0};
  String diet;
  float width_min;
  float width_max;
  float height_min;
  float height_max;
  float rep_rate_min;
  float rep_rate_max;
  float speed_min;
  float speed_max;
  boolean nucleus = false;
  float lifespan_min;
  float lifespan_max;
  int num_organisms = 0;
  String movement = null;
  boolean gene_flow = false;
  
  float mut_rate = .2;
  
  static int num_species = 0;
  static ArrayList<Species> known_species;
  
  public Species()
  {
    this.col= col;
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
  }
  
  public Species(
  int[] col, 
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
    this.col = col;
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
  public boolean getGeneFlow()
  {
    return this.gene_flow;
  }
  public void setGeneFlow(boolean gene_flow)
  {
    this.gene_flow = gene_flow;
  }
  public String getMovement()
  {
    return this.movement;
  }
  public void setMovement(String movement)
  {
    this.movement = movement;
  }
  public int getNumOrganisms()
  {
    return this.num_organisms;
  }
  public void setNumOrganisms(int num_organisms)
  {
    this.num_organisms = num_organisms;
  }
  public ArrayList<Species> getKnownSpecies()
  {
    return Species.known_species;
  }
  public void setKnownSpecies(ArrayList<Species> known_species)
  {
    Species.known_species = known_species;
  }
  public int getNumSpecies()
  {
    return Species.num_species;
  }
  public void setNumSpecies(int num_known_species)
  {
    Species.num_species = num_known_species;
  }
  
  public int[] getCol()
  {
    return this.col;
  }
  public void setCol(int[] col)
  {
    this.col = col;
  }
    public String getDiet()
  {
    return this.diet;
  }
  public void setDiet(String diet)
  {
    this.diet = diet;
  }
    public float getWidthMin()
  {
    return this.width_min;
  }
  public void setWidthMin(float width_min)
  {
    this.width_min = width_min;
  }
  public float getWidthMax()
  {
    return this.width_max;
  }
  public void setWidthMax(float width_max)
  {
    this.width_max = width_max;
  }
      public float getHeightMin()
  {
    return this.height_min;
  }
  public void setHeightMin(float height_min)
  {
    this.height_min = height_min;
  }
  public float getHeightMax()
  {
    return this.height_max;
  }
  public void setHeightMax(float height_max)
  {
    this.height_max = height_max;
  }
  public float getRepRateMin()
  {
    return this.rep_rate_min;
  }
  public void setRepRateMin(float rep_rate_min)
  {
    this.rep_rate_min = rep_rate_min;
  }
  public float getRepRateMax()
  {
    return this.rep_rate_max;
  }
  public void setRepRateMax(float rep_rate_max)
  {
    this.rep_rate_max = rep_rate_max;
  }
  public float getSpeedMin()
  {
    return this.speed_min;
  }
  public void setSpeedMin(float speed_min)
  {
    this.speed_min = speed_min;
  }
  public boolean getNucleus()
  {
    return this.nucleus;
  }
  public void setNucleus(boolean nucleus)
  {
    this.nucleus = nucleus;
  }
  public float getLifeSpanMin()
  {
    return this.lifespan_min;
  }
  public void setLifeSpanMin(float lifespan_min)
  {
    this.lifespan_min = lifespan_min;
  }
  public float getLifeSpanMax()
  {
    return this.lifespan_max;
  }
  public void setLifeSpanMax(float lifespan_max)
  {
    this.lifespan_max = lifespan_max;
  }
}
*/
