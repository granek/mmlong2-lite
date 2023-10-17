OUTDIR="/work/josh/mmlong_data/zymo_promion_104"
RUN_ID="ERR7287988"
srun --pty -A chsi -p chsi -c80 --mem 500G singularity exec --bind /work/josh docker://quay.io/biocontainers/sra-tools:3.0.8--h9f5acd7_0 fasterq-dump --format fastq --threads 80 --progress --split-files --outdir $OUTDIR $RUN_ID
cd $OUTDIR
srun -A chsi -p chsi -c40 --mem 300G pigz --processes 40 ${RUN_ID}.fastq

#-------------------------

OUTDIR="/work/josh/mmlong_data/wwtp_gridion_104"
RUN_ID="ERR7256374"
srun --pty -A chsi -p chsi -c80 --mem 500G singularity exec --bind /work/josh docker://quay.io/biocontainers/sra-tools:3.0.8--h9f5acd7_0 fasterq-dump --format fastq --threads 80 --progress --split-files --outdir $OUTDIR $RUN_ID
cd $OUTDIR
srun -A chsi -p chsi -c40 --mem 300G pigz --processes 40 ${RUN_ID}.fastq
