class AuthenticationRepository {
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    // здесь может быть твоя логика или обращение к API
    await Future.delayed(const Duration(seconds: 1));
    print('User registered: $email');
  }
}
