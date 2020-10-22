import 'package:flutter/material.dart';
import 'package:podcast/home/favourite.dart';
import 'package:podcast/home/home.dart';
import 'package:podcast/home/setting.dart';
import 'auth/signin_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/password_reset_screen.dart';
import 'auth/account_activation_message_screen.dart';
import 'widgets/no_internet.dart';
import 'home/allpodcasts.dart';
import 'home/search.dart';
import 'home/addpodcast.dart';

var routes = <String, WidgetBuilder>{
  '/signUp': (ctx) => SignUpScreen(),
  '/signIn': (ctx) => SignInScreen(),
  '/yourPodcasts': (ctx) => Home(),
  '/passwordReset': (ctx) => PasswordResetScreen(),
  '/accountActivationMessage': (ctx) => AccountActivationMessageScreen(),
  '/noInternet': (ctx) => NoInternet(),
  '/search': (ctx) => SearchPod(),
  '/podcasts': (ctx) => AllPodcasts(),
  '/addPodcast': (ctx) => MyApp(),
  '/favourite': (ctx) => Favourite(),
  '/setting': (ctx) => Setting(),
};