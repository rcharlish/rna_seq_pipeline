RNA-Seq Pipeline

This repository contains an RNA-seq analysis pipeline designed to process sequencing data and quantify gene expression levels. The pipeline includes several steps aimed at quality control, preprocessing, alignment, and reads quantification.
Pipeline Overview

The RNA-seq pipeline includes the following steps:

    Quality Control (QC) with FastQC and MultiQC:
        Reads are assessed for quality using FastQC.
        MultiQC is used to aggregate FastQC reports for easier analysis.

    Trimming with Fastp:
        Input FASTQ files are trimmed using Fastp to remove adapter sequences and low-quality bases.
        Trimmed reads are outputted for downstream analysis.

    Alignment with Hisat2:
        The Hisat2 aligner is used to map trimmed FASTQ files to a reference genome or transcriptome.
        Aligned reads are outputted in SAM format.

    BAM Processing with Samtools and Sambamba:
        SAM files are converted to sorted BAM files using Samtools.
        Duplicates are marked and removed from the sorted BAM files using Sambamba.

    Reads Quantification with FeatureCounts:
        Gene expression levels are quantified from the cleaned BAM files using FeatureCounts.
        Quantification results are outputted in a tabular format.

File Structure

    pipeline.sh: The main script containing the RNA-seq analysis pipeline.
    README.md: This file, providing an overview of the pipeline and instructions for use.

Dependencies

Ensure that the following dependencies are installed and available on your system:

    FastQC
    MultiQC
    Fastp
    Hisat2
    Samtools
    Sambamba
    FeatureCounts

Additionally, a Conda environment file named ngs.yml is provided within this repository. This YAML file specifies the required dependencies and their versions for executing the RNA-seq pipeline. To ensure compatibility and reproducibility, it's recommended to create a Conda environment based on this file before executing the pipeline.
