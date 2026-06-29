class Validator {
  // Email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    if (!value.contains('@')) {
      return "Enter valid email";
    }
    return null;
  }

  //password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter a password";
    }
    if (value.length < 8) {
      return "Password should be atleast 6 characters";
    }
    return null;
  }
  // confirm password

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Confirm your password";
    }
    if (value != password) {
      return " Password donot match";
    }
    return null;
  }
}
