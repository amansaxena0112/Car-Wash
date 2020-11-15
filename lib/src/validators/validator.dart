import 'dart:async';

class Validators {
  static final phoneNumberFormat =
      RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9]', caseSensitive: true);

  final isStringNull = StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink) {
      if (data == null) {
        sink.addError('Name is Mandatory');
      } else {
        sink.add(data.trim());
      }
    },
  );

  final isPhoneNumber = StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink) {
      if (data == null || data.trim().isEmpty) {
        sink.addError('phone number is Mandatory');
      } else if (data.trim().length < 10 ||
          data.trim().length > 10 ||
          !phoneNumberFormat.hasMatch(data.trim())) {
        sink.addError('Enter valid phone number');
      } else {
        sink.add(data.trim());
      }
    },
  );
}
