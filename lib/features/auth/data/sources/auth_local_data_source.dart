import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(User user);
  Future<User?> getUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const _userKey = 'cached_user';

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheUser(User user) async {
    await sharedPreferences.setString(_userKey, json.encode(user.toJson()));
  }

  @override
  Future<User?> getUser() async {
    final userStr = sharedPreferences.getString(_userKey);
    if (userStr != null) {
      return User.fromJson(json.decode(userStr));
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_userKey);
  }
}
