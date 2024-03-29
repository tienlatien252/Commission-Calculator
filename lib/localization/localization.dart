import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'translations.dart';

class FFULocalizations {
  TranslationBundle _translationBundle;
  FFULocalizations(Locale locale) {
    _translationBundle = translationBundleForLocale(locale);
  }

  // Title
  String get welcome => _translationBundle.welcome;
  String get signOutTitle => _translationBundle.signInLabel;
  String get signInTitle => _translationBundle.signInTitle;
  String get recoverPasswordTitle => _translationBundle.recoverPasswordTitle;

  // Labels
  String get emailLabel => _translationBundle.emailLabel;
  String get nextButtonLabel => _translationBundle.nextButtonLabel;
  String get cancelButtonLabel => _translationBundle.cancelButtonLabel;
  String get passwordLabel => _translationBundle.passwordLabel;
  String get troubleSigningInLabel => _translationBundle.troubleSigningInLabel;
  String get signInLabel => _translationBundle.signInLabel;
  String get recoverHelpLabel => _translationBundle.recoverHelpLabel;
  String get sendButtonLabel => _translationBundle.sendButtonLabel;
  String get nameLabel => _translationBundle.nameLabel;
  String get saveLabel => _translationBundle.saveLabel;

  // Messages
  String get passwordLetterMessage => _translationBundle.passwordLetterMessage;
  String get passwordDigitMessage => _translationBundle.passwordDigitMessage;
  String get passwordInvalidMessage => _translationBundle.passwordInvalidMessage;
  String get passwordLengthMessage => _translationBundle.passwordLengthMessage;
  String get emailNotValidMessage => _translationBundle.emailNotValidMessage;
  String get nameLengthMessage => _translationBundle.nameLengthMessage;
  

  String get signInFacebook => _translationBundle.signInFacebook;
  String get signInGoogle => _translationBundle.signInGoogle;
  String get signInEmail => _translationBundle.signInEmail;
  String get signInAnonymous => _translationBundle.signInAnonymous;
  

  String get errorOccurredMessage => _translationBundle.errorOccurredMessage;

  static Future<FFULocalizations> load(Locale locale) {
    return SynchronousFuture<FFULocalizations>(
        FFULocalizations(locale));
  }

  static FFULocalizations of(BuildContext context) {
    return Localizations.of<FFULocalizations>(context, FFULocalizations) ??
        _DefaultFFULocalizations();
  }

  static const LocalizationsDelegate<FFULocalizations> delegate =
      const _FFULocalizationsDelegate();

  String allReadyEmailMessage(String email, String providerName) =>
      _translationBundle.allReadyEmailMessage(email, providerName);

  String recoverDialog(String email) => _translationBundle.recoverDialog(email);
}

class _DefaultFFULocalizations extends FFULocalizations {
  _DefaultFFULocalizations() : super(const Locale('en', 'US'));
}

class _FFULocalizationsDelegate
    extends LocalizationsDelegate<FFULocalizations> {
  const _FFULocalizationsDelegate();

  static const List<String> _supportedLanguages = const <String>[
    'en', // English
    'fr', // French
  ];

  @override
  bool isSupported(Locale locale) =>
      _supportedLanguages.contains(locale.languageCode);

  @override
  Future<FFULocalizations> load(Locale locale) => FFULocalizations.load(locale);

  @override
  bool shouldReload(_FFULocalizationsDelegate old) => false;
}
