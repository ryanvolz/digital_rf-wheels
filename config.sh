# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

SRC_DIR=src

function fetch_unpack_pypi_source {
    local package_name=$1
    local package_version=$2
    local source_dir=${3:-$SRC_DIR}
    local archive_name="${package_name}-${package_version}.tar.gz"
    local source_url="https://pypi.io/packages/source/${package_name:0:1}/${package_name//_/-}/$archive_name"
    rm_mkdir dl_tmp
    (cd dl_tmp && curl -O $source_url)
    local out_archive=$(abspath $archive_name)
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
    # test
    pytest ../$SRC_DIR
}

