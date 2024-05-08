class Biome
{
    ArrayList<Species> b;
    ArrayList<Luca> new_lucas = new ArrayList<Luca>();
    ArrayList<Luca> to_remove = new ArrayList<Luca>();
    Species new_spec = null;
    
    Biome()
    {
        b = new ArrayList<Species>();
    }

    void run()
    {
        Iterator<Species> it = b.iterator();
        while(it.hasNext())
        {
            Species s = it.next();
            s.run();
            if(s.all_in_species.size() > 0 && !(s.all_in_species.get(0) instanceof Predator))
            {
                if(e.biome.b.size() < 3)
                {
                    new_spec = s.speciate(all_prey.get(0));
                    new_lucas.add(all_prey.get(0));
                    break;
                }
            }
        }
        if(new_lucas.size() > 0 && new_spec != null)
        {
            for(Luca l : new_lucas)
            {
                if(l instanceof Predator)
                {
                    continue;
                }
                l.spec.all_in_species.remove(l);
                l.spec = new_spec;
                new_spec.all_in_species.add(l);
            }
        }
        // Second loop: Check if any Luca instances should be removed
        Iterator<Species> it2 = b.iterator();
        while(it2.hasNext())
        {
            Species s = it2.next();
            if(s.all_in_species.size() == 0)
            {
                it2.remove();
                s = null;
            }
        }

        if(new_spec != null)
        {
            //new_species.all_in_species.addAll(new_lucas);
            b.add(new_spec);
            //new_species = null;
        }
        //e.biome.b.run();
        new_spec = null;
    }
}