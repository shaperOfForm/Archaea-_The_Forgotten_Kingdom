/**
    *Environment class
    A class to manage the creation and deletion of food objects in the environment
 */
class Environment
{
    // List of all food
    ArrayList<Food> all_food;
    
    // Limit of food
    int limit = 400;

    // Biome
    Biome biome;

    /**
        *Constructor for the Environment class
        @return void
     */
    Environment()
    {
        // Initialize all food
        all_food = new ArrayList<Food>();
        // Add food to the list
        for(int i = 0; i < limit; i++)
        {
            all_food.add(new Food());
        }
        // Initialize biome
        biome = new Biome();
    }

    /**
        *Method to continuosly add food to the environment as it is eaten
        @return void
     */
    void run()
    {
        // Count how many Food objects have been eaten
        int eaten = 0;
        // Iterate through all food
        Iterator<Food> itf = all_food.iterator();
        // While there is another food object
        while(itf.hasNext())
        {
            // Get the food object
            Food f = itf.next();
            // If the food object has been eaten
            if(f.eaten())
            {
                // Remove the food object
                itf.remove();
                // Increment the eaten counter
                eaten++;
                // Set the food object to null
                f = null;
            }
            // Otherwise
            else
            {
                // Draw the food object
                f.drawFood();
            }
        }
        // For each food object that has been eaten
        for(int i = 0; i < eaten; i++)
        {
            // Add a new food object
            all_food.add(new Food());
        }
    }
    /*
        void run()
    {
        // A method to remove eaten food and add new food
        for(int i = 0; i < all_food.size(); i++)
        {
            // If the food is eaten
            if(all_food.get(i).eaten())
            {
                // Remove the food
                all_food.remove(i);
                // Add a new food
                Food f = new Food();
                all_food.add(f);
                f.drawFood();
                i--;
            }
            else
            {
                all_food.get(i).drawFood();
            }
        }
    }*/
}