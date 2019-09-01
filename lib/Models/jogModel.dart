import 'package:geolocator/geolocator.dart';

import 'package:my_jogs/Models/positionModel.dart';

class JogModel {
  static final storageKey = "jogModel";
  int id;
  int userId;
  List<PositionModel> position;
  DateTime beginDate;
  DateTime endDate;

  JogModel({this.id, this.userId, this.position, this.beginDate, this.endDate});


  JogModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      userId = json['userId'],
      position = json['position'] == null ? null : PositionModel.fromJsonArray(json['position']),
      beginDate = json['beginDate'] is String ? DateTime.parse(json['beginDate']) : json['beginDate'],
      endDate = json['endDate'] is String ? DateTime.parse(json['endDate']) : json['endDate']
      ;

  static List<JogModel> fromJsonArray(List<dynamic> jsonList) {
    List<JogModel> result = List();
    for (Map<String, dynamic> jsonElement in jsonList) {
      result.add(JogModel.fromJson(jsonElement));
    }
    return result;
  }

  static Future<double> totalDistanceFrom(List<PositionModel> positions) async {
        double result = 0;
        var index = 0;
        for (var position in positions ?? List()) {
          index++;
          if (index < positions.length) {
            final secondPosition = positions[index];
            double distance = await Geolocator().distanceBetween(position.lat, position.lon, secondPosition.lat, secondPosition.lon);
            if (distance != null) {
              result += distance;
            }
          }
        }
        return result;
  }

  List<Map<String, dynamic>> positionsToJSON() {
    var result = List();
    for (var pos in position ?? List()) {
      result.add(pos.toJson());
    }
    return result;
  }

  Map<String, dynamic> toJson() {   
      return {
      'id': id.toString(),
      'userId': userId.toString(),
      'position': position == null ? null : position.map((value) => value.toJson()).toList(),
      'beginDate': beginDate == null ? null : beginDate.toIso8601String(),
      'endDate': endDate == null ? null : endDate.toIso8601String()
    };
  } 
}