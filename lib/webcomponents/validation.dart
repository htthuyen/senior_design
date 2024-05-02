extension StringExtensions on String {


  bool isValidEmail() {
    return RegExp(
              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'

    ).hasMatch(this);

  }

  bool isWhitespace() => this.trim().isEmpty;
  bool isValidAmount() {
    return RegExp(
      r'^(0|[1-9][0-9]{0,2})(,\d{3})*(\.\d{1,2})?'

    ).hasMatch(this);
  }
  bool isValidPhoneNumber() {
    return RegExp(
      r'^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$'
    ) .hasMatch(this);
  }

  bool isValidPassword(){
    return RegExp(
      r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$'
    ).hasMatch(this);
  }
}