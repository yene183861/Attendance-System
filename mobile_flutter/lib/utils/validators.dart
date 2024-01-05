import 'package:formz/formz.dart';
import 'pattern.dart';
import 'validation_error.dart';

// Function support Validator
class Validators {
  static bool isValidEmail(String email) {
    return RegexPattern.emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length > 5;
  }

  static bool isValidName(String name) {
    return name.isNotEmpty;
  }

  static bool isValidPhone(String phone) {
    return RegexPattern.phoneRegExp.hasMatch(phone);
  }

  static bool isValidZipCode(String zipCode) {
    return RegexPattern.zipCodeRegExp.hasMatch(zipCode);
  }
}

class Phone extends FormzInput<String, ValidationError> {
  const Phone.pure() : super.pure('');

  const Phone.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    if (value.isEmpty) {
      return ValidationError.empty;
    } else {
      final isValid = Validators.isValidPhone(value);
      return isValid ? null : ValidationError.invalid;
    }
  }
}

class Password extends FormzInput<String, ValidationError> {
  const Password.pure() : super.pure('');

  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    if (value.isEmpty) {
      return ValidationError.empty;
    }
    final isValid = Validators.isValidPassword(value);
    return isValid ? null : ValidationError.invalid;
  }
}

class Email extends FormzInput<String, ValidationError> {
  const Email.pure() : super.pure('');

  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    if (value.isEmpty) {
      return ValidationError.empty;
    } else {
      final isValid = Validators.isValidEmail(value);
      return isValid ? null : ValidationError.invalid;
    }
  }
}

class FullName extends FormzInput<String, ValidationError> {
  const FullName.pure() : super.pure('');

  const FullName.dirty([String value = '']) : super.dirty(value);

  @override
  ValidationError? validator(String value) {
    if (value.isEmpty) {
      return ValidationError.empty;
    } else {
      return (value.isNotEmpty && value.length >= 2)
          ? null
          : ValidationError.invalid;
    }
  }
}