class SettingsModel {
  static final storageKey = "settingsModel";
  double speedTarget;
  double toleranceValue;

  SettingsModel({this.speedTarget, this.toleranceValue});

  static SettingsModel defaultValue() {
    return SettingsModel(speedTarget: 10, toleranceValue: 0.1);
  }

  SettingsModel.fromJson(Map<String, dynamic> json)
    : speedTarget = json['speedTarget'],
      toleranceValue = json['toleranceValue'];

  Map<String, dynamic> toJson() => {
    'speedTarget': speedTarget,
    'toleranceValue': toleranceValue,
  };
}