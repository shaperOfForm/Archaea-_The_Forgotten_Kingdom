// Imports
import fisica.*;
import java.lang.Math.*;
//import org.jbox2d.*;

// Declare world and Luca
FWorld world;
FBlob l;

void setup() {
  
  // Set frame size and background
  size(1000, 1000);
  background(220, 55, 55);
  
  // Initialize fisica
  Fisica.init(this);
  
  // Create new blob
  l = new FBlob();
  // Set shape
  l.setAsCircle(500, 500, 50);
  
  // Instantiate world and set edges and gravity
  world = new FWorld();
  world.setEdges();
  world.setGravity(0, 0);
  
  //Add luca to the world
  //l.setPosition(500, 500);
  //l.setVelocity(200.0, 200.0);
  world.add(l);
  
}

// Declare variables to store position and velocity
float posX = 500; 
float posY = 500; 
float velX = 0;
float velY = 0;

// Draw
void draw() {
  // Draw background
  drawBack();
  // Next frame
  world.step();
  // Draw everything in the world
  world.draw();
  
  // Calculate acceleration based on the forces applied
  float forceX = 10;
  float forceY = 10;
  float mass = 1; 
  float accelerationX = forceX / mass; 
  float accelerationY = forceY / mass; 
  
  // Update velocity based on acceleration
  velX += accelerationX;
  velY += accelerationY;
  
  // Update position based on velocity
  posX += velX;
  posY += velY;
  
  // Apply the force
  l.addForce(100, 1);
  
  
  // Print the updated position and velocity values
  println("getForceY()" + l.getForceY());
  println("\ngetX(): " + l.getX() + " getY(): " + l.getY() + " getVelocityX(): " + l.getVelocityX() + " getVelocityY(): " + l.getVelocityY());
  //println("\nPosX: " + posX + " PosY: " + posY + " VelX: " + velX + " VelY: " + velY);
}
  
// Draw background
void drawBack()
{
  background(220, 55, 55);
}
