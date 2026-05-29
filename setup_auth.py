import os

files = {
    "lib/features/auth/domain/entities/user.dart": """
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
""",
    "lib/features/auth/domain/repositories/auth_repository.dart": """
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
  Future<void> logout();
  Future<User?> getCachedUser();
}
""",
    "lib/features/auth/data/sources/auth_local_data_source.dart": """
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
""",
    "lib/features/auth/data/repositories/auth_repository_impl.dart": """
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/auth_local_data_source.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<User> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty) {
      final user = User(id: '1', email: email, name: 'John Doe');
      await localDataSource.cacheUser(user);
      return user;
    }
    throw Exception('Invalid credentials');
  }

  @override
  Future<User> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = User(id: '2', email: email, name: name);
    await localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearCache();
  }

  @override
  Future<User?> getCachedUser() async {
    return await localDataSource.getUser();
  }
}

@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return await SharedPreferences.getInstance();
}

@riverpod
Future<AuthLocalDataSource> authLocalDataSource(AuthLocalDataSourceRef ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return AuthLocalDataSourceImpl(prefs);
}

@riverpod
Future<AuthRepository> authRepository(AuthRepositoryRef ref) async {
  final localDataSource = await ref.watch(authLocalDataSourceProvider.future);
  return AuthRepositoryImpl(localDataSource);
}
""",
    "lib/features/auth/presentation/providers/auth_provider.dart": """
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user.dart';
import '../../data/repositories/auth_repository_impl.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<User?> build() async {
    final repo = await ref.watch(authRepositoryProvider.future);
    return await repo.getCachedUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.watch(authRepositoryProvider.future);
      return await repo.login(email, password);
    });
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.watch(authRepositoryProvider.future);
      return await repo.register(name, email, password);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final repo = await ref.watch(authRepositoryProvider.future);
    await repo.logout();
    state = const AsyncValue.data(null);
  }
}
"""
}

for file_path, content in files.items():
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(content.strip() + "\n")

print("Domain and data files generated successfully!")
