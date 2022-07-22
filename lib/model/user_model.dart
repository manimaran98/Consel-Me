class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? mobile;
  String? icNum;
  String? birthDate;
  String? gender;
  String? occupation;
  String? role;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.mobile,
    this.birthDate,
    this.gender,
    this.icNum,
    this.occupation,
    this.role,
  });

//Receive Data from Server

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['user_id'],
      email: map['email'],
      firstName: map['firstName'],
      mobile: map['mobile'],
      icNum: map['icNum'],
      birthDate: map['birthDate'],
      gender: map['gender'],
      occupation: map['occupation'],
      role: map['role'],
    );
  }

  //Sending Data to the Server
  Map<String, dynamic> toMap() {
    return {
      'user_id': uid,
      'email': email,
      'firstName': firstName,
      'mobile': mobile,
      'icNum': icNum,
      'birthDate': birthDate,
      'gender': gender,
      'occupation': occupation,
      'role': role,
    };
  }
}
