import Food from "./Food.js";
import Biome from "./Biome.js";
/**
    *Environment class
    A class to manage the creation and deletion of food objects in the environment
 */
export default class Environment {
  constructor() {
    // Initialize all food as an empty array
    this.all_food = [];
    // Limit of food
    this.limit = 400;
    // Initialize biome
    this.biome = new Biome();

    // Add food to the list
    for (let i = 0; i < this.limit; i++) {
      this.all_food.push(new Food());
    }
  }

  run() {
    // Count how many Food objects have been eaten
    let eaten = 0;

    // Iterate through all food using filter to remove eaten food and count them
    this.all_food = this.all_food.filter(food => {
      if (food.eaten()) {
        eaten++;
        return false; // Remove the food from the array
      } else {
        food.drawFood(); // Draw the food object
        return true; // Keep the food in the array
      }
    });

    // For each food object that has been eaten, add a new food object
    for (let i = 0; i < eaten; i++) {
      this.all_food.push(new Food());
    }
  }
}