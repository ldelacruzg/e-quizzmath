class QuizTimer {
  Duration time;
  bool isRunning;

  QuizTimer({
    this.time = const Duration(seconds: 0),
    this.isRunning = false,
  });
}
