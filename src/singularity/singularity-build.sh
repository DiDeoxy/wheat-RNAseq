# # build the base container
# sudo singularity build \
#     src/singularity/images/base.simg \
#     src/singularity/recipes/base.def

# # build the base make container
# sudo singularity build \
#     src/singularity/images/base-make.simg \
#     src/singularity/recipes/base-make.def

# # build the base java container
# sudo singularity build \
#     src/singularity/images/base-java.simg \
#     src/singularity/recipes/base-java.def

# # build the fastqc container
# sudo singularity build \
#     src/singularity/images/fastqc.simg \
#     src/singularity/recipes/fastqc.def

# # build the fastqc container
# sudo singularity build \
#     src/singularity/images/star.simg \
#     src/singularity/recipes/star.def

# build the fastqc container
sudo singularity build \
    src/singularity/images/multiqc.simg \
    src/singularity/recipes/multiqc.def