class ChangePasswordParam {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePasswordParam({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['old_password'] = oldPassword;
    data['new_password'] = newPassword;
    data['confirm_password'] = confirmPassword;

    return data;
  }
}
