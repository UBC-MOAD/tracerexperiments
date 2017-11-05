#!/bin/bash

#SBATCH --job-name=glueDiagnostics_LOWESTBFrun12  
#SBATCH --ntasks=1 
#SBATCH --mem=100Gb
#SBATCH --time=02:00:00
#SBATCH --mail-user=kramosmu@eos.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --account=def-allen


module load netcdf-mpi/4.4.1.1
module load netcdf-fortran-mpi/4.4.4
module load python/2.7.13 


cd /scratch/kramosmu/MITgcm/tracerexperiments/LOWEST_BF_run12

echo "Current working directory is `pwd`"

echo "Diagnostics combining"
bash $PROJECT/kramosmu/MITgcm/utils/scripts/glueDiagnostics.sh
bash $PROJECT/kramosmu/MITgcm/utils/scripts/deflateDiagnostics.sh
echo "done combining and deflating diagnostics"
