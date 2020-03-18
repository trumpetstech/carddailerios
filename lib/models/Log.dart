class Log {
  int id;
  String name;
  String time;
  String phone;

  Log({
    this.id,
    this.name,
    this.time,
    this.phone,
  });

  factory Log.fromMap(Map<String, dynamic> json) => new Log(
        id: json["_id"],
        name: json["name"],
        time: json["time"],
        phone: json["phone"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "time": time,
        "phone": phone,
      };
}