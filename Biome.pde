class Biome
{
    ArrayList<Species> b;
    ArrayList<Luca> new_lucas = new ArrayList<Luca>();
    ArrayList<Luca> to_remove = new ArrayList<Luca>();

    Biome()
    {
        b = new ArrayList<Species>();
    }

    Species new_species = null;
    void run()
    {
        Iterator<Species> it = b.iterator();
        while(it.hasNext())
        {
            Species s = it.next();
            s.run();
            if(s.all_in_species.size() > 0 && !(s.all_in_species.get(0) instanceof Predator))
            {
                for(Luca luca: s.all_in_species)
                {
                    if(all_prey.size() == 2 && luca.cell_w > 10)
                    {
                        new_species = s.speciate(luca);
                        new_lucas.add(luca);
                        break;
                    }
                }
            }
        }
        if(new_lucas.size() > 0 && new_species != null)
        {
            for(Luca l : new_lucas)
            {
                l.spec.all_in_species.remove(l);
                l.spec = new_species;
                new_species.all_in_species.add(l);
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

        if(new_species != null)
        {
            //new_species.all_in_species.addAll(new_lucas);
            b.add(new_species);
            //new_species = null;
        }
        //e.biome.b.run();
        new_species = null;
    }
}