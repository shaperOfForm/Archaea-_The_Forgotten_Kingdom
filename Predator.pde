ArrayList<Luca> all_prey = new ArrayList<Luca>();
ArrayList<Predator> all_predators = new ArrayList<Predator>();

class Predator extends Luca
{
    
    Luca closest_prey;
    String img_path;
    
    float max_hunger;
    float split_thresh;
    float lifespan;

    Predator()
    {
        super();
        this.cell_w = 25;
        this.max_force = 999999999;

        // PLAY WITH TOP SPEED NEXT!!!!!!!
        // Then read the textbook 
        // Adjust UML and Components
        
        this.top_speed = 13;
        Luca closest_prey = null;
        this.stam = 10;
        this.rep_prog = 20;
        this.rep_rate = 30;
        this.max_hunger = 500;
        this.split_thresh = 20;
        this.lifespan = 400;
        this.life_remaining = this.lifespan;
        all_predators.add(this);
    }
    Predator(float x, float y, float cell_w, float top_speed, float rep_rate, float max_force, float max_hunger, float max_stam, float split_thresh, float lifespan)
    {
        this();
        this.cell_w = cell_w + random(-1, 1);
        this.max_force = max_force + random(-mut_range, mut_range);
        this.top_speed = top_speed + random(-1, 1);
        Luca closest_prey = null;
        this.stam = 0;
        this.rep_rate = rep_rate + random(-1, 1);
        this.rep_prog = random(0, 5);
        this.max_hunger = max_hunger + random(-mut_range, mut_range);
        this.split_thresh = split_thresh + random(-mut_range, mut_range);
        this.lifespan = lifespan + random(-mut_range, mut_range);
        this.life_remaining = this.lifespan;
        all_predators.add(this);
    }

    void drawLuca()
    {
        noStroke();
        noFill();
        beginShape();
        texture(pred_img);
        if(!isPaused)
        {
            for (float i = 0; i < TWO_PI; i = i + 0.2)
            {
                int index = int(degrees(i)) % 360;
                // Create edge of circle using sine and cosine
                float x1 = sin_values[index] * this.cell_w;
                float y1 = cos_values[index] * this.cell_w;

                // Map the relative position of the vertex within the shape to the exact range of the image dimensions
                float u = map(x1, -1.2*this.cell_w, 1.2*this.cell_w, 0, pred_img.width-0);
                float v = map(y1, -1.2*this.cell_w, 1.2*this.cell_w, 0, pred_img.height-0); // Use height instead of width

                // Add the offset to the edge coordinates
                x1 += this.loc.x;
                y1 += this.loc.y;

                // Create a curved line between the vertices
                vertex(x1, y1, u, v);
            }
        endShape(CLOSE);
        }
    }

    PVector repel(Luca l)
    {
        force = PVector.sub(this.loc, l.loc);
        //float dist = dir.magSq();
        float dist = force.mag();
        dist = constrain(dist, 5, 1000);
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
            force.mult(10);
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
            force.mult(6);
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