class ResetPassParam {
  final String uid;
  final String token;
  final String newPassword;

  ResetPassParam({
    required this.uid,
    required this.token,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['token'] = token;
    data['new_password'] = newPassword;
    return data;
  }
}
