#!/usr/bin/env bash
# DESCRIPTION: Wrapper script for running mmlong2-lite Snakemake workflow, based on mmlong2-lite script

#-----------------------------------------------------------
# Run the following to run this script:
#   conda activate snakemake
#   srun -A chsi -p chsi -c10 --mem 20G ./mmlong2-lite.sh 
#-----------------------------------------------------------

# Pre-set default settings
set -eo pipefail
set -u

#-----------------------------------------------------------
FASTQ_FILE="/work/josh/joebrown_soil/results_0/fastq_dir/jb_soil.fastq.gz"
SAMPLE="JB_SOIL" # Look into "workdir" snakemake config <https://stackoverflow.com/a/40997767>
NUM_THREADS=40
MEDAKA_MODEL="r941_e81_sup_g514" # medak_mod_pol=r1041_e82_400bps_sup_v4.2.0
#-----------------------------------------------------------
FASTQ_DIR=$(dirname $FASTQ_FILE)
#-----------------------------------------------------------
mode=Nanopore-simplex
cov="none"
flye_cov=3
flye_ovlp=0
minimap_ram=50
minimap_ref=10
min_contig_len=3000
max_contig_con=18
inc_contig_len=120000
min_mag_len=250000
medaka_split=20
semibin_mod=global
semibin_prot=prodigal
np_map_ident=90
pb_map_ident=97
il_map_ident=97
min_compl_1=90
min_compl_2=50
min_compl_3=50
min_compl_4=50
min_cont_1=5
min_cont_2=10
min_cont_3=10
min_cont_4=10
das_tool_score_1=0.5
das_tool_score_2=0.5
das_tool_score_3=0
stage="OFF"
stages=("OFF" "assembly" "polishing")
RULE="Finalise"
extra=""
#-----------------------------------------------------------
# mamba activate snakemake
# conda shell.bash activate snakemake

snakemake \
    --slurm --default-resources slurm_account=chsi slurm_partition=chsi mem_mb=400000 cpus_per_task=${NUM_THREADS} --jobs 30 \
    --cores 1 \
    --nolock \
    --use-singularity \
    --singularity-args "--bind $FASTQ_DIR" \
    -s mmlong2-lite.smk \
    --configfile mmlong2-lite-config.yaml \
    -R $RULE \
    --until $RULE \
    --config \
    sample=$SAMPLE \
    fastq=$FASTQ_FILE \
    proc=$NUM_THREADS \
    medak_mod_pol=$MEDAKA_MODEL\
    mode=$mode reads_diffcov=$cov flye_ovlp=$flye_ovlp flye_cov=$flye_cov min_contig_len=$min_contig_len min_mag_len=$min_mag_len semibin_mod=$semibin_mod $extra

# sing=$sing  
exit 0
