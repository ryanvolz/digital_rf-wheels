# Define custom utilities

function build_libs {
    source multibuild/library_builders.sh
    build_hdf5
}

function pre_build {
    build_libs
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    # upgrade numpy to most recent version (if build version is still around)
    pip install -U numpy
    # test
    pytest ../src
}

