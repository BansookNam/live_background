mixin PreventRecursiveCall {
  final _preventStackOverFlowMaxCount = 5;
  int recursiveCallCount = 1;

  bool get isRecursiveCountSafe =>
      recursiveCallCount < _preventStackOverFlowMaxCount;
}
