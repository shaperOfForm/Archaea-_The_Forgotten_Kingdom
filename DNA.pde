class DNA
{
    float[] genes;
    DNA()
    {
        this.genes = new float[10];
        for(int i = 0; i < this.genes.length; i++)
        {
            this.genes[i] = random(0, 1);
        }
    }

    DNA(float[] newgenes)
    {
        this.genes = new float[newgenes.length];
        for(int i = 0; i < newgenes.length; i++)
        {
            this.genes[i] = newgenes[i];
        }
    }
    
    DNA copy()
    {
        float[] newgenes = new float[this.genes.length];
        for(int i = 0; i < this.genes.length; i++)
        {
            newgenes[i] = this.genes[i];
        }
        return new DNA(newgenes);
    }
}