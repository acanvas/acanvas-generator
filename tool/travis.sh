#!/bin/bash

# Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
# All rights reserved. Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# Fast fail the script on failures.
set -e

# Install global tools.
pub global activate tuneup

# Verify that the libraries are error free.
pub global run tuneup check

# Run the tests.
#dart -c test/all.dart

# Run all the generators and analyze the generated code.
dart tool/grind.dart test

# Install dart_coveralls; gather and send coverage data.
if [ "$COVERALLS_TOKEN" ]; then
  echo "token found"
  pub global activate --source git https://github.com/block-forest/dart-coveralls
  pub global run dart_coveralls:dart_coveralls report \
    --token $COVERALLS_TOKEN \
    --retry 2 \
    --exclude-test-files \
    test/all.dart
fi