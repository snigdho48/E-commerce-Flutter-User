import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeUtils{
  static final light= ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  );
  static final dark= ThemeData(
  primarySwatch: Colors.red,
  brightness: Brightness.dark,

  );
}
class ThemeServices{
     final _box= GetStorage();
     final _key='isDarkMode';
     _saveTheme(bool isDarkMode)=>_box.write(_key, isDarkMode);
     bool loadTheme()=> _box.read(_key)??false;
     ThemeMode get theme=> loadTheme()?ThemeMode.dark:ThemeMode.light;

     void swtichTheme(){
       Get.changeThemeMode(loadTheme()?ThemeMode.light:ThemeMode.dark);
       _saveTheme(!loadTheme());
     }
}

