# Define custom utilities
# Test for OSX with [ -n "$IS_OSX" ]

SRC_DIR=src
HDF5_VERSION="${1:-1.12.1}"

function fetch_unpack_pypi_source {
    local package_name=$1
    local package_version=$2
    local source_dir=${3:-$SRC_DIR}
    local archive_name="${package_name}-${package_version}.tar.gz"
    local source_url="https://pypi.io/packages/source/${package_name:0:1}/${package_name//_/-}/$archive_name"
    rm_mkdir dl_tmp
    echo $source_url
    (cd dl_tmp && curl -L -O $source_url)
    local out_archive=$(abspath dl_tmp/$archive_name)
    echo $out_archive
    mkdir -p $source_dir
    (cd $source_dir \
        && rm_mkdir arch_tmp \
        && cd arch_tmp \
        && untar $out_archive \
        && rsync --remove-source-files -avh */ .. \
        && cd .. \
        && rm -rf arch_tmp)
}

function wheel_add_build_number {
    local package_name=$1
    local package_version=$2
    local wheel_dir=$3
    local build_num=$4
    local package_name_version="${package_name}-${package_version}"
    local wheel_name=$(cd "$wheel_dir"; ls ${package_name_version}*)
    local wheel_suffix="${wheel_name:${#package_name_version}}"
    if [ "$build_num" -ne "0" ]; then
        local new_path="${wheel_dir}/${package_name_version}-${build_num}${wheel_suffix}"
        mv "${wheel_dir}/${wheel_name}" "$new_path"
    fi
}

function pip_opts {
    # Extra options for pip
    echo "--no-build-isolation"
}

function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    source multibuild/library_builders.sh
    build_hdf5
    export CFLAGS="$CFLAGS '-std=c99'"
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    # test
    pytest ../$SRC_DIR
}

