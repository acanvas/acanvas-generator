#!/bin/bash

# Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
# All rights reserved. Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# Fast fail the script on failures.
set -e

# Get our packages.
pub get

# Verify that the libraries are error free.
dartanalyzer --fatal-warnings bin/acanvas_generator.dart lib/acanvas_generator.dart test/all.dart

# Run the tests.
dart -c test/all.dart

# Run all the generators and analyze the generated code.
dart tool/grind.dart buildbot
