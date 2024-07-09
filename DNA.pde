/**
    * DNA class for the predator and luca
    * Contains the genes of the predator and luca
    * A class to simulate DNA via heredity and random mutation
 */
class DNA
{
    // Array of genes (floats between 0 and 1)
    float[] genes;

    /**
        * Constructor for DNA with random genes
     */
    DNA()
    {
        // Create a new array of 10 random floats between 0 and 1
        this.genes = new float[11];
        for(int i = 0; i < this.genes.length; i++)
        {
            this.genes[i] = random(0, 1);
        }
    }


    /**
        * Constructor for DNA with given genes
        * @param newgenes - the genes to be copied
     */
    DNA(float[] newgenes)
    {
        // Create a new array of the same length as newgenes
        this.genes = new float[newgenes.length];
        // Copy the values of newgenes into this.genes
        for(int i = 0; i < newgenes.length; i++)
        {
            this.genes[i] = newgenes[i];
        }
    }

    /**
        * Method to copy the genes of a DNA object
     */
    DNA copy()
    {   
        // Create a new array of the same length as this.genes
        float[] newgenes = new float[this.genes.length];
        // Copy the values of this.genes into newgenes
        for(int i = 0; i < this.genes.length; i++)
        {
            newgenes[i] = this.genes[i];
        }
        // Return a new DNA object with the newgenes
        return new DNA(newgenes);
    }
}