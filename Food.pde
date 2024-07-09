/**
  *Food class
  This class creates food objects that are eaten by the lucas
 */
class Food
{
  // Attributes
  float mass;
  PVector loc;
  // Constant (I think this is unneccessary)
  float G = 0.4;
  // ArrayList of all Food objects
  ArrayList<Food> all_food;
  // Image of food
  PImage food_img;

  /**
    *Constructor: Creates a food object
   */
  Food()
  {
    // Random location
    this.loc = new PVector(random(20, width-20), random(70, height-20));
    // Random mass (size)
    this.mass = random(4, 10);
    // Random image
    this.food_img = food_imgs[int(random(0, food_imgs.length))];
  }
  
  /**
    *Method to draw the food
    @return void
   */
  void drawFood()
  {
    // No stroke for images
    noStroke();
    // Fill with white
    textureMode(IMAGE);
    // Begin shape
    beginShape();
    // Texture the image
    texture(this.food_img);
    // Vertexes based on mass (size)
    vertex(this.loc.x, this.loc.y, 0, 0);
    vertex(this.loc.x + 2*mass, this.loc.y, 200, 0);
    vertex(this.loc.x + 2*mass, this.loc.y + 2*mass, 200, 200);
    vertex(this.loc.x, this.loc.y + 2*mass, 0, 200);
    // End shape
    endShape();
  }

  /**
    *Method to check if food is eaten
    @return boolean true if food is eaten, false if not
   */
  boolean eaten()
  {
    // For all lucas (prey and predators)
    for(Luca luca: all)
    {
      // If the the luca is bigger than the food and the distance between the food and the luca is less than the luca's width minus the food's mass
      if(PVector.dist(this.loc, luca.loc) < luca.cell_w - this.mass + 8 && luca.cell_w > this.mass)
      {
        // If it is a predator
        if(luca instanceof Predator)
        {
          // Restore less stamina, abate less hunger
          luca.hunger -= this.mass;
          luca.stam += this.mass;
        }
        // If it is a prey
        else
        {
          // Restore more stamina, abate more hunger
          luca.hunger -= 1.25*this.mass;
          luca.stam += 1.25*this.mass;
        }
        // Imcrement that luca's food eaten
        luca.food_eaten++;
        // Make sure hunger is not less than zero
        if(luca.hunger < 0)
        {
          luca.hunger = 0;
        }
        // Return true
        return true;
      }
    }
    // If no luca is eating the food, return false
    return false;
  }
  
  /*
  // Method to attract a luca
  PVector attract(Luca luca)
  {
    // Force is the difference between the food's location and the luca's location
    PVector force = PVector.sub(this.loc, luca.loc);
    // Distance is the magnitude of the force
    float distance = force.mag();
    // Constrain the distance
    distance = constrain(distance, 5.0, 25.0);
    // Normalize the force
    force.normalize();
    // Calculate the strength of the force
    float strength = (G * mass * luca.mass) / (distance * distance);
    // Multiply the force by the strength
    force.mult(strength);
    // Return the force
    return force;
  }
  */
}
