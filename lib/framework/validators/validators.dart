
// class Validators {
//   static final RegExp _passwordRegExp = RegExp(
//     r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,}$',
//   );

//   static isValidEmail(String email) {
//     return EmailValidator.validate(email);
//   }

//   static isValidPassword(String password) {
//     return _passwordRegExp.hasMatch(password);
//   }

//   static String minLength(String value) {
//     if (value.isEmpty ||
//         ((value is Iterable || value is String || value is Map) &&
//                 value.length == 0 ||
//             value.length < 3)) {
//       return ValidatorErrors.minLengthThreeChars;
//     }
//     return '';
//   }
// }

// class ValidatorErrors {
//   ValidatorErrors._();

//   static const String minLengthThreeChars = 'Minimum length 3 characters';
// }
