class DeviceModel {
  /// Device name.
  final String? name;

  /// The name of the current operating system.
  final String? systemName;

  /// The current operating system version.
  final String? systemVersion;

  /// Device model.
  final String? model;

  /// Localized name of the device model.
  final String? localizedModel;

  /// Unique UUID value identifying the current device.
  final String? identifierForVendor;

  /// `false` if the application is running in a simulator, `true` otherwise.
  final bool? isPhysicalDevice;

  /// Versionnumber of the installed App
  final String? appVersionNumber;

  /// Buildnumber of the installed app version
  final String? appBuildNumer;

  /// Operating System
  final String? os;

  DeviceModel({
    this.name,
    this.systemName,
    this.systemVersion,
    this.model,
    this.localizedModel,
    this.identifierForVendor,
    this.isPhysicalDevice,
    this.appVersionNumber,
    this.appBuildNumer,
    this.os,
  });

  DeviceModel copyWith({
    String? name,
    String? systemName,
    String? systemVersion,
    String? model,
    String? localizedModel,
    String? identifierForVendor,
    bool? isPhysicalDevice,
    String? appVersionNumber,
    String? appBuildNumer,
    String? os,
  }) {
    return DeviceModel(
      name: name ?? this.name,
      systemName: systemName ?? this.systemName,
      systemVersion: systemVersion ?? this.systemVersion,
      model: model ?? this.model,
      localizedModel: localizedModel ?? this.localizedModel,
      identifierForVendor: identifierForVendor ?? this.identifierForVendor,
      isPhysicalDevice: isPhysicalDevice ?? this.isPhysicalDevice,
      appVersionNumber: appVersionNumber ?? this.appVersionNumber,
      appBuildNumer: appBuildNumer ?? this.appBuildNumer,
      os: os ?? this.os,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'systemName': systemName,
      'systemVersion': systemVersion,
      'model': model,
      'localizedModel': localizedModel,
      'identifierForVendor': identifierForVendor,
      'isPhysicalDevice': isPhysicalDevice,
      'appVersionNumber': appVersionNumber,
      'appBuildNumer': appBuildNumer,
      'os': os,
    };
  }

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      name: map['name'] as String,
      systemName: map['systemName'] as String,
      systemVersion: map['systemVersion'] as String,
      model: map['model'] as String,
      localizedModel: map['localizedModel'] as String,
      identifierForVendor: map['identifierForVendor'] as String,
      isPhysicalDevice: map['isPhysicalDevice'] as bool,
      appVersionNumber: map['appVersionNumber'] as String,
      appBuildNumer: map['appBuildNumer'] as String,
      os: map['os'] as String,
    );
  }
}
