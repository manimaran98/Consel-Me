// ignore: camel_case_types
class bookingModel {
  String? bookingId;
  String? psychologyName;
  String? psychologyId;
  String? imgUrl;
  String? user_id;
  String? bookingDate;
  String? bookingTime;
  String? bookingFee;
  String? bookingStatus;

  bookingModel({
    this.bookingId,
    this.psychologyName,
    this.psychologyId,
    this.user_id,
    this.imgUrl,
    this.bookingDate,
    this.bookingTime,
    this.bookingFee,
    this.bookingStatus,
  });

//Receive Data from Server

  factory bookingModel.fromMap(map) {
    return bookingModel(
      bookingId: map['bookingId'],
      psychologyName: map['psychologyName'],
      psychologyId: map['psychologyId'],
      imgUrl: map['imgUrl'],
      user_id: map['user_id'],
      bookingDate: map['bookingDate'],
      bookingTime: map['bookingTime'],
      bookingFee: map['bookingFee'],
      bookingStatus: map['bookingStatus'],
    );
  }

  //Sending Data to the Server
  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'imgUrl': imgUrl,
      'psychologyName': psychologyName,
      'psychologyId': psychologyId,
      'user_id': user_id,
      'bookingDate': bookingDate,
      'bookingTime': bookingTime,
      'bookingFee': bookingFee,
      'bookingStatus': bookingStatus
    };
  }
}
