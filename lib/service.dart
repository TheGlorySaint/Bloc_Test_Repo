import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt services = GetIt.instance;

setupServices() {
  services.registerSingletonAsync<SharedPreferences>(() async {
    debugPrint('shared preferences - get instance ...');
    return await SharedPreferences.getInstance();
  });
}
