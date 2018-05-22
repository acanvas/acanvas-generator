// Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library rockdot_generator.common_test;

import 'package:rockdot_generator/src/common.dart';
import 'package:unittest/unittest.dart';

void defineTests() {
  group('common', () {
    test('normalizeProjectName', () {
      expect(normalizeProjectName('foo.dart'), 'foo');
      expect(normalizeProjectName('foo-bar'), 'foo_bar');
    });

    test('substituteVars simple', () {
      _expect('foo {{bar}} baz', {'bar': 'baz'}, 'foo baz baz');
    });

    test('substituteVars nosub', () {
      _expect('foo {{bar}} baz', {'aaa': 'bbb'}, 'foo {{bar}} baz');
    });
  });
}

void _expect(String original, Map<String, String> vars, String result) {
  expect(substituteVars(original, vars), result);
}
