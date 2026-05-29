import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthState.initial());

  Future<void> checkSession() async {
    emit(const AuthState.loading());
    try {
      final user = await authRepository.getCachedUser();
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());
    try {
      final user = await authRepository.login(email, password);
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(const AuthState.loading());
    try {
      final user = await authRepository.register(name, email, password);
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> logout() async {
    emit(const AuthState.loading());
    try {
      await authRepository.logout();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
