import 'package:encrypt/encrypt.dart';

class SessionModel {
  static final storageKey = "sessionModel";
  static final String kEncryptionKey = "NYXDo432lengthkeykC1uqwscfghjkiu";
  static final iv = IV.fromLength(16);
  String token;
    
  SessionModel({this.token});

  SessionModel.fromJson(Map<String, dynamic> json)
    : token = json['token'];

  Map<String, dynamic> toJson() => {
    'token': token,
  };

  static Encrypter encrypter() {
    final key = Key.fromUtf8(SessionModel.kEncryptionKey);
    return Encrypter(AES(key));
  }

  SessionModel encrypted() {
    final encrypted = encrypter().encrypt(token ?? "", iv: iv).base64;
    return SessionModel(token: encrypted);
  }

  SessionModel decrypted() {
    final encrypted = Encrypted.fromBase64(token);
    final decrypted = encrypter().decrypt(encrypted, iv: iv);
    return SessionModel(token: decrypted);
  }

}

