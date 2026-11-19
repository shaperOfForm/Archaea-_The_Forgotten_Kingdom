# Archaea
Virtual Ecosystem Simulation (unfinished)

## Running the Simulation

Archaea is built using Java and the [Processing](https://processing.org/) framework.

### Prerequisites

- Install [Processing 4](https://processing.org/download) (version 4.4.3 or later recommended for CLI support).
- Ensure Processing is accessible from your terminal (added to your system's PATH).

### Running from the Command Line

1. Open a terminal (PowerShell, Command Prompt, or the integrated terminal in VS Code).
2. Navigate to the folder containing the Processing sketch (`.pde` files).
3. Run the following command:

   ```bash
   processing cli --sketch="$PWD" --run
   ```

   This command launches the sketch using Processing.

   **Note:** `$PWD` works in PowerShell and Unix-like shells. In Windows Command Prompt (`cmd.exe`), use `%CD%` instead:

   ```cmd
   processing cli --sketch="%CD%" --run
   ```

### Running with Visual Studio Code (Optional)

You can also develop and run Archaea using [Visual Studio Code](https://code.visualstudio.com/) with a Processing extension.

1. Install Visual Studio Code.
2. Open the **Extensions** panel (`Ctrl+Shift+X`).
3. Search for and install a Processing extension that supports Java-based Processing sketches.
4. Open the Archaea project folder in VS Code.
5. Use the extension's run functionality, if supported, or execute the following command in VS Code's integrated terminal:

   ```powershell
   processing cli --sketch="$PWD" --run
   ```

**Note:** The Processing application is still required to provide the Processing runtime. Installing a VS Code extension alone does not replace it.

### Running with the Processing IDE

1. Open Processing.
2. Select **File → Open** and locate the main `.pde` file.
3. Click the **Run** button (▶) to launch the simulation.

### Troubleshooting

If the terminal reports that `processing` is not recognized:

- Verify that Processing 4.4.3 or later is installed.
- Ensure the Processing executable's directory is included in your system's PATH.
- Restart your terminal after updating PATH.

If the sketch fails to launch, verify that you're running the command from the sketch's root directory and that the main `.pde` file has the same name as its enclosing folder.


## General Description

This educational simulation promotes awareness of major theories in the fields of Population Biology, Microbiology and Evolutionary Studies and demonstrates the applicability of Computer Science to the natural world. It contains a genetic algorithm (that plays out in front of your eyes) and simulates the natural variation between species and between individuals of the same species.

Archaea simulates, tracks, and displays aspects of life on a microbiological scale. The cells, or LUCAs (“Last Universal Common Ancestor”) will start off extremely simple in terms of traits and behaviors, and progressively complexify as they adapt, mutate new traits, and are acted upon by environmental pressures. Simulating an environment with finite resources drives competition to procure those resources, survive in the environment, and reproduce, causing the LUCAs to adapt and change over time. The cells are programmed with needs, and priorities in terms of which needs need to be met at any given time. As two simulations will never play out exactly the same, users will basically be culturing their own petri dish, with a front row seat to observe from.

In building this world with these conditions in place, we can illustrate how natural selection occurs ‘naturally’ under these circumstances, as well as how other mechanisms of evolution act on a system—speciation, mutation, gene flow, genetic drift, altruism, and selective pressures such as predation, resource availability, and intra- and inter-specific competition. In this way, this revolutionary, evolutionary, educational software aims to help people visualize a process that no human could ever before observe with their own eyes. By setting the stage for evolutionary processes, Archaea demonstrates and visualizes how such a system can result in remarkably interesting patterns among and between species, while also demonstrating “the nature of code.”

To occur, evolution by natural selection requires three conditions to exist in a closed system: (1) phenotypic variation, (2) heredity, and (3) differential survivability. Archaea aims to simulate an environment with these conditions built in. The genetic algorithm will provide the (1) variation of traits and behaviors as well as the (2) inheritance of those traits and behaviors. It will aim to allow for as many types of variation as possible between generations. These variations, along with the rules of the simulation, will naturally result in (3) some individuals surviving longer than others, giving them a better chance of living long enough to replicate. This, in turn, determines which of these variations will thrive in the environment, and ultimately, the fate of the species.

This is for anyone interested in seeing how environmental factors, when paired with a genetic algorithm, can have a profound impact on a population of inhabitants; or in how the natural world can be simulated with computers, by simply programming an environment, agents, and the rules and functions of both. Users are able to pause the simulation, change its speed, and skip generations. In later updates they will be able to save a species for use in other simulations and there will be a visual phylogenetic tree available to view after each run.