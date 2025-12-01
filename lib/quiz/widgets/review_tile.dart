import 'package:flutter/material.dart';
import 'package:mestre_nr/core/theme/theme_controller.dart';

class ReviewTile extends StatefulWidget {
  final Map<String, dynamic> data;
  final double width;

  const ReviewTile({super.key, required this.data, required this.width});

  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  bool _isExpanded = false;

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Color _getShadowColor() {
    if (ThemeController.themeMode.value == ThemeMode.light) {
      return Colors.black.withAlpha(100);
    }
    return Colors.white.withAlpha(20);
  }

  Color _getBorderColor() {
    if (ThemeController.themeMode.value == ThemeMode.light) {
      return Colors.black;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 50.0;
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(color: _getBorderColor(), width: 0.5),
        ),
        shadowColor: _getShadowColor(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _toggle,
          splashColor: Colors.white24,
          highlightColor: Colors.white10,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: widget.width * 0.85 > 500 ? 500 : widget.width * 0.85,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: _buildFullContent(cs),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullContent(ColorScheme cs) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _buildHeader(cs),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 15),
          const Divider(height: 1),
          const SizedBox(height: 15),
          buildHideContent(cs),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  List<Widget> _buildHeader(ColorScheme cs) {
    Color getAnswerColor() {
      if (widget.data['isCorrect']) return cs.secondary;
      return cs.error;
    }

    return [
      Icon(Icons.circle, color: getAnswerColor()),
      Text(
        'Questão ${widget.data['id'] + 1}',
        style: TextStyle(
          color: cs.primary,
          fontWeight: FontWeight.bold,
          fontSize: widget.width * 0.046,
        ),
      ),
      AnimatedRotation(
        turns: _isExpanded ? 0.5 : 0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: widget.width * 0.06,
        ),
      ),
    ];
  }

  Widget buildHideContent(ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.data['prompt'],
          style: TextStyle(color: cs.onSurface, fontSize: widget.width * 0.038),
        ),
        const SizedBox(height: 10),
        if (!widget.data['isCorrect'])
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.dangerous_outlined, color: cs.error),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.data['userAnswer'],
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontSize: widget.width * 0.0365,
                  ),
                ),
              ),
            ],
          ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check, color: cs.secondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.data['correctOption'],
                style: TextStyle(
                  color: cs.onSurfaceVariant,
                  fontSize: widget.width * 0.0365,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
