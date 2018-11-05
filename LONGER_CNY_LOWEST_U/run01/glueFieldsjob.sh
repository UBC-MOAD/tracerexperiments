#!/bin/bash

#SBATCH --job-name=glueFields_LONGER_CNY_LOWEST_U_01
#SBATCH --ntasks=1
#SBATCH --mem=100Gb
#SBATCH --time=00:30:00
#SBATCH --mail-user=kramosmu@eos.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --account=rrg-allen


module load netcdf-mpi/4.4.1.1
module load netcdf-fortran-mpi/4.4.4
module load python/2.7.13                     


cd /scratch/kramosmu/MITgcm/tracerexperiments/LONGER_CNY_LOWEST_U_run01

echo "Current working directory is `pwd`"

echo "Fields combining"
bash $PROJECT/kramosmu/MITgcm/utils/scripts/glueFields.sh
bash $PROJECT/kramosmu/MITgcm/utils/scripts/deflateFields.sh
echo "done combining and deflating fields"

