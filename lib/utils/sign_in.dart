import 'package:fb/config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:realm/realm.dart';

Future<User> signInWithGoogle(App app) async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn(
    serverClientId: GlobalConfig().clientID,
  ).signIn();

  // todo handle error
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  return await app.logIn(Credentials.googleIdToken(googleAuth!.idToken!));
}
