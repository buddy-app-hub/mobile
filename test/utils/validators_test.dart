import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/utils/validators.dart';

const invalidMailResponse = 'Ingresá un correo electrónico válido';
const invalidPasswordResponse = 'Ingresá una contraseña';
const invalidNameResponse = 'Ingresá un nombre';
const passwordShortResponse = 'La contraseña debe tener al menos 6 caracteres';
const passwordsDontMatchResponse = 'Las contraseñas no coinciden';

void main() {
  group('validateEmail', () {
    test('returns error for null email', () {
      expect(validateEmail(null), equals(invalidMailResponse));
    });

    test('returns error for empty email', () {
      expect(validateEmail(''), equals(invalidMailResponse));
    });

    test('returns error for invalid email', () {
      expect(validateEmail('invalid-email'), equals(invalidMailResponse));
    });

    test('returns null for valid email', () {
      expect(validateEmail('test@example.com'), isNull);
    });
  });

  group('validatePassword', () {
    test('returns error for null password', () {
      expect(validatePassword(null), equals(invalidPasswordResponse));
    });

    test('returns error for empty password', () {
      expect(validatePassword(''), equals(invalidPasswordResponse));
    });

    test('returns error for short password', () {
      expect(validatePassword('12345'), equals(passwordShortResponse));
    });

    test('returns null for valid password', () {
      expect(validatePassword('123456'), isNull);
    });
  });

  group('validateConfirmPassword', () {
    test('returns error for null confirm password', () {
      expect(validateConfirmPassword(null, 'password'), equals(invalidPasswordResponse));
    });

    test('returns error for empty confirm password', () {
      expect(validateConfirmPassword('', 'password'), equals(invalidPasswordResponse));
    });

    test('returns error for short confirm password', () {
      expect(validateConfirmPassword('12345', 'password'), equals(passwordShortResponse));
    });

    test('returns error for non-matching passwords', () {
      expect(validateConfirmPassword('password1', 'password2'), equals(passwordsDontMatchResponse));
    });

    test('returns null for matching passwords', () {
      expect(validateConfirmPassword('password', 'password'), isNull);
    });
  });

  group('validateName', () {
    test('returns error for null name', () {
      expect(validateName(null), equals(invalidNameResponse));
    });

    test('returns error for empty name', () {
      expect(validateName(''), equals(invalidNameResponse));
    });

    test('returns null for valid name', () {
      expect(validateName('John Doe'), isNull);
    });
  });
}
