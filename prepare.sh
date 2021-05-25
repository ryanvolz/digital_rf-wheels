# Define utilities for before entering the build phase

function fetch_unpack_index {
    local package_name=$1
    local project_spec=$2
    [ -z "$project_spec" ] && echo "project_spec not defined" && exit 1
    local source_dir=${3:-src}
    rm_mkdir dl_tmp
    pip download $(pip_opts) --no-deps --no-binary $package_name -d dl_tmp $project_spec $BUILD_DEPENDS
    local out_archive=$(abspath $(ls dl_tmp/$package_name*))
    mkdir -p $source_dir
    (cd $source_dir \
        && rm_mkdir arch_tmp \
        && cd arch_tmp \
        && untar $out_archive \
        && rsync --remove-source-files -avh */ .. \
        && cd .. \
        && rm -rf arch_tmp)
}

