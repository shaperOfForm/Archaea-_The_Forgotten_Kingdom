class Environment
{
    ArrayList<Food> all_food;
    
    int limit = 1200;

    Biome biome;

    Environment()
    {
        all_food = new ArrayList<Food>();
        for(int i = 0; i < limit; i++)
        {
            all_food.add(new Food());
        }
        biome = new Biome();
    }

    void run()
    {
        int eaten = 0;

        Iterator<Food> itf = all_food.iterator();
        while(itf.hasNext())
        {
            Food f = itf.next();
            if(f.eaten())
            {
                itf.remove();
                eaten++;
                f = null;
            }
            else
            {
                f.drawFood();
            }
        }
        for(int i = 0; i < eaten; i++)
        {
            all_food.add(new Food());
        }
    }
}