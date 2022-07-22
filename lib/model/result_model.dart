class resultModel {
  String? resultId;
  String? userId;
  String? psychologyId;
  String? condition;
  String? resultTime;
  String? resultDate;

  resultModel({
    this.resultId,
    this.userId,
    this.psychologyId,
    this.condition,
    this.resultTime,
    this.resultDate,
  });

//Receive Data from Server

  factory resultModel.fromMap(map) {
    return resultModel(
      resultId: map['resultId'],
      userId: map['userId'],
      psychologyId: map['psychologyId'],
      condition: map['condition'],
      resultTime: map['resultTime'],
      resultDate: map['resultDate'],
    );
  }

  //Sending Data to the Server
  Map<String, dynamic> toMap() {
    return {
      'resultId': resultId,
      'userId': userId,
      'psychologyId': psychologyId,
      'condition': condition,
      'resultTime': resultTime,
      'resultDate': resultDate,
    };
  }
}
