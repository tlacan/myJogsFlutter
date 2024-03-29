import 'package:geolocator/geolocator.dart';

import 'package:my_jogs/Models/positionModel.dart';
import 'package:my_jogs/Utils/helper.dart';

class JogModel {
  static final storageKey = "jogModel";
  int id;
  int userId;
  List<PositionModel> position;
  DateTime beginDate;
  DateTime endDate;
  double distance;

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

  Future<double> computedTotalDistance() async {
        double result = 0;
        var index = 0;
        for (var pos in position ?? List()) {
          index++;
          if (index < position.length) {
            final secondPos = position[index];
            double distance = await Geolocator().distanceBetween(pos.lat, pos.lon, secondPos.lat, secondPos.lon);
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
      'id': id,
      'userId': userId,
      'position': position == null ? null : position.map((value) => value.toJson()).toList(),
      'beginDate': Helper.dateISO8601Short(beginDate),
      'endDate': Helper.dateISO8601Short(endDate)
    };
  } 
}