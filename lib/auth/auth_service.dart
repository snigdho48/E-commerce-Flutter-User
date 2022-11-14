import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static UserCredential? usercredential;
  static OAuthCredential? oAuthCredential;
  static final _auth = FirebaseAuth.instance;
  static User? get currentUser => _auth.currentUser;

  static Future<bool> login(String email, String password) async {
    final usercredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return usercredential.user != null;
  }

  static Future<UserCredential> signInAnonymously() =>
      _auth.signInAnonymously();

  static Future<bool> register(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential.user != null;
  }

  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    oAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print('id : ${oAuthCredential?.accessToken}');
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(oAuthCredential!);
  }

  static Future<void> logout() {
    return _auth.signOut();
  }

}
