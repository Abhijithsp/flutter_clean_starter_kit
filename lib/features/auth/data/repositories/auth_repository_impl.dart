import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/auth_local_data_source.dart';

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
