class Validators {

  static String? validateEmail({
    required String email
  }){
    if( email.trim().isEmpty ){
      return 'Please enter your email.';
    }
    if( !email.trim().contains('@') ){
      return 'Please enter a valid email.';
    }
    return null;
  }
  
  static String? validatePassword({
    required String password,
  }) {
    if (password.trim().isEmpty) {
      return 'Please enter your password.';
    }
    if (password.trim().length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }
  
  static String? validatePasswordMatch({
    required String password,
    required String confirmPassword,
  }) {
    if (password.trim().isEmpty || confirmPassword.trim().isEmpty) {
      return "Password fields can't be empty.";
    }
    if (password.trim() != confirmPassword.trim()) {
      return "Passwords do not match.";
    }
    return null;
  }

  static String? validateUsername({
    required String username
  }){
    if(username.trim().isEmpty){
      return 'Please enter a Username.';
    }
    if(username.trim().length < 5){
      return 'Username must be atleast 5 characters long.';
    }
    return null;
  }
  
  static String? validateResetPassword({
    required String code,
    required String password,
    required String confirmPassword,
  }){
    if(code.trim().isEmpty){
      return 'Please enter the code from your email.';
    }
    validatePassword(password: password);
    validatePassword(password: confirmPassword);
    validatePasswordMatch(password: password, confirmPassword: confirmPassword);

    return null;
  }

  static String? validateProduct({
    required String itemName,
    required int? price,
    required int? stock,
    required int? percent,
  }){
    if(itemName.isEmpty) return 'Item name is required';
    if(price == null) return 'Price is required.';
    if(price < 1) return 'Price cannot be 0 or negative.';
    if(stock == null) return 'Stock is required';
    if(stock < 0) return 'Stock cannot be negative';
    if(percent != null){
      if(percent < 1 || percent > 99) return 'Sale percent must be between 1 and 99.';
    }
    return null;
  }
}