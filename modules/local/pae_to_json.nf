process PAE_TO_JSON {
    tag "$meta.id"
    label 'process_single'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'docker://nfcore/proteinfold_alphafold2_standard:1.0.0' :
        'nfcore/proteinfold_alphafold2_standard:1.0.0' }"

    input:
    tuple val(meta), path(pkl)

    output:
    tuple val(meta), path("*.json"), emit: plddt_json
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    pae_to_json.py

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python3 --version | sed 's/Python //g')
    END_VERSIONS
    """

    stub:
    """
    touch result.json

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python3 --version | sed 's/Python //g')
    END_VERSIONS
    """
}
