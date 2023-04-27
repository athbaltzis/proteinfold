process RUN_JALVIEW {
    tag "$meta.id"
    label 'process_single'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://athbaltzis/jalview:11_dev' :
        'athbaltzis/jalview:11_dev' }"

    input:
    tuple val(meta), path(fasta)
    tuple val(meta), path(alignment)
    tuple val(meta), path(pdb)
    tuple val(meta), path(plddt)

    output:
    path ("*_mqc.html") , emit: multiqc
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    java -jar /jalview-all-latest-develop-j11.jar \
        --headless \
        --open=${fasta} \
        --open=${alignment} \
        --open=${pdb} \
        --nossannotation \
        --tempfac=PLDDT \
        --tempfac-label="pLDDT" \
        --tempfac-shading \
        --paematrix=[seqid=${meta.id}\\|A]${plddt} \
        --wrap \
        --image=[type=html]${meta.id}_mqc.html


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        java: \$(echo \$(java --version 2>&1) | sed 's/^openjdk//; s/[0-9]*-[0-9]*-[0-9]*.*//')
    END_VERSIONS
    """

    stub:
    """
    touch ${meta.id}_mqc.html

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        java: \$(echo \$(java --version 2>&1) | sed 's/^openjdk//; s/[0-9]*-[0-9]*-[0-9]*.*//')
    END_VERSIONS
    """
}
