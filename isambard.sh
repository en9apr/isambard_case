#!/bin/bash

#PBS -N LHS

# Select 1 nodes (maximum of 64 cores)
#PBS -l select=1:ncpus=6

# Select wall time to 16 hours (as we have doubled number of iterations: 8000 to 15000)
#PBS -l walltime=01:59:59

# Use the arm nodes
#PBS -q arm

# Load modules for currently recommended OpenFOAM v2306 build
module unload PrgEnv-cray
module load PrgEnv-gnu

# Change to directory that script was submitted from
export PBS_O_WORKDIR=$(readlink -f $PBS_O_WORKDIR)
export OMP_NUM_THREADS=1
cd $PBS_O_WORKDIR

# Load the environment variables for OpenFOAM v2306 build
export OPENFOAM_DIR=/home/ex-aroberts/OpenFOAM/OpenFOAM-v2306
export PATH=$PATH:$OPENFOAM_DIR/bin/
source $OPENFOAM_DIR/etc/bashrc

blockMesh > log.blockMesh 2>&1

decomposePar > log.decomposePar 2>&1

aprun -n 6 simpleFoam -parallel > log.simpleFoam 2>&1

reconstructPar -latestTime > log.reconstructPar 2>&1

#------------------------------------------------------------------------------
