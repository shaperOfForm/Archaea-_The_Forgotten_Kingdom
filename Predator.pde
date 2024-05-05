ArrayList<Luca> all_prey = new ArrayList<Luca>();
ArrayList<Predator> all_predators = new ArrayList<Predator>();

class Predator extends Luca
{
    
    Luca closest_prey;
    String img_path;

    float fitness;

    int prey_eaten;

    Predator()
    {
        super();
        
        this.cell_w = map(dna.genes[1], 0, 1, 20, 30); // 25

        // PLAY WITH TOP SPEED NEXT!!!!!!!
        // Then read the textbook 
        // Adjust UML and Components
        this.top_speed = map(dna.genes[0], 0, 1, 13, 17); // 13
        Luca closest_prey = null;
        this.rep_prog = random(4, 9);
        this.rep_rate = map(dna.genes[2], 0, 1, 30, 40); // 30
        this.max_hunger = map(dna.genes[4], 0, 1, 200, 400); // 500
        this.max_stam = map(dna.genes[5], 0, 1, 36, 55); // 150
        this.split_thresh = map(dna.genes[6], 0, 1, 25, 35); //20;
        this.lifespan = map(dna.genes[3], 0, 1, 200, 300); // 400
        this.life_remaining = this.lifespan;
        all_predators.add(this);
        this.stam = 14;
        this.hunger = 0;
        this.prey_eaten = 0;
    }
    Predator(float x, float y, Predator parent)
    {
        super(x, y, parent);
        this.stam = 0;
        if(this instanceof Predator)
        {
            float offset = 0.1f; // Change this to the desired offset
            this.top_speed = map(dna.genes[0], 0, 1, parent.top_speed * (1 - offset), parent.top_speed * (1 + offset));
            this.cell_w = map(dna.genes[1], 0, 1, parent.cell_w * (1 - offset), parent.cell_w * (1 + offset));
            this.cell_w = constrain(this.cell_w, 12, 35);
            this.rep_rate = map(dna.genes[2], 0, 1, parent.rep_rate * (1 - offset), parent.rep_rate * (1 + offset));
            this.lifespan = map(dna.genes[3], 0, 1, parent.lifespan * (1 - offset), parent.lifespan * (1 + offset));
            this.mut_rate = map(dna.genes[7], 0, 1, parent.mut_rate * (1 - offset), parent.mut_rate * (1 + offset));
            this.max_hunger = map(dna.genes[4], 0, 1, parent.max_hunger * (1 - offset), parent.max_hunger * (1 + offset));
            this.max_stam = map(dna.genes[5], 0, 1, parent.max_stam * (1 - offset), parent.max_stam * (1 + offset));
            this.split_thresh = map(dna.genes[6], 0, 1, parent.split_thresh * (1 - offset), parent.split_thresh * (1 + offset));
            all_predators.add(this);
        }
    }

    @Override
    void fitness()
    {
        this.fitness += pow((this.prey_eaten), 2);
        this.fitness += pow((.05*this.food_eaten), 2);
        this.fitness += pow(this.children.size(), 2);
    }
    
    void drawLuca() {
    noStroke();
    noFill();
    beginShape();
    // Calculate the color based on the life_remaining
    color startColor = color(255, 0, 0); // Red color
    color endColor = color(pred_img.pixels[0]); // Original color of the image
    float amt = map(this.life_remaining, -600, this.lifespan, 1, 0);
    color interpColor = lerpColor(startColor, endColor, amt);
    tint(interpColor); // Apply the color tint to the image
    texture(pred_img);
    if(!isPaused) {
        for (float i = 0; i < TWO_PI; i = i + 0.2) {
            int index = int(degrees(i)) % 360;
            // Create edge of circle using sine and cosine
            float x1 = sin_values[index] * this.cell_w;
            float y1 = cos_values[index] * this.cell_w;

            // Map the relative position of the vertex within the shape to the exact range of the image dimensions
            float u = map(x1, -1.2*this.cell_w, 1.2*this.cell_w, 0, pred_img.width);
            float v = map(y1, -1.2*this.cell_w, 1.2*this.cell_w, 0, pred_img.height); 

            // Add the offset to the edge coordinates
            x1 += this.loc.x;
            y1 += this.loc.y;

            // Create a curved line between the vertices
            vertex(x1, y1, u, v);
        }
    }
    endShape(CLOSE);
    noTint(); // Remove the tint for other drawings

        // Draw a circular progress bar for the hunger level
    stroke(255, 0, 0); // Red color for the progress bar
    strokeWeight(4); // Make the progress bar a bit thicker
    noFill(); // No fill for the progress bar
    float hungerAngle = map(this.hunger, 0, 100, 0, TWO_PI); // Map the hunger level to an angle
    arc(this.loc.x, this.loc.y, this.cell_w * 2, this.cell_w * 2, -HALF_PI, -HALF_PI + hungerAngle); // Draw the progress bar
    strokeWeight(4); // Reset the stroke weight
    stroke(0); // Reset the stroke color

    // Draw a circular progress bar for the stamina level
    stroke(255, 165, 0); // Blue color for the progress bar
    float staminaAngle = map(this.stam, 0, 100, 0, TWO_PI); // Map the stamina level to an angle
    arc(this.loc.x, this.loc.y, this.cell_w * 2, this.cell_w * 2, HALF_PI, HALF_PI + staminaAngle); // Draw the progress bar

    strokeWeight(1); // Reset the stroke weight
    stroke(0); // Reset the stroke color
    //stroke(this.spec.col);
    //ellipse(0,0,radius*2,radius*2);
}

    PVector repel(Luca l)
    {
        force = PVector.sub(this.loc, l.loc);
        //float dist = dir.magSq();
        float dist = force.mag();
        dist = constrain(dist, 4, 1000);
        force.normalize();
        float force_mag = -1;
        if(dist != 0)
        {
            force_mag *= 1 * this.cell_w * l.cell_w / (dist);
        }

        // Balance the constant here with the constant parameter in the repel function

        //float force = -1 * 1 / (d * d);
        force.mult(force_mag);
        return force;
    }

    @Override
      // Method to detect if a luca is making contact with another luca
  // Returns the luca it is making contact with
  Luca detectContact()
  {
    // For every luca
    for(int i = 0; i < all_predators.size(); i++)
    {
      // If it is not the luca we're checking
      if(!this.equals(all_predators.get(i)))
      {
        
        // Calculate the distance between the lucas
        float distance = dist(this.loc.x, this.loc.y, all_predators.get(i).loc.x, all_predators.get(i).loc.y);
        // If they are touching
        if(distance < (this.cell_w + all_predators.get(i).cell_w + 1))
        {
          // If not already on the contacts list
          if(!this.contacts.contains(all_predators.get(i)))
          {
            // Add it to the contacts list
            this.contacts.add(all_predators.get(i));
          }
          // Return the luca it is touching
          return all_predators.get(i);
        }
        // If they are not touching
        else
        {
          // If the other luca is on the contacts list
          if(this.contacts.contains(all_predators.get(i)))
          {
            //println(this.id + " is no longer touching " + i);
            // Remove it from the contacts list
            this.contacts.remove(all_predators.get(i));
          }
        }
      }
    }
    // If no contacts are found, return null
    return null;
  }

    @Override
    void applyBehaviors()
    {
        // Separate
        force = this.separate();
        // If the predators are touching
        if(this.contacts.size() > 0)
        {
            force.mult(3);
            this.applyForce(force);
        }

        //println(can_seek);
        // Seek prey
        force = this.seekClosestPrey();
        //println("SEEK FORC: " + seekForce);
        if(force != null /*&& this.can_seek*/ && (force.x != 0 && force.y != 0))
        {
            //seekForce.setMag(50000);
            force.mult(12);
            //seekForce.limit(25*this.top_speed);
            this.applyForce(force);
        }
        else
        {
            println("Wandering");
        }
        // Seek food
        force = this.seekClosest();
        if(force != null /*&& this.can_seek*/ && (force.x != 0 && force.y != 0))
        {
            //seekForce.setMag(50000);
            force.mult(8);
            //seekForce.limit(15*this.top_speed);
            this.applyForce(force);
        }
        else
        {
            println("No food to seek.");
        }
    }

    @Override
    PVector separate()
    {
        sum = new PVector();
        int count = 0;
        
        // For each contact
        if(this.contacts.size() > 0)
        {
            for(int i = 0; i < this.contacts.size(); i++)
            {
                if((this.contacts.get(i) instanceof Predator))
                {

                    // Get the vector between the two lucas
                    force = PVector.sub(this.loc, this.contacts.get(i).loc);
                    
                    force.normalize();
                    //pull.mult(all.get(i).top_speed);
                    
                    float dist = PVector.dist(this.loc, this.contacts.get(i).loc);
                    
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
                else
                {
                    continue;
                }
            }
            sum.div(count);
            sum.setMag(this.top_speed);
            //sum.limit(this.top_speed);
            sum.sub(this.vel);
            //steer.mult(.5);
            sum.limit(this.max_force * this.mass);
        }
        return sum;   
    }

    PVector seekClosestPrey()
    {
        float min_dist = Float.MAX_VALUE;
        Luca closest = null;
        for(Luca prey: all_prey)
        {
            if(prey != null)
            {
                float dist = PVector.dist(this.loc, prey.loc) / prey.cell_w;
                if(dist < min_dist && !prey.eaten())
                {
                    min_dist = dist;
                    closest = prey;
                }
            }
        }
        this.closest_prey = closest;
        return this.seek(this.closest_prey);
    }

    PVector seek(Luca prey)
    {
        if(prey != null)
        {
            PVector desired = PVector.sub(prey.loc, this.loc);
            desired.normalize();
            desired.mult(this.top_speed);
            PVector steer = PVector.sub(desired, this.vel);
            steer.limit(this.max_force * this.mass);
            return steer;
        }
        else
        {
            return null;
        }
    }
}