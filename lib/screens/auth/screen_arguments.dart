class ScreenArguments {
  final String type;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? accessToken;
  final String? refreshToken;
  ScreenArguments({
    required this.type,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.accessToken,
    this.refreshToken,
  });
}
