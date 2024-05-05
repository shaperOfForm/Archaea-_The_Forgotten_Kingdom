class Biome
{
    ArrayList<Species> b;
    ArrayList<Species> new_species = new ArrayList<Species>();

    Biome()
    {
        b = new ArrayList<Species>();
    }

    void run()
    {
        Iterator<Species> it = e.biome.b.iterator();
        while(it.hasNext())
        {
            Species s = it.next();
            s.run();
        }
        e.biome.b.addAll(new_species);
        //e.biome.b.run();
        redraw();
    }
}