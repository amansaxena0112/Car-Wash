class CarModel {
  int id;
  String model;
  String category;

  CarModel({
    this.id,
    this.model,
    this.category,
  });

  CarModel.fromMap(Map<String, dynamic> record) {
    id = record['id'] != null ? record['id'] : 0;
    model = record['model'] != null ? record['model'] : '';
    category = record['category'] != null ? record['category'] : '';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'model': model,
      'category': category,
    };
  }
}
