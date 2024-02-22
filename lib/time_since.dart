String getTimeSince(DateTime date, {bool ago = false}) {
  String timeSince = '';
  Duration diff = DateTime.now().difference(date);
  if (diff.inMinutes < 60) {
    timeSince = diff.inMinutes == 1
        ? '${diff.inMinutes} minute'
        : '${diff.inMinutes} minutes';
  } else if (diff.inHours < 24) {
    timeSince =
        diff.inHours == 1 ? '${diff.inHours} hour' : '${diff.inHours} hours';
  } else if (diff.inDays < 7) {
    timeSince = diff.inDays == 1 ? '${diff.inDays} day' : '${diff.inDays} days';
  } else {
    timeSince = diff.inDays ~/ 7 == 1
        ? '${diff.inDays ~/ 7} week'
        : '${diff.inDays ~/ 7} weeks';
  }

  return ago ? "$timeSince ago" : timeSince;
}
