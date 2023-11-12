import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jaljayo/feature/authentication/repos/authentication_repo.dart';
import 'package:jaljayo/feature/onboarding/views/tutorial_screen.dart';
import 'package:jaljayo/feature/users/view_models/user_view_model.dart';

import '../../utils.dart';

//Expose Nothing, Because this view model just show loading screen when we create user account and do trigger that account creation
class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<void> build() {
    //AuthenticationRepository를 초기화
    _authRepo = ref.read(authRepo);
  }

  Future<void> signUp(BuildContext context) async {
    //작업을 시작하면 사용자에게 로딩중이라고 알림
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    final users = ref.read(usersProvider.notifier);
    //AsyncValue.guard는 error가 있으면 error를 expose하고 error가 없다면 해당 data를 저장하고 아무것도 return하지 않음
    state = await AsyncValue.guard(() async {
      //AuthenticationRepository의 signUp을 통해 user account를 creation함
      final userCredential = await _authRepo.emailSignUp(
        form["email"],
        form["password"],
      );
      await users.createProfile(userCredential, form["name"], form["bio"]);
    });
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      context.goNamed(TutorialScreen.routeName);
    }
  }
}

//StateProvider is A Provider that exposes a value that can be modified from outside
//이 form state를 사용하여 유저가 화면에 적는 정보를 form에 저장함
final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
