
class UserModel {
  static final storageKey = "userModel";
  int userId;
  String email;
    
  UserModel({this.userId, this.email});

  UserModel.fromJson(Map<String, dynamic> json)
    : userId = json['userId'],
      email = json['email'];

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
  };
}