

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
