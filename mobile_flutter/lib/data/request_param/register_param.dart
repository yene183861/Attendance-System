class RegisterParams {
  final String nickname;
  final String email;
  final String password;

  RegisterParams({
    required this.nickname,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nickname'] = nickname;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
