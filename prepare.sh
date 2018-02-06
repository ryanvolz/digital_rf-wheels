function prepare_source {
    local repo_dir=$(abspath ${1:-$REPO_DIR})
    local src_dir=$(abspath ${2:-src})
    if [ -z "$IS_OSX" ]; then
        sudo apt-get install cmake
    else
        brew install cmake
    fi
    pip install -r ${repo_dir}/python/dev_requirements.txt
    mkdir -p ${src_dir}
    pushd ${src_dir}
    cmake ${repo_dir}/python
    make digital_rf_sdist
    popd
}

