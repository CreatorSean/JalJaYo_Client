import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  //전에는 disk와 소통했다면 여기서는 firebase와 소통할 수 있게 된다.
  //Sharedfreferences처럼 preferences가 필요없다.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool get isLoggedIn => user != null;
  User? get user => _firebaseAuth.currentUser;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();
  //stream을 사용하면 유저의 인증 상태가 바뀔 때 앱을 실시간으로 새로고침 할 수 있다.
  //stream은 실시간 연결이다.
  //예를 들면 전화기 같은 것이다. 계속 들고 있다가 무슨 일이 생기면 바로 알 수 있는 것이다.
  //단순히 백엔드에 요청하는 것이 아니라 UI와 백엔드 간의 연결 같은 것이다.
  //즉 변화를 바로 알 수 있는 것이다.

  //firebase에 Email과 Password로 user를 creation함
  Future<UserCredential> emailSignUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> githubSignIn() async {
    await _firebaseAuth.signInWithProvider(GithubAuthProvider());
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());

//이 Provider를 통해 유저의 인증 상태 변경을 감지한다.
final authState = StreamProvider((ref) {
  final repo = ref.read(authRepo);
  return repo.authStateChanges();
});
