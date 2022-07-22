// ignore: camel_case_types
class psychologyModel {
  String? psychologyId;
  String? psychologyName;
  String? gender;
  String? special;
  String? price;
  String? imgUrl;

  psychologyModel({
    this.psychologyId,
    this.psychologyName,
    this.gender,
    this.special,
    this.price,
    this.imgUrl,
  });

//Receive Data from Server

  factory psychologyModel.fromMap(map) {
    return psychologyModel(
      psychologyId: map['psychologyId'],
      psychologyName: map['psychologyName'],
      gender: map['gender'],
      special: map['special'],
      price: map['price'],
      imgUrl: map['imgUrl'],
    );
  }

  //Sending Data to the Server
  Map<String, dynamic> toMap() {
    return {
      'psychologyId': psychologyId,
      'psychologyName': psychologyName,
      'gender': gender,
      'special': special,
      'price': price,
      'imgUrl': imgUrl,
    };
  }
}
