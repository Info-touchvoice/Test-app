String capitalizeEachWord(String input) {
  return input
      .split(' ')
      .map((word) => word.isNotEmpty
          ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
          : '')
      .join(' ');
}

String trimToTwoWords(String input) {
  final words = input.trim().split(RegExp(r'\s+'));
  String trimWords = words.take(2).join(' ');
  return capitalizeEachWord(trimWords);
}
