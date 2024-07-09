import Luca from './Luca.js';
import Predator from './Predator.js';

export default class Species {
  constructor(luca = null, isPredator = false) {
    // Initialize attributes
    this.col = color(random(255), random(255), random(255));
    this.all_in_species = [];
    this.speciate = false;

    if (luca === null && !isPredator) {
      // Constructor for prey species
      let luca = new Luca();
      luca.spec = this;
      this.all_in_species.push(luca);
      // Assuming e.biome.b.add(this); is adding this species to a global biome list
      e.biome.b.push(this);
      luca.spawn();
    } else if (isPredator) {
      // Constructor for predators
      let predator = new Predator();
      predator.spec = this;
      this.all_in_species.push(predator);
      predator.spawn();
      predator.loc = createVector(100, 100);
    } else if (luca !== null) {
      // Constructor for speciation
      let l2 = luca.spawn(luca);
      l2.spec = this;
      if (l2.spec != null) {
        let index = l2.spec.all_in_species.indexOf(l2);
        if (index > -1) {
          l2.spec.all_in_species.splice(index, 1);
        }
      }
      this.all_in_species.push(l2);
    }
  }
  
  /**
    *Method to run each luca in a species
    @return void
   */
  // Assuming Luca, Predator, and other relevant classes and global variables are defined elsewhere

run() {
  let new_lucas = []; // Temporary list to store new lucas before adding them

  // Update state of all Luca instances
  for (let i = 0; i < all_in_species.length; i++) {
    let l = all_in_species[i];
    l.fitness();
    l.detectContact();
    l.checkEdges();
    l.life_remaining--;
    l.rep_prog++;
    l.hunger += 0.5;
    l.hunger = constrain(l.hunger, 0, l.max_hunger);
    l.fric = p5.Vector.mult(p5.Vector.normalize(l.vel), -1 * l.fricMag);
    l.applyForce(l.fric);
    l.stam = constrain(l.stam, 0.0, l.split_thresh);

    let limit = luca_limit;
    let temp = all_prey;
    if (l instanceof Predator) {
      limit = pred_limit;
      temp = [...all_predators];
    }

    if (temp.length < limit && l.stam >= l.split_thresh && l.rep_prog >= l.rep_rate) {
      let new_luca;
      if (l instanceof Predator) {
        new_luca = l.split();
        new_luca.stam = 0;
        new_luca.rep_prog = 0;
      } else {
        new_luca = l.split();
      }
      new_lucas.push(new_luca);
      l.rep_prog = 0;
      l.stam = random(0, 2);
    }
  }

  if (new_lucas.length > 0) {
    new_lucas.forEach(l => {
      all.push(l);
      all_in_species.push(l);
    });
  }

  all_in_species = all_in_species.filter(l => {
    l.applyBehaviors();
    l.move();
    l.drawLuca();
    return true;
  });

  // Remove Luca instances that should be removed
  all_in_species = all_in_species.filter(l => {
    if (l.hunger >= l.max_hunger || l.life_remaining <= 0 || (!(l instanceof Predator) && l.eaten())) {
      if (l instanceof Predator) {
        let index = all_predators.indexOf(l);
        if (index > -1) all_predators.splice(index, 1);
      } else {
        let index = all_prey.indexOf(l);
        if (index > -1) all_prey.splice(index, 1);
      }
      let index = all.indexOf(l);
      if (index > -1) all.splice(index, 1);
      return false;
    }
    return true;
  });
}
  /**
    *A method to split one species into two
    @param l The luca to split from the species
    @return Species The new species
   */
    speciate(luca) {
      // Draw a circle to represent the speciation event, if needed
      ellipse(100, 100, 100, 100);
      // Create a new species from a luca from the old species
      let newSpecies = new Species(luca);
      // Return the new species
      return newSpecies;
    }
}