#!/bin/bash

#SBATCH --job-name=CNTDIFF53
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=32
#SBATCH --mem=100GB
#SBATCH --time=06:00:00
#SBATCH --mail-user=kramosmu@eos.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --account=def-allen


module load netcdf-mpi/4.4.1.1
module load netcdf-fortran-mpi/4.4.4
module load python


echo "Current working directory is `pwd`"

echo "Starting run at: `date`"
mpirun -np 112 ./mitgcmuv 
echo "Job finished at: `date`"


