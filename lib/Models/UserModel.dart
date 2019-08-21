
class UserModel {
  static final storageKey = "userModel";
  int userId;
  String email;
  String password;
    
  UserModel({this.userId, this.email, this.password});

  UserModel.fromJson(Map<String, dynamic> json)
    : userId = json['userId'];

  Map<String, dynamic> toJson() => {
    'userId': userId,
  };
}