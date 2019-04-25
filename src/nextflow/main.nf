Channel
    .fromFilePairs( "$params.fastqs/*{.read1,.read2}.fastq.gz" )
    .ifEmpty { exit 1, "Fastq file(s) not found at: $params.fastqs" }
    .into { fq_pairs_fastqc; fq_pairs_trim }

process fastqc_raw {
    input:
    set pair_id, file(fq_pair) from fq_pairs_fastqc

    output:
    file "*" into fastqc_raw_out

    script:
    """
    fastqc -t $task.cpus --no-extract $fq_pair
    """
}

process multiqc_raw {
    publishDir "$params.results/multiqc_raw", mode: 'copy'

    input:
    file fastqcs from fastqc_raw_out.collect()

    output:
    file "*"

    script:
    """
    multiqc -n multiqc_raw $fastqcs
    """
}

process trim {
    input:
    set pair_id, file(fq_pair) from fq_pairs_trim

    output:
    file "*.log" into trim_log
    set pair_id, file("*P.fastq.gz"), file("*U.fastq.gz") into trimmed_fastqc, trimmed_align

    """
    java -jar \$TRIM PE \
        -threads $task.cpus \
        $fq_pair \
        -baseout ${pair_id}.fastq.gz \
        ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 \
        SLIDINGWINDOW:4:15 MINLEN:36 2> ${pair_id}.log
    """
}

process fastqc_trimmed {
    input:
    set pair_id, file(paired), file(unpaired) from trimmed_fastqc

    output:
    file "*" into fastqc_trimmed_out

    script:
    """
    fastqc -t $task.cpus --no-extract $paired $unpaired
    """
}

Channel
    .fromPath( "$params.genome/*.fa" )
    .ifEmpty { exit 1, "Fasta file not found at: $params.genome" }
    .set { genome }
Channel
    .fromPath( "$params.gtf/*.gtf")
    .ifEmpty { exit 1, "GTF file not found at: $params.gtf" }
    .into { gtf_star_index; gtf_star_align }

process star_index {
    input:
    file genome
    file gtf from gtf_star_index

    output:
    file "star" into star_index
    
    script:
    def avail_mem = task.memory ? "--limitGenomeGenerateRAM ${task.memory.toBytes()} - 100000000" : ''
    """
    mkdir star
    star \\
        --runMode genomeGenerate \\
        --runThreadN $task.cpus \\
        --genomeDir star/ \\
        --sjdbGTFfile $gtf \\
        --genomeFastaFiles $genome \\
        $avail_mem
    """
}

process star_align {
    publishDir "$params.results/star", mode: 'copy'

    input:
    set pair_id, file(paired), file(unpaired) from trimmed_align
    file index from star_index.first()
    file gtf from gtf_star_align.first()

    output:
    set file("*Log.final.out"), file('*.bam') into star_aligned
    file "*.out" into alignment_logs
    file "*SJ.out.tab" into star_sj
    file "*Log.out" into star_log

    script:
    """
    star \\
        --genomeDir $index \\
        --sjdbGTFfile $gtf \\
        --readFilesIn $paired \\
        --runThreadN $task.cpus \\
        --outWigType bedGraph \\
        --outSAMtype BAM SortedByCoordinate \\
        --readFilesCommand gunzip -c \\
        --outFileNamePrefix $pair_id
    """
}

process multiqc_trimmed {
    publishDir "$params.results/multiqc_trimmed", mode: 'copy'

    input:
    file fastqcs from fastqc_trimmed_out.collect()
    file trim_logs from trim_log.collect()
    file alignments_logs from alignment_logs.collect()

    output:
    file "*"

    script:
    """
    multiqc -n multiqc_trimmed $fastqcs $trim_logs $alignments_logs
    """
}
