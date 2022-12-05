class Event {
  Event(this.id, this.username, this.title, this.start, this.end, this.unit, this.description, this.mailSend);
  String id;
  String username;
  String title;
  DateTime start;
  DateTime end;
  String unit;
  String description;
  bool mailSend;
}

