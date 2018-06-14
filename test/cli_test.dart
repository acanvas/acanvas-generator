// Copyright (c) 2015, Block Forest. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library rockdot_generator.cli_test;

import 'dart:async';
import 'dart:io';

import 'package:rockdot_generator/rockdot_generator.dart';
import 'package:unittest/unittest.dart';

void defineTests() {
  group('cli', () {
    RockdotCommandRunner app;
    CliLoggerMock logger;
    FileTargetMock target;

    setUp(() {
      logger = new CliLoggerMock();
      target = new FileTargetMock();
      app = new RockdotCommandRunner(logger, target);
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
      return app.run([]).then(_expectOk);
    });

    test('one arg', () {
      return app.run(['project', "--override"]).then((_) {
        _expectOk();
        expect(target.createdCount, isPositive);
      });
    });

    test('non-existing command (bad)', () {
      return _expectError(app.run(['bad_command']));
    });

    test('non-existing flag for command (bad)', () {
      return _expectError(app.run(['project', '--foobar']));
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


class FileTargetMock implements Target {
  int createdCount = 0;
  final Directory _cwd = new Directory('test');
  @override Directory get cwd => _cwd;

  @override
  Future createFile(String path, List<int> contents) {
    expect(contents, isNot(isEmpty));
    expect(path, isNot(startsWith('/')));

    createdCount++;

    return new Future.value();
  }

}
