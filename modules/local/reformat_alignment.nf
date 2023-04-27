process REFORMAT_ALIGNMENT {
    tag "$meta.id"
    label 'process_single'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/perl:5.26.2' :
        'perl:5.26.2' }"

    input:
    tuple val(meta), path(a3m_alignment)

    output:
    tuple val(meta), path("${a3m_alignment.baseName}.a2m"), emit: a2m_alignment
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    reformat.pl a3m a2m ${a3m_alignment} ${a3m_alignment.baseName}.a2m

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        perl: \$(echo \$(perl --version 2>&1) | sed 's/.*v\\(.*\\)) built.*/\\1/')
    END_VERSIONS
    """

    stub:
    """
    touch ${a3m_alignment.baseName}.a2m

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        perl: \$(echo \$(perl --version 2>&1) | sed 's/.*v\\(.*\\)) built.*/\\1/')
    END_VERSIONS
    """
}
