A Fast Synthesis Method for Wideband Polarization Reconfigurable Arrays Based on Cluster Entropy Model

This repository provides a MATLAB implementation of a cluster-entropy-based optimization method for synthesizing the polarization-state distribution of large-scale wideband polarization reconfigurable arrays (PRAs).

The code formulates the polarization allocation problem as a binary mixed-integer optimization problem, where multi-scale local windows are used to suppress local clustering of identical polarization states. The optimization is implemented in YALMIP and solved by Gurobi.

Required toolboxes / solvers
YALMIP：Used for modeling binary optimization variables and constraints.
Gurobi：Used as the MILP solver backend.
epository structure

A typical project structure can be:

.
├── main_cluster_entropy_64x64.m
├── tiling_countsets_xy.m
├── figures/
│   └── polarization_distribution_64x64.png
└── README.md
File description
clusterentropymodel6464.m:   Main optimization script for the 64×64 PRA polarization-state synthesis.
tiling_countsets2.m:   Generate the multi-scale tiling window sets and corresponding linear index lists.
R_calcu:   Calculate the autocorrelation functions for a given polarization-state map


the optimization summary:

Set parameter MIPGap to value 0.01
Set parameter NodefileDir to value ""
Set parameter NLPHeur to value 1
Set parameter TuneTimeLimit to value 0
Gurobi Optimizer version 13.0.1 build v13.0.1rc0 (win64 - Windows 11+.0 (26200.2))

CPU model: 12th Gen Intel(R) Core(TM) i7-12700, instruction set [SSE2|AVX|AVX2]
Thread count: 12 physical cores, 20 logical processors, using up to 20 threads

Non-default parameters:
MIPGap  0.01
NLPHeur  1
TuneTimeLimit  0

Optimize a model with 2722 rows, 21840 columns and 58704 nonzeros (Min)
Model fingerprint: 0x828051ec
Model has 15024 linear objective coefficients
Variable types: 0 continuous, 21840 integer (21840 binary)
Coefficient statistics:
  Matrix range     [2e-04, 3e+02]
  Objective range  [6e-03, 5e-01]
  Bounds range     [1e+00, 1e+00]
  RHS range        [5e-01, 1e+00]

Presolve removed 0 rows and 4432 columns
Presolve time: 0.04s
Presolved: 2722 rows, 17408 columns, 38912 nonzeros
Variable types: 0 continuous, 17408 integer (16384 binary)
Found heuristic solution: objective -0.4209333

Root relaxation: objective -6.801231e+02, 3101 iterations, 0.02 seconds (0.04 work units)

    Nodes    |    Current Node    |     Objective Bounds      |     Work
 Expl Unexpl |  Obj  Depth IntInf | Incumbent    BestBd   Gap | It/Node Time

     0     0 -680.12309    0    9   -0.42093 -680.12309      -     -    0s
H    0     0                    -680.1202024 -680.12309  0.00%     -    0s

Explored 1 nodes (3101 simplex iterations) in 0.13 seconds (0.14 work units)
Thread count was 20 (of 20 available processors)

Solution count 2: -680.12 -0.420933 

Optimal solution found (tolerance 1.00e-02)
Best objective -6.801202023597e+02, best bound -6.801230872163e+02, gap 0.0004%
Total elapsed MATLAB time: 2.39 s

Model size: 2722 rows, 21840 columns
Binary variables: 21840
Best objective: -680.1202023597
Relative gap: 0.0004%
Gurobi solve time: 0.13 s
Total elapsed MATLAB time: 2.39 s