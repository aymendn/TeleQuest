import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nasa/providers/auth.dart';

import '../core/app_route.dart';
import 'custom_button.dart';
import 'custom_input.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key, this.isSignup = false}) : super(key: key);

  final bool isSignup;

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _repeatPasswordController;

  late FocusNode _nameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  late FocusNode _repeatPasswordFocusNode;

  late bool isSubmitted;
  late bool isLoading;

  String? get _emailErrorText {
    final text = _emailController.value.text;

    if (!isSubmitted && !_emailFocusNode.hasFocus) {
      return null;
    }

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short';
    }
    if (!text.contains('@')) {
      return 'Email should contain "@"';
    }
    if (!RegExp(r'.+\@.+\..+').hasMatch(text)) {
      return 'Invalid Email';
    }

    return null;
  }

  String? get _passwordErrorText {
    final text = _passwordController.value.text;

    if (!isSubmitted && !_passwordFocusNode.hasFocus) {
      return null;
    }

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 8) {
      return 'Must contain at least 8 characters';
    }

    return null;
  }

  String? get _repeatPasswordErrorText {
    final text = _repeatPasswordController.value.text;

    if (!isSubmitted && !_repeatPasswordFocusNode.hasFocus) {
      return null;
    }

    if (text != _passwordController.text) {
      return 'Password does not match!';
    }

    return null;
  }

  String? get _nameErrorText {
    final text = _nameController.value.text;

    if (!isSubmitted && !_nameFocusNode.hasFocus) {
      return null;
    }

    if (text.length < 3) {
      return 'Too short';
    }

    if (text.length > 15) {
      return 'Too Long';
    }

    if (text[text.length - 1] == ' ') {
      return 'Name can\'t end with space';
    }

    if (!RegExp(r'^[a-zA-Z0-9_]*$').hasMatch(text)) {
      return 'Name should contain only numbers, letters and underscore.';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();

    isSubmitted = false;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          if (widget.isSignup)
            CustomInput(
              text: 'Name',
              errorText: _nameErrorText,
              onFocusChange: (_) => setState(() {}),
              controller: _nameController,
              focusNode: _nameFocusNode,
              onChanged: (value) => setState(() {}),
              onFieldSubmitted: (_) => _emailFocusNode.requestFocus(),
            ),
          CustomInput(
            text: 'Email',
            errorText: _emailErrorText,
            onFocusChange: (_) => setState(() {}),
            controller: _emailController,
            focusNode: _emailFocusNode,
            onChanged: (value) => setState(() {}),
            onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
          ),
          CustomInput(
            text: 'Passowrd',
            errorText: _passwordErrorText,
            onFocusChange: (_) => setState(() {}),
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            onChanged: (value) => setState(() {}),
            onFieldSubmitted: (_) => _repeatPasswordFocusNode.requestFocus(),
          ),
          if (widget.isSignup)
            CustomInput(
              text: 'Repeat Passowrd',
              errorText: _repeatPasswordErrorText,
              onFocusChange: (_) => setState(() {}),
              controller: _repeatPasswordController,
              focusNode: _repeatPasswordFocusNode,
              onChanged: (value) => setState(() {}),
              onFieldSubmitted: (_) => _repeatPasswordFocusNode.unfocus(),
            ),
          Consumer(
            builder: (context, ref, child) {
              final auth = ref.read(authProvider);
              return CustomButton(
                text: widget.isSignup ? 'Sign up' : 'Sign in',
                onPressed: () async {
                  setState(() {
                    isSubmitted = true;
                  });
                  if (_emailErrorText != null ||
                      _passwordErrorText != null ||
                      (widget.isSignup &&
                          (_repeatPasswordErrorText != null ||
                              _nameErrorText != null))) {
                    return;
                  }

                  setState(() {
                    isLoading = true;
                  });
                  try {
                    if (widget.isSignup) {
                      await auth.signup(
                          name: _nameController.text
                              .trim()
                              .replaceAll(RegExp(r"\s+"), " "),
                          email: _emailController.text,
                          password: _passwordController.text);
                    } else {
                      await auth.login(SigninMethod.email,
                          email: _emailController.text,
                          password: _passwordController.text);
                    }

                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed(AppRoute.home);
                  } catch (e) {
                    setState(() {
                      isLoading = false;
                    });
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                          e.toString(),
                        ),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    super.dispose();
  }
}
