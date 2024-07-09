/**
    *Biome class
    For managing the species in the biome
 */
class Biome
{
    // Arraylist of Species
    ArrayList<Species> b;
    // Arraylist of Luca instances to be added to a new species
    ArrayList<Luca> new_lucas = new ArrayList<Luca>();
    // Arraylist of Luca instances to be removed
    ArrayList<Luca> to_remove = new ArrayList<Luca>();
    // Initialize new species to be added
    Species new_spec = null;
    
    /**
        *Constructor for the Biome class
     */
    Biome()
    {
        // Initialize the species arraylist
        b = new ArrayList<Species>();
    }

    /**
        *Method to run each species in the Biome
        @return void
     */
    void run()
    {
        // First loop: Check if a species should be split
        // Create iterator for the species arraylist    
        Iterator<Species> it = b.iterator();
        // While there is another species to run
        while(it.hasNext())
        {
            // Get the next species
            Species s = it.next();
            // Run the species
            s.run();
            // If the species has at least one member and the first member is not a predator
            if(s.all_in_species.size() > 0 && !(s.all_in_species.get(0) instanceof Predator))
            {
                // If there are less than three species in the biome and at least one prey
                if(e.biome.b.size() < 3 && all_prey.size() > 0)
                {
                    // Split one species into two
                    new_spec = s.speciate(all_prey.get(0));

                    //PROBLEM IS HERE
                    // ADD SPECIES TO BIOME< NOT PREY TO SPECIES
                    // Add the new species to the biome
                    new_lucas.add(all_prey.get(0));

                    //Limit top speed of second prey and check speciation blip

                    // Exit the loop
                    //break;
                }
            }
        }
        // If there is a new species to be added
        if(new_lucas.size() > 0 && new_spec != null)
        {
            // Loop through the new Luca instances
            for(Luca l : new_lucas)
            {
                // If the Luca instance is a predator,
                if(l instanceof Predator)
                {
                    // Skip it
                    continue;
                }
                // Remove the Luca from its old species
                l.spec.all_in_species.remove(l);
                // Assign it the new species
                l.spec = new_spec;
                // And add it to it
                new_spec.all_in_species.add(l);
            }
        }
        // Second loop: Check if any Luca instances should be removed or need to be added to a species
        // Create iterator for the new species arraylist
        it = b.iterator();

        // While there is another species to run
        while(it.hasNext())
        {
            // Get the next species
            Species s = it.next();
            // If the species has no members
            if(s.all_in_species.size() == 0)
            {
                // Remove the species
                it.remove();
                // Set the species to null
                s = null;
            }
        }
        // If there is a new species to be added
        if(new_spec != null)
        {
            // Add the new species to the biome
            b.add(new_spec);
            // Run the new species
            new_spec.run();
        }
        // Reset new_spec to null
        new_spec = null;

        // Boolean to check if a new predator has been added (if they all die, add a new one)
        boolean spawn_pred = true;
        // Loop through the species
        for(Species s: b)
        {
            // If the species is not null and the first member is a predator
            if(s != null && s.all_in_species.size() != 0 && s.all_in_species.get(0) instanceof Predator)
            {
                // Set the boolean to false
                spawn_pred = false;
            }
        }
        // If a new predator should be added
        if(spawn_pred)
        {
            // Add a new predator to the biome
            b.add(new Species(1));
        }
    }
    /*
    void run()
    {
        // First loop: Check if a species should be split
        // Create iterator for the species arraylist    
        //Iterator<Species> it = b.iterator();
        // While there is another species to run
        //while(it.hasNext())
        for(Species s: b)
        {
            // Get the next species
            //Species s = it.next();
            // Run the species
            s.run();
            // If the species has at least one member and does not consist of predators
            if(s.all_in_species.size() > 0 && !(s.all_in_species.get(0) instanceof Predator))
            {
                // If there are less than three species in the biome and at least one prey
                if(e.biome.b.size() < 3 && all_prey.size() > 0)
                {
                    // Split one species into two
                    new_spec = s.speciate(all_prey.get(0));
                    // Add the new species to the biome
                    new_lucas.add(all_prey.get(0));
                    // Exit the loop
                    break;
                }
            }
        }
        // If there is a new species to be added
        if(new_lucas.size() > 0 && new_spec != null)
        {
            // Loop through the new Luca instances
            for(Luca l : new_lucas)
            {
                // If the Luca instance is a predator,
                if(l instanceof Predator)
                {
                    // Skip it
                    continue;
                }
                // Remove the Luca from its old species
                l.spec.all_in_species.remove(l);
                // Assign it a new species
                l.spec = new_spec;
                // And add it to it
                new_spec.all_in_species.add(l);
            }
        }
        // Second loop: Check if any Luca instances should be removed or need to be added to a species
        // Create iterator for the new species arraylist
        //Iterator<Species> it2 = b.iterator();
        // Create an arraylist of Species to be removed
        ArrayList<Species> to_remove = new ArrayList<Species>();
        // While there is another species to run
        //while(it2.hasNext())
        for(Species s: b)
        {
            // Get the next species
            //Species s = it2.next();
            // If the species has no members
            if(s.all_in_species.size() == 0)
            {
                // Remove the species
                //it2.remove();
                // Add the species to the to_remove arraylist
                to_remove.add(s);
                // Remove the species
                //b.remove(s);
                // Set the species to null
                //s = null;
            }
        }
        // For each species in the to_remove arraylist
        for(Species s: to_remove)
        {
            // Remove the species
            b.remove(s);
        }
        // If there is a new species to be added
        if(new_spec != null)
        {
            // Add the new species to the biome
            b.add(new_spec);
            // Run the new species
            new_spec.run();
        }
        // Reset new_spec to null
        new_spec = null;
        // Boolean to check if a new predator has been added (if they all die, add a new one)
        boolean spawn_pred = true;
        // Loop through the species
        for(Species s: b)
        {
            // If the species is not null and the first member is a predator
            if(s != null && s.all_in_species.size() != 0 && s.all_in_species.get(0) instanceof Predator)
            {
                // Set the boolean to false
                spawn_pred = false;
            }
        }
        // If a new predator should be added
        if(spawn_pred)
        {
            // Add a new predator to the biome
            b.add(new Species(1));
        }
    }
    */
}