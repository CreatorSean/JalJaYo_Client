import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaljayo/constants/gaps.dart';
import 'package:jaljayo/constants/sizes.dart';
import 'package:jaljayo/feature/authentication/view_models/signup_view_model.dart';
import 'package:jaljayo/feature/authentication/views/email_screen.dart';
import 'package:jaljayo/feature/authentication/widgets/form_button.dart';

class UsernameScreen extends ConsumerStatefulWidget {
  const UsernameScreen({super.key});

  @override
  ConsumerState<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends ConsumerState<UsernameScreen> {
  final TextEditingController _usernameStrController = TextEditingController();

  String _usernameStr = "";

  void _onNextTap() {
    if (_usernameStr.isEmpty) return;
    ref.read(signUpForm.notifier).state = {"name": _usernameStr};
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailScreen(usernameStr: _usernameStr),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _usernameStrController.addListener(
      () {
        setState(() {
          _usernameStr = _usernameStrController.text;
        });
      },
    );
  }

  @override
  void dispose() {
    _usernameStrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          'Sign up',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v40,
            const Text(
              "Create username",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v8,
            const Text(
              "You can alwatys change this later.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: Sizes.size16,
              ),
            ),
            Gaps.v16,
            TextField(
              controller: _usernameStrController,
              decoration: InputDecoration(
                hintText: 'Usernae',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            Gaps.v16,
            GestureDetector(
              onTap: _onNextTap,
              child: FormButton(
                isDisabled: _usernameStr.isEmpty,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
