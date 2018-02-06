# Define utilities for before entering the build phase

function fetch_unpack_index {
    local project_spec=$1
    [ -z "$project_spec" ] && echo "project_spec not defined" && exit 1
    local source_dir=${2:-src}
    rm_mkdir dl_tmp
    pip download $(pip_opts) --no-deps --no-binary :all: -d dl_tmp $project_spec
    local out_archive=$(abspath $(ls dl_tmp/*))
    mkdir -p $source_dir
    (cd $source_dir \
        && rm_mkdir arch_tmp \
        && cd arch_tmp \
        && untar $out_archive \
        && rsync --delete -avh */ ..)
}

