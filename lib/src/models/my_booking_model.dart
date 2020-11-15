class MyBookingModel {
  String status;
  String modeOfPayment;
  String bookingId;
  String dateTime;
  String address;
  String latitude;
  String longitude;
  String car;
  String carCategory;
  String service;
  String bookedAt;
  String amount;

  MyBookingModel({
    this.status,
    this.modeOfPayment,
    this.bookingId,
    this.dateTime,
    this.address,
    this.latitude,
    this.longitude,
    this.car,
    this.carCategory,
    this.service,
    this.bookedAt,
    this.amount,
  });

  MyBookingModel.fromMap(Map<String, dynamic> record) {
    status = record['status'] != null ? record['status'] : '';
    modeOfPayment =
        record['mode_of_payment'] != null ? record['mode_of_payment'] : '';
    bookingId = record['booking_id'] != null ? record['booking_id'] : '';
    dateTime = record['date_time'] != null ? record['date_time'] : '';
    address = record['address'] != null ? record['address'] : '';
    latitude = record['latitude'] != null ? record['latitude'] : '';
    longitude = record['longitude'] != null ? record['longitude'] : '';
    car = record['car'] != null ? record['car'] : '';
    carCategory = record['car_category'] != null ? record['car_category'] : '';
    service = record['service'] != null ? record['service'] : '';
    bookedAt = record['booked_atB'] != null ? record['booked_atB'] : '';
    amount = record['amount'] != null ? record['amount'] : '';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'mode_of_payment': modeOfPayment,
      'booking_id': bookingId,
      'date_time': dateTime,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'car': car,
      'car_category': carCategory,
      'service': service,
      'booked_atB': bookedAt,
      'amount': amount,
    };
  }
}
