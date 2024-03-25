void setup()
{
  size(500,500);
  background(255);
  fill(0);
  smooth();
  frameRate(11);
  
  Luca luca = new Luca();
  // Spawn first luca
  luca.spawn();
}

int limit = 2;
Luca child = null;

void draw(){
  drawBack();
  
  // If there are less lucas than the limit
  if(limit > 0)
  {
    // Replicate
    child = all.get(0).split();
    limit--;
    child.loc = new PVector(all.get(0).loc.x, all.get(0).loc.y);
  }
  //If they are not touching
  if(child != null && dist(all.get(0).loc.x, all.get(0).loc.y, all.get(1).loc.x, all.get(1).loc.y) < all.get(0).cell_w+1)
  {
    // Push them apart
    all.get(0).move(200);
    child.move(20);
    println("L2: " + child.loc.x);
  }
  else
  {
    // Otherwise, move a cell to a point
    all.get(0).move(new PVector(200, 200));
  }
  // Display the lucas
  drawLuca(all.get(0));
  drawLuca(child);
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

// Draw background
void drawBack()
{
  background(220, 55, 55);
}
static void move(Luca l, float deg)
{
  l.move(deg);
}
