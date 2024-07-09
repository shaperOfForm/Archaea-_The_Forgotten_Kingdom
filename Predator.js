import Luca from './Luca.js';
// I did not have time to properly adjust the starting attributes to ensure that all the predators and prey don't die right away, or the prey in the long run
// The limit on the number of predators got it to a point where it was presentable

/**
    *Prdator class
    This class extends the Luca class and is used to create predators in the simulation
 */
export default class Predator extends Luca {
  constructor(x, y, parent = null) {
    super(x, y, parent); // Assuming Luca's constructor accepts x, y, and parent parameters
    this.closest_prey = null;
    this.prey_eaten = 0;
    // Assuming dna is a global or passed variable with genes as its property
    this.top_speed = this.mapGene(dna.genes[0], 19, 19);
    this.cell_w = this.mapGene(dna.genes[1], 20, 27);
    this.rep_rate = this.mapGene(dna.genes[2], 15, 15);
    this.lifespan = this.mapGene(dna.genes[3], 500, 500);
    this.max_hunger = this.mapGene(dna.genes[4], 48, 48);
    this.mut_rate = this.mapGene(dna.genes[5], 0.5, 0.75);
    this.split_thresh = this.mapGene(dna.genes[6], 200, 200);
    this.seek_prey_force = this.mapGene(dna.genes[7], 22, 22);
    this.seek_food_force = this.mapGene(dna.genes[8], 16, 16);
    this.delta_acc = this.mapGene(dna.genes[8], 0.15, 0.15);
    this.life_remaining = this.lifespan + 100;
    all_predators.push(this); // Assuming all_predators is an array

    if (parent) {
      // Child predator specific initialization
      let offset = 0.1;
      this.stam = 0;
      this.rep_prog = random(0, 2);
      this.top_speed = this.mutate(parent.top_speed, offset);
      this.cell_w = this.constrainMutate(parent.cell_w, 0.75 * offset, 12, 35);
      this.rep_rate = this.mutate(parent.rep_rate, offset);
      this.lifespan = this.mutate(parent.lifespan, offset);
      this.life_remaining = this.lifespan;
      this.max_hunger = this.mutate(parent.max_hunger, offset);
      this.mut_rate = this.mutate(parent.mut_rate, offset);
      this.split_thresh = this.mutate(parent.split_thresh, offset);
      this.seek_prey_force = this.mutate(parent.seek_prey_force, 0.1 * offset);
      this.seek_food_force = this.mutate(parent.seek_food_force, 0.1 * offset);
    } else {
      // First predator specific initialization
      this.stam = this.split_thresh - 5;
      this.hunger = 0;
      this.prey_eaten = 0;
      this.rep_prog = this.rep_rate - 5;
    }
  }

  mapGene(gene, min, max) {
    return map(gene, 0, 1, min, max); // Assuming map is a function similar to Processing's map
  }

  mutate(value, offset) {
    return map(random(), 0, 1, value * (1 - offset), value * (1 + offset));
  }

  constrainMutate(value, offset, min, max) {
    let mutated = this.mutate(value, offset);
    return constrain(mutated, min, max); // Assuming constrain is a function similar to Processing's constrain
  }

    /**
        *Method to calculate the fitness of a predator
        @return void
      */
    fitness() {
      // Fitness is calculated using the number of prey it has eaten, the amount of food it has eaten, and the number of children it has
      this.fitness += pow((this.prey_eaten), 2);
      this.fitness += pow((0.05 * this.food_eaten), 2);
      this.fitness += pow(this.children.length, 2);
    }
    
    /**
        *Method to draw the predator
        @return void
      */
    drawLuca() {
      // No stroke or fill because it's an image
      noStroke();
      noFill();
      // Calculate the color based on the life_remaining
      let startColor = color(255, 0, 0); // Red color
      let endColor = color(pred_img.pixels[0]); // Original color of the image
      // Map the life_remaining indirectly to a value between 1 and 0. -300 is so they are not still alive while nearly transparent
      let amt = map(this.life_remaining, -400, this.lifespan, 1, 0);
      // Interpolate the color based on the life_remaining
      let interpColor = lerpColor(startColor, endColor, amt);
      // Apply the color tint to the image
      tint(interpColor);
      // Draw the predator as an image
      image(pred_img, this.loc.x, this.loc.y, this.cell_w * 2, this.cell_w * 2);
    
      // Draw a circular progress bar for the hunger level (green)
      stroke(0, 255, 0);
      // Make the progress bar thicker
      strokeWeight(4);
      // No fill for the progress bar
      noFill();
      // Map the hunger level to an angle of a semi-circle
      let hungerAngle = map(this.hunger, 0, this.max_hunger, PI, 0); // Map the hunger level to an angle
      // Draw the progress bar
      arc(this.loc.x, this.loc.y, this.cell_w * 2, this.cell_w * 2, -HALF_PI, -HALF_PI + hungerAngle);
    
      // Draw a circular progress bar for the stamina level (yellow)
      stroke(255, 210, 0);
      // Map the stamina level to an angle
      let staminaAngle = map(this.stam, 0, this.split_thresh, 0, PI);
      // Draw the progress bar
      arc(this.loc.x, this.loc.y, this.cell_w * 2, this.cell_w * 2, HALF_PI, HALF_PI + staminaAngle);
    
      // Reset the stroke weight and color to defaults
      strokeWeight(1);
      stroke(0);
      noTint(); // Remove the tint for other drawings
    }
    
    /**
        *Method to apply a repulsion force to prey (for evasion)
        @param l the prey to repel
        @return PVector the force vector to repel the prey
      */
      repel(l) {
        // Calculate the force vector between the predator and the prey
        let force = p5.Vector.sub(this.loc, l.loc);
        // Calculate the distance between the predator and the prey
        let dist = force.mag();
        // Constrain the distance to a range between 5 and the predator's sense range
        // A minimum of 5 is used to prevent division by 0 and so that the force acting on the prey does not get too large as they get very close
        dist = constrain(dist, 5, l.sense_range);
        // Normalize the force vector
        force.normalize();
        // Set the magnitude of the force vector
        let force_mag = -2;
        // If the denominator is not 0
        if (dist !== 0) {
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
    detectContact() {
      // For every predator
      for (let i = 0; i < all_predators.length; i++) {
        // If this is not the same as the one we're checking
        if (this !== all_predators[i]) {
          // Calculate the distance between the predators
          let distance = dist(this.loc.x, this.loc.y, all_predators[i].loc.x, all_predators[i].loc.y);
          // If they are touching
          if (distance < (this.cell_w + all_predators[i].cell_w + 1)) {
            // If not already on the contacts list
            if (!this.contacts.includes(all_predators[i])) {
              // Add it to the contacts list
              this.contacts.push(all_predators[i]);
            }
            // Return the predator it is touching
            return all_predators[i];
          } else {
            // If the other luca is on the contacts list
            if (this.contacts.includes(all_predators[i])) {
              // Remove it from the contacts list
              let index = this.contacts.indexOf(all_predators[i]);
              if (index > -1) {
                this.contacts.splice(index, 1);
              }
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
      applySeparation() {
        let force = this.separate();
        // If the predators are touching
        if (this.contacts.length > 0) {
          // Scale and apply the force
          force.mult(8);
          this.applyForce(force);
        }
      }

    /**
      * Method to apply force to seek the closest prey
      @return void 
    */
    applySeekPreyForce() {
      let force = this.seekClosestPrey();
      // If there is prey to seek and the force is not null or zero
      if (force !== null && (force.x !== 0 || force.y !== 0)) {
        // Scale and apply the force
        force.mult(this.seek_prey_force);
        this.applyForce(force);
      }
    }

    /**
        * Method to apply force to seek food
        @return void
      */

    applySeekFoodForce() {
      let force = this.seekClosest();
      // If there is food to seek
      if (force !== null /*&& this.can_seek*/ && (force.x !== 0 || force.y !== 0)) {
        // Scale and apply the force
        force.mult(this.seek_food_force);
        this.applyForce(force);
      }
    }

    /**
        *Method to apply the internal forces of the predator
        @return void
      */
    applyBehaviors() {
      // Separate
      this.applySeparation();
      // Seek prey
      this.applySeekPreyForce();
      // Seek food
      this.applySeekFoodForce();
    }

    /**
        *Method to separate from other predators
        @return PVector the force vector to separate from other predators
      */
    separate() {
      let sum = createVector(0, 0);
      let count = 0;
    
      if (this.contacts.length > 0) {
        for (let i = 0; i < this.contacts.length; i++) {
          let force = p5.Vector.sub(this.loc, this.contacts[i].loc);
          force.normalize();
          let distance = p5.Vector.dist(this.loc, this.contacts[i].loc);
          let forceMagnitude = map(distance, 0, 20, 0, 3);
          force.mult(forceMagnitude);
          sum.add(force);
          count++;
        }
    
        if (count > 0) {
          sum.div(count);
          sum.setMag(this.top_speed);
          sum.sub(this.vel);
          sum.limit(this.max_force);
        }
      }
    
      return sum;
    }

    /**
        *Method to seek the closest prey
        @return PVector the force vector to seek the closest prey
      */
    seekClosestPrey() {
      let min_dist = Infinity; // Initialize the minimum distance to a very large number
      let closest = null; // Initialize the closest prey to null
    
      // For every prey
      all_prey.forEach(prey => {
        // If the prey is not null
        if (prey !== null) {
          // Calculate the distance between the predator and the prey. Divide by the cell width so that bigger prey are more appealing
          let dist = p5.Vector.dist(this.loc, prey.loc) / prey.cell_w;
          // If the distance is less than the minimum distance and the prey has not been eaten
          if (dist < min_dist && !prey.eaten()) {
            min_dist = dist; // Set the minimum distance to the distance
            closest = prey; // Set the closest prey to the prey
          }
        }
      });
    
      this.closest_prey = closest; // Set the closest prey to the predator's closest prey
      // Return the force vector to seek the closest prey, if closest is not null
      return closest ? this.seek(this.closest_prey.loc) : createVector(0, 0);
    }

    /**
        *Method to seek specified prey
        @param prey the prey to seek
        @return PVector the force vector to seek the prey
      */
    seek(prey) {
      if (prey != null) {
        // Get the desired velocity vector
        let desired = p5.Vector.sub(prey.loc, this.loc);
        // Normalize the desired velocity vector
        desired.normalize();
        // Scale the desired velocity vector to the top speed
        desired.mult(this.top_speed);
        // Get the force vector between the desired velocity and the current velocity
        let force = p5.Vector.sub(desired, this.vel);
        // Limit the force vector to the maximum force
        force.limit(this.max_force);
        // Return the force vector
        return force;
      } else {
        // Return a zero vector if prey is null
        return createVector(0, 0);
      }
    }
}