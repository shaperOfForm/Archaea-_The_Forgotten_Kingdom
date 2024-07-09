import Species from './Species.js';
import Predator from './Predator.js';
import { allPrey } from './Archaea.js';
/**
    *Biome class
    For managing the species in the biome
 */
export default class Biome {
  constructor() {
    this.speciesList = []; // Array of Species
    this.newLucas = []; // Array of Luca instances to be added to a new species
    this.toRemove = []; // Array of Luca instances to be removed
    this.newSpecies = null; // Initialize new species to be added
  }

  run() {
    // First loop: Check if a species should be split
    this.speciesList.forEach((species, index) => {
      species.run();
      if (species.allInSpecies.length > 0 && !(species.allInSpecies[0] instanceof Predator)) {
        if (this.speciesList.length < 3 && allPrey.length > 0) {
          // Split one species into two
          this.newSpecies = species.speciate(allPrey[0]);
          // Incorrectly adding prey to newLucas instead of adding new species to biome
          // Correct action: Add the new species to the biome
          this.newLucas.push(allPrey[0]); // This line is incorrect based on the comment
        }
      }
    });

    // Correcting the issue: Adding new species to the biome
    if (this.newLucas.length > 0 && this.newSpecies != null) {
      this.newLucas.forEach(luca => {
        if (!(luca instanceof Predator)) {
          luca.spec.allInSpecies = luca.spec.allInSpecies.filter(l => l !== luca);
          luca.spec = this.newSpecies;
          this.newSpecies.allInSpecies.push(luca);
        }
      });
    }

    // Second loop: Remove species with no members
    this.speciesList = this.speciesList.filter(species => species.allInSpecies.length > 0);

    // Add the new species to the biome
    if (this.newSpecies != null) {
      this.speciesList.push(this.newSpecies);
      this.newSpecies.run();
      this.newSpecies = null;
    }

    // Check for predator addition
    let spawnPred = true;
    this.speciesList.forEach(species => {
      if (species.allInSpecies.length > 0 && species.allInSpecies[0] instanceof Predator) {
        spawnPred = false;
      }
    });

    if (spawnPred) {
      this.speciesList.push(new Species(1)); // Assuming Species constructor can handle predator creation
    }
  }
}