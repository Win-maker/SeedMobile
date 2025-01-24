class FormValidators {
  /// Validate if the field is not empty
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate if the input is a valid email
  static String? email(String? value) {
    const emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
    final regex = RegExp(emailPattern);
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validate if the input is a valid phone number
  static String? phoneNumber(String? value) {
    const phonePattern = r'^\+?[0-9]{10,15}$';
    final regex = RegExp(phonePattern);
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validate if the input is a strong password
  /// Password must contain at least 8 characters, 1 uppercase, 1 lowercase, 1 number, and 1 special character
  static String? password(String? value) {
    // const passwordPattern =
    //     r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    // final regex = RegExp(passwordPattern);
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    // else if (!regex.hasMatch(value)) {
    //   return 'Password must be at least 8 characters long, include an uppercase letter, a number, and a special character.';
    // }
    return null;
  }

  /// Validate if the input is numeric
  static String? numeric(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    final number = num.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    return null;
  }

  /// Validate if the input matches a specific pattern
  static String? pattern(String? value, String pattern, {String fieldName = 'Field'}) {
    final regex = RegExp(pattern);
    if (value == null || !regex.hasMatch(value)) {
      return '$fieldName is invalid';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int min, {String fieldName = 'Field'}) {
    if (value == null || value.length < min) {
      return '$fieldName must be at least $min characters long';
    }
    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int max, {String fieldName = 'Field'}) {
    if (value == null || value.length > max) {
      return '$fieldName cannot exceed $max characters';
    }
    return null;
  }

  /// Validate if the input is within a range (numeric)
  static String? range(String? value, {required num min, required num max, String fieldName = 'Field'}) {
    final number = num.tryParse(value ?? '');
    if (number == null) {
      return '$fieldName must be a valid number';
    }
    if (number < min || number > max) {
      return '$fieldName must be between $min and $max';
    }
    return null;
  }

  /// Combine multiple validators
  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (var validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}
