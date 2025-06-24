#  ////////*                                              
#         *///////////                                    
# //////////*   ////////////                              
#           ,/////////////////                            
# /////////////////////////////    ./////                 
#            //////////////////   ////// .///             
#     *///////////////////////// .//////.     ///         
#                 //////////////.  */////,*////  .//      
#                   /////////////.     ,/////  ,///* //   
#                     /////////////       /////      ,/*, 
#                      .//////////////.  ///////          
#                         //////////////////////          
#                             ,/////,*/////////           
#                               //////////////            
#                            ///////////////              
#                           /////////////                 
#                         ,/////////*                     
#                    .////////.                           

# This SnakeMake file contains the main rule that organizes rules
# Project: longread simulation study
# Description: simulate long reads and test the performance of different de novo assemblers on the simulated data of ONT (HQ) data
# Author: Paula Uittenbogaard
# Date: 20-02-2025

# To run this pipeline, run 'conda activate simulation', 
# followed by 'snakemake -s 0_simulation_pipeline_ONT.smk --config-file config.yaml' 
# snakemake -s 0_simulation_pipeline_ONT.smk --configfile config.yaml --cores 20 --resources mem_mb=100

####################################
## CONFIG FILE SETTING
####################################
RUN_DIR = config['rundir']
targets = config['targets']
SEED = config['seed']
METHOD = config['method'] #Check if this is set to ONT!
readlengths = config['readlengths']
depths = config['depths']
accuracies = config['accuracies']
assemblers = ['canu','miniasm','flye','raven','wtdbg2']

##############################
## Setting output directories
##############################
out_dir = os.path.abspath(RUN_DIR + "/simulation_output/ONT/")
pbsim_dir = f"{out_dir}/PBSIM3/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
canu_dir = f"{out_dir}/canu/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
flye_dir = f"{out_dir}/flye/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
miniasm_dir = f"{out_dir}/miniasm/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
raven_dir = f"{out_dir}/raven/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
wtdbg2_dir = f"{out_dir}/wtdbg2/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
alignment_dir = f"{out_dir}/{{ASSEMBLERS}}/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}/minimap2"

#######################
## Setting parameters
#######################
ERRMODEL = "/home/uitte01p/experimental/test_for_sim_study/test_PBSIM3/pbsim3/data/ERRHMM-ONT-HQ.model"
prefix = f"{METHOD}_ac{{ACCURACY}}_rl{{READLENGTH}}_de{{DEPTH}}"

##################
## Target rules
##################

rule all:
    input:
        expand([##path to the simulated reads produced by PBSIM3:
            f"{pbsim_dir}/{prefix}_0001.fq.gz",
            ##path to the alignment of reads to ref:
            f"{pbsim_dir}/{prefix}_0001.bam",
            f"{pbsim_dir}/{prefix}_0001.bam.bai",
            ##path to the assembled output of canu:
            f"{canu_dir}/{prefix}.contigs.fasta",
            ##path to the assembled output of flye:
            f"{flye_dir}/{prefix}.contigs.fasta",
            ##path to the assembled output of miniasm:
            f"{miniasm_dir}/{prefix}.contigs.fasta",
            ##path to the assembled output of raven:
            f"{raven_dir}/{prefix}.contigs.fasta",
            ##path to the assembled output of wtdbg2:
            f"{wtdbg2_dir}/{prefix}.contigs.fasta",
            ##paths to all alignments to ref:
            f"{alignment_dir}/{prefix}.contigs.bam",
            f"{alignment_dir}/{prefix}.contigs.bam.bai",
            f"{alignment_dir}/{prefix}.contigs.stats"],
            TARGETS = targets, 
            READLENGTH = readlengths,
            ASSEMBLERS = assemblers,
            ACCURACY = accuracies, 
            DEPTH = depths)

##############
## Load rules
##############

#include: "1_1_Sim_it.smk"
include: "1_2_PBSIM3.smk"
include: "2_1_canu.smk"
include: "2_2_flye.smk"
include: "2_3_miniasm.smk"
include: "2_4_raven.smk"
include: "2_5_wtdbg2.smk"
include: "3_1_alignments.smk"