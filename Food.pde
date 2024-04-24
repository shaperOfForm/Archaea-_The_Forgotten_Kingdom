class Food
{
  float mass;
  PVector loc;
  float G;
  
  ArrayList<Food> all_food;

  String img_path;

  PImage food_img;

  Food()
  {
    this.loc = new PVector(random(width), random(height));
    this.mass = random(8, 13);
    this.G = 0.4;
    //println(food_img.width, food_img.height);
    this.img_path = "food" + int(random(1, 8)) + ".png";
    this.food_img = loadImage(img_path);
  }
  
  void drawFood()
  {
    //size(10, 10, P2D);
    noStroke();
    //fill(175, 200);

    textureMode(IMAGE);
    //ellipse(this.loc.x, this.loc.y, mass*2, mass*2);
    beginShape();
    texture(this.food_img);
    vertex(this.loc.x, this.loc.y, 0, 0);
    vertex(this.loc.x + 2*mass, this.loc.y, 200, 0);
    vertex(this.loc.x + 2*mass, this.loc.y + 2*mass, 200, 200);
    vertex(this.loc.x, this.loc.y + 2*mass, 0, 200);
    endShape();
  }

  boolean eaten()
  {
    for(Luca luca: all)
    {
      if(PVector.dist(this.loc, luca.loc) < luca.cell_w - this.mass)
      {
        luca.hunger -= 50;
        // Limit hunger to 0
        if(luca.hunger < 0)
        {
          luca.hunger = 0;
        }
        return true;
      }
    }
    return false;
  }
  
  PVector attract(Luca luca)
  {
    PVector force = PVector.sub(this.loc, luca.loc);
    float distance = force.mag();
    distance = constrain(distance, 5.0, 25.0);
    
    force.normalize();
    float strength = (G * mass * luca.mass) / (distance * distance);
    force.mult(strength);
    return force;
  }
}
