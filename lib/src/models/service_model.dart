class ServiceModel {
  int id;
  String service;
  int price;

  ServiceModel({
    this.id,
    this.service,
    this.price,
  });

  ServiceModel.fromMap(Map<String, dynamic> record) {
    id = record['id'] != null ? record['id'] : 0;
    service = record['service'] != null ? record['service'] : '';
    price = record['price'] != null ? record['price'] : 0;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'service': service,
      'price': price,
    };
  }
}
