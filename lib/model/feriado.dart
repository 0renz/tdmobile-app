class Feriado {
  String date;
  String name;
  String type;

  Feriado(this.date, this.name, this.type);

  factory Feriado.fromJson(Map<String, dynamic> json) {
    return Feriado(
      json['date'] as String,
      json['name'] as String,
      json['type'] as String,
    );
  }

  @override
  String toString() {
    return 'Feriado{date: $date, name: $name, type: $type}';
  }
}