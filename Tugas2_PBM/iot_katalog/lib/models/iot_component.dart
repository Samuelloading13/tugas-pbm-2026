class IotComponent {
  final int? id;
  final String name;
  final int price;
  final String description;

  IotComponent({this.id, required this.name, required this.price, required this.description});

  factory IotComponent.fromJson(Map<String, dynamic> json) {
    return IotComponent(
      id: json['id'],
      name: json['name'].toString(),
      price: int.tryParse(json['price'].toString()) ?? 0,
      description: json['description'].toString(),
    );
  }
}