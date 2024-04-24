class Environment
{
    ArrayList<Food> all_food;
    
    int limit = 100;

    Environment()
    {
        all_food = new ArrayList<Food>();
        for(int i = 0; i < limit; i++)
        {
            all_food.add(new Food());
        }
    }

    void run()
    {
        Iterator<Food> itf = all_food.iterator();
        Food new_food = null;
        while(itf.hasNext())
        {
            Food f = itf.next();
            f.drawFood();
            if(f.eaten())
            {
                itf.remove();
                new_food = new Food();
            }
        }
        if(new_food != null)
        {
            all_food.add(new_food);
        }
    }
}