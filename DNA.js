
/**
 * DNA class for the predator and luca
 * Contains the genes of the predator and luca
 * A class to simulate DNA via heredity and random mutation
 */
class DNA {
  /**
   * Constructor for DNA with random genes
   */
  constructor(genes) {
    if (genes) {
      // If genes are provided, copy them
      this.genes = [...genes];
    } else {
      // Create a new array of 11 random floats between 0 and 1
      this.genes = Array.from({ length: 11 }, () => random(0, 1));
    }
  }

  /**
   * Method to copy the genes of a DNA object
   */
  copy() {
    // Return a new DNA object with a copy of this.genes
    return new DNA(this.genes);
  }
}