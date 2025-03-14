nextflow.enable.dsl=2

params.bgen_dir = "gs://fc-aou-datasets-controlled/v8/wgs/short_read/snpindel/acaf_threshold/bgen/chr21.bgen{,.bgi}"  // Input BGEN directory in GCS
params.output_dir = "${WORKSPACE_BUCKET}/split_bgen" // Output directory for split files
params.region_size = 5000000 // Default chunk size (5Mb)

process split_bgen {

    publishDir "${params.output_dir}", mode: 'move'

    input:
    tuple val(bgen_filename), path(bgen_files)

    output:
    path "*_*_*.bgen"

    script:
    """
    # Extract chromosome info from the filename
    IFS="|"; read chr total_length < <(sqlite3 ${bgen_filename}.bgi 'select chromosome, max(position) from variant')
 
    
    # Split into chunks based on region_size
    start=1
    while [ \$start -le \$total_length ]; do
        end=\$((start + ${params.region_size} - 1))
        [ \$end -gt \$total_length ] && end=\$total_length
        
        output_file="\${chr}_\${start}_\${end}.bgen"
        bgenix -g ${bgen_filename} -incl-range \${chr}:\${start}-\${end} > \${output_file}
        
        start=\$((end + 1))
    done
    """
} 

workflow {
    Channel.fromFilePairs("${params.bgen_dir}")
        | split_bgen
}
