import 'package:formz/formz.dart';

/// Validation errors for the [passwordOnLogin] [FormzInput].
enum PasswordValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template passwordOnSignup}
/// Form input for an passwordOnLogin input.
/// {@endtemplate}
class PasswordOnSignup extends FormzInput<String, PasswordValidationError> {
  /// {@macro passwordOnSignup}
  const PasswordOnSignup.pure() : super.pure('');

  /// {@macro passwordOnSignup}
  const PasswordOnSignup.dirty([super.value = '']) : super.dirty();

  static final _passwordRegExp =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  PasswordValidationError? validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '')
        ? null
        : PasswordValidationError.invalid;
  }
}

/// {@template passwordOnLogin}
/// Form input for an passwordOnLogin input.
/// {@endtemplate}
class PasswordOnLogin extends FormzInput<String, PasswordValidationError> {
  /// {@macro passwordOnLogin}
  const PasswordOnLogin.pure() : super.pure('');

  /// {@macro passwordOnLogin}
  const PasswordOnLogin.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String? value) {
    return (value ?? '').isNotEmpty ? null : PasswordValidationError.invalid;
  }
}
