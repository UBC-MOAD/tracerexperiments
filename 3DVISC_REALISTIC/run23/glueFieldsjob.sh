#!/bin/bash

#SBATCH --job-name=glueFields3DVISC23
#SBATCH --ntasks=1
#SBATCH --mem=100Gb
#SBATCH --time=00:30:00
#SBATCH --mail-user=kramosmu@eos.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --account=def-allen


module load netcdf-mpi/4.4.1.1
module load netcdf-fortran-mpi/4.4.4
module load python/2.7.13                     


cd /scratch/kramosmu/MITgcm/tracerexperiments/3DVISC_REALISTIC_run23

echo "Current working directory is `pwd`"

echo "Fields combining"
bash $PROJECT/kramosmu/MITgcm/utils/scripts/glueFields.sh
bash $PROJECT/kramosmu/MITgcm/utils/scripts/deflateFields.sh
echo "done combining and deflating fields"

