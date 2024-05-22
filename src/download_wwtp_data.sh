#!/usr/bin/env bash

# OUTDIR="/work/josh/mmlong_data/zymo_promion_104"
# RUN_ID="ERR7287988"
# srun --pty -A chsi -p chsi -c80 --mem 500G singularity exec --bind /work/josh docker://quay.io/biocontainers/sra-tools:3.0.8--h9f5acd7_0 fasterq-dump --format fastq --threads 80 --progress --split-files --outdir $OUTDIR $RUN_ID
# cd $OUTDIR
# srun -A chsi -p chsi -c40 --mem 300G pigz --processes 40 ${RUN_ID}.fastq

#-------------------------
WORK_DIR="/work/${USER}"
OUTDIR="${WORK_DIR}/mmlong_data/wwtp_gridion_104"
mkdir -p $OUTDIR
RUN_ID="ERR7256374"
THREADS=40

cd $OUTDIR
srun --pty -A chsi -p chsi -c ${THREADS} --mem 200G singularity exec --bind ${WORK_DIR} docker://quay.io/biocontainers/sra-tools:3.0.8--h9f5acd7_0 fasterq-dump --format fastq --threads ${THREADS} --progress --split-files --outdir $OUTDIR $RUN_ID
srun -A chsi -p chsi -c40 --mem 300G pigz --processes 40 ${RUN_ID}.fastq
