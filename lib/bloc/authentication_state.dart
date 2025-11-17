part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

class AuthInitial extends AuthenticationState {}

class AuthLoading extends AuthenticationState {}

class AuthSuccess extends AuthenticationState {}

class AuthFailure extends AuthenticationState {
  final String error;

  AuthFailure(this.error);
}
