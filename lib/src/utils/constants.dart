class Constants {
  static final Constants _constants = Constants._();
  factory Constants() => _constants;
  Constants._();

  static const int PORT = 80;
  static const PROTOCOL_DEV = 'http';
  static String hostDev = 'abf.prep800.com'; //'192.168.1.8';
  static const String GOOGLE_KEY_DEV =
      'AIzaSyDu48xt0xEO-BCUB5vVcWrpHYcIbsWOUII';
  static const String DOCUMENT_PATH_PREFIX_DEV = '';
  static const PROTOCOL_PROD = 'http';
  static const String HOST_PROD = 'abf.prep800.com';
  static const String GOOGLE_KEY_PROD =
      'AIzaSyDu48xt0xEO-BCUB5vVcWrpHYcIbsWOUII';
  static const String KEY_CURRENT_VERSION = "";
  static const String KEY_UPDATE_REQUIRED = "";

  static const DIALOG_TYPE_CONFIRMATION = 'confirmation';

  static const String API_BASE_URL = '/api';
  static const String LOGIN_API = '$API_BASE_URL/log/in';
  static const String SIGNUP_API = '$API_BASE_URL/sign/up';
  static const String GET_PROFILE_API = '$API_BASE_URL/get/profile';
  static const String UPDATE_PROFILE_API = '$API_BASE_URL/update/profile';
  static const String VERIFY_OTP_API = '$API_BASE_URL/verify/otp';
  static const String RESEND_OTP_API = '$API_BASE_URL/resend/otp';
  static const String SEARCH_CAR_API = '$API_BASE_URL/get/cars';
  static const String SERVICES_API = '$API_BASE_URL/get/services';
  static const String BOOK_NOW_API = '$API_BASE_URL/book/now';
  static const String BOOK_LATER_API = '$API_BASE_URL/book/later';
  static const String REPEAT_SERVICE_API = '$API_BASE_URL/repeat/booking';
  static const String GET_BOOKINGS_API = '$API_BASE_URL/my/bookings';
  static const String NOTIFICATION = '$API_BASE_URL/notifications';
  static const String SUPPORT = '$API_BASE_URL/contact/us';
  static const String FORGET_PASSWORD = '$API_BASE_URL/forgot/password';
  static const int BASE_COLOR = 0xFF00B1DA;

  // String constants
  static const String ACCESS_TOKEN = 'accessToken';
}
