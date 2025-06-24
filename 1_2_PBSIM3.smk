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

# This SnakeMake file contains the rule to run PBSIM3
# Project: longread simulation study
# Description: simulate long-reads using PBSIM3. 
#           Vary the readlength, sequencing depth and error rate
# Author: Paula Uittenbogaard
# Date: 20-02-2025

#######################
## Setting directories
#######################
PBSIM3 = "/home/uitte01p/experimental/test_for_sim_study/test_PBSIM3/pbsim3/src/./pbsim"

rule pbsim:
    input: 
        f"{RUN_DIR}/targets/{{TARGETS}}.fasta"
    output:
        f"{RUN_DIR}/{{TARGETS}}/{prefix}_0001.fq.gz",
        f"{RUN_DIR}/{{TARGETS}}/{prefix}_0001.maf.gz",
        f"{RUN_DIR}/{{TARGETS}}/{prefix}_0001.ref"
    log:
        f"{RUN_DIR}/{{TARGETS}}/{prefix}.log"
    params:
        error_model = {ERRMODEL},
        calculated_accuracy=lambda wildcards: [int(item)/100 for item in {wildcards.ACCURACY}]
    shell:
        """
        cd {RUN_DIR}
        {PBSIM3} --seed {SEED} \
                 --strategy wgs \
                 --method errhmm \
                 --errhmm {params.error_model} \
                 --depth {wildcards.DEPTH} \
                 --genome {input} \
                 --accuracy-mean {params.calculated_accuracy} \
                 --length-mean {wildcards.READLENGTH} \
                 --prefix {wildcards.TARGETS}/{METHOD}_ac{wildcards.ACCURACY}_rl{wildcards.READLENGTH}_de{wildcards.DEPTH} \
                 2> {log}
       """
#pars below were used for simulation_output_1 and simulation_output_2
#                 --accuracy-mean 0.981 \
#                 --accuracy-max 0.987 \
#                 --accuracy-min 0.975 \

rule move_output_pbsim:
    input:
        fq = f"{RUN_DIR}/{{TARGETS}}/{prefix}_0001.fq.gz",
        maf = f"{RUN_DIR}/{{TARGETS}}/{prefix}_0001.maf.gz",
        ref = f"{RUN_DIR}/{{TARGETS}}/{prefix}_0001.ref",
        log = f"{RUN_DIR}/{{TARGETS}}/{prefix}.log"
    output:
        fq = f"{pbsim_dir}/{prefix}_0001.fq.gz",
        maf = f"{pbsim_dir}/{prefix}_0001.maf.gz",
        ref = f"{pbsim_dir}/{prefix}_0001.ref",
        log = f"{pbsim_dir}/{prefix}.log"
    shell:
        """
        mv {input.fq} {output.fq}
        mv {input.maf} {output.maf}
        mv {input.ref} {output.ref}
        mv {input.log} {output.log}
        """

rule align_reads_to_ref:
    input:
        fq = f"{pbsim_dir}/{prefix}_0001.fq.gz",
        ref = f"{pbsim_dir}/{prefix}_0001.ref"
    output:
        bam = f"{pbsim_dir}/{prefix}_0001.bam",
        bai = f"{pbsim_dir}/{prefix}_0001.bam.bai"
    params:
        tempdir = f"{pbsim_dir}/alignments/minimap2/"
    log:
        f"{pbsim_dir}/{prefix}_alignments.log"
    shell:
        """
        minimap2 --MD -ax map-ont -t 20 {input.ref} {input.fq} | samtools sort -@ 10 -T {params.tempdir} -O BAM -o {output.bam} - 2> {log}; \
        samtools index {output.bam} 2>> {log}
        """