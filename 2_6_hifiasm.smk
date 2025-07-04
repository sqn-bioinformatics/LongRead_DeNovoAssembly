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

# This SnakeMake file contains the rule to run hifiasm
# Project: longread simulation study
# Description: perform de novo assembly on the simulated reads generated by PBSIM3 followed by ccs to generate HiFi consensus reads. 
#           The datasets have varying the readlength, sequencing depth and error rate
# Author: Paula Uittenbogaard
# Date: 06-05-2025

rule hifiasm:
    input: 
        f"{ccs_dir}/{prefix}.fastq.gz"
    output:
        gfa = f"{hifiasm_dir}/{prefix}.bp.p_ctg.gfa",
        fasta = f"{hifiasm_dir}/{prefix}.contigs.fasta"
    log:
        f"{hifiasm_dir}/{prefix}.log"
    params:
        outdir = f"{hifiasm_dir}/{prefix}"
    shell:
        """
        hifiasm -o {params.outdir} -t 20 {input} 2> {log} 
        awk '/^S/{{print ">"$2;print $3}}' {output.gfa} > {output.fasta}
        """