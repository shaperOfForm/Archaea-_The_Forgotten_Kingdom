ArrayList<Luca> all_prey = new ArrayList<Luca>();
ArrayList<Predator> all_predators = new ArrayList<Predator>();

class Predator extends Luca
{
    
    Luca closest_prey;

    Predator()
    {
        super();
        this.cell_w = 30;
        this.max_force = 3;
        this.top_speed = 4;
        Luca closest_prey = null;
        all_predators.add(this);
    }
    Predator(float x, float y, float cell_w, float cell_h, int species_num, float top_speed, float rep_rate)
    {
        super(x, y, cell_w, cell_h, species_num, top_speed, rep_rate);
        this.cell_w = 30;
        this.max_force = 3;
        this.top_speed = 4;
        Luca closest_prey = null;
        all_predators.add(this);
    }

    PVector repel(Luca l)
    {
        PVector dir = PVector.sub(this.loc, l.loc);
        float d = dir.mag();
        d = constrain(d, 5, 100);
        dir.normalize();
        float force = -1 * 1.0 / (d * d);
        dir.mult(force);
        return dir;
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
        PVector separateForce = this.separate().setMag(5000);
        separateForce.limit(1000*this.top_speed);
        // If the predators are touching
        if(this.contacts.size() > 0 && PVector.dist(this.loc, this.contacts.get(0).loc) < (this.cell_w + this.contacts.get(0).cell_w + 100))
        {
            this.applyForce(separateForce);
        }

        println(can_seek);

        PVector seekForce = this.seekClosestPrey();
        if(seekForce != null && this.can_seek && (seekForce.x != 0 && seekForce.y != 0))
        {
            seekForce.setMag(50000);
            //seekForce.mult(7*this.max_force);
            seekForce.limit(25*this.top_speed);
            this.applyForce(seekForce);
        }
        else
        {
            println("Wandering");
        }
    }

    @Override
    PVector separate()
    {
        PVector sum = new PVector();
        int count = 0;
        
        PVector steer = new PVector();
        
        // For each contact
        if(this.contacts.size() > 0)
        {
            for(int i = 0; i < this.contacts.size(); i++)
            {
                if((this.contacts.get(i) instanceof Predator))
                {
                    // Set a new destination
                    this.move(new PVector(random(width), random(height)));
                    // Get the vector between the two lucas
                    PVector pull = PVector.sub(this.loc, this.contacts.get(i).loc);
                    
                    pull.normalize();
                    //pull.mult(all.get(i).top_speed);
                    
                    float dist = PVector.dist(this.loc, this.contacts.get(i).loc);
                    
                    /*if(dist > 0 && dist < (all.get(i).cell_w + all.get(i).contacts.get(n).cell_w))
                    {
                    pull.div(dist);
                    }
                    */
                    
                    sum.add(pull);
                    count++;
                    
                }
                else
                {
                    continue;
                }
                sum.div(count);
                //sum.setMag(1);
                //sum.limit(this.top_speed);
                steer = PVector.sub(sum, this.vel);
                //steer.mult(.5);
                //steer.limit(500);
            }
        }
        return steer;   
    }

    PVector seekClosestPrey()
    {
        float min_dist = Float.MAX_VALUE;
        for(Luca prey: all_prey)
        {
            if(prey != null)
            {
            float dist = PVector.dist(this.loc, prey.loc);
                if(dist < min_dist)
                {
                    min_dist = dist;
                    this.closest_prey = prey;
                }
            }
        }
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
            //steer.limit(this.max_force);
            return steer;
        }
        else
        {
            return new PVector(0, 0);
        }
    }
}