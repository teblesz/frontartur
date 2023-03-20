import 'package:formz/formz.dart';

/// Validation errors for the [RoomId] [FormzInput].
enum RoomIdValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template roomid}
/// Form input for an roomId input.
/// {@endtemplate}
class RoomId extends FormzInput<String, RoomIdValidationError> {
  /// {@macro roomId}
  const RoomId.pure() : super.pure('');

  /// {@macro roomId}
  const RoomId.dirty([super.value = '']) : super.dirty();

  @override
  RoomIdValidationError? validator(String? value) {
    return (value ?? '').isNotEmpty ? null : RoomIdValidationError.invalid;
  }
}
