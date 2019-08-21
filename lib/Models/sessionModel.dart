

class SessionModel {
  static final storageKey = "sessionModel";
  String token;
    
  SessionModel({this.token});

  SessionModel.fromJson(Map<String, dynamic> json)
    : token = json['token'];

  Map<String, dynamic> toJson() => {
    'token': token,
  };
}

