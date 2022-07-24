import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

class SecureStorage{
  final _storage = FlutterSecureStorage();

  Future writeSecureData({@required String key, @required String value})  async {
    var writeData = await _storage.write(key: key, value: value);
    return writeData;
  }
  Future readSecureData({@required String key}) async {
    var readData = await _storage.read(key: key);
    return readData;
  }
  Future deleteSecureData({@required String key}) async{
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }

}