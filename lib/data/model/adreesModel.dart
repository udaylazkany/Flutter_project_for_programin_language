class Address {
  final int id;
  final String buildingNumber;
  final String floorNumber;
  final String apartmentNumber;
  final String streetName;
  final String city;

  Address({
    required this.id,
    required this.buildingNumber,
    required this.floorNumber,
    required this.apartmentNumber,
    required this.streetName,
    required this.city,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json["id"],
      buildingNumber: json["buildingNumber"],
      floorNumber: json["floorNumber"],
      apartmentNumber: json["apartmentNumber"],
      streetName: json["streetName"],
      city: json["city"],
    );
  }
}