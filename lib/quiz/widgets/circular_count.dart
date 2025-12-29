import 'dart:async';
import 'package:flutter/material.dart';

class CircularCountdown extends StatefulWidget {
  final int seconds;
  final double size;
  final Color color;
  final VoidCallback onTimeExpired;

  const CircularCountdown({
    super.key,
    this.seconds = 20,
    this.size = 120,
    required this.color,
    required this.onTimeExpired,
  });

  @override
  State<CircularCountdown> createState() => _CircularCountdownState();
}

class _CircularCountdownState extends State<CircularCountdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final ValueNotifier<int> _currentSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentSeconds = ValueNotifier(widget.seconds);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.seconds),
    )..forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds.value > 0) {
        _currentSeconds.value--;
      } else {
        widget.onTimeExpired();
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _currentSeconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 10,
              color: widget.color.withAlpha(26),
            ),
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SizedBox.expand(
                child: CircularProgressIndicator(
                  value: 1 - _controller.value,
                  strokeWidth: 10,
                  color: widget.color,
                  strokeCap: StrokeCap.round,
                ),
              );
            },
          ),
          ValueListenableBuilder<int>(
            valueListenable: _currentSeconds,
            builder: (context, value, child) {
              return Text(
                value.toString(),
                style: TextStyle(
                  fontSize: widget.size * 0.35,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: widget.color,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
