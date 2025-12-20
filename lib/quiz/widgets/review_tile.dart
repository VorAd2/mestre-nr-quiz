import 'package:flutter/material.dart';

class ReviewTile extends StatefulWidget {
  final Map<String, dynamic> data;
  const ReviewTile({super.key, required this.data});

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Card(
          elevation: 2,
          shadowColor: Colors.black26,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: cs.outlineVariant, width: 1),
          ),
          clipBehavior: Clip.antiAlias,
          color: cs.surface,
          child: InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(24),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: _buildFullContent(theme, cs),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullContent(ThemeData theme, ColorScheme cs) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: _buildHeader(theme, cs)),
        if (_isExpanded) ...[
          const SizedBox(height: 16),
          Divider(height: 1, color: cs.outlineVariant),
          const SizedBox(height: 16),
          _buildHiddenContent(theme, cs),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  List<Widget> _buildHeader(ThemeData theme, ColorScheme cs) {
    Color getAnswerColor() {
      if (widget.data['isCorrect']) return Colors.green;
      return cs.error;
    }

    return [
      Icon(Icons.circle, color: getAnswerColor(), size: 16),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          'Questão ${widget.data['id'] + 1}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      AnimatedRotation(
        turns: _isExpanded ? 0.5 : 0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: cs.onSurfaceVariant,
          size: 28,
        ),
      ),
    ];
  }

  Widget _buildHiddenContent(ThemeData theme, ColorScheme cs) {
    final isTimeout = widget.data['userAnswer'] == null;
    final wrongIcon = isTimeout
        ? Icons.timer_off_outlined
        : Icons.cancel_outlined;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.data['prompt'],
          style: theme.textTheme.bodyLarge?.copyWith(
            color: cs.onSurface,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),
        if (!widget.data['isCorrect'])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(wrongIcon, color: cs.error, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.data['userAnswer'] ?? 'Tempo esgotado',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check, color: Colors.green, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.data['correctOption'],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
