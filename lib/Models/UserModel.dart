
class UserModel {
  static final storageKey = "userModel";
  int userId;
    
  UserModel({this.userId});

  UserModel.fromJson(Map<String, dynamic> json)
    : userId = json['userId'];

  Map<String, dynamic> toJson() => {
    'userId': userId,
  };
}