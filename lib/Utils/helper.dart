class Helper {

  static bool isNullOrEmpty(String value) {
    if (value == null) {
      return true;
    }
    return value.isEmpty;
  }
}