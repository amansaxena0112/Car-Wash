class UserModel {
  String name;
  String mobile;
  String email;
  String password;
  String accessToken;
  String profile;
  String dob;

  UserModel({
    this.name,
    this.email,
    this.mobile,
    this.password,
    this.accessToken,
    this.profile,
    this.dob,
  });

  UserModel.fromMap(Map<String, dynamic> record) {
    name = record['full_name'] != null ? record['full_name'] : '';
    mobile = record['mobile'] != null ? record['mobile'] : '';
    email = record['email'] != null ? record['email'] : '';
    password = record['password'] != null ? record['password'] : '';
    accessToken = record['token'] != null ? record['token'] : '';
    profile = record['profile'] != null ? record['profile'] : '';
    dob = record['dob'] != null ? record['dob'] : '';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'full_name': name,
      'mobile': mobile,
      'email': email,
      'password': password,
      'token': accessToken,
      'profile': profile,
      'dob': dob,
    };
  }
}
