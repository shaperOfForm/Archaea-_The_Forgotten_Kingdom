

// Remove import statements for p5

let backImg;
let e;
let f_rate = 11;
let food_imgs = [];
let pred_img;
let isPaused = false;
let about_bool = false;
let s, s2;
let predator;
let sin_values = new Array(360);
let cos_values = new Array(360);
let new_species = [];
let all = [];
let grid = [];
let grid_cell_size = 22;
let cols, rows;
let luca_limit = 52;
let pred_limit = 13;
let all_prey = [];
let all_predators = [];
let force, sum;
let new_spec_color;

let luca;

function preload() {
  
  // Preload images from the "data" directory
  for (let i = 1; i <= 7; i++) {
    food_imgs.push(loadImage(`data/food${i}.png`));
  }
  pred_img = loadImage("data/predator-min.png");
  let back_num = int(random(1, 5));
  backImg = loadImage(`data/background${back_num}.jpg`);
}

// Adjust the sketch to use global mode
function setup() {
  createCanvas(windowWidth, windowHeight);
  //luca = new Luca();
}

function draw() {
  background(220);
  circle(mouseX, mouseY, 20);
  /*
  // Debugging: Ensure luca is defined and has drawLuca method
  if (luca && typeof luca.drawLuca === 'function') {
    try {
      // Create a new Luca object
      luca.drawLuca();
      console.log('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    } catch (error) {
      console.error('Failed to draw Luca:', error);
    }
  } else {
    console.log('Luca is not initialized or drawLuca is not a function');
  }
    */
}

// No need to instantiate p5 object