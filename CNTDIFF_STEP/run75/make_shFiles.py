"""Generate sh files needed to submit tracerexperiment runs

Run as make_shFiles.py runname, where runname is a string with the nae of the run as will 
appear on the queue.

The files created are: mitgcm.sh, glueFields.sh, glueDiagnostics.sh

KRM2018
"""
import sys

def main():
    runname = sys.argv[1]
    top, bottom = mitgcm(runname)    
    with open('mitgcm.sh', 'wt') as f:
        f.writelines(top)
        f.writelines(bottom)
    
    first, middle, last = glueFields(runname)
    with open('glueFields.sh', 'wt') as f:
        f.writelines(first)
        f.writelines(middle)
        f.writelines(last)
    
    one, two, three = glueDiagnostics(runname)
    with open('glueDiagnostics.sh', 'wt') as f:
        f.writelines(one)
        f.writelines(two)
        f.writelines(three)

#-----------------------------------------------------

def mitgcm(runname):
    the_egg = """#!/bin/bash
"""
    the_egg += ('#SBATCH --job-name=%s \n' %runname)

    the_bread = """\
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
"""
    return(the_egg, the_bread)

#------------------------------------------------------------

def glueFields(runname):
    the_cheese ="""#!/bin/bash
"""
    the_cheese += ('#SBATCH --job-name=glueFields%s \n' %runname)
    the_meat = """\
#SBATCH --ntasks=1
#SBATCH --mem=100Gb
#SBATCH --time=00:30:00
#SBATCH --mail-user=kramosmu@eos.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --account=def-allen

module load netcdf-mpi/4.4.1.1
module load netcdf-fortran-mpi/4.4.4
module load python/2.7.13
"""

    the_meat += ('cd /scratch/kramosmu/MITgcm/tracerexperiments/%s \n' %runname)
    the_bread = """\
echo "Current working directory is `pwd`"

echo "Fields combining"
bash $PROJECT/kramosmu/MITgcm/utils/scripts/glueFields.sh
bash $PROJECT/kramosmu/MITgcm/utils/scripts/deflateFields.sh
echo "done combining and deflating fields" 
"""
    return(the_cheese, the_meat, the_bread)

#----------------------------------------------------------------------------

def glueDiagnostics(runname):
    the_cheese ="""\
#!/bin/bash
"""
    the_cheese += ('#SBATCH --job-name=glueDiagnostics%s \n' %runname)
    the_meat = """\
#SBATCH --ntasks=1
#SBATCH --mem=100Gb
#SBATCH --time=02:00:00
#SBATCH --mail-user=kramosmu@eos.ubc.ca
#SBATCH --mail-type=ALL
#SBATCH --account=def-allen

module load netcdf-mpi/4.4.1.1
module load netcdf-fortran-mpi/4.4.4
module load python/2.7.13
"""

    the_meat += ('cd /scratch/kramosmu/MITgcm/tracerexperiments/%s \n' %runname)
    the_bread = """\
echo "Current working directory is `pwd`"

echo "Fields combining"
bash $PROJECT/kramosmu/MITgcm/utils/scripts/glueDiagnostics.sh
bash $PROJECT/kramosmu/MITgcm/utils/scripts/deflateDiagnostics.sh
echo "done combining and deflating fields"
"""
    return(the_cheese, the_meat, the_bread)

#-----------------------------------------------------------------------------------


if __name__ == '__main__':
    main()

