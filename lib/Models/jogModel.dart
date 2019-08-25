import 'package:my_jogs/Models/positionModel.dart';

class JogModel {
  static final storageKey = "jogModel";
  int id;
  int userId;
  List<PositionModel> position;
  DateTime beginDate;
  DateTime endDate;
  double totalDistance;

  JogModel({this.id, this.userId, this.position, this.beginDate, this.endDate, this.totalDistance});


  JogModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      userId = json['userId'],
      position = PositionModel.fromJsonArray(json['position']),
      beginDate = json['beginDate'],
      endDate = json['endDate'],
      totalDistance = json['totalDistance']
      ;

  static List<JogModel> fromJsonArray(List<dynamic> jsonList) {
    List<JogModel> result = List();
    for (Map<String, dynamic> jsonElement in jsonList) {
      result.add(JogModel.fromJson(jsonElement));
    }
    return result;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'position': position,
    'beginDate': beginDate,
    'endDate': endDate,
    'totalDistance': totalDistance,
  };
}