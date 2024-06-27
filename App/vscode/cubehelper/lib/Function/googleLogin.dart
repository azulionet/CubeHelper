import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Global/define.dart';

class GoolgleLogin {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static bool bLogin = false;

  static Future<bool> signInWithGoogle(
      {required void Function(bool, String) onSignInSucceeded}) async {
    // Trigger the authentication flow

    G.Log("signInWithGoogle");

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

    final User? user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = FirebaseAuth.instance.currentUser!;
      assert(user.uid == currentUser.uid);

      onSignInSucceeded(true, user.email as String);

      bLogin = true;
    } else {
      bLogin = false;
      G.Log("user null");

      onSignInSucceeded(false, "");
    }
    return true;

    /*
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = FirebaseAuth.instance.currentUser!;
        assert(user.uid == currentUser.uid);

        bLogin = true;
        onSignInSucceeded(true);

        print('signInWithGoogle succeeded: $user');

        return true;
      } else {
        onSignInSucceeded(false);
        return false;
      }
    } catch (e) {
      e.toString().toast();
      onSignInSucceeded(false);
      return false;
    }
    */
  }

  static void signOutGoogle() async {
    if (bLogin == false) {
      print("User signed out - but not login");
      return;
    }

    bLogin = false;
    await _googleSignIn.signOut();
    print("User signed out");
  }
}
