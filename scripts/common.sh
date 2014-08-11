#!/bin/bash

# Copyright 2014 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS-IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# author: johncox@google.com (John Cox)
#
# Common library shared by all shell scripts in this package.
#

set -e
shopt -s nullglob

export SOURCE_DIR="$( cd "$( dirname "${BASH_ARGV[0]}" )" && cd .. && pwd )"
export EXAMPLES_DIR=$SOURCE_DIR/examples
export EXAMPLES_README=$EXAMPLES_DIR/README.md
export SCRIPTS_DIR=$SOURCE_DIR/scripts
export SCRIPTS_RESOURCES_DIR=$SCRIPTS_DIR/resources

export COURSE_BUILDER_CLONE_DIR=$EXAMPLES_DIR/course-builder
export COURSE_BUILDER_DIR=$EXAMPLES_DIR/coursebuilder
export COURSE_BUILDER_MODULES_DIR=$COURSE_BUILDER_DIR/modules
# Update this revision to the Course Builder check-in you want.
export COURSE_BUILDER_REVISION=7aebc8574de7
export COURSE_BUILDER_TESTS_DIR=$COURSE_BUILDER_DIR/tests
export COURSE_BUILDER_TESTS_EXT_DIR=$COURSE_BUILDER_TESTS_DIR/ext
export COURSE_BUILDER_URL=https://code.google.com/p/course-builder/

export MODULE_NAME=lti
export MODULE_SRC_DIR=$SOURCE_DIR/src
export MODULE_TESTS_DIR=$SOURCE_DIR/tests


function clean_examples_folder() {
    # Recursively removes everything from $EXAMPLES_DIR except the readme.
    find $EXAMPLES_DIR | egrep -v $EXAMPLES_DIR$ | grep -v $EXAMPLES_README | \
        xargs rm -rf
}


function get_course_builder() {
    # Fetches CB into examples/coursebuilder.
    git clone $COURSE_BUILDER_URL $COURSE_BUILDER_CLONE_DIR
    cd $COURSE_BUILDER_CLONE_DIR
    git checkout $COURSE_BUILDER_REVISION
    git apply $SCRIPTS_RESOURCES_DIR/module.patch
    mv coursebuilder ..
    rm -rf $COURSE_BUILDER_CLONE_DIR
}


function link_module() {
    # Symlinks module files into Course Builder directory.
    ln -s $MODULE_SRC_DIR $COURSE_BUILDER_MODULES_DIR/$MODULE_NAME
}


function link_tests() {
    # Symlinks tests into Course Builder directory.
    ln -s $MODULE_TESTS_DIR $COURSE_BUILDER_TESTS_EXT_DIR/$MODULE_NAME
}