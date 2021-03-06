## Base quality calculator

from __future__ import print_function
import logging
import pysam

from functions.shared_functions import *

def base_quality(myvcf,bampath,filename):

  log=open(filename,"w")

  ## Open the bamfile.  We do it ONCE and ONCE ONLY for speed reasons
  logging.debug("Opening bam file")
  samfile=pysam.Samfile(bampath,"rb") # rb = "read bam"

  for idx,variant in enumerate(myvcf):
    
    baseq=[]

    ## Remove 1 to POS to convert from 1-based to 0-based
    ## VCFs are 1 based, SAM coordinates are 0 based
    variant.POS=variant.POS-1

    for alignedread in samfile.fetch(variant.CHROM,variant.POS,variant.POS+1):
      if not alignedread.is_proper_pair:
        continue
      else:
        ## Which base in the read is at the position we want?  Use the
        ## "aligned_pairs" list of tuples to determine this
        offset = [item for item in alignedread.aligned_pairs if item[1] == variant.POS][0][0]
        if(offset!=None):
          ## We subtract 33 because SAM specification tells us to
          baseq.append(ord(alignedread.qual[offset])-33)

    ## THIS IS WHERE WE WRITE OUTPUT
    variant.POS=variant.POS+1 # return variant.POS to original 1-based value
    print(str(variant.CHROM)+":"+str(variant.POS)+"\t"+str(mean(baseq)))
    print(str(variant.CHROM)+":"+str(variant.POS)+"\t"+str(mean(baseq)),file=log)
  
  ## Close the bamfile
  samfile.close()

  ## Close the logfile
  log.close()
