import { food_imgs } from './sketch.js';
import Predator from './Predator.js';
// Class for food objects

export default class Food {
  constructor() {
    // Random location
    this.loc = createVector(random(20, width - 20), random(70, height - 20));
    // Random mass (size)
    this.mass = random(4, 10);
    // Random image from a predefined array of food images
    this.food_img = food_imgs[int(random(0, food_imgs.length))];
  }

  drawFood() {
    // No stroke for images
    noStroke();
    // Fill with white is not necessary in p5.js when using images
    // Set texture mode
    textureMode(IMAGE);
    // Begin shape
    beginShape();
    // Texture the image
    texture(this.food_img);
    // Vertices based on mass (size)
    vertex(this.loc.x, this.loc.y, 0, 0);
    vertex(this.loc.x + 2 * this.mass, this.loc.y, 200, 0);
    vertex(this.loc.x + 2 * this.mass, this.loc.y + 2 * this.mass, 200, 200);
    vertex(this.loc.x, this.loc.y + 2 * this.mass, 0, 200);
    // End shape
    endShape(CLOSE);
  }

  eaten(allLucas) {
    // Iterate through all lucas (prey and predators)
    for (let luca of allLucas) {
      // If the luca is bigger than the food and the distance between the food and the luca is less than the luca's width minus the food's mass
      if (this.loc.dist(luca.loc) < luca.cell_w - this.mass + 8 && luca.cell_w > this.mass) {
        // Adjust hunger and stamina based on whether it's a predator or prey
        let hungerReduction = luca instanceof Predator ? this.mass : 1.25 * this.mass;
        let staminaIncrease = hungerReduction;
        luca.hunger -= hungerReduction;
        luca.stam += staminaIncrease;
        // Increment the luca's food eaten
        luca.food_eaten++;
        // Ensure hunger is not less than zero
        luca.hunger = max(luca.hunger, 0);
        // Return true indicating the food was eaten
        return true;
      }
    }
    // If no luca is eating the food, return false
    return false;
  }
}