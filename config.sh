# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

function fetch_unpack_index {
    local package_name=$1
    local project_spec=$2
    [ -z "$project_spec" ] && echo "project_spec not defined" && exit 1
    local source_dir=${3:-src}
    rm_mkdir dl_tmp
    pip download $(pip_opts) --no-deps --no-binary $package_name -d dl_tmp $project_spec
    local out_archive=$(abspath $(ls dl_tmp/*))
    mkdir -p $source_dir
    (cd $source_dir \
        && rm_mkdir arch_tmp \
        && cd arch_tmp \
        && untar $out_archive \
        && rsync --remove-source-files -avh */ .. \
        && cd .. \
        && rm -rf arch_tmp)
}

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    source multibuild/library_builders.sh
    build_hdf5
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    # download the source
    fetch_unpack_index $PACKAGE_NAME $PROJECT_SPEC src
    # test
    pytest src
}

