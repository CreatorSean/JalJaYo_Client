import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaljayo/constants/gaps.dart';
import 'package:jaljayo/constants/sizes.dart';
import 'package:jaljayo/feature/authentication/view_models/signup_view_model.dart';
import 'package:jaljayo/feature/authentication/views/password_screen.dart';
import 'package:jaljayo/feature/authentication/widgets/form_button.dart';
//account를 만들 때 username이나 birthday가 필요하지 않기에 account creation을 email_screen.dart에서 진행하는 것이다.

class EmailScreenArgs {
  final String usernameStr;

  EmailScreenArgs({
    required this.usernameStr,
  });
}

class EmailScreen extends ConsumerStatefulWidget {
  final String usernameStr;

  const EmailScreen({
    super.key,
    required this.usernameStr,
  });

  @override
  ConsumerState<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends ConsumerState<EmailScreen> {
  final TextEditingController _emailStrController = TextEditingController();

  String _emailStr = "";

  String? _isEmailValid() {
    if (_emailStr.isEmpty) return null;
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regExp.hasMatch(_emailStr)) {
      return "Email not valid";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _emailStrController.addListener(
      () {
        setState(() {
          _emailStr = _emailStrController.text;
        });
      },
    );
  }

  @override
  void dispose() {
    _emailStrController.dispose();
    super.dispose();
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onSubmit() {
    if (_emailStr.isEmpty || _isEmailValid() != null) return;
    //signUpForm Provider를 사용하여 email을 생성하면 해당 정보를 저장한다.
    final state = ref.read(signUpForm.notifier).state;
    ref.read(signUpForm.notifier).state = {...state, "email": _emailStr};
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
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
              Text(
                "What is your email, ${widget.usernameStr}",
                style: const TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v8,
              TextField(
                controller: _emailStrController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onEditingComplete: _onSubmit,
                decoration: InputDecoration(
                  hintText: 'Email',
                  errorText: _isEmailValid(),
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
                onTap: _onSubmit,
                child: FormButton(
                  isDisabled: _emailStr.isEmpty || _isEmailValid() != null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
