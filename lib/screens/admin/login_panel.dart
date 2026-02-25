import 'package:flutter/material.dart';
import 'package:lounge_menu_nfc/screens/admin/section/login_form.dart';
import 'package:lounge_menu_nfc/screens/homepage/section/header_logo.dart';

class LoginPanel extends StatelessWidget {
  const LoginPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        HeaderLogo(),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: LoginForm()),
        ),
      ],
    );
  }
}
