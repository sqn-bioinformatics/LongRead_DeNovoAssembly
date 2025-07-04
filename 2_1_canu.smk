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

# This SnakeMake file contains the rule to run canu
# Project: longread simulation study
# Description: perform de novo assembly on the simulated reads generated by PBSIM3. 
#           The datasets have varying the readlength, sequencing depth and error rate
# Author: Paula Uittenbogaard
# Date: 25-03-2025

rule canu:
    input: 
        f"{pbsim_dir}/{prefix}_0001.fq.gz"
    resources:
        mem_mb = 5000
    threads: 10
    output:
        f"{canu_dir}/{prefix}.contigs.fasta"
    params:
        prefix = f"{prefix}",
        outdir = f"{canu_dir}"
    shell:
        """
        canu -p {params.prefix} \
             -d {params.outdir} \
             useGrid=false \
             genomeSize=1m \
             minInputCoverage=8 \
             stopOnLowCoverage=8 \
             -nanopore-raw {input}
        """



#        bash run_canu.sh {METHOD} {wildcards.ACCURACY} \
 #                        {wildcards.READLENGTH} {wildcards.DEPTH} \
  #                       {input} \
   #                      {out_dir}/canu/{wildcards.TARGETS}/rl{wildcards.READLENGTH}/de{wildcards.DEPTH}  
