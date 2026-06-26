import 'package:google_sign_in/google_sign_in.dart';

/// Wraps GoogleSignIn plugin for consistent access from the repository.
class GoogleSignInService {
  GoogleSignInService({GoogleSignIn? googleSignIn})
      : _googleSignIn = googleSignIn ?? GoogleSignIn();

  final GoogleSignIn _googleSignIn;

  Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();

  Future<GoogleSignInAuthentication> authentication(
    GoogleSignInAccount account,
  ) {
    return account.authentication;
  }

  Future<void> signOut() => _googleSignIn.signOut();
}

