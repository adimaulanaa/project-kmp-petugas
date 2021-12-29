abstract class Repository {
  Future<String> signInWithCredentials(String email, String password);
  Future<void> signOut();
  Future<void> persistToken(String token);
  Future<bool> isSignedIn();
}
