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
# Description: simulate long reads and test the performance of different de novo assemblers on the simulated data of HiFi data
# Author: Paula Uittenbogaard
# Date: 29-04-2025

# To run this pipeline, run 'conda activate simulation', 
# followed by 'snakemake -s 0_simulation_pipeline_HiFi.smk --config-file config.yaml --cores 20 --resources mem_mb=100'
# set -j 1 (1 job at a time) when producing ccs reads, the pbccs package doesn't support to set a temp-dir so all jobs will write to the same temp dir if not set. 

####################################
## CONFIG FILE SETTING
####################################
RUN_DIR = config['rundir']
targets = config['targets']
SEED = config['seed']
METHOD = config['method'] #Check if this is set to HiFi!
readlengths = config['readlengths']
depths = config['depths']
accuracies = config['accuracies']
assemblers = ['hifiasm','lja','hicanu','mbg','hiflye']

##############################
## Setting output directories
##############################
out_dir = os.path.abspath(RUN_DIR + "/simulation_output_3/HiFi")
pbsim_dir = f"{out_dir}/PBSIM3/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
ccs_dir = f"{out_dir}/ccs/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
hifiasm_dir = f"{out_dir}/hifiasm/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
hicanu_dir = f"{out_dir}/hicanu/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
hiflye_dir = f"{out_dir}/hiflye/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
lja_dir = f"{out_dir}/lja/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
mbg_dir = f"{out_dir}/mbg/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}"
alignment_dir = f"{out_dir}/{{ASSEMBLERS}}/{{TARGETS}}/ac{{ACCURACY}}/rl{{READLENGTH}}/de{{DEPTH}}/minimap2"

#######################
## Setting parameters
#######################
ERRMODEL = "/home/uitte01p/experimental/test_for_sim_study/test_PBSIM3/pbsim3/data/ERRHMM-RSII.model"
prefix = f"{METHOD}_ac{{ACCURACY}}_rl{{READLENGTH}}_de{{DEPTH}}"

##################
## Target rules
##################

rule all:
    input:
        expand([##path to the simulated reads produced by PBSIM3:
            f"{pbsim_dir}/{prefix}_0001.bam",
            ##path to the hifi reads produced by ccs and their alignment to ref:
            f"{ccs_dir}/{prefix}.fastq.gz",
            f"{ccs_dir}/{prefix}.bam",
            f"{ccs_dir}/{prefix}.bam.bai",
            ##path to the assembly produced by hifiasm:
            f"{hifiasm_dir}/{prefix}.contigs.fasta",
            ##path to the assembly produced by lja:
            f"{lja_dir}/{prefix}.contigs.fasta",
            ##path to the assembly produced by hicanu:
            f"{hicanu_dir}/{prefix}.contigs.fasta",
            ##path to the assembly produced by mbg:
            f"{mbg_dir}/{prefix}.contigs.fasta",
            ##path to the assembly produced by hiflye:
            f"{hiflye_dir}/{prefix}.contigs.fasta",
            ##paths to all alignments to ref:
            f"{alignment_dir}/{prefix}.contigs.bam",
            f"{alignment_dir}/{prefix}.contigs.bam.bai",
            f"{alignment_dir}/{prefix}.contigs.stats"],
            TARGETS = targets, 
            READLENGTH = readlengths, 
            DEPTH = depths,
            ACCURACY = accuracies,
            ASSEMBLERS = assemblers)

##############
## Load rules
##############

include: "1_3_PBSIM3_PacBio.smk"
include: "1_4_CCS.smk"
include: "2_6_hifiasm.smk"
include: "2_7_lja.smk"
include: "2_8_hicanu.smk"
include: "2_9_mbg.smk"
include: "2_10_hiflye.smk"
include: "3_1_alignments.smk"