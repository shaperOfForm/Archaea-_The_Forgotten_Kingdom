static int h;
static int w;
static PVector dest1;
static PVector origin = new PVector(w, h);
static float center_x = w/2;
static float center_y = h/2;
static ArrayList<Luca> all = new ArrayList<Luca>();
static float rand = 0;
static float rand2 = 0;
static Luca l2 = null;

void setup() 
{
  size(1000, 1000);
  background(220, 55, 55);
  h = height;
  w = width;
  Luca l = new Luca();
  l.spawn();
  display(l);
  dest1 = new PVector(300, 300);
  rand = random(0, 360);
}

void draw() 
{
  //for(int i = 0; i<Luca.all.size(); i++)
  //{
    Luca l = all.get(0);
    //if(l2 == null)
    //{
      int count = 0;
      if(count<1)
      {
        //l2 = l.split();
        l2 = l.spawn(l);
        l.move(rand);
        
        all.get(1).move(rand-180);
        count++;
        display(l);
        display(all.get(1));
      }
      
      //if(l.loc.dist(l2.loc) < max(max(l.loc.x, l.loc.y, l2.loc.x), l2.loc.y))
      //{
      //  print("HELLO");

      //}
      else
      {
        print("HELLO");
        l.acc.x = 0; l.acc.y = 0;
        l.vel.x = 0; l.vel.y = 0;
      }
      
      //println("BEFORE" + l2.acc);
    //l2.acc = l2.acc.rotate(180);
    //println(l2.acc);
    //}
    //all.set(1, l2);
    //display(l);
    //display(l2);
    //if(Species.num_species == 1)
    {
      
      //print(Luca.all.get(0)); //<>//
      //l.move(900, 700, l.speed);
      //dest1 = new PVector(600, 240);
      //l.move(dest1);
      //l.moveRandom();
      //l.move((3*PI)/2);
      
      //l.move(270);
      display(l);
      
      //l.move(dest1);
      //display(l);
      //print(Luca.lucas.get(0));
      //print(lucas[1].cell_x);
      //display(l2);

      //Luca.all.set(i, l);
      //Luca.all.set(i+1, l2);
      //display(l2);
      //display(Luca.all.get(Luca.all.size()-1));
      //lucas[0].cell_x++;
      //lucas[1].move(900, 300, 1);
    }
    if(Species.num_species == 2)
    {
      //l.move(330, 260);
    }
    //println(Luca.lucas.size());
    //Luca.viewAll();
    //l.phage(this);
  //}
}
void display(Luca l)
{
  ellipse(l.loc.x, l.loc.y, l.cell_w, l.cell_h);
}
void draw_back()
{
  background(220, 55, 55);
}
static void move(Luca l, float deg)
{
  l.move(deg);
}
