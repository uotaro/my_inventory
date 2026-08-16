import 'package:flutter/material.dart';

/// お気に入り評価（0〜5）をタップで入力するための星ウィジェット。
/// 選択済みの星を再タップすると0（未評価）に戻る。
class FavoriteStarsInput extends StatelessWidget {
  const FavoriteStarsInput({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 32,
  });

  final int rating;
  final ValueChanged<int> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final filled = starValue <= rating;
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          iconSize: size,
          icon: Icon(
            filled ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () => onChanged(starValue == rating ? 0 : starValue),
        );
      }),
    );
  }
}

/// お気に入り評価（0〜5）を読み取り専用で表示するための星ウィジェット。
class FavoriteStarsDisplay extends StatelessWidget {
  const FavoriteStarsDisplay({super.key, required this.rating, this.size = 16});

  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index < rating;
        return Icon(
          filled ? Icons.star : Icons.star_border,
          size: size,
          color: Colors.amber,
        );
      }),
    );
  }
}
