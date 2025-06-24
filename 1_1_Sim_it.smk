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

# This SnakeMake file contains the rule to run Sim-it
# Project: longread simulation study
# Description: simulate long-reads using Sim-it. 
#           Vary the readlength, sequencing depth and error rate
# Author: Paula Uittenbogaard
# Date: 20-02-2025

#######################
## Unpacking configs
#######################
RUN_DIR = config['rundir']
TARGETS = config['targets']
#CONFIG_PATH = "/home/uitte01p/experimental/test_for_sim_study/test_Sim_it/Sim-it/config_Sim-it.txt"
CONFIG_PATH = "/home/uitte01p/experimental/test_for_sim_study"
SIM_IT = "/home/uitte01p/experimental/test_for_sim_study/test_Sim_it/Sim-it/Sim-it1.3.6.pl"
ERROR_PROFILE = "/home/uitte01p/experimental/test_for_sim_study/test_Sim_it/Sim-it/error_profile_ONT.txt"

rule write_config_sim_it:
    input:
        f"{CONFIG_PATH}/copy_config_Sim-it.txt"
    output:
        f"{CONFIG_PATH}/TEST_{METHOD}_{READLENGTH}_{ACCURACY}_{DEPTH}/copy_config_Sim-it.txt"
    shell:
        """cp {input} {output} 
        echo "Sequencing depth         = {DEPTH}" >> {output} 
        echo "Median length            = {READLENGTH}" >> {output} 
        echo "Length range             = 500-150000" >> {output} 
        echo "Accuracy                 = {ACCURACY}%" >> {output} 
        echo "Error profile            = {ERROR_PROFILE}" >> {output} 
        """

rule sim_it:
    input: 
        target = f"{RUN_DIR}/targets/{TARGETS}.fasta",
        config_path = f"{CONFIG_PATH}/TEST_{METHOD}_{READLENGTH}_{ACCURACY}_{DEPTH}/copy_config_Sim-it.txt"
    output:
        f"{OUT_DIR}/Sim_it/{TARGETS}/{METHOD}_{READLENGTH}_{ACCURACY}_{DEPTH}/Long_reads_{TARGETS}_HAP12.fasta",
    params:
        temp_dir = temp(f"{OUT_DIR}/Sim_it/{TARGETS}/{METHOD}_{READLENGTH}_{ACCURACY}_{DEPTH}")
    shell:
        "perl {SIM_IT} -c {input.config_path} -o {params.temp_dir}"

