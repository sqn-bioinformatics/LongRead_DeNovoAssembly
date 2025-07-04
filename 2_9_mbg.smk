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

# This SnakeMake file contains the rule to run mbg
# Project: longread simulation study
# Description: perform de novo assembly on the simulated reads generated by PBSIM3 followed by ccs to generate HiFi consensus reads. 
#           The datasets have varying the readlength, sequencing depth and error rate
# Author: Paula Uittenbogaard
# Date: 13-05-2025

rule mbg:
    input: 
        f"{ccs_dir}/{prefix}.fastq.gz"
    output:
        gfa = f"{mbg_dir}/{prefix}.gfa",
        fasta = f"{mbg_dir}/{prefix}.contigs.fasta"
    log:
        f"{mbg_dir}/{prefix}.log"
    shell:
        """
        MBG -i {input} -o {output.gfa} -k 1501 -w 1450 -a 1 -u 3
        awk '/^S/{{print ">"$2;print $3}}' {output.gfa} > {output.fasta}
        """