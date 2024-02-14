// Imports
import fisica.*;
import java.lang.Math.*;
//import org.jbox2d.*;

// Set center
float center_x = width/2;
float center_y = height/2;

// Create ArrayList
static ArrayList<Luca> all = new ArrayList<Luca>();

// Declare world and Luca
FWorld world;
Luca l;

// Returns true if there is contact
boolean touching = false;

// Set up world
void setup() {
  
  // Set frame size and background
  size(1000, 1000);
  background(220, 55, 55);
  
  // Initialize fisica
  Fisica.init(this);

  // Instantiate world and set edges and gravity
  world = new FWorld();
  world.setEdges();
  world.setGravity(0, 0);
}
int c = 0;

// Draw
void draw() {
  
  // Draw background
  drawBack();
  // Next frame
  world.step();
  
  // Draw everything in the world
  world.draw();
  
  // If no Lucas exist
  if(all.size() < 1)
  {
    // Create a Luca
    // Constructor sets the blob as a circle at the designated location with a radius of 50
    // Also tried using Blobs instead of Luca and setting it as a circle in setup() with no luck
    // Tried explicitly setting the initial position with no luck
    l = new Luca(500, 500);
    
    
    // Set friction
    l.setFriction(0);
    // Set color of Luca
    l.setFillColor(color(68, 56, 98));
    
    // Add the Luca to the ArrayList
    all.add(l);
    // Add the Luca to the world
    world.add(l);
  }
  
  // For every Luca in the ArrayList
  for(int i = 0; i < all.size(); i++)
  {
    
    // Increase its stamina
    all.get(i).stam++;
    
    //if(c == 0)
    //{
    //*****
    // Uncomment to see tracking of position and velocity using both attributes and get methods during movement
    //
    // all.get(i).move(10, 10);
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
    
    // If more than one Luca exists
    if(all.size() > 1)
    {
      // Print the original Luca's position and velocity values
      println("posX: " + all.get(0).posX + " | posY: " + all.get(0).posY + " | velX: " + all.get(0).velX + " | velY: " + all.get(0).velY);
      println("getX(): " + all.get(0).getX() + " | getY(): " + all.get(0).getY() + " | getVelocityX(): " + all.get(0).getVelocityX() + " | getVelocityY: " + all.get(0).getVelocityY());
    }
  }
}

// Global variable
Luca child;

// To replicate a Luca //<>//
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
}

  // Defines what happens when contact is initiated
  void contactStarted(FContact contact) {
    
    // Set global variable to true
    touching = true;
    
    // Draw in green an ellipse where the contact started
    fill(0, 170, 0);
    ellipse(contact.getX(), contact.getY(), 20, 20);
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
    ellipse(contact.getX(), contact.getY(), 10, 10);
    
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
   ellipse(contact.getX(), contact.getY(), 10, 10);
   
 }

/*
// Set a Luca's stamina
 void setStam(Luca l, float stam)
{
  l.stam = stam;
}
*/

// Draw background
void drawBack()
{
  background(220, 55, 55);
}
