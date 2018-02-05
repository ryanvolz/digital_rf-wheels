function prepare_repo {
    local repo_dir=${1:-$REPO_DIR}
    if [ -z "$IS_OSX" ]; then
        yum install -y cmake
    else
        brew install cmake
    fi
    pip install -r ${repo_dir}/python/dev_requirements.txt
    mkdir -p ${repo_dir}/python/build
    cd ${repo_dir}/python/build
    cmake ..
}

