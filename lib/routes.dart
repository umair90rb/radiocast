import 'package:flutter/material.dart';
import 'auth/signin_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/password_reset_screen.dart';
import 'auth/account_activation_message_screen.dart';
import 'widgets/no_internet.dart';

var routes = <String, WidgetBuilder>{
  // '/firstScreen': (ctx) => FirstScreen(),
  '/signUp': (ctx) => SignUpScreen(),
  '/signIn': (ctx) => SignInScreen(),
  '/home': (ctx) => SignInScreen(),
  '/passwordReset': (ctx) => PasswordResetScreen(),
  // '/newPassword': (ctx) => NewPasswordScreen(),
  '/accountActivationMessage': (ctx) => AccountActivationMessageScreen(),
  // '/home': (ctx) => NavigationBarScreen(),
  // '/profile': (ctx) => ProfileScreen(),
  '/noInternet': (ctx) => NoInternet(),
  // '/notification': (ctx) => NotificationScreen(),

};