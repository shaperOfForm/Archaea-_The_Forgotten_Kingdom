// If certain parts are unnecessary, it's because I don't want to make any more edits because I don't want to break anything
// I could not make documentation from the .pde files.
// It pains me to submit this as unpolished as it is.

// Import Iterator class
import java.util.Iterator;

// Background image
PImage back;
// Environment object
Environment e;
// Frame rate
static int f_rate;
// Food images
PImage[] food_imgs;
// Predator image
PImage pred_img;
// Boolean to check if the simulation is paused
boolean isPaused;
// Boolean to check if the about page is displayed
boolean about_bool;
// Species of prey
Species s;
Species s2;
//Species s3;

// Species of predator
Species predator;

// Sine and cosine look-up tables
float sin_values[] = new float[360];
float cos_values[] = new float[360];

// Temporary array list for adding new species to the biome
ArrayList<Species> new_species;

// Array list to store all lucas (prey and predators)
ArrayList<Luca> all;

// Matrix for the flocking grid (to check which lucas are in the same cell)
ArrayList<Luca>[][] grid;
// Size of the grid cells (in pixels);
int grid_cell_size = 22;
// Number of rows and columns in the grid
int cols;
int rows;

// Set prey limit
int luca_limit = 52;
// Set predator limit
int pred_limit = 13;

//ArrayLists to store all the prey and predators
ArrayList<Luca> all_prey;
ArrayList<Predator> all_predators;

// Declaring force vectors to be used in multiple methods (optimization trick from "The Nature of Code")
PVector force;
// Sum is not fully implemented, but it works for now
PVector sum;

  /**
    * Set up the simulation
    @return void
   */
  void setup()
  {
    // Set up canvas
    fullScreen(P2D);
    //size(1000, 1000, P2D);
    fill(0);
    smooth();

    force = new PVector();
    sum = new PVector();

    // Set up the simulation
    isPaused = false;
    about_bool = false;
    // Set frame rate
    f_rate = 11;
    frameRate(f_rate);
    // Set up the grid
    cols = width/grid_cell_size;
    rows = height/grid_cell_size;
    grid = new ArrayList[cols][rows];
    // Initialize the grid
    for(int i = 0; i < cols; i++)
    {
      for(int j = 0; j < rows; j++)
      {
        grid[i][j] = new ArrayList<Luca>();
      }
    }

    // Create sine and cosine look-up tables
    for(int i = 0; i < 360; i++)
    {
      sin_values[i] = sin(radians(i));
      cos_values[i] = cos(radians(i));
    }

    all = new ArrayList<Luca>();
    all_predators = new ArrayList<Predator>();
    all_prey = new ArrayList<Luca>();
    new_species = new ArrayList<Species>();

    // Load Food images
    PImage img1 = loadImage("food1.png");
    PImage img2 = loadImage("food2.png");
    PImage img3 = loadImage("food3.png");
    PImage img4 = loadImage("food4.png");
    PImage img5 = loadImage("food5.png");
    PImage img6 = loadImage("food6.png");
    PImage img7 = loadImage("food7.png");
    // Store food images in an array so they only have to be loaded once
    food_imgs = new PImage[]{img1, img2, img3, img4, img5, img6, img7};
    // Load predator image
    pred_img = loadImage("predator-min.png");
    // Load background image
    int back_num = (int)random(1, 5);
    // Load a random background image
    back = loadImage("background" + back_num + ".jpg");
    // Create an environment object
    e = new Environment();
    // Create two species of prey
    s = new Species();
    s2 = new Species();
    // Set location of second prey
    s2.all_in_species.get(0).loc = new PVector(width - 100, 100);
    s2.all_in_species.get(0).top_speed = 1;

    //s3 = new Species();
    //s3.all_in_species.get(0).loc = new PVector(100, height - 100);
    // Create a species of predator
    predator = new Species(1);
    // Set location of predator
    predator.all_in_species.get(0).loc = new PVector(500, height/2);
    // Initialize biome
    e.biome = new Biome();
    // Add species to the biome
    e.biome.b.add(s);
    e.biome.b.add(s2);
    //e.biome.b.add(s3);
    e.biome.b.add(predator);
    
  }

  /**
    * Draw the simulation
    @return void
   */
  void draw()
  {
    // Clear the grid
    for(int i = 0; i < cols; i++)
    {
      for(int j = 0; j < rows; j++)
      {
        grid[i][j].clear();
      }
    }

    // For each prey
    for(Luca l: all_prey)
    {
      // Get the location of the prey
      int x = int(l.loc.x) / grid_cell_size;
      int y = int(l.loc.y) / grid_cell_size;
      // Add the prey to the grid
      for(int n = -1; n <= 1; n++)
      {
        for(int m = -1; m <= 1; m++)
        {
          if(x + n >= 0 && x+n < cols && y + m >= 0 && y + m < rows)
          {
            grid[x + n][y + m].add(l);
          }
        }
      }
    }
  // If the about panel is open
  if(about_bool)
  {
    // Pause the simulation
    isPaused = true;
    // Draw one frame
    redraw();
    // Draw the about panel
    drawPanel();
    // Draw the about page
    showAbout();
    // Exit the draw method
    return;
  }
  // If the about panel is not open
  else
  {
    // If isPaused is true
    if (isPaused) 
    {
      // Stop the loop
      noLoop();
    }
    // If isPaused is false
    else 
    {
      // If the step button is clicked
      if(mousePressed && mouseX >= 50.5*width/100 && mouseX <= 50.5*width/100 + 150 && mouseY >= 3 && mouseY <= 52)
      {
        // Advance one frame
        step();
        // Draw one frame
        redraw();
        // Pause the simulation
        isPaused = true;
        // Stop the loop
        noLoop();
      }
      // Otherwise
      else
      {
        // Continuously advance and draw one frame
        step();
        redraw();
      }
    }
    // Draw the panel
    drawPanel();
  }
  /*
  if(!about)
  {
    drawPanel();
  }
  */
}

// Some parts of the simulation control buttons may seem unnecessary, but they were added so the simulation would not break after certain combinations of button clicks.

/**
  Pause the simulation
  @return void
 */
void pause()
{
  // Pause the simulation
  isPaused = true;
  // Set the frame rate to normal speed
  frameRate(11);
  // Stop the loop
  noLoop();
}

/**
  Play the simulation
  @return void
 */
void play()
{
  // Set the frame rate to normal speed
  f_rate = 11;
  frameRate(f_rate);
  //redraw();
  // Unpause the simulation
  isPaused = false;
  // Start the loop
  loop();
}

/**
  Advance one frame
  @return void
 */
void stepForButton()
{
  // Set the frame rate to normal speed
  f_rate = 11;
  frameRate(11);
  // If the simulation is paused
  if(isPaused)
  {
    // Start the simulation
    loop();
    // Set isPaused to true - it is paused in the draw loop after advancing one frame
    isPaused = false;
  }
}

/**
  Fast forward the simulation
  @return void
 */
void fastForward()
{
  // If the simulation is not paused
  if(!isPaused)
  {
    // Multiply frame rate by 2, limited to 165
    f_rate = constrain(f_rate*=2, 11, 165);
  }
  // If the simulation is paused
  else
  {
    // Unpause the simulation
    isPaused = false;
    // Set the frame rate to normal speed
    f_rate = 11;
  }
  // Apply the change
  frameRate(f_rate);
  // Start the loop
  loop();
}

/**
  Restart the simulation
  @return void
 */
void restart()
{
  // If the simulation is paused
  if(isPaused)
  {
    // Unpause the simulation
    isPaused = false;
    // Start the loop
    loop();
  }
  // Clear ArrayLists
  e.biome.b.clear();
  all.clear();
  all_prey.clear();
  all_predators.clear();
  
  // Reinitialize
  setup();
  // Zero out the velocities and accelerations of initial prey and predator
  predator.all_in_species.get(0).vel = new PVector(0, 0);
  predator.all_in_species.get(0).acc = new PVector(0, 0);
  s.all_in_species.get(0).vel = new PVector(0, 0);
  s.all_in_species.get(0).acc = new PVector(0, 0);
  
  // Run the environment
  e.run();
  
  // Restart the draw loop
  draw();
}

/**
  Pause the simulation to show the about page
  @return void
 */
void about()
{
  // Set about to the opposite of its current value
  about_bool = !about_bool;
  // If the about page is open, pause the simulation
  isPaused = about_bool;
  // Draw one frame so the data is current
  redraw();
}

/**
  Mouse pressed event
  @return void
 */
void mousePressed() {
  // Pause button
  if (mouseX >= 18.5*width/100 && mouseX <= 18.5*width/100 + 150 && mouseY >= 2 && mouseY <= 52) 
  {
    pause();
  }
  // Play button
  if (mouseX >= 34.5*width/100 && mouseX <= 34.5*width/100 + 150 && mouseY >= 2 && mouseY <= 52) 
  {
    play();
  }
  // Step button
  if(mouseX >=50.5*width/100 && mouseX <= 50.5*width/100 + 150 && mouseY >= 2 && mouseY <= 52)
  {
    stepForButton();
  }
  // Fast forward button
  if(mouseX >= 66.5*width/100 && mouseX <= 66.5*width/100 + 150 && mouseY >= 2 && mouseY <= 52)
  {
    fastForward();
  }
  // Restart button
  if(mouseX >= 2*width/100 && mouseX <= 2*width/100 + 150 && mouseY >= 2 && mouseY <= 52)
  {
    restart();
  }
  // About button
  if(mouseX >= 83*width/100 && mouseX <= 83*width/100 + 150 && mouseY >= 2 && mouseY <= 52)
  {
    about();
  }
}

/**
  Show the about page
  @return void
 */
void showAbout()
{
  // Set the size of the page
  int w = 900;
  int h = 1000;
  // Set the offset
  int offset = 490;
  // Set the background color
  fill(255, 255, 255, 180);
  // Draw the rectangle
  rect(offset, 50, w + 5, height - 50);
  // Set the text color to black
  fill(0);
  // Set the text size
  textSize(23);
  // Set the text alignment
  text("The driving force behind this project is Zachary Smith, a passionate Computer Science student whose interdisciplinary approach bridges the gap between technology and Biology.\n", offset + 5, 50, w - 5, height - 100);
  // Set the text size
  textSize(19);
  // Set the text alignment
  text("The simulation was created, using Java Processing, as a project for the capstone course CPS 485 - Projects at State University of New York at New Paltz.", offset + 5, 150, w - 5, height - 100);
  text("My goal is to create an educational simulation that unveils the hidden complexities of microbial life and its impact on our planet. The primary aim is to promote awareness of major theories in Ecology, Microbiology, and Evolutionary Studies. Through the simulation, I aim to engage learners and inspire curiosity about the microbial world. By emphasizing the applicability of Computer Science to understanding natural phenomena, we hope to foster a deeper appreciation for the unseen life forms that shape our environment.\n\n", offset + 5, 250, w - 5, height - 100);
  text("To mimic the microbial life which evolves within closed systems the simulation possesses three critical ingredients:", offset + 5, 440, w - 5, h - offset - 100);
  // Set the text color to red
  fill(255, 0, 0);
  // Set the text alignment
  text("Variability: ", offset + 5, 520, w - 5, h - offset - 100);
  // Set the text color to black
  fill(0);
  // Set the text alignment
  text("Within and between microbe populations, individuals exhibit diverse traits. Some have slightly higher metabolic rates. Some have slightly thicker membranes, etc. These nuances matter. Some traits confer advantages, such as better camouflage or more efficient foraging. These small tweaks accumulate over generations.\n", offset + 5, 550, w - 5, height - 100);
  // Set the text color to green
  fill(0, 100, 0);
  // Set the text alignment
  text("Heredity: ", offset + 5, 650, w - 5, h - offset - 100);
  // Set the text color to black
  fill(0);
  // Set the text alignment
  text("Genes pass from one generation to the next, preserving adaptations that enhance survival, making them more prevalent in the population. Heredity ensures continuity—the script handed down through time.\n", offset + 5, 685, w - 5, height - 100);
  // Set the text color to blue
  fill(0, 0, 255);
  // Set the text alignment
  text("Differential Reproductive Success: ", offset + 5, 770, w - 5, h - 100);
  // Set the text color to black
  fill(0);
  // Set the text alignment
  text("Individuals with advantageous traits are more likely to survive and reproduce. Their offspring inherit these beneficial traits, perpetuating them in subsequent generations.\n\nNow, let's shift our gaze to the digital domain. Here, software becomes our laboratory—a tool to simulate these very forces. We write code that mimics nature's rules: mutations introduce variation, reproduction passes down. In doing so, users can discover whether natural selection occurs 'naturally' under these conditions.", offset + 5, 800, w - 5, height - 100);
  // Set the text size
  textSize(16);
  // Set the text alignment
  text("Limit of Liability: The author of this software is not liable for any damages caused by the software.", offset + 5, height - 50, w - 5, height - 100);
}

/**
  Draw the about panel
  @return void
 */
void drawAboutPanel()
{
  // Set the color of the panel
  fill(200, 200);
  // Draw the panel
  rect(83*width/100, 2, 150, 52);
  // Draw the about button
  aboutButton();
}

/**
  Draw background
  @return void
 */
void drawBack()
{
  // Draw background
  tint(100);
  // Draw background image
  image(back, 0, 0, width, height);
  // Remove tint
  tint(255);
}

/**
  Draw restart button
  @return void
 */
void restartButton()
{
  // Load restart button image
  PImage restart = loadImage("restart.png");
  // Draw restart button inside panel
  image(restart, 2*width/100, 2, 150, 50);
}

/**
  Draw play button
  @return void
 */
void playButton()
{
  // Load play button image
  PImage play = loadImage("play.png");
  // Draw play button inside panel
  image(play, 34.5*width/100, 2, 150, 50);
}

/*
  Draw pause button
  @return void
 */
void pauseButton()
{
  // Load pause button image
  PImage pause = loadImage("pause.png");
  // Draw pause button inside panel
  image(pause, 18.5*width/100, 2, 150, 50);
}

/**
  Draw fast forward button
  @return void
 */
void fastForwardButton()
{
  // Load fast forward button image
  PImage fastForward = loadImage("ff.png");
  // Draw fast forward button inside panel
  image(fastForward, 66.5*width/100, 2, 150, 50);
}

/**
  Draw step button
  @return void
 
 */
void stepButton()
{
  // Load step button image
  PImage step = loadImage("step.png");
  // Draw step button inside panel
  image(step, 50.5*width/100, 3, 150, 52);
}

// Draw about button
void aboutButton()
{
  // Load about button image
  PImage about_button = loadImage("about.png");
  // Draw about button inside panel
  image(about_button, 83*width/100, 2, 150, 52);
}

/**
  Advance one frame
  @return void
 */
void step()
{
  // Draw background
  drawBack();
  // Run the environment
  e.run();
  // Run the biome
  e.biome.run();
  // Draw one frame
  redraw();
}

/**
  Draw the panel
  @return void
 */
void drawPanel()
{
  // If the about page is not open
  if(!about_bool)
  {
    // Set the color of the panel
    fill(200, 200);
    // Draw the panel
    rect(0, 0, width, 50);
    // Add play button to panel
    playButton();
    // Add pause button to panel
    pauseButton();
    // Add fast forward button to panel
    fastForwardButton();
    // Add step button to panel
    stepButton();
    // Add restart button to panel
    restartButton();
    // Add about button to panel
    aboutButton();
    // Draw the legend
    drawLegend();
  }
  // If the about page is open
  else
  {
    // Set the color of the panel
    fill(200);
    // Draw the panel
    rect(0, 0, width, 50);
    // Add about button to panel
    aboutButton();
  }
}

/**
  Draw the legend
  @return void
 */
void drawLegend()
{
  // Set the text size
  textSize(20);

  // Draw color indicator for hunger (green)
  fill(0, 255, 0);
  // Draw a square
  rect(width - 150, 10, 15, 15);
  // Set the text color to black
  fill(0);
  // Draw the text
  text("ENERGY", width - 130, 25);

  // Draw color indicator for reproduction (yellow)
  fill(255, 210, 0);
  // Draw a square
  rect(width - 150, 30, 15, 15);
  // Set the text color to black
  fill(0);
  // Draw the text
  text("REPRODUCE", width - 130, 45);
}

/*
void keyPressed() {
  try {
    saveFrame("screenshot.png");
  } 
  catch (Exception e) {
  }
}
*/

// Box2D work - may have come from GitHub. Not sure. I don't want to for-certain claim it as my own, but I also don't want to delete it
// The fisica physics engine work was overwritten. I can get it from GitHub upon request, but it does not contribute to the current state of the project at all.

 //<>// //<>//
/*
/*import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.collision.shapes.CircleShape;
import org.jbox2d.dynamics.joints.*;
import java.util.ArrayList;

Box2DProcessing box2d;
ArrayList<Body> particles;
ArrayList<Body> particles2;
float radius = 100;
int numParticles = 20;

void setup() {
  size(600, 400);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0); // Setting gravity to (0, 0)
  
  particles = new ArrayList<Body>();
  particles2 = new ArrayList<Body>();
  
  // Create circular arrangement of particles
  createParticles(particles, numParticles);
  createParticles(particles2, numParticles);
  
  // Connect neighboring particles with revolute joints
  for (int i = 0; i < numParticles; i++) {
    connectParticles(i, (i + 1) % numParticles, particles);
    connectParticles(i, (i + 1) % numParticles, particles2);
  }
}

void draw() {
  background(255);
  box2d.step();
  
  // Apply forces to move particles of particles towards the center
  Vec2 center = new Vec2(width / 2, height / 2);
  for (Body particle : particles) {
    Vec2 pos = particle.getWorldCenter();
    Vec2 force = center.sub(pos).mul(0.001f); // Adjust the force magnitude as needed
    particle.applyForceToCenter(force);
  }
  
  // Apply forces to move particles of particles2 towards the center
  for (Body particle : particles2) {
    Vec2 pos = particle.getWorldCenter();
    Vec2 force = center.sub(pos).mul(0.001f); // Adjust the force magnitude as needed
    particle.applyForceToCenter(force.mul(-1)); // Applying force in opposite direction
  }
  
  // Display particles of particles1
  for (Body particle : particles) {
    Vec2 pos = box2d.getBodyPixelCoord(particle);
    ellipse(pos.x, pos.y, 10, 10);
  }
  
  // Display particles of particles2
  for (Body particle : particles2) {
    Vec2 pos = box2d.getBodyPixelCoord(particle);
    ellipse(pos.x, pos.y, 10, 10);
  }
}

Body createParticle(float x, float y) {
  BodyDef bd = new BodyDef();
  bd.type = BodyType.DYNAMIC;
  bd.position.set(box2d.coordPixelsToWorld(x, y));
  Body particle = box2d.createBody(bd);
  
  CircleShape cs = new CircleShape();
  cs.m_radius = box2d.scalarPixelsToWorld(5); // Adjust radius as needed
  
  FixtureDef fd = new FixtureDef();
  fd.shape = cs;
  fd.density = 1.0;
  fd.friction = 0.3;
  fd.restitution = 0.5;
  
  particle.createFixture(fd);
  
  return particle;
}

void connectParticles(int index1, int index2, ArrayList<Body> particlesList) {
  Body particle1 = particlesList.get(index1);
  Body particle2 = particlesList.get(index2);
  
  RevoluteJointDef jd = new RevoluteJointDef();
  jd.bodyA = particle1;
  jd.bodyB = particle2;
  jd.collideConnected = false;
  jd.localAnchorA.setZero();
  jd.localAnchorB.setZero();
  
  box2d.createJoint(jd);
}

void createParticles(ArrayList<Body> particlesList, int count) {
  for (int i = 0; i < count; i++) {
    float angle = map(i, 0, count, 0, TWO_PI);
    float x = width / 2 + cos(angle) * radius;
    float y = height / 2 + sin(angle) * radius;
    Body particle = createParticle(x, y);
    particlesList.add(particle);
  }
}

*/












// Imports
/*
import fisica.*;
import java.lang.Math.*;
import shiffman.box2d.*;

// Set center
float center_x = width/2;
float center_y = height/2;


// Create ArrayList
static ArrayList<Luca> all = new ArrayList<Luca>();


// Declare world and Luca
FWorld world;
Luca l;

ArrayList<FBlob> blobs = new ArrayList<FBlob>();

// Returns true if there is contact
boolean touching = false;

// Set up world
void setup() {
  
  //Settings.maxPairs = 1000;
  
  // Set frame size and background
  size(1000, 1000);
  background(220, 55, 55);
  
  // Initialize fisica
  Fisica.init(this);

  // Instantiate world and set edges and gravity
  world = new FWorld();
  world.setEdgesRestitution(999999999);
  world.setEdges();
  world.setGravity(0, 0);
  
  l = new Luca(500, 500);
  l.setPosition(width/2, height/2);
  l.setVelocity(0, 0);
  l.setRestitution(0);
  l.setNoStroke();
  l.setFill(200, 30, 90);
  // Set friction
  l.setFriction(0);
  // Set color of Luca
  l.setFillColor(color(68, 56, 98));
  all.add(l);
  world.add(l);
  
  FBlob blob = new FBlob();
  blob.setAsCircle(500, 500, 50);
  blobs.add(blob);
  world.add(blob);
  //FBlob blob2 = new FBlob();
  //blob2.setAsCircle(200, 200, 50);
  //blobs.add(blob2);
  //world.add(blob2);

}
//int c = 0;

ArrayList<FBody> bodies = new ArrayList<FBody>();

// Draw
void draw() {
  
  // Draw background
  drawBack();

  // Draw everything in the world
  world.draw();
  // Next frame
  world.step();  

  if(bodies.size() >= 2)
  {
    if(bodies.get(0) != null)
    {
      //println("ALL: " + all.size());
    ArrayList contacts = bodies.get(0).getContacts();
    //println(contacts.size());
    for (int i=0; i<contacts.size(); i++) 
    {
    FContact c = (FContact)contacts.get(i);
    line(c.getBody1().getX(), c.getBody1().getY(), c.getBody2().getX(), c.getBody2().getY());
      println("HERE: " + c.getBody1().getX());
    }
      //println("BODY1: " + bodies.get(0));
      //println("LUCA1: " + all.get(0));
      //println(bodies.get(0) == all.get(0));
    }
  }
  
  // If no Lucas exist
  if(all.size() < 1)
  {
    // Create a Luca
    // Constructor sets the blob as a circle at the designated location with a radius of 50
    // Also tried using Blobs instead of Luca and setting it as a circle in setup() with no luck
    // Tried explicitly setting the initial position with no luck
    
    

    
    // Add the Luca to the world
    world.add(l);
  }
  
  
  //println(all.get(0).stam);
  // For every Luca in the ArrayList
  for(int i = 0; i < all.size(); i++)
  {
    
    if(bodies.size() > 2 && bodies.get(0) != null && bodies.get(1) != null && !touching)
    {
      bodies.get(0).addForce(random(-400, 400), random(-400, 400));
      bodies.get(1).addForce(random(-400, 400), random(-400, 400));
    }
    
    //println("posX: " + all.get(0).posX + " | posY: " + all.get(0).posY + " | velX: " + all.get(0).velX + " | velY: " + all.get(0).velY);
    //println("getX(): " + all.get(0).getX() + " | getY(): " + all.get(0).getY() + " | getVelocityX(): " + all.get(0).getVelocityX() + " | getVelocityY: " + all.get(0).getVelocityY());
    // Increase its stamina
    all.get(i).stam++;
    
    //if(c == 0)
    //{
    //*****
    // Uncomment to see tracking of position and velocity using both attributes and get methods during movement
    //
    if(all.get(i).can_move && all.get(i).stam > 100)
    {
     //all.get(i).move(-1, 1);
    }
    //
    //*****
    //c++;
    //}
    // If the Luca is not moving and has at least 200 stamina
    if(all.get(i).velX < 1 && all.get(i).velY < 1 && all.get(i).stam >= 200)
    {
      // It replicates
      split(all.get(i));
    }
    
    // No effect, handles in contactPersisted method
    /*
    if(touching)
    {
      
      // Pick a random location within the Lucas' range
      float x1 = random(-luca.speed, luca.speed);
      float y1 = random(-luca.speed, luca.speed);
      float x2 = random(-child.speed, child.speed);
      float y2 = random(-child.speed, child.speed);
      
      // Move to those locations
      luca.move(x1, y1);
      println("POS" + luca.posX);
      child.move(x2, y2);
      
    }*/
    /*
    // If more than one Luca exists
    if(all.size() > 1)
    {
      //println("Never gets here");
      // Print the original Luca's position and velocity values
      //println("posX: " + all.get(0).posX + " | posY: " + all.get(0).posY + " | velX: " + all.get(0).velX + " | velY: " + all.get(0).velY);
      //println("getX(): " + all.get(0).getX() + " | getY(): " + all.get(0).getY() + " | getVelocityX(): " + all.get(0).getVelocityX() + " | getVelocityY: " + all.get(0).getVelocityY());
    }
  }
}

// Global variable
Luca child;

// To replicate a Luca
void split(Luca luca)
{
  
  // If the Luca exists and has more than 200 stamina
  if(luca != null && luca.stam > 200) 
  {
    
    // If there is no contact
    if(!touching)
    {
      // Spawn a Luca
      // The line should spawn a child Luca on top of its parent
      // However, since its not tracking position or velocity,
      // it uses the original position of the first luca every time
      child = luca.spawn();
      
      // Using move method here doesn't work. Either doesn't change values or updates them without end
    
    }
    
    // Set their staminas to zero
    child.stam = 0;
    luca.stam = 0;
    //println("Parent: " + luca.stam + " Child: " + child.stam);
  }
  
  // Add joint
  /*
  FDistanceJoint j = new FDistanceJoint(luca, child);
  j.setLength(5);
  j.addToWorld(world);
  */
  /*
}
  // Defines what happens when contact is initiated
  void contactStarted(FContact contact) {
    
    // Set global variable to true
    touching = true;
    
    // Draw in green an ellipse where the contact started
    fill(0, 170, 0);
    //ellipse(contact.getX(), contact.getY(), 20, 20);
 }
 
  // Defines what happens when contact persists
  void contactPersisted(FContact contact) {
    
    // Cannot use update() method here. Only Contact and FBody methods
    
    // Set global variable to true
    touching = true;
   
    // Separate
    contact.getBody1().addForce(2000, 2000); 
    contact.getBody2().addForce(-2000, -2000);
    
    // Draw in blue an ellipse where the contact took place
    fill(0, 0, 170);
    //ellipse(contact.getX(), contact.getY(), 10, 10);
    
 }
 
 // Defines what happens when contact ends
 void contactEnded(FContact contact)
 {
   // Set global variable to false
   touching = false;
   
   // Stop motion
   contact.getBody1().resetForces();
   contact.getBody1().setVelocity(0, 0);
   contact.getBody2().resetForces();
   contact.getBody2().setVelocity(0, 0);
   
   // Show when/where contact ends in red
   fill(170, 0, 0);
   //ellipse(contact.getX(), contact.getY(), 10, 10);
   //println("HELLO: " + contact.getBody1().getX());
   
   //println(contact.getBody1());
   if(!bodies.contains(contact.getBody1()))
   {
     bodies.add(contact.getBody1());
     println("TRUE: " + !bodies.contains(contact.getBody1()));
     println(bodies.size());
   }
   if(!bodies.contains(contact.getBody2()))
   {
     bodies.add(contact.getBody2());
   }
   
   //bodies.add(contact.getBody2());
   
   
   //contacts.add(contact);
   
   //println(contacts.get(0));
   
   //line(c.getBody1().getX(), c.getBody1().getY(), c.getBody2().getX(), c.getBody2().getY());
   //println("HERE: " + c.getBody1().getX());  
   //println(contacts);
   
 }

/*
// Set a Luca's stamina
 void setStam(Luca l, float stam)
{
  l.stam = stam;
}
*/
/*
// Draw background
void drawBack()
{
  background(220, 55, 55);
}
*/
