import java.util.Iterator;

PImage back;

Environment e;

static int f_rate;

PImage[] food_imgs;

PImage pred_img;

boolean isPaused;
boolean about;

Species s;
Species s2;
//Species s3;

Species predator;

float sin_values[] = new float[360];
float cos_values[] = new float[360];

ArrayList<Species> new_species = new ArrayList<Species>();
ArrayList<Luca> all = new ArrayList<Luca>();

ArrayList<Luca>[][] grid;
int grid_cell_size = 22;
int cols;
int rows;

// Set luca limit
int luca_limit = 50;
int pred_limit = 15;

void setup()
{
  // Set up canvas
  fullScreen(P2D);
  fill(0);
  smooth();
  isPaused = false;
  about = false;
  // Set frame rate
  f_rate = 11;
  frameRate(f_rate);
  
  cols = width/grid_cell_size;
  rows = height/grid_cell_size;

  grid = new ArrayList[cols][rows];

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

  // Load Food images
  PImage img1 = loadImage("food1.png");
  PImage img2 = loadImage("food2.png");
  PImage img3 = loadImage("food3.png");
  PImage img4 = loadImage("food4.png");
  PImage img5 = loadImage("food5.png");
  PImage img6 = loadImage("food6.png");
  PImage img7 = loadImage("food7.png");
  food_imgs = new PImage[]{img1, img2, img3, img4, img5, img6, img7};

  pred_img = loadImage("predator-min.png");

  int back_num = (int)random(1, 5);

  back = loadImage("background" + back_num + ".jpg");
  
  e = new Environment();
  
  s = new Species();

  s2 = new Species();
  s2.all_in_species.get(0).loc = new PVector(width - 100, 100);

  //s3 = new Species();
  //s3.all_in_species.get(0).loc = new PVector(100, height - 100);

  predator = new Species(1);
  predator.all_in_species.get(0).loc = new PVector(400, height/2);

  e.biome = new Biome();

  e.biome.b.add(s);
  e.biome.b.add(s2);
  //e.biome.b.add(s3);

  e.biome.b.add(predator);
  
}

  void draw()
  {
    if(all_predators.size() > 0)
    {
      //println("PREDATOR: " + all_predators.get(0).stam);
    }

    for(int i = 0; i < cols; i++)
    {
      for(int j = 0; j < rows; j++)
      {
        grid[i][j].clear();
      }
    }

    for(Luca l: all_prey)
    {
      int x = int(l.loc.x) / grid_cell_size;
      int y = int(l.loc.y) / grid_cell_size;

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

  if(about)
  {
    isPaused = true;
    redraw();
    drawPanel();
    
    showAbout();
    //drawAboutPanel();
    return;
  }
  
  else
  {
  
    // Pause the simulation
  if (isPaused) 
  {
      noLoop();
  } 
  else 
  {
    if(mousePressed && mouseX >= 50.5*width/100 && mouseX <= 50.5*width/100 + 150 && mouseY >= 3 && mouseY <= 52)
    {
      // Check step method to see what to change
      step();
      redraw();
      isPaused = true;
      noLoop();
      //step();
    }
    else
    {
      //loop();
      step();
      redraw();
    }
  }
  drawPanel();
  }
  /*
  if(!about)
  {
    drawPanel();
  }
  */
}

void pause()
{
  isPaused = true;
  frameRate(11);
  noLoop();
}

void play()
{
  f_rate = 11;
  frameRate(11);
  //redraw();
  isPaused = false;
  loop();
}

void stepForButton()
{
  //drawPanel();
  //redraw();
  //loop();
  f_rate = 11;
  frameRate(11);
  if(isPaused)
  {
    loop();
    isPaused = false;
  }
}

void fastForward()
{
  if(!isPaused)
  {
    // Increase the frame rate
    //f_rate *= 2;
    // Limit the frame rate to 165
    f_rate = constrain(f_rate*=2, 11, 165);
  }
  else
  {
    isPaused = false;
    f_rate = 11;
  }
  frameRate(f_rate);
  loop();
}

void restart()
{
  // Clear ArrayLists
  e.biome.b.clear();
  all.clear();
  all_prey.clear();
  all_predators.clear();
  
  // Reinitialize
  setup();
  //redraw();
  predator.all_in_species.get(0).vel = new PVector(0, 0);
  predator.all_in_species.get(0).acc = new PVector(0, 0);
  s.all_in_species.get(0).vel = new PVector(0, 0);
  s.all_in_species.get(0).acc = new PVector(0, 0);
  
  e.run();
  
  draw();
}

void about()
{
  about = !about;
  isPaused = about;
  //println("ABOUT: " + about + " IS PAUSED: " + isPaused);
}

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

void showAbout()
{
  int w = 900;
  int h = 1000;
  int offset = 490;
  fill(255, 255, 255, 180);
  rect(offset, 50, w + 5, height - 50);
  fill(0);
  textSize(23);
  text("The driving force behind this project is Zachary Smith, a passionate Computer Science student whose interdisciplinary approach bridges the gap between technology and Biology.\n", offset + 5, 50, w - 5, height - 100);
  textSize(19);
  text("The simulation was created, using Java Processing, as a project for the capstone course CPS 485 - Projects at State University of New York at New Paltz.", offset + 5, 150, w - 5, height - 100);
  text("My goal is to create an educational simulation that unveils the hidden complexities of microbial life and its impact on our planet. The primary aim is to promote awareness of major theories in Ecology, Microbiology, and Evolutionary Studies. Through the simulation, I aim to engage learners and inspire curiosity about the microbial world. By emphasizing the applicability of Computer Science to understanding natural phenomena, we hope to foster a deeper appreciation for the unseen life forms that shape our environment.\n\n", offset + 5, 250, w - 5, height - 100);
  text("To mimic the microbial life which evolves within closed systems the simulation possesses three critical ingredients:", offset + 5, 440, w - 5, h - offset - 100);
  fill(255, 0, 0);
  text("Variability: ", offset + 5, 520, w - 5, h - offset - 100);
  fill(0);
  text("Within and between microbe populations, individuals exhibit diverse traits. Some have slightly higher metabolic rates. Some have slightly thicker membranes, etc. These nuances matter. Some traits confer advantages, such as better camouflage or more efficient foraging. These small tweaks accumulate over generations.\n", offset + 5, 550, w - 5, height - 100);
  fill(0, 100, 0);
  text("Heredity: ", offset + 5, 650, w - 5, h - offset - 100);
  fill(0);
  text("Genes pass from one generation to the next, preserving adaptations that enhance survival, making them more prevalent in the population. Heredity ensures continuity—the script handed down through time.\n", offset + 5, 685, w - 5, height - 100);
  fill(0, 0, 255);
  text("Differential Reproductive Success: ", offset + 5, 770, w - 5, h - 100);
  fill(0);
  text("Individuals with advantageous traits are more likely to survive and reproduce. Their offspring inherit these beneficial traits, perpetuating them in subsequent generations.\n\nNow, let's shift our gaze to the digital domain. Here, software becomes our laboratory—a tool to simulate these very forces. We write code that mimics nature's rules: mutations introduce variation, reproduction passes down. In doing so, users can discover whether natural selection occurs 'naturally' under these conditions.", offset + 5, 800, w - 5, height - 100);
  textSize(16);
  text("Limit of Liability: The author of this software is not liable for any damages caused by the software.", offset + 5, height - 50, w - 5, height - 100);
}

void drawAboutPanel()
{
  fill(200, 200);
  rect(83*width/100, 2, 150, 52);
  aboutButton();
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
  tint(100);
  image(back, 0, 0, width, height);
  tint(255);
}

void restartButton()
{
  PImage restart = loadImage("restart.png");
  image(restart, 2*width/100, 2, 150, 50);
}

void playButton()
{
  PImage play = loadImage("play.png");
  image(play, 34.5*width/100, 2, 150, 50);
}

void pauseButton()
{
  PImage pause = loadImage("pause.png");
  // Draw pause button inside panel
  image(pause, 18.5*width/100, 2, 150, 50);
}

void fastForwardButton()
{
  PImage fastForward = loadImage("ff.png");
  image(fastForward, 66.5*width/100, 2, 150, 50);
}

void stepButton()
{
  PImage step = loadImage("step.png");
  image(step, 50.5*width/100, 3, 150, 52);
}

void aboutButton()
{
  PImage about = loadImage("about.png");
  image(about, 83*width/100, 2, 150, 52);
}

void step()
{
    // Draw background
  drawBack();
  e.run();

  
  e.biome.run();
  redraw();
}


// A method to create a JPanel along the top of the screen
void drawPanel()
{
  if(!about)
  {
    fill(200, 200);
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
    aboutButton();

    drawLegend();
  }
  else
  {
    fill(200);
    rect(0, 0, width, 50);
    aboutButton();
  }
}

void drawLegend()
{
  textSize(20); // Increase the text size

  // Draw color indicator for hunger
  fill(0, 255, 0); // Green color
  rect(width - 150, 10, 15, 15); // Increase the size of the rectangle
  fill(0); // Black color for the text
  text("HUNGER", width - 130, 25); // Adjust the position of the label

  // Draw color indicator for reproduction
  fill(255, 210, 0); // Yellow color
  rect(width - 150, 30, 15, 15); // Increase the size of the rectangle
  fill(0); // Black color for the text
  text("REPRODUCE", width - 130, 45); // Adjust the position of the label
}