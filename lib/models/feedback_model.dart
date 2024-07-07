enum FeedbackType {
  excellent,
  good,
  fair,
  bad,
  worst,
}

class FeedbackModel {
  final FeedbackType type;
  final int index;
  final String message, emoji, selectedEmoji;

  FeedbackModel({
    required this.emoji,
    required this.selectedEmoji,
    required this.type,
    required this.index,
    required this.message,
  });

// @override
// String toString() {
//   return feedbackTypeToString(type);
// }
}
