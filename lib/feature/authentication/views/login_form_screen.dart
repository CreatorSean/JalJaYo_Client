import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jaljayo/constants/gaps.dart';
import 'package:jaljayo/constants/sizes.dart';
import 'package:jaljayo/feature/authentication/view_models/login_view_model.dart';
import 'package:jaljayo/feature/authentication/widgets/form_button.dart';

class LoginFormScreen extends ConsumerStatefulWidget {
  const LoginFormScreen({super.key});

  @override
  ConsumerState<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends ConsumerState<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formDataMap = {};

  ///유효성 검사를 진행하는 함수
  void _onSubmitTap() {
    //각 key에 해당된 위젯에서 유효성 검사를 진행함
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ref.read(loginProvider.notifier).login(
              formDataMap["email"]!,
              formDataMap["password"]!,
              context,
            );
        //context.goNamed(InterestsScreen.routeName);
        //textformfield의 onsaved 함수를 콜백하게됨
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gaps.v28,
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Please write your email";
                  }
                  return null;
                  //유효성 검사 규칙
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formDataMap['email'] = newValue;
                  }
                },
              ),
              Gaps.v16,
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Please write your email";
                  }
                  return null;
                  //유효성 검사 규칙
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formDataMap['password'] = newValue;
                  }
                },
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSubmitTap,
                child: FormButton(
                  isDisabled: ref.watch(loginProvider).isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
