
class PositionModel {
  double lat;
  double lon;

  PositionModel({this.lat, this.lon});
  
  PositionModel.fromJson(Map<String, dynamic> json)
    : lat = json['lat'],
      lon = json['lon'];
  
  static List<PositionModel> fromJsonArray(List<dynamic> jsonList) {
    List<PositionModel> result = List();
    for (Map<String, dynamic> jsonElement in jsonList ?? List()) {
      result.add(PositionModel.fromJson(jsonElement));
    }
    return result;
  }

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lon': lon,
  };
}