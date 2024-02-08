# Archaea
 Virtual Ecosystem Simulation

1. Problem Description  

1.1 Business Context and Goals 

General Description:
I am working on a project called “Archaea: The Forgotten Kingdom”. This is on-campus at SUNY New Paltz, under the supervision of Prof. Michael Curry. I will be using The Nature of Code by Daniel Shiffman, in building the world. I am the sole contributor to the project, aside from Prof. Curry’s advisement. This educational simulation promotes awareness of major theories in the fields of Population Biology, Microbiology and Evolutionary Studies and demonstrates the applicability of Computer Science to the natural world.

Project Description:
I am working with Prof. Curry on creating a 2D virtual microbiological ecosystem simulator called “Archaea: The Forgotten Kingdom”, using Java Processing. The Nature of Code by Daniel Shiffman and the fisica library (a wrapper of Box2D) will be used to build the world. It will contain a genetic algorithm and simulate the natural variation between species and between individuals of the same species. This is a large project with various tasks and sub-projects. 
 
Archaea will simulate, track, and display aspects of life on a microbiological scale. The cells, or LUCAs (“Last Universal Common Ancestor”) will start off extremely simple in terms of the traits and behaviors, and progressively complexify as they adapt, mutate new traits, and are acted upon by environmental pressures. Simulating an environment with finite resources will drive competition to procure those resources, survive in the environment, and reproduce, causing the LUCAs to adapt and change over time. Archaea will be at the intersection of two foundational sciences: Computer Science and Biology—technology and life. Archaea bridges the gap. 
 
It is for anyone interested in seeing how environmental factors, when paired with a genetic algorithm, can have a profound impact on a population of inhabitants; or in how the natural world can be simulated with computers, by simply programming an environment, agents, and the rules and functions of both. This educational software can be used by teachers and students alike, to illustrate concepts from class. Evolution explains much about the natural world, and Archaea aims to illustrate those explanations. Users will be able to pause the simulation, change its speed, and save a species for use in other simulations.  
 
To occur, evolution by natural selection requires three conditions to exist in a closed system: phenotypic variation1, heredity2, and differential survivability3. Archaea aims to simulate an environment with these conditions built in. The genetic algorithm will provide the variation of traits and behaviors1 as well as the inheritance of those traits and behaviors2. It will aim to allow for as many types of variation as possible between generations. These variations along with the rules of the simulation, will naturally result in some individuals surviving longer than others3, giving them a better chance of living long enough to replicate. This, in turn, determines which of these variations will thrive in the environment, and ultimately, the fate of the species. 
 
In building this world with these conditions in place, we can illustrate how natural selection occurs ‘naturally’ under these circumstances, as well as how other mechanisms of evolution act on a system—speciation, mutation, gene flow, genetic drift, altruism, and selective pressures such as predation, resource availability, and intra- and inter-specific competition. By laying out the rules for life in the ecosystem, founded on the three key principles, we can simulate evolution, a process that can take millions of years to take place, in a short amount of time. In this way, this revolutionary, evolutionary, educational software aims to help people visualize a process that no human could ever before observe with their own eyes. By setting the stage for evolutionary processes, Archaea demonstrates and visualizes how such a system can result in remarkably interesting patterns among and between species, while also demonstrating “the nature of code.” 


USERS: the users of the program would be science teachers, students, professors, enthusiasts, and anyone interested in observing evolutionary processes act upon a closed system over time and the resulting variation; as well as anyone interested in how computer programs can be modeled after the natural world.

When & Where can the users use this ? 
The program can be accessed online. The simulation is free-to-use. If the user wishes to save their species for later use and/or access other possible member-only features, they can sign up for the premium membership.

Functionalities: What can the software do ? 
The program will start by asking the user to set the initial conditions. The simulation will begin, using these input parameters to initialize the world. The cells will be programmed with needs, and priorities in terms of which needs need to be met at any given time. Their traits and behaviors will start out very basic, and they will gradually change as time goes on and they mutate and adapt to the environment. As two simulations will never play out exactly the same, users will basically be culturing their own petri dish, with a front row seat to observe from. Users can save a species for use in future simulations. This educational software can be used by teachers, students, and anyone interested in seeing concepts of population biology in action and learning something in the process. Evolution explains much about the natural world, and Archaea aims to illustrate those explanations. Users will be able to pause the simulation, speed it up to skip generations, or slow it down so they don’t miss a thing.  

+ “BUSINESS” PROBLEM/GOALS (in the context of the given business situations):

Components/hardware: display, mouse and keyboard inputs.

List of transactions, operations, interactions:

o	Set the initial conditions (number of cells, number of species, etc.)
Input = keyboard
Output = “Creating World…” message, initialize world 

o	Change the speed of the simulation (x0, x0.5, x2, x4, x8, …)
Input = mouse. Buttons in top-right of screen
Output = void: updates speed

o	Save a species
Input = mouse. Button appears in the middle of the screen when the simulation is paused.
Output = “Save successful!” message, save species

o	Load a species
Input = mouse. Button appears when setting initial conditions
Output = “Load successful!” message, load species

o	(Time permitting) View phylogenetic tree and other analytical data.
Input = mouse. Button in top-right of screen
Output = void, switch to phylogeny mode
