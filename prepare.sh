# Define utilities for before entering the build phase

function fetch_unpack_index {
    local project_spec=$1
    [ -z "$project_spec" ] && echo "project_spec not defined" && exit 1
    local source_dir=${2:-src}
    rm_mkdir arch_tmp
    pip download $(pip_opts) --no-deps --no-binary :all: -d arch_tmp $project_spec
    local out_archive=$(ls arch_tmp/*)
    rm_mkdir $source_dir
    (cd $source_dir && untar ../$out_archive && rsync --delete -avh * ..)
}

