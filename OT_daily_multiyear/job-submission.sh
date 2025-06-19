#!/bin/bash

#SBATCH -J OT-daily-multiyear-job-attempt-1
#SBATCH -c 1
#SBATCH -o OT-daily-multiyear-job-attempt-1.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=dan.grose@lancaster.ac.uk
#SBACH -w bayes
srun Rscript analysis_multiyear.R

