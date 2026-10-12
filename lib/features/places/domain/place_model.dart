/// Modelo de lugar o punto de control segun agent/04_PRODUCTO.md.
class Place {
  const Place({
    required this.id,
    required this.code,
    required this.name,
    this.description = '',
  });

  final String id;
  final String code;
  final String name;
  final String description;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Place && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
