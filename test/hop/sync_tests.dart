part of test_hop;

// TODO: test output using new TestRunner

class SyncTests {
  static void run() {
    test('true result is cool', _testTrueIsCool);
    test('false result fails', _testFalseIsFail);
    test('null result is sad', _testNullIsSad);
    test('exception is sad', _testExceptionIsSad);
    test('bad task name', _testBadParam);
    test('no task name', _testNoParam);
    test('no tasks defined', _testNoTasks);
    test('ctx.fail', _testCtxFail);
  }

  static void _testCtxFail() {
    _testSimpleSyncTask((ctx) => ctx.fail('fail!'), (value) {
      expect(value, RunResult.FAIL);
    });
  }

  static void _testTrueIsCool() {
    _testSimpleSyncTask((ctx) => true, (value) {
      expect(value, RunResult.SUCCESS);
    });
  }

  static void _testFalseIsFail() {
    _testSimpleSyncTask((ctx) => false, (value) {
      expect(value, RunResult.FAIL);
    });
  }

  static void _testNullIsSad() {
    _testSimpleSyncTask((ctx) => null,(value) {
      expect(value, RunResult.ERROR);
    });
  }

  static void _testExceptionIsSad() {
    _testSimpleSyncTask((ctx) {
        throw 'sorry';
      },
      (value) {
        expect(value, RunResult.EXCEPTION);
      }
    );
  }

  static void _testBadParam() {
    final taskConfig = new TaskRegistry();
    taskConfig.addSync('good', (ctx) => true);

    final hopConfig = new HopConfig(taskConfig, ['bad'], _testPrint);

    final future = Runner.run(hopConfig);
    expect(future, isNotNull);

    final onComplete = expectAsync1((value) {
      expect(value, RunResult.BAD_USAGE);
      // TODO: test that proper error message is printed
    });

    future.then(onComplete);
  }

  static void _testNoParam() {
    final taskConfig = new TaskRegistry();
    taskConfig.addSync('good', (ctx) => true);

    final hopConfig = new HopConfig(taskConfig, [], _testPrint);

    final future = Runner.run(hopConfig);
    expect(future, isNotNull);

    final onComplete = expectAsync1((value) {
      expect(value, RunResult.SUCCESS);
      // TODO: test that task list is printed
    });

    future.then(onComplete);
  }

  static void _testNoTasks() {
    final taskConfig = new TaskRegistry();

    final hopConfig = new HopConfig(taskConfig, [], _testPrint);

    final future = Runner.run(hopConfig);
    expect(future, isNotNull);

    final onComplete = expectAsync1((value) {
      expect(value, RunResult.SUCCESS);
      // TODO: test that task list is printed
    });

    future.then(onComplete);
  }

  static Action0 _testSimpleSyncTask(Func1<TaskContext, bool> task,
                            Action1<RunResult> completeHandler) {
    testTaskCompletion(new Task.sync(task), completeHandler);
  }
}
