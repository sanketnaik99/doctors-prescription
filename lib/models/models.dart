class AuthenticationResult {
  final String message;
  final bool result;

  AuthenticationResult({this.message, this.result});
}

class UserData {
  final String email;
  final String uid;
  final String userType;
  final String username;

  UserData({this.email, this.userType, this.uid, this.username});
}
