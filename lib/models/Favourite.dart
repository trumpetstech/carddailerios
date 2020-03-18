class Favourite {
  int id;
  String name;
  String phone;

  Favourite({
    this.id,
    this.name,
    this.phone,
  });

  factory Favourite.fromMap(Map<String, dynamic> json) => new Favourite(
        id: json["_id"],
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "phone": phone,
      };
}