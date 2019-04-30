# # build the base container
# sudo singularity build \
#     src/singularity/images/base.sif \
#     src/singularity/recipes/base.def

# # build the base make container
# sudo singularity build \
#     src/singularity/images/base-make.sif \
#     src/singularity/recipes/base-make.def

# # build the base java container
# sudo singularity build \
#     src/singularity/images/base-java.sif \
#     src/singularity/recipes/base-java.def

# build the fastqc container
sudo singularity build \
    src/singularity/images/base-r.sif \
    src/singularity/recipes/base-r.def

# # build the fastqc container
# sudo singularity build \
#     src/singularity/images/fastqc.sif \
#     src/singularity/recipes/fastqc.def

# # build the star container
# sudo singularity build \
#     src/singularity/images/star.sif \
#     src/singularity/recipes/star.def

# # build the multi container
# sudo singularity build \
#     src/singularity/images/multiqc.sif \
#     src/singularity/recipes/multiqc.def

# # build the trimmomatic container
# sudo singularity build \
#     src/singularity/images/trimmomatic.sif \
#     src/singularity/recipes/trimmomatic.def

# # build the seqkit container
# sudo singularity build \
#     src/singularity/images/seqkit.sif \
#     src/singularity/recipes/seqkit.def

