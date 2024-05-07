Species new_spec = null;

class Biome
{
    ArrayList<Species> b;
    ArrayList<Luca> new_lucas = new ArrayList<Luca>();
    ArrayList<Luca> to_remove = new ArrayList<Luca>();

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
            if(s.all_in_species.size() > 0  && !(s.all_in_species.get(0) instanceof Predator))
            {
                Species old_species = null;
                Luca min = null;
                Luca max = null;
                boolean larger = false;
                for(Luca luca: s.all_in_species)
                {
                    if(all_prey.size() == 2 && luca.cell_w > 10)
                    {
                    /*
                    if(luca instanceof Predator)
                    {
                        continue;
                    }
                    if(s.width_var > s.width_avg)
                    {
                        speciate = true;
                        for(Species sp: b)
                        {
                            if(sp.width_var > sp.width_avg)
                            {
                                old_species = sp;
                            }
                            else
                            {
                                luca.spec = sp;
                                sp.all_in_species.add(luca);
                                return;
                            }
                        }
                        println("Variance" + s.width_var);
                        println("Square of average" + s.width_avg);
                        for(Luca l2: s.all_in_species)
                        {
                            if(luca.equals(l2))
                            {
                                continue;
                            }
                            if(min == null || l2.cell_w < min.cell_w)
                            {
                                min = l2;
                                larger = false;
                            }
                            if(max == null || l2.cell_w > max.cell_w)
                            {
                                max = l2;
                                larger = true;
                            }
                            
                        }
                        if(max == null || min == null)
                        {
                            continue;
                        }
                        if(max.cell_w - s.width_avg > s.width_avg - min.cell_w)
                        {
                            if(larger)
                            {
                                */
                                new_spec = s.speciate(max);
                                new_lucas.add(max);
                            /*}
                            else
                            {
                                max.spec = old_species;
                                old_species.all_in_species.add(max);
                            }
                        }
                        else
                        {
                            if(!larger)
                            {
                                new_spec = s.speciate(min);
                                new_lucas.add(min);
                            }
                            else
                            {
                                min.spec = old_species;
                                old_species.all_in_species.add(min);
                            }
                        }*/
                        break;
                    }
                    //break;
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