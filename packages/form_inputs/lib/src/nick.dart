import 'package:formz/formz.dart';

/// Validation errors for the [Nick] [FormzInput].
enum NickValidationError {
  /// Generic invalid error.
  invalid
}

class Nick extends FormzInput<String, NickValidationError> {
  /// {@macro passwordOnLogin}
  const Nick.pure() : super.pure('');

  /// {@macro passwordOnLogin}
  const Nick.dirty([super.value = '']) : super.dirty();

  @override
  NickValidationError? validator(String? value) {
    if (!(value ?? '').isNotEmpty) return NickValidationError.invalid;
    if (value!.length > 13) return NickValidationError.invalid;
    return null;
  }
}
