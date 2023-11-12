import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jaljayo/constants/sizes.dart';
import 'package:jaljayo/feature/authentication/view_models/social_auth_view_model.dart';
import 'package:jaljayo/feature/authentication/views/username_screen.dart';
import 'package:jaljayo/feature/authentication/widgets/auth_button.dart';

import '../../../constants/gaps.dart';
import 'login_screen.dart';

class SignUpScreen extends ConsumerWidget {
  static const routeURL = "/";
  static const routeName = "signUp";
  const SignUpScreen({super.key});

  final tDuration = const Duration(seconds: 1);
  final rDuration = const Duration(seconds: 1);

  void _onLoginTap(BuildContext context) async {
    context.pushNamed(LoginScreen.routeName);
    //push a location onto the page stack => 이전 화면 위에 다른 화면을 올림
  }

  void _onEmailTap(BuildContext context) {
    // context.pushNamed(UsernameScreen.routeName);
    //context.go는 이전 화면 위에 다른 화면을 올리는 것이 아님

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UsernameScreen(),
      ),
    );
  }

  void onAppleTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrientationBuilder(
      builder: (context, orientation) {
        // if (orientation == Orientation.landscape) {
        //   return const Scaffold(
        //     body: Center(
        //       child: Text(
        //         'Plz rotate ur phone.',
        //       ),
        //     ),
        //   );
        // }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size40,
              ),
              child: Column(
                children: [
                  Gaps.v80,
                  const Text(
                    'Sign up for TikTok',
                    style: TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v20,
                  const Opacity(
                    opacity: 0.6,
                    child: Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Create a profile, follow other accounts, make your own videos, and more.',
                        style: TextStyle(
                          fontSize: Sizes.size16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Gaps.v40,
                  if (orientation == Orientation.portrait) ...[
                    GestureDetector(
                      onTap: () => _onEmailTap(context),
                      child: const AuthButton(
                        // createPage: ,
                        icon: FaIcon(FontAwesomeIcons.user),
                        text: "Use phone or email",
                      ),
                    ),
                    Gaps.v16,
                    GestureDetector(
                      onTap: () => ref
                          .read(socialAuthProvider.notifier)
                          .githubSignIn(context),
                      child: const AuthButton(
                        icon: FaIcon(FontAwesomeIcons.github),
                        text: "Continue with Github",
                      ),
                    )
                  ],
                  if (orientation == Orientation.landscape)
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onEmailTap(context),
                            child: const AuthButton(
                              // createPage: ,
                              icon: FaIcon(FontAwesomeIcons.user),
                              text: "Use phone or email",
                            ),
                          ),
                        ),
                        Gaps.h16,
                        Expanded(
                          child: GestureDetector(
                            onTap: () => onAppleTap(context),
                            child: const AuthButton(
                              icon: FaIcon(FontAwesomeIcons.apple),
                              text: "Continue with Apple",
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.only(
                top: Sizes.size32,
                bottom: Sizes.size64,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                  ),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => _onLoginTap(context),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
