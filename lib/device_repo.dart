import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'device_model.dart';

class DeviceRepository {
  DeviceModel? deviceModel;
  get isLocationPermissionEnable => _handleLocationPermission();

  Future<DeviceModel?> getDevice() async {
    try {
      DeviceModel? device;

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        device = DeviceModel(
          name: iosInfo.name,
          systemName: iosInfo.systemName,
          systemVersion: iosInfo.systemVersion,
          model: iosInfo.model,
          localizedModel: iosInfo.localizedModel,
          identifierForVendor: iosInfo.identifierForVendor,
          isPhysicalDevice: iosInfo.isPhysicalDevice,
          os: 'iOS',
        );
      } else if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        device = DeviceModel(
          name: androidInfo.device,
          systemName: androidInfo.host,
          systemVersion: androidInfo.version.release,
          model: androidInfo.model,
          localizedModel: androidInfo.product,
          identifierForVendor: androidInfo.id,
          isPhysicalDevice: androidInfo.isPhysicalDevice,
          os: 'android',
        );
      }

      return device?.copyWith(
        appVersionNumber: packageInfo.version,
        appBuildNumer: packageInfo.buildNumber,
      );
    } catch (exception) {
      log('DeviceModel exception: $exception');
      return DeviceModel();
    }
  }

  Future<String?> getIP() async {
    final info = NetworkInfo();
    var wifiIP = await info.getWifiIP();
    return wifiIP;
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<Position?> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;
    final location = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return location;
  }
}
