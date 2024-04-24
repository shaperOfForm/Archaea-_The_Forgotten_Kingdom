import java.util.Iterator;

Environment e;

ArrayList<Species> biome;

float time;

void setup()
{
  // Set up canvas
  size(1000,1000, P2D);
  background(255);
  fill(0);
  smooth();
  frameRate(11);
  
  e = new Environment();

  biome = new ArrayList<Species>();
  
  Species s = new Species();

  Species predator = new Species(1);

  biome.add(s);

  biome.add(predator);
  
}
// Set luca limit
int limit = 50;

void draw()
{
  // Draw background
  drawBack();

  e.run();

  Iterator<Species> it = biome.iterator();
  while(it.hasNext())
  {
    Species s = it.next();
    s.run();
  }
  
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
