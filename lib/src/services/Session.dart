import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session{
  static Future<SharedPreferences> _sharedPreference() async {
    return SharedPreferences.getInstance();
  }

  static Future<bool> isVerified() async {
    SharedPreferences _prefs = await _sharedPreference();
    final status = _prefs.getBool("verified") ?? false;
    return status;
  }

  static setVerified({@required bool isVerified}) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setBool("verified", isVerified);
  }


  static setToken({@required String tokenAPI}) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("token", tokenAPI);
  }

  static Future<String> getToken() async {
    SharedPreferences _prefs = await _sharedPreference();
    final token = _prefs.getString("token") ?? "";
    return token;
  }

  static setAdmin({@required String key}) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("isAdmin", key);
  }

  static Future<String> getAdmin() async {
    SharedPreferences _prefs = await _sharedPreference();
    final admin = _prefs.getString("isAdmin") ?? "";
    return admin;
  }

  static setUID({@required String uid}) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("uid", uid);
  }

  static Future<String> getUID() async {
    SharedPreferences _prefs = await _sharedPreference();
    final uid = _prefs.getString("uid") ?? "";
    return uid;
  }

  static setFullName({@required String fullName}) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("fullName", fullName);
  }

  static Future<String> getFullName() async {
    SharedPreferences _prefs = await _sharedPreference();
    final fullName = _prefs.getString("fullName") ?? "";
    return fullName;
  }


  static setListDriverDetails({@required List<String> listDetails}) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setStringList("listDriverDetails", listDetails);
  }

  static Future<List<String>> getListDriverDetails() async {
    SharedPreferences _prefs = await _sharedPreference();
    final list = _prefs.getStringList("listDriverDetails") ?? [];
    return list;
  }

  static setListVehicleDetails({@required List<String> listDetails}) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setStringList("listVehicleDetails", listDetails);
  }

  static Future<List<String>> getListVehicleDetails() async {
    SharedPreferences _prefs = await _sharedPreference();
    final list = _prefs.getStringList("listVehicleDetails") ?? [];
    return list;
  }

  static setListViolations({@required List<String> listViolations}) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setStringList("listViolations", listViolations);
  }

  static Future<List<String>> getListViolations() async {
    SharedPreferences _prefs = await _sharedPreference();
    final list = _prefs.getStringList("listViolations") ?? [];
    return list;
  }

}