#!/bin/bash

# Define paths
reads=~/Desktop/practice/
multiqc_output=~/Desktop/practice/qc
trimming=~/Desktop/practice/trimmomatic_output/
index=~/Desktop/practice/ref_genome
align=~/Desktop/practice/align

if false
then

# Perform FastQC analysis on input FASTQ files
fastqc -t 2 $reads/*.gz -o ${reads}

# Generate MultiQC report
multiqc -p $reads/*.html . -o ${multiqc_output}


# Loop over input FASTQ files and run Trimmomatic for trimming

for read_file in $reads/*.gz
do
	# Extract sample name
	sample=$(basename $read_file | cut -d '_' -f1)
    
	# Run fastp
 	fastp -w 5 -a AGATCGGAAGAGC -i "${reads}/${sample}_1_subset.fastq.gz" -I "${reads}/${sample}_2_subset.fastq.gz" \
 	-o "${trimming}/${sample}_trimmed_r1.fastq.gz" -O "${trimming}/${sample}_trimmed_r2.fastq.gz" \
 	--html "${trimming}/${sample}_fastp.html" --json "${trimming}/${sample}_fastp.json"     
done

# Index reference genome with HISAT2
hisat2-build $index/*.fna ${index}/genome_index



# Run HISAT2 alignment for trimmed FASTQ files
for trimmed_file in $trimming/*.gz
do
    # Extract sample name
    sample=$(basename $trimmed_file | cut -d '_' -f1)
        
    # Run HISAT2 alignment
    hisat2 -p 4 -x ${index}/genome_index -1 $trimmed_file -2 $trimmed_file -S "${align}/${sample}_aligned.sam"
done


# Convert SAM files to sorted BAM files and mark duplicates using GATK4
for sam_file in ${align}/*.sam
do
    # Extract sample name from the SAM file name
    sample=$(basename $sam_file | cut -d '_' -f1)

    # Convert SAM file to sorted BAM
    samtools view -@ 1 -b $sam_file | samtools sort -@ 1 -o "${align}/${sample}_sorted.bam"

    # Mark duplicates using sambamba
    sambamba markdup -r -t 5 "${align}/${sample}_sorted.bam" "${align}/${sample}_rmdup.bam"
done


# Run featureCounts for read quantification
featureCounts -a $index/*.gtf -o $align/count_matrix.txt -T 4 -t exon -g gene_id \
    $align/*.bam

fi

