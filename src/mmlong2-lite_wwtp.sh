#!/usr/bin/env bash
# DESCRIPTION: Wrapper script for running mmlong2-lite Snakemake workflow, based on mmlong2-lite script

#-----------------------------------------------------------
# Run the following to run this script:
#   conda activate snakemake
#   srun -A chsi -p chsi -c10 --mem 20G ./mmlong2-lite.sh 
#-----------------------------------------------------------

# Pre-set default settings
SCRIPT_DIR="$(dirname "$(realpath "$0")")" # capture the path of this script
set -eo pipefail
set -u

#-----------------------------------------------------------
FASTQ_FILE="/work/josh/mmlong_data/wwtp_gridion_104/ERR7256374.fastq.gz"
SAMPLE="wwtp_104" # Look into "workdir" snakemake config <https://stackoverflow.com/a/40997767>
NUM_THREADS=80
MEM_MB=600000
MEDAKA_MODEL="r104_e81_sup_g5015" # Just guessing on the model, the paper doesn't say whether it is fast/hac/sup or guppy version
# srun -A chsi -p chsi  singularity exec oras://gitlab-registry.oit.duke.edu/granek-lab/granek-container-images/mmlong2/mmlong-polishing-simage:latest  medaka tools list_models
WORKDIR="/work/josh/mmlong_output"
DB_DIR="/work/josh/mmlong_db"

# https://pubmed.ncbi.nlm.nih.gov/35789207/
# The generated raw Nanopore data were basecalled in super-accurate mode using Guppy v. 5.0.16 with the dna_r9.4.1_450bps_sup.cfg model for R9.4.1 and the dna_r10.4_e8.1_sup.cfg model for R10.4 chemistry. 
# Given that the R10.4 data were observed to feature concatemeric reads that might complicate the metagenome assembly step, 
# the concatemers in R10.4 data were split by using the split_on_adapter command (five iterations) of 
# duplex-tools v. 0.2.5 (https://github.com/nanoporetech/duplex-tools). 
# Adapters for Nanopore reads were removed using Porechop v. 0.2.3 (ref. 30), 
# and reads with a lower length than 200 bp and a Phred quality score below 7 and 10 for R9.4.1 and R10.4 reads, respectively, were removed using NanoFilt v. 2.6.0 (ref. 31)

#-----------------------------------------------------------
FASTQ_DIR=$(dirname $FASTQ_FILE)
mkdir -p ${DB_DIR}
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
mkdir -p $WORKDIR; cd $WORKDIR

snakemake \
    --slurm --default-resources slurm_account=chsi slurm_partition=chsi mem_mb=${MEM_MB} cpus_per_task=${NUM_THREADS} --jobs 30 \
    --latency-wait 15 \
    --cores ${SLURM_CPUS_PER_TASK} \
    --nolock \
    --use-singularity \
    --singularity-args "--bind ${FASTQ_DIR},${DB_DIR}" \
    -s ${SCRIPT_DIR}/mmlong2-lite.smk \
    --configfile ${SCRIPT_DIR}/mmlong2-lite-config.yaml \
    -R $RULE \
    --until $RULE \
    --config \
    dbdir=$DB_DIR \
    sample=$SAMPLE \
    fastq=$FASTQ_FILE \
    proc=$NUM_THREADS \
    medak_mod_pol=$MEDAKA_MODEL\
    mode=$mode reads_diffcov=$cov flye_ovlp=$flye_ovlp flye_cov=$flye_cov min_contig_len=$min_contig_len min_mag_len=$min_mag_len semibin_mod=$semibin_mod $extra

#    workdir=$WORKDIR \

# sing=$sing  
exit 0
