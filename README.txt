*Advanced Sensitivity analysis for Balmorel introduced by Juan Gea-Bermudez in January 2020

This file describes how to perform:
- Global Sensitivity Analysis with Morris Screening
- Uncertainty simulation with Montecarlo

In order to perform any simulation, we need to place the folder "sensitivity_analysis" inside the balmorel folder (next to simex and base).

1. Global Sensitivity Analysis with Morris Screening (morris_screening folder)
Step 1: Generation of scenarios (scenario_creation folder)
        - Update the uncertainty data in the file "input_morris.csv" which is in the input folder (do not change the order of the columns!).
        - Inside the file "morrissampling.m", modify the parameters "p" (number of levels), and "r" (number of repetitions) to modify how many scenarios are created as well as the possible values that the parameters will take 
	- Run "Morris_scenario_creation.m". A file called "MorrisSampling_rXXXX_pXXX.mat" will be created automatically in the output folder. Save this file for later use.
        - Create an excel file called "MorrisSampling.xlsx" in /morris_screening/scenario_creation/output, and create a matrix following this example (Use the values Xval just created by MATLAB inside the file ""MorrisSampling_rXXXX_pXXX.mat" and make sure to use the right header in the columns) 
                       Parameter1          Parameter2            Parameter3    (ETC ETC)
          Scenario1      50                     1                    1000
          Scenario2      48.4                   1                    1000
          Scenario3      48.4                   2                    1000   
          (ETC ETC)
        - Additional note: the graphs are not activated by default since it takes time to generate them

Step 2: Perform simulations in Balmorel
        - Make sure that the project directory is in "base/model/" (the typical one in Balmorel)
        - Check that all the .inc files and the main file "Balmorel_Morris_screening.gms" in the folder "morris_screening" so they are consinstent with the parameters that we are going to modify 
        - Update (if needed) the set scenariosrunning and execute "Balmorel_Morris_screening.gms"

Step 3: Output analysis (output_analysis folder)
        - Place the "MorrisSampling_rXXXX_pXXX.mat" file (generatred in Step 1) in "output_analysis/input/", as well as processed output files with the results from the optimizations of Step 2 (for example,
          if you are interested in the average of electricity prices, you can create an excel file with data on the first column, being each row the average price corresponding to each scenario)
        - Check the files "Morris_output_analysis.m" and "computeEEi.m" so they are in line with the amount of output you are interested in plotting (this should be improved in the future)
        - Run "Morris_output_analysis.m" and analyse the graphs obtained



2. Uncertainty simulation with Montecarlo (montecarlo_simulations folder)
Step 1: Generation of scenarios (scenario_creation folder)
        - Update the uncertainty data in the file "input_montecarlo.csv" which is in the input folder (do not change the order of the columns!).
        - Inside the file "Montecarlo_scenario_creation.m", modify the parameter N to define how many scenarios will be created 
	- Run "Montecarlo_scenario_creation.m". A file called "LHS_Sampling_kXXXX_NXXXX.mat" will be created automatically in the output folder. Save this file for possible later use.
        - Create an excel file called "LHS_Sampling.xlsx" in /montecarlo_simulations/scenario_creation/output, and create a matrix following this example (Use the values Xval just created by MATLAB inside the file "LHS_Sampling_kXXXX_NXXXX.mat" and make sure to use the right header in the columns) 
                       Parameter1          Parameter2            Parameter3  (ETC ETC)
          Scenario1      10                     1                    1000
          Scenario2      50                     3                    5500
          Scenario3      38                     2                    1500   
          (ETC ETC)
        - Additional note: the graphs are not activated by default since it takes time to generate them

Step 2: Perform simulations in Balmorel
        - Make sure that the project directory is in "base/model/" (the typical one in Balmorel)
        - Check that all the .inc files and the main file "Balmorel_montecarlo.gms" in the folder "montecarlo_simulations" so they are consinstent with the parameters that we are going to modify 
        - Update (if needed) the set scenariosrunning and execute "Balmorel_montecarlo.gms" 

Step 3: Output analysis (output_analysis folder)
        - Place in "output_analysis/input/" the processed output files with the results from the optimizations of Step 2 (for example,
          if you are interested in the average of electricity prices, you can create an excel file with data on the first column, being each row the average price corresponding to each scenario)
        - Modify the file "MonteCarlo.m" as required (there is some inspirational code) so the output can be analysed
        - Run "MonteCarlo.m" and analyse the graphs obtained



Suggestions for the optimizations in GAMS:
- By default CPLEX solvers have the option "advind" activated. This options takes advantage of the previous solution to find the solution of the next scenario "faster". However, this process is only 
  faster if: a) the scenarios do not change to much (as is the case of the scenarios in the Global Sensitivity Analysis created with Morris Screening), and b) if the size of the model is relatively small.
  My experience so far is that with large models, it is more convenient to not activate the "advind" option, and running the barrier method 