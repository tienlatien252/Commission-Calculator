import 'dart:async';

import 'package:Calmission/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class SignInManager extends ChangeNotifier {
  SignInManager({@required this.auth});
  final AuthService auth;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    return await signInMethod();
  }

  Future<User> signInAnonymously() async {
    return await _signIn(auth.signInAnonymously);
  }

  Future<void> signInWithGoogle() async {
    return await _signIn(auth.signInWithGoogle);
  }

  Future<void> signInWithFacebook() async {
    return await _signIn(auth.signInWithFacebook);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    return await auth.signInWithEmailAndPassword(email, password);
  }
}
/*
class SignInManager extends ChangeNotifier {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthService auth;
  final ValueNotifier<bool> isLoading;


  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<User> signInAnonymously() async {
    return await _signIn(auth.signInAnonymously);
  }

  Future<void> signInWithGoogle() async {
    return await _signIn(auth.signInWithGoogle);
  }

  Future<void> signInWithFacebook() async {
    return await _signIn(auth.signInWithFacebook);
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;
      return await auth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
*/
