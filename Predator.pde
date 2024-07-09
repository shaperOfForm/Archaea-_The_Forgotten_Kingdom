// I did not have time to properly adjust the starting attributes to ensure that all the predators and prey don't die right away, or the prey in the long run
// The limit on the number of predators got it to a point where it was presentable

/**
    *Prdator class
    This class extends the Luca class and is used to create predators in the simulation
 */
class Predator extends Luca
{
    // Attributes
    Luca closest_prey;
    int prey_eaten;
    float seek_prey_force;
    float seek_food_force;

    /**
        *Constructor for the first predator
     */
    Predator()
    {
        // Call to Luca constructor
        super();
        // initialize closest_prey to null
        Luca closest_prey = null;
        // Set attributes, the mapping is currently unnecessary for most attributes as I temporarily set starting values for them
        this.top_speed = map(dna.genes[0], 0, 1, 19, 19);
        // Sets the size based on the DNA gene (random float between 0 and 1) mapped to a range between 23 and 30
        this.cell_w = map(dna.genes[1], 0, 1, 20, 27);
        this.rep_rate = map(dna.genes[2], 0, 1, 15, 15);
        this.lifespan = map(dna.genes[3], 0, 1, 500, 500); // 400
        this.max_hunger = map(dna.genes[4], 0, 1, 48, 48); // 500
        // Sets the mutation rate based on the DNA gene (random float between 0 and 1) mapped to a range between 0.5 and 0.75
        this.mut_rate = map(dna.genes[5], 0, 1, .5, .75);
        this.split_thresh = map(dna.genes[6], 0, 1, 200, 200); //20;
        this.seek_prey_force = map(dna.genes[7], 0, 1, 22, 22);
        this.seek_food_force = map(dna.genes[8], 0, 1, 16, 16);
        this.delta_acc = map(dna.genes[8], 0, 1, .15, .15);
        // Set the first predator's remaining life to be 100 more than its lifespan
        this.life_remaining = this.lifespan + 100;
        // Add the predator to the all_predators list
        all_predators.add(this);

        // These are all temporary until I can play with the values more

        // I think the conditional is unneccessary
        if(this.equals(all_predators.get(0)))
        {
            // Set the starting stamina to be 5 less than the split threshold
            this.stam = this.split_thresh - 5;
        }
        // Set the starting hunger to be 0
        this.hunger = 0;
        // Set prey eaten to 0
        this.prey_eaten = 0;
        // Set reproduction progress so the first predator can reproduce very quickly
        this.rep_prog = rep_rate - 5;
        
    }
    /**
        *Constructor for the first predator
        @param x the x-coordinate of the predator
        @param y the y-coordinate of the predator
        @param parent the parent predator
     */
    Predator(float x, float y, Predator parent)
    {
        // Call to Luca constructor
        super(x, y, parent);
        // Set stamina to 0
        this.stam = 0;
        // Set reproduction progress (0 to 2 so they do not all replicate at once)
        rep_prog = random(0, 2);
        // An offset which represents the range of values the attributes can be mutated by
        float offset = 0.1f;
        // Use the parent genes as a base, 'mutate them' by mapping them to a range that is a percentage away from the parent value, as dictated by the offset, and assign them to the attributes
        this.top_speed = map(dna.genes[0], 0, 1, parent.top_speed * (1 - offset), parent.top_speed * (1 + offset));
        this.cell_w = map(dna.genes[1], 0, 1, parent.cell_w * (1 - .75*offset), parent.cell_w * (1 + .75*offset));
        this.cell_w = constrain(this.cell_w, 12, 35);
        this.rep_rate = map(dna.genes[2], 0, 1, parent.rep_rate * (1 - offset), parent.rep_rate * (1 + offset));
        this.lifespan = map(dna.genes[3], 0, 1, parent.lifespan * (1 - offset), parent.lifespan * (1 + offset));
        this.life_remaining = this.lifespan;
        this.max_hunger = map(dna.genes[4], 0, 1, parent.max_hunger * (1 - offset), parent.max_hunger * (1 + offset));
        this.mut_rate = map(dna.genes[5], 0, 1, parent.mut_rate * (1 - offset), parent.mut_rate * (1 + offset));
        this.split_thresh = map(dna.genes[6], 0, 1, parent.split_thresh * (1 - offset), parent.split_thresh * (1 + offset));
        this.seek_prey_force = map(dna.genes[7], 0, 1, parent.seek_prey_force * (1 - .1*offset), parent.seek_prey_force * (1 + .1*offset));
        this.seek_food_force = map(dna.genes[8], 0, 1, parent.seek_food_force * (1 - .1*offset), parent.seek_food_force * (1 + .1*offset));
        // Add the predator to the all_predators list
        all_predators.add(this);
    }

    /**
        *Method to calculate the fitness of a predator
        @return void
     */
    @Override
    void fitness()
    {
        // Fitness is calcuated using the number of prey it has eaten, the amount of food it has eaten, and the number of children it has
        this.fitness += pow((this.prey_eaten), 2);
        this.fitness += pow((.05*this.food_eaten), 2);
        this.fitness += pow(this.children.size(), 2);
    }
    
    /**
        *Method to draw the predator
        @return void
     */
    void drawLuca()
    {
        // No stroke or fill because it's an image
        noStroke();
        noFill();
        // Draw the predator as a circle
        beginShape();
        // Calculate the color based on the life_remaining
        color startColor = color(255, 0, 0); // Red color
        color endColor = color(pred_img.pixels[0]); // Original color of the image
        // Map the life_remaining indirectly to a value between 1 and 0. -300 is so they are not still alive while nearly transparent
        float amt = map(this.life_remaining, -400, this.lifespan, 1, 0);
        // Interpolate the color based on the life_remaining
        color interpColor = lerpColor(startColor, endColor, amt);
        // Apply the color tint to the image
        tint(interpColor);
        // Draw the predator as an image
        texture(pred_img);
        // If the simulation is not paused
        if(!isPaused) 
        {
            // For every angle in a circle
            for (float i = 0; i < TWO_PI; i = i + 0.2) 
            {
                // Calculate the index of the angle in the sine and cosine arrays
                int index = int(degrees(i)) % 360;

                // Create edge of circle using sine and cosine
                float x1 = sin_values[index] * this.cell_w;
                float y1 = cos_values[index] * this.cell_w;

                // Map the relative position of the vertex within the shape to the exact range of the image dimensions
                float u = map(x1, -1.2*this.cell_w, 1.2*this.cell_w, 0, pred_img.width);
                float v = map(y1, -1.2*this.cell_w, 1.2*this.cell_w, 0, pred_img.height); 

                // Translate the vertex to the predator's location
                x1 += this.loc.x;
                y1 += this.loc.y;

                // Draw a line between the vertices
                vertex(x1, y1, u, v);
            }
        }
        // End the shape
        endShape(CLOSE);
        // Remove the tint for other drawings
        noTint();

        // Draw a circular progress bar for the hunger level (green)
        stroke(0, 255, 0);
        // Make the progress bar thicker
        strokeWeight(4);
        // No fill for the progress bar
        noFill();
        // Map the hunger level to an angle of a semi-circle
        float hungerAngle = map(this.hunger, 0, this.max_hunger, PI, 0); // Map the hunger level to an angle
        // Draw the progress bar
        arc(this.loc.x, this.loc.y, this.cell_w * 2, this.cell_w * 2, -HALF_PI, -HALF_PI + hungerAngle);
        // Reset the stroke weight
        strokeWeight(4);
        // Reset the stroke color
        stroke(0);

        // Draw a circular progress bar for the stamina level (yellow)
        stroke(255, 210, 0);
        // Map the stamina level to an angle
        float staminaAngle = map(this.stam, 0, this.split_thresh, 0, PI);
        // Draw the progress bar
        arc(this.loc.x, this.loc.y, this.cell_w * 2, this.cell_w * 2, HALF_PI, HALF_PI + staminaAngle); // Draw the progress bar
        
        // Reset the stroke weight
        strokeWeight(1);
        // Reset the stroke color
        stroke(0);
    }
    
    /**
        *Method to apply a repulsion force to prey (for evasion)
        @param l the prey to repel
        @return PVector the force vector to repel the prey
     */
    PVector repel(Luca l)
    {
        // Calculate the force vector between the predator and the prey
        force = PVector.sub(this.loc, l.loc);
        // Calculate the distance between the predator and the prey
        float dist = force.mag();
        // Constrain the distance to a range between 5 and the predator's sense range
        // A minimum of 5 is used to prevent division by 0 and so that the force acting on the the prey does not get too large as they get very close
        dist = constrain(dist, 5, l.sense_range);
        // Normalize the force vector
        force.normalize();
        // Set the magnitude of the force vector
        float force_mag = -2;
        // If the denominator is not 0
        if(dist != 0)
        {
            // Scale the magnitude of the force vector inversely to the distance between them
            force_mag *= 1 * this.cell_w * l.cell_w / (dist);
        }
        // Multiply the force vector by the magnitude
        force.mult(force_mag);
        // Return the force vector
        return force;
    }

    /**
        *Method to detect contact with other predators
        @return Luca the predator it is touching
     */
    @Override
    Luca detectContact()
    {
        // For every predator
        for(int i = 0; i < all_predators.size(); i++)
        {
            // If this is not the same as the one we're checking
            if(!this.equals(all_predators.get(i)))
            {
                
                // Calculate the distance between the predators
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
                    // Return the predator it is touching
                    return all_predators.get(i);
                }
                // If they are not touching
                else
                {
                    // If the other luca is on the contacts list
                    if(this.contacts.contains(all_predators.get(i)))
                    {
                        // Remove it from the contacts list
                        this.contacts.remove(all_predators.get(i));
                    }
                }
            }
        }
        // If no contacts are found, return null
        return null;
    }

    /**
        *Method to apply sparation force from other predators
        @return void
     */
     @Override
     void applySeparation()
     {
        force = this.separate();
        // If the predators are touching
        if(this.contacts.size() > 0)
        {
            // Scale and apply the force
            force.mult(8);
            this.applyForce(force);
        }
     }

     /**
        * Method to apply force to seek the closest prey
        @return void 
      */
      void applySeekPreyForce()
      {
        force = this.seekClosestPrey();
        // If there is prey to seek
        if(force != null /*&& this.can_seek*/ && (force.x != 0 && force.y != 0))
        {
            // Scale and apply the force
            force.mult(this.seek_prey_force);
            this.applyForce(force);
        }
      }

    /**
        * Method to apply force to seek food
        @return void
     */

    @Override
    void applySeekFoodForce()
    {
        force = this.seekClosest();
        // If there is food to seek
        if(force != null /*&& this.can_seek*/ && (force.x != 0 && force.y != 0))
        {
            // Scale and apply the force
            force.mult(this.seek_food_force);
            this.applyForce(force);
        }
    }

    /**
        *Method to apply the internal forces of the predator
        @return void
     */
    @Override
    void applyBehaviors()
    {
        // Separate
        applySeparation();
        // Seek prey
        applySeekPreyForce();
        // Seek food
        applySeekFoodForce();
    }

    /**
        *Method to separate from other predators
        @return PVector the force vector to separate from other predators
     */
    @Override
    PVector separate()
    {
        // Reset sum
        if(sum != null)
        {
            sum.x = 0;
            sum.y = 0;
        }
        else
        {
            sum = new PVector(0, 0);
        }
        // Initialize the count of the predators
        int count = 0;
        
        // If there is contact
        if(this.contacts.size() > 0)
        {
            // For every predator in contact
            for(int i = 0; i < this.contacts.size(); i++)
            {
                // Get the vector between the two predators
                force = PVector.sub(this.loc, this.contacts.get(i).loc);
                // Normalize the vector
                force.normalize();
                // Calculate the distance between the two predators
                float dist = PVector.dist(this.loc, this.contacts.get(i).loc);
                // When within 20 pixels of each other, map that distance between 0 and 3
                float force_mag = map(dist, 0, 20, 0, 3);
                // Scale the force vector by the magnitude
                force.mult(force_mag);
                // Add the force vector to the sum
                sum.add(force);
                // Increment the count
                count++;
                
            }
            // Take the average force
            sum.div(count);
            // Set the magnitude of the sum force to the top speed
            sum.setMag(this.top_speed);
            // Get the vector of the difference between the sum of the desired velocity and the current velocity
            sum.sub(this.vel);
            // Limit the force to the maximum force
            sum.limit(this.max_force);
        }
        // Return the sum of the forces
        return sum;   
    }

    /**
        *Method to seek the closest prey
        @return PVector the force vector to seek the closest prey
     */
    PVector seekClosestPrey()
    {
        // Initialize the minimum distance to a very large number
        float min_dist = Float.MAX_VALUE;
        // Initialize the closest prey to null
        Luca closest = null;
        // For every prey
        for(Luca prey: all_prey)
        {
            // If the prey is not null
            if(prey != null)
            {
                // Calculate the distance between the predator and the prey. Divide by the cell width so that bigger prey are more appealing
                float dist = PVector.dist(this.loc, prey.loc) / prey.cell_w;
                // If the distance is less than the minimum distance and the prey has not been eaten
                if(dist < min_dist && !prey.eaten())
                {
                    // Set the minimum distance to the distance
                    min_dist = dist;
                    // Set the closest prey to the prey
                    closest = prey;
                }
            }
        }
        // Set the closest prey to the predator's closest prey
        this.closest_prey = closest;
        // Return the force vector to seek the closest prey
        return this.seek(this.closest_prey);
    }

    /**
        *Method to seek specified prey
        @param prey the prey to seek
        @return PVector the force vector to seek the prey
     */
    PVector seek(Luca prey)
    {
        // If the prey is not null
        if(prey != null)
        {
            // Get the desired velocity vector
            PVector desired = PVector.sub(prey.loc, this.loc);
            // Normalize the desired velocity vector
            desired.normalize();
            // Scale the desired velocity vector to the top speed
            desired.mult(this.top_speed);
            // Get the force vector between the desired velocity and the current velocity
            force = PVector.sub(desired, this.vel);
            // Limit the force vector to the maximum force
            force.limit(this.max_force);
            // Return the force vector
            return force;
        }
        // If the prey is null
        else
        {
            // Return null
            return null;
        }
    }
}