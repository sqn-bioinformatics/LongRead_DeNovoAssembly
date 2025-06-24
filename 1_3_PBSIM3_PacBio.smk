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
        f"{RUN_DIR}/{{TARGETS}}/{prefix}_0001.bam",
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
                 --pass-num 10 \
                 --accuracy-mean {params.calculated_accuracy} \
                 --length-mean {wildcards.READLENGTH} \
                 --prefix {wildcards.TARGETS}/{METHOD}_ac{wildcards.ACCURACY}_rl{wildcards.READLENGTH}_de{wildcards.DEPTH} \
                 2> {log}
        """

rule move_output_pbsim:
    input:
        bam = f"{RUN_DIR}/{{TARGETS}}/{prefix}_0001.bam",
        maf = f"{RUN_DIR}/{{TARGETS}}/{prefix}_0001.maf.gz",
        ref = f"{RUN_DIR}/{{TARGETS}}/{prefix}_0001.ref",
        log = f"{RUN_DIR}/{{TARGETS}}/{prefix}.log"
    output:
        bam = f"{pbsim_dir}/{prefix}_0001.bam",
        maf = f"{pbsim_dir}/{prefix}_0001.maf.gz",
        ref = f"{pbsim_dir}/{prefix}_0001.ref",
        log = f"{pbsim_dir}/{prefix}.log"
    shell:
        """
        mv {input.bam} {output.bam}
        mv {input.maf} {output.maf}
        mv {input.ref} {output.ref}
        mv {input.log} {output.log}
        """