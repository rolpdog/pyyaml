#!/bin/bash

set -eux

# doesn't really matter which Python we use, so long as it can run cibuildwheel, and we're consistent within the
# build, since cibuildwheel is internally managing looping over all the Pythons for us.
export PYBIN=python3

${PYBIN} -V
${PYBIN} -m pip install -U --user cibuildwheel

# we're using a private build of libyaml, so set paths to favor that instead of whatever's laying around
export C_INCLUDE_PATH=$(cd libyaml/include; pwd):${C_INCLUDE_PATH:-}
export LIBRARY_PATH=$(cd libyaml/src/.libs; pwd):${LIBRARY_PATH:-}
export LD_LIBRARY_PATH=$(cd libyaml/src/.libs; pwd):${LD_LIBRARY_PATH:-}

export PYYAML_FORCE_CYTHON=1
export PYYAML_FORCE_LIBYAML=1
export CIBW_TEST_COMMAND='cd {project}; python tests/lib/test_all.py'

${PYBIN} -m cibuildwheel --platform auto --output-dir dist .
