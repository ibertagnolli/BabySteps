/// TODO We aren't using this class now, but will need it for the
/// Calendar to denote days with events. See TableCalendar's eventLoader
/// method. https://pub.dev/packages/table_calendar
class Event {
  final String title;
  const Event(this.title);
  @override
  String toString() => title;
}