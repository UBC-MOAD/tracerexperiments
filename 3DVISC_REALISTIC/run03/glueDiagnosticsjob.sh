#!/bin/bash

#SBATCH --job-name=glueDiagnostics_3DVISCreal03  
#SBATCH --ntasks=1 
#SBATCH --mem=100Gb
#SBATCH --time=01:00:00
#SBATCH --mail-user=kramosmu@eos.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --account=rrg-allen


module load netcdf-mpi/4.4.1.1
module load netcdf-fortran-mpi/4.4.4
module load python/2.7.13 


cd /scratch/kramosmu/MITgcm/tracerexperiments/3DVISC_REALISTIC_run03

echo "Current working directory is `pwd`"

echo "Diagnostics combining"
bash $PROJECT/kramosmu/MITgcm/utils/scripts/glueDiagnostics.sh
bash $PROJECT/kramosmu/MITgcm/utils/scripts/deflateDiagnostics.sh
echo "done combining and deflating diagnostics"
