// Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library rockdot_generator.cli_test;

import 'dart:async';
import 'dart:io';

import 'package:rockdot_generator/rockdot_generator.dart';
import 'package:rockdot_generator/src/cli_app.dart';
import 'package:unittest/unittest.dart';

void defineTests() {
  group('cli', () {
    CliApp app;
    CliLoggerMock logger;
    GeneratorTargetMock target;

    setUp(() {
      logger = new CliLoggerMock();
      target = new GeneratorTargetMock();
      app = new CliApp(generators, logger, target);
      app.cwd = new Directory('test');
    });

    void _expectOk([_]) {
      expect(logger.getStderr(), isEmpty);
      expect(logger.getStdout(), isNot(isEmpty));
    }

    Future _expectError(Future f, [bool hasStdout = true]) {
      return f.then((_) => fail('error expected')).catchError((e) {
        expect(logger.getStderr(), isNot(isEmpty));
        if (hasStdout) {
          expect(logger.getStdout(), isNot(isEmpty));
        } else {
          expect(logger.getStdout(), isEmpty);
        }
      });
    }

    test('no args', () {
      return app.process([]).then(_expectOk);
    });

    test('one arg', () {
      return app.process([generators.first.id, "--override"]).then((_) {
        _expectOk();
        expect(target.createdCount, isPositive);
      });
    });

    test('one arg (bad)', () {
      return _expectError(app.process(['bad_generator']));
    });

    test('two args (bad)', () {
      return _expectError(app.process([generators.first.id, 'foobar']));
    });
  });
}

class CliLoggerMock implements CliLogger {
  StringBuffer _stdout = new StringBuffer();
  StringBuffer _stderr = new StringBuffer();

  void stderr(String message) => _stderr.write(message);
  void stdout(String message) => _stdout.write(message);

  String getStdout() => _stdout.toString();
  String getStderr() => _stderr.toString();
}

class GeneratorTargetMock implements GeneratorTarget {
  int createdCount = 0;

  Future createFile(String path, List<int> contents) {
    expect(contents, isNot(isEmpty));
    expect(path, isNot(startsWith('/')));

    createdCount++;

    return new Future.value();
  }
}
