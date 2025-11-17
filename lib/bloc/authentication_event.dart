part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}

class SignUpRequested extends AuthenticationEvent {
  final String email;
  final String password;
  final String name;
  final String phone;

  SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
  });
}
