import 'dart:async';
import 'package:flutter/material.dart';

class CircularCountdown extends StatefulWidget {
  final int seconds;
  final double size;
  final Color color;

  const CircularCountdown({
    super.key,
    this.seconds = 20,
    this.size = 140,
    required this.color,
  });

  @override
  State<CircularCountdown> createState() => _CircularCountdownState();
}

class _CircularCountdownState extends State<CircularCountdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.seconds;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.seconds),
    )..forward();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _current--;
      });
      if (_current <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final progress = 1 - _controller.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                strokeAlign: 5,
                value: progress,
                strokeWidth: 10,
                color: widget.color,
                backgroundColor: widget.color.withValues(alpha: 0.2),
              ),
              Text(
                _current <= 0 ? '0' : _current.toString(),
                style: TextStyle(
                  fontSize: widget.size * 0.25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
