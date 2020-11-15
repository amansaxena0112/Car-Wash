import 'package:autobuff/src/models/car_model.dart';
import 'package:autobuff/src/models/service_model.dart';

class BookingModel {
  ServiceModel serviceModel;
  CarModel carModel;
  String address;
  String modeOfPayment;
  double latitude;
  double longitude;
  String dateTime;

  BookingModel({
    this.serviceModel,
    this.carModel,
    this.address,
    this.modeOfPayment,
    this.latitude,
    this.longitude,
    this.dateTime,
  });

  BookingModel.fromMap(Map<String, dynamic> record) {
    serviceModel = record['service'] != null
        ? ServiceModel.fromMap(record['service_id'])
        : ServiceModel();
    carModel =
        record['car'] != null ? CarModel.fromMap(record['car_id']) : CarModel();
    address = record['address'] != null ? record['address'] : '';
    modeOfPayment =
        record['mode_of_payment'] != null ? record['mode_of_payment'] : '';
    latitude = record['latitude'] != null ? record['latitude'] : 0.0;
    longitude = record['longitude'] != null ? record['longitude'] : 0.0;
    dateTime = record['date_time'] != null ? record['date_time'] : '';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'service': serviceModel,
      'car': carModel,
      'address': address,
      'mode_of_payment': modeOfPayment,
      'latitude': latitude,
      'longitude': longitude,
      'date_time': dateTime,
    };
  }
}
