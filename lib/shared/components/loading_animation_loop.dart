import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class LoadingAnimationLoop extends StatefulWidget {
  final List<String> lottieFiles;
  final Duration duration;

  const LoadingAnimationLoop({
    super.key,
    required this.lottieFiles,
    this.duration = const Duration(seconds: 2),
  });

  @override
  _LoadingAnimationLoopState createState() => _LoadingAnimationLoopState();
}

class _LoadingAnimationLoopState extends State<LoadingAnimationLoop> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startLoop();
  }

  void _startLoop() {
    _timer = Timer.periodic(widget.duration, (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.lottieFiles.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        widget.lottieFiles[_currentIndex],
        width: 150,
        height: 150,
        fit: BoxFit.contain,
        repeat: true,
      ),
    );
  }
}
