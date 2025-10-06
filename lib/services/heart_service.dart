import 'package:flutter/material.dart';

class HeartReaction extends StatefulWidget {
  final String postId;
  final bool isLiked;
  final int likeCount;
  final Future<bool> Function(bool) onLikeToggled;

  const HeartReaction({
    super.key,
    required this.postId,
    required this.isLiked,
    required this.likeCount,
    required this.onLikeToggled,
  });

  @override
  State<HeartReaction> createState() => _HeartReactionState();
}

class _HeartReactionState extends State<HeartReaction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // FIXED: Simple tween without sequence to avoid assertion errors
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Heart button with animation
        GestureDetector(
          onTap: _isLoading ? null : _handleLike,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Icon(
              widget.isLiked ? Icons.favorite : Icons.favorite_border,
              color: widget.isLiked ? Colors.red : Colors.grey[600],
              size: 24,
            ),
          ),
        ),

        const SizedBox(width: 6),

        // Like count
        Text(
          _formatLikeCount(widget.likeCount),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),

        // Loading indicator
        if (_isLoading) ...[
          const SizedBox(width: 8),
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ],
    );
  }

  String _formatLikeCount(int count) {
    if (count == 0) return '0';
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }

  Future<void> _handleLike() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // FIXED: Simple forward and reset without complex sequencing
      await _controller.forward();
      await _controller.reverse();

      final success = await widget.onLikeToggled(!widget.isLiked);

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update like'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
