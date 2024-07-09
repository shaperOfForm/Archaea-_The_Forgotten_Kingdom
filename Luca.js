

/**
  *Luca class
  A class to create Luca objects (cells) and provide all of its functionality
 */
class Luca
{

  /**
    *Default constructor
   */
  constructor(x = 100, y = 100, parent = null, top_speed = 26, cell_w = Math.random() * (19 - 15) + 15, rep_rate = 10, lifespan = 400, max_hunger = 55, mut_rate = 0.65, split_thresh = 50, seek_force = 15, sense_range = 500, flock_force = 12, delta_acc = 0.2) {
    // Spawns in center of screen
    this.loc = createVector(x, y);
    this.vel = createVector(0, 0);
    this.acc = createVector(0, 0);
    // Set attributes
    this.top_speed = top_speed;
    this.cell_w = cell_w; // Adjusted to use the parameter directly
    this.rep_rate = rep_rate;
    this.lifespan = lifespan;
    this.max_hunger = max_hunger;
    this.mut_rate = mut_rate;
    this.split_thresh = split_thresh;
    this.seek_force = seek_force;
    this.sense_range = sense_range;
    this.flock_force = flock_force;
    this.delta_acc = delta_acc;
    // Set mass (Used a proportion of the average mass of a bacterial cell divided by the average mass of a bacterial cell to the 'volme' of a prey, using its width as the radius)
    this.mass = 64656.70908252886 / (this.cell_w/2 * this.cell_w/2 * this.cell_w/2);
    // Iniialize parent and children
    this.parent = parent;
    this.children = [];
    //this.dest = null;
    // X and y coordinates used in drawing the wavy edges of the cell
    this.xCoor = [];
    this.yCoor = [];
    // Initialize attributes
    this.contacts = [];
    // Setting life_remining to full
    this.life_remaining = this.lifespan;
    // Setting hunger to zero
    this.hunger = 0;
    // If the Luca is a predator
    if(!(this instanceof Predator))
    {
      // Add the Luca to the prey ArrayList
      all_prey.push(this);
    }
    if(parent)
    {
      
      this.col = parent.col;
      parent.children.push(this);
      this.dna = parent.dna.copy();
      this.mutate();
      // Set reproduction progress and stamina for first luca so they don't die right away
      this.rep_prog = 0;
      this.stam = 0;
      //The line above and the block below may be redundant, but I don't want to play with it any more than I have to, as it may break the balancing
      if(!(this instanceof Predator))
      {
        // An offset which represents the range of values the attributes can be mutated by
        let offset = 0.1;
        // Use the parent genes as a base, 'mutate them' by mapping them to a range that is a percentage away from the parent value, as dictated by the offset, and assign them to the attributes
        this.top_speed = map(dna.genes[0], 0, 1, parent.top_speed * (1 - offset), parent.top_speed * (1 + offset));
        this.cell_w = map(dna.genes[1], 0, 1, parent.cell_w * (1 - .5*offset), parent.cell_w * (1 + .5*offset)); // 15
        this.rep_rate = map(dna.genes[2], 0, 1, parent.rep_rate * (1 - offset), parent.rep_rate * (1 + offset)); // 25
        this.lifespan = map(dna.genes[3], 0, 1, parent.lifespan * (1 - offset), parent.lifespan * (1 + offset)); // 150
        this.max_hunger = map(dna.genes[4], 0, 1, parent.max_hunger * (1 - offset), parent.max_hunger * (1 + offset)); // 500
        this.mut_rate = map(dna.genes[5], 0, 1, parent.mut_rate * (1 - offset), parent.mut_rate * (1 + offset)); //.25
        this.split_thresh = map(dna.genes[6], 0, 1, parent.split_thresh * (1 - offset), parent.split_thresh * (1 + offset)); // 30
        this.seek_force = map(dna.genes[7], 0, 1, parent.seek_force * (1 - .1*offset), parent.seek_force * (1 + .1*offset));
        this.sense_range = map(dna.genes[8], 0, 1, parent.sense_range * (1 - .1*offset), parent.sense_range * (1 + .1*offset));
        this.flock_force = map(dna.genes[9], 0, 1, parent.flock_force * (1 - .1*offset), parent.flock_force * (1 + .1*offset));
        this.delta_acc = map(dna.genes[9], 0, 1, parent.delta_acc * (1 - .1*offset), parent.delta_acc * (1 + .1*offset));
        this.rep_prog = random(0, 3);
      }
    }
    else
    {
      // Create a new DNA object
      this.dna = new DNA();
      // Set reproduction progress and stamina for first luca so they don't die right away
      this.rep_prog = 12;
      this.stam = this.split_thresh - 10;
      /*
      this.col = new_spec_col;
      */
    }
  }
  
  mutate() {
  // For each gene in the DNA
  for (let i = 0; i < this.dna.genes.length; i++) {
    // If a random number between 0 and 1 is less than the mutation rate
    if (random(1) < this.mut_rate) {
      // Mutate the gene by adding a random value between -9 and 9
      this.dna.genes[i] += random(-9, 9);
      // Constrain the gene to be between 0 and 1. This results in a mutation of either 0 or 1 most of the time, for the mutations to be observable for the presentation
      this.dna.genes[i] = constrain(this.dna.genes[i], 0, 1);
    }
  }
}

applyRepeller(p) {
  // Set force to the repel force
  let force = p.repel(this);
  // Apply the force
  this.applyForce(force);
}

fitness() {
  // Fitness is calculated using the number of food eaten and the number of descendants
  this.fitness += pow((0.25 * this.food_eaten), 2);
  this.fitness += pow(this.children.size, 2);
}

applyFlockForce() {
  // For each of the three flocking forces
  for (let k = 0; k < 3; k++) {
    // Get separation, cohesion, and alignment forces
    let force = this.flock()[k];
    // Scale the forces
    force.mult(this.flock_force);
    // Apply the forces
    this.applyForce(force);
  }
}

applySeparation() {
  // Have them separate from each other
  let force = this.separate();
  // Scale the force
  force.mult(4);
  // Apply the force
  this.applyForce(force);
}

applySeekFoodForce() {
  // Get the seek food force
  let force = this.seekClosest();
  // If the force is not null
  if (force !== null /*&& this.can_seek*/ /* && (force.x !== 0 && force.y !== 0)*/) {
    // Map the hunger level to a value between 0 and 1
    let h = map(this.hunger, 0, this.max_hunger, 0, 1);
    // Constrain the hunger level by max hunger and a number below 1
    h = constrain(h, 0.5, this.max_hunger);
    // Scale the force using the hunger level and the seek force
    force.mult(h * this.seek_force);
    // Apply the force
    this.applyForce(force);
  }
}


  applyEvasionForce() {
  // Reset force
  if (this.force !== null) {
    this.force.set(0, 0);
  } else {
    this.force = createVector(0, 0);
  }
  // For each predator
  all_predators.forEach(p => {
    // Add the repel force
    let repel = p.repel(this);
    if (repel !== null) {
      this.force.add(repel);
    }
  });
  // Limit the force
  this.force.limit(this.max_force);
  // Scale the force - Highest priority
  this.force.mult(19);
  // Apply the force
  this.applyForce(this.force);
}

  applyWallForce() {
  // Get force from walls
  let force = this.wallForce();
  // Scale the force
  force.mult(4);
  // Apply the force
  this.applyForce(force);
}

  flockAndSeparate() {
  // Get the grid location of the Luca
  let i = Math.floor(this.loc.x / this.cell_w);
  let j = Math.floor(this.loc.y / this.cell_w);
  // Constrain the grid location to the grid size
  i = constrain(i, 0, grid.length - 1);
  j = constrain(j, 0, grid[0].length - 1);

  // Get the Luca objects in the same cell
  let temp = grid[i][j];
  // For each Luca in the cell
  for (let l2 of temp) {
    // If the Luca is not the same as the current Luca
    if (this !== l2) {
      // If the Luca is the same species
      if (this.spec === l2.spec) {
        // Apply flocking behavior
        this.applyFlockForce();
      }
      // If the Luca is not the same species and not a Predator
      else if (!(l2 instanceof Predator)) {
        // Apply separation
        this.applySeparation();
      }
    }
  }
}
  
  applyBehaviors() {
  this.flockAndSeparate();
  // Seek food
  this.applySeekFoodForce();

  // Evade predators
  this.applyEvasionForce();

  // Move away from walls
  this.applyWallForce();
}

seek(target) {
  // Get the desired velocity
  let force = p5.Vector.sub(target, this.loc);
  // Normalize the force
  force.normalize();
  // Multiply by the maximum speed
  force.mult(this.top_speed);
  // Get the steering force by subtracting the current velocity from the desired velocity
  force.sub(this.vel);
  // Limit the force
  force.limit(this.max_force);
  // Return the force
  return force;
}

  flock() {
  // Get the separation, alignment, and cohesion forces
  let sep = this.separate(); // Assuming separate() is defined elsewhere
  let ali = this.align(); // Assuming align() is defined elsewhere
  let coh = this.cohesion(); // Assuming cohesion() is defined elsewhere
  // Scale the forces
  sep.mult(1.9);
  ali.mult(3.5);
  coh.mult(2.0);
  // Return the forces as an array
  return [sep, ali, coh];
}

  cohesion() {
  // Set the maximum neighbor distance for cohesion
  let neighborDist = 100;
  // Initialize the sum of locations and count
  let sum = createVector(0, 0);
  let count = 0;
  // For each prey
  all_prey.forEach(l => {
    // Calculate the distance between the two lucas
    let d = dist(this.loc.x, this.loc.y, l.loc.x, l.loc.y);
    // If the distance is greater than 0 and less than the neighbor distance
    if (d > 0 && d < neighborDist) {
      // Add the location of the prey to the sum
      sum.add(l.loc);
      // Increment the count
      count++;
    }
  });
  // If there are any lucas for cohesion
  if (count > 0) {
    // Get the average location
    sum.div(count);
    // Return the seek force to the average location
    return this.seek(sum);
  } else {
    // Return a zero vector
    return createVector(0, 0);
  }
}

align() {
  let neighborDist = 50;
  let sum = createVector(0, 0);
  let count = 0;
  all_prey.forEach(l => {
    let d = p5.Vector.dist(this.loc, l.loc);
    if (d > 0 && d < neighborDist) {
      sum.add(l.vel);
      count++;
    }
  });
  if (count > 0) {
    sum.div(count);
    sum.normalize();
    sum.mult(this.top_speed);
    let force = p5.Vector.sub(sum, this.vel);
    force.limit(this.max_force);
    return force;
  } else {
    return createVector(0, 0);
  }
}

wallForce() {
  let margin = 100;
  if (this.force !== null) {
    this.force.set(0, 0);
  } else {
    this.force = createVector(0, 0);
  }
  let count = 0;
  if (this.loc.x > width - margin) {
    let forceStrength = map(this.loc.x, width - margin, width, 0, this.max_force * this.mass);
    this.force.add(-forceStrength, 0);
    count++;
  } else if (this.loc.x < margin) {
    let forceStrength = map(this.loc.x, 0, margin, this.max_force * this.mass, 0);
    this.force.add(forceStrength, 0);
    count++;
  }
  if (this.loc.y > height - margin) {
    let forceStrength = map(this.loc.y, height - margin, height, 0, this.max_force * this.mass);
    this.force.add(0, -forceStrength);
    count++;
  } else if (this.loc.y < margin) {
    let forceStrength = map(this.loc.y, 0, margin, this.max_force * this.mass, 0);
    this.force.add(0, forceStrength);
    count++;
  }
  if (count !== 0) {
    this.force.div(count);
    this.force.limit(this.cell_w / 3);
  }
  return this.force;
}

seekClosest() {
  let min_dist = Infinity;
  let closest = null;
  e.all_food.forEach(food => {
    if (food !== null) {
      let dist = p5.Vector.dist(this.loc, food.loc) / food.mass;
      if (dist < min_dist && !food.eaten && this.cell_w > 2 * food.mass) {
        min_dist = dist;
        closest = food;
      }
    }
  });
  this.closest_food = closest;
  if (this.closest_food != null) {
    return this.seek(this.closest_food.loc);
  } else {
    return createVector(0, 0);
  }
}

seek(food) {
  if (food != null) {
    let force = p5.Vector.sub(food.loc, this.loc);
    force.normalize();
    force.mult(this.top_speed);
    force.sub(this.vel);
    force.limit(this.max_force);
    return force;
  } else {
    return null;
  }
}
  
separate() {
  let sum = createVector(0, 0);
  let count = 0;
  if (this.contacts.length > 0) {
    this.contacts.forEach(contact => {
      let force = p5.Vector.sub(this.loc, contact.loc);
      force.normalize();
      let dist = p5.Vector.dist(this.loc, contact.loc);
      let force_mag = map(dist, 0, 20, 0, 3);
      force.mult(force_mag);
      sum.add(force);
      count++;
    });
    if (count > 0) {
      sum.div(count);
      sum.setMag(this.top_speed);
      sum.sub(this.vel);
      sum.limit(this.max_force);
    }
  }
  return sum;
}

drawLuca() {
  stroke(0);
  let startColor = color(40);
  let endColor = this.spec.col;
  let amt = map(this.life_remaining, 0, this.lifespan, 0, 1);
  let interpColor = lerpColor(startColor, endColor, amt);
  fill(interpColor);
  beginShape();
  if (!window.isPaused) { // Assuming isPaused is a global variable
    for (let i = 0; i < TWO_PI; i += 0.2) {
      let index = int(degrees(i)) % 360;
      let x1 = sin(index) * this.cell_w;
      let y1 = cos(index) * this.cell_w;
      let xOffset = random(-1.25, 1.25);
      let yOffset = random(-1.25, 1.25);
      x1 += this.loc.x + xOffset;
      y1 += this.loc.y + yOffset;
      curveVertex(x1, y1);
    }
  }
  endShape(CLOSE);
  noFill();

  stroke(0, 255, 0);
  strokeWeight(4);
  noFill();
  let hungerAngle = map(this.hunger, 0, this.max_hunger, PI, 0);
  arc(this.loc.x, this.loc.y, this.cell_w * 2, this.cell_w * 2, -HALF_PI, -HALF_PI + hungerAngle);
  strokeWeight(1);
  stroke(0);

  stroke(255, 210, 0);
  let staminaAngle = map(this.stam, 0, this.split_thresh, 0, PI);
  arc(this.loc.x, this.loc.y, this.cell_w * 2, this.cell_w * 2, HALF_PI, HALF_PI + staminaAngle);
  strokeWeight(1);
  stroke(0);
}

detectContact() {
  let temp = [];
  // If the luca is a predator
  if (this instanceof Predator) {
    // Set the temporary array to the all_predators array
    temp = [...all_predators];
  }
  // If the luca is not a predator
  else {
    // Get the grid location of the luca
    let i = Math.floor(this.loc.x / this.cell_w);
    let j = Math.floor(this.loc.y / this.cell_w);
    // Constrain the grid location to the grid size
    i = constrain(i, 0, grid.length - 1);
    j = constrain(j, 0, grid[0].length - 1);
    // Get the lucas in the same cell
    temp = grid[i][j];
  }
  // For every luca
  for (let l of temp) {
    // If it is not the luca we're checking
    if (this !== l) {
      // Calculate the distance between the lucas
      let distance = dist(this.loc.x, this.loc.y, l.loc.x, l.loc.y);
      // If they are touching
      if (distance < (this.cell_w + l.cell_w + 1)) {
        // If not already on the contacts list
        if (!this.contacts.includes(l)) {
          // Add it to the contacts list
          this.contacts.push(l);
        }
        // Return the luca it is touching
        return l;
      }
      // If they are not touching
      else {
        // If the other luca is on the contacts list
        if (this.contacts.includes(l)) {
          // Remove it from the contacts list
          this.contacts = this.contacts.filter(contact => contact !== l);
        }
      }
    }
  }
  // If no contacts are found, return null
  return null;
}

spawn() {
  // Set new Luca's x and y values, and their p5.Vector location
  this.loc = createVector(width - 100, height - 100);
  // Add this Luca to the global array
  all.push(this);
}

spawn(l) {
  let l2 = null;
  // If the luca is a predator
  if (l instanceof Predator) {
    // Create a new predator with the same location and properties as l
    l2 = new Predator(l.loc.x, l.loc.y, l);
  } else {
    // Create a new prey with the same location and properties as l
    l2 = new Luca(l.loc.x, l.loc.y, l);
  }
  // Add the new luca to the global array
  all.push(l2);
  // Return the new luca
  return l2;
}

split() {
  // Lower the stamina and replication progress and increase the hunger
  this.stam *= random(0, 0.1);
  this.hunger += random(15, 25);
  this.rep_prog = random(0, 3);
  // Spawn new luca on top of original
  let l2 = new Luca(); // Assuming Luca can be instantiated like this
  // Set the new luca's stamina and location
  l2.stam = 0;
  l2.loc = createVector(this.loc.x, this.loc.y);

  // Set child and parent
  if (this.children != null) {
    l2.parent = this;
    this.children.push(l2);
  }
  // Set the new luca's species
  l2.spec = this.spec;
  // Return the new luca
  return l2;
}
  
eaten() {
  // If the luca is not a predator
  if (!(this instanceof Predator)) {
    // For each predator
    all_predators.forEach(pred => {
      // If the distance between the luca and the predator is less than the predator's cell width
      if (p5.Vector.dist(this.loc, pred.loc) <= pred.cell_w && pred.cell_w > this.cell_w) {
        // Lower the predator's hunger and increase its stamina
        pred.hunger -= this.cell_w;
        pred.stam += this.cell_w;
        // Increase the predator's prey eaten count
        pred.prey_eaten++;
        // Limit hunger to zero
        pred.hunger = max(pred.hunger, 0);
        // Return true
        return true;
      }
    });
  }
  // If not eaten, return false
  return false;
}

checkEdges() {
  // If the luca is touching the right edge
  if (this.loc.x > width) {
    // Set the x location to the width
    this.loc.x = width;
    // Reverse the x velocity
    this.vel.x *= -1;
  }
  // If a luca is touching the left edge
  else if (this.loc.x < 0) {
    // Set the x location to 0
    this.loc.x = 0;
    // Reverse the x velocity
    this.vel.x *= -1;
  }
  // If a luca is touching the bottom edge
  if (this.loc.y > height) {
    // Set the y location to the height
    this.loc.y = height;
    // Reverse the y velocity
    this.vel.y *= -1;
  }
  // If a luca is touching the top edge
  else if (this.loc.y < 0) {
    // Set the y location to 0 (top edge)
    this.loc.y = 0;
    // Reverse the y velocity
    this.vel.y *= -1;
  }
}

applyForce(f) {
  // Divide the force by the mass
  let force = p5.Vector.div(f, this.mass);
  // Add the force to the acceleration
  this.acc.add(force);
}

move() {
  // Limit the acceleration
  this.acc.limit(this.max_force / this.mass);
  // Add the acceleration to the velocity
  this.vel.add(this.acc);
  // Slow down the change in velocity
  this.vel = p5.Vector.lerp(this.vel, p5.Vector.add(this.vel, this.acc), this.delta_acc);
  // Limit the velocity
  this.vel.limit(this.top_speed);
  // Add the velocity to the location
  this.loc.add(this.vel);
  // Reset the acceleration
  this.acc.mult(0);
}
}
