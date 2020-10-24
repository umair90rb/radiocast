import 'package:flutter/material.dart';
import 'package:podcast/home/favourite.dart';
import 'package:podcast/home/home.dart';
import 'package:podcast/home/setting.dart';
import 'package:podcast/home/upload_podcast.dart';
import 'package:podcast/sec/friend_profile.dart';
import 'package:podcast/sec/search_frient.dart';
import 'package:podcast/sec/sec_profile.dart';
import 'auth/signin_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/password_reset_screen.dart';
import 'auth/account_activation_message_screen.dart';
import 'widgets/no_internet.dart';
import 'home/allpodcasts.dart';
import 'home/search.dart';
import 'home/addpodcast.dart';

import 'sec/signin_screen.dart';
import 'sec/signup_screen.dart';
import 'sec/password_reset_screen.dart';
import 'sec/account_activation_message_screen.dart';


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

  //sec auth
  '/secSignin' : (ctx) => SecSignInScreen(),
  '/secSignup' : (ctx) => SecSignUpScreen(),
  '/secPasswordReset': (ctx) => SecPasswordResetScreen(),
  '/secAccountActivationMessage': (ctx) => SecAccountActivationMessageScreen(),

  '/secProfile' : (ctx) => SecProfile(),
  '/searchFriend' : (ctx) => SearchFriend(),
  '/friendProfile' : (ctx) => FriendProfile(),

  '/uploadPodcast' : (ctx) => UplaodPodcast(),
};