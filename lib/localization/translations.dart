import 'dart:ui' show Locale;

class TranslationBundle {
  const TranslationBundle(this.parent);
  final TranslationBundle parent;

  String get welcome => parent?.welcome;
  String get signOutTitle => parent?.signOutTitle;
  String get signInTitle => parent?.signInTitle;
  String get recoverPasswordTitle => parent?.recoverPasswordTitle;

  String get emailLabel => parent?.emailLabel;
  String get nextButtonLabel => parent?.nextButtonLabel;
  String get cancelButtonLabel => parent?.cancelButtonLabel;
  String get passwordLabel => parent?.passwordLabel;
  String get troubleSigningInLabel => parent?.troubleSigningInLabel;
  String get signInLabel => parent?.signInLabel;
  String get recoverHelpLabel => parent?.recoverHelpLabel;
  String get sendButtonLabel => parent?.sendButtonLabel;
  String get nameLabel => parent?.nameLabel;
  String get saveLabel => parent?.saveLabel;

  String get passwordLetterMessage => parent?.passwordLetterMessage;
  String get passwordDigitMessage => parent?.passwordDigitMessage;
  String get passwordLengthMessage => parent?.passwordLengthMessage;
  String get passwordInvalidMessage => parent?.passwordInvalidMessage;
  String get emailNotValidMessage => parent?.emailNotValidMessage;
  String get nameLengthMessage => parent?.nameLengthMessage;

  String get signInFacebook => parent?.signInFacebook;
  String get signInGoogle => parent?.signInGoogle;
  String get signInEmail => parent?.signInEmail;
  String get signInAnonymous => parent?.signInAnonymous;

  String get errorOccurredMessage => parent?.errorOccurredMessage;

  allReadyEmailMessage(String email, String providerName) =>
      parent?.allReadyEmailMessage(email, providerName);

  recoverDialog(String email) => parent?.recoverDialog(email);
}

// ignore: camel_case_types
class _Bundle_fr extends TranslationBundle {
  const _Bundle_fr() : super(null);

  @override
  String get welcome => r'Bienvenue';
  @override
  String get emailLabel => r'Adresse mail';
  @override
  String get passwordLabel => r'Mot de passe';

  @override
  String get nextButtonLabel => r'SUIVANT';
  @override
  String get cancelButtonLabel => r'ANNULER';
  @override
  String get signInLabel => r'CONNEXION';

  @override
  String get saveLabel => r'ENREGISTRER';

  @override
  String get signInTitle => r'Connexion';

  @override
  String get troubleSigningInLabel => 'Difficultés à se connecter ?';

  @override
  String get passwordInvalidMessage =>
      'Le mot de passe est invalide ou l\'utilisateur n\'a pas de mot de passe.';

  @override
  String get recoverPasswordTitle => r'Récupérer mot de passe';

  @override
  String get recoverHelpLabel =>
      r'Obtenez des instructions envoyées à cet e-mail ' +
      'pour expliquer comment réinitialiser votre mot de passe';

  @override
  String get sendButtonLabel => r'ENVOYER';

  @override
  String get nameLabel => r'Nom et prénom';

  @override
  String get errorOccurred => r'Une erreur est survenue';

  @override
  allReadyEmailMessage(String email, String providerName) {
    return '''Vous avez déjà utilisé $email.
Connectez-vous avec $providerName pour continuer.''';
  }

  @override
  recoverDialog(String email) {
    return 'Suivez les instructions envoyées à $email ' +
        'pour retrouver votre mot de passe';
  }

  String get passwordLengthMessage =>
      r'Le mot de passe doit comporter 6 caractères ou plus';

  @override
  String get signInFacebook => r'Connexion avec Facebook';

  @override
  String get signInGoogle => r'Connexion avec Google';

  @override
  String get signInEmail => r'Connexion avec email';
}

// ignore: camel_case_types
class _Bundle_en extends TranslationBundle {
  const _Bundle_en() : super(null);

  @override
  String get welcome => r'Welcome';
  @override
  String get emailLabel => r'Email';
  @override
  String get signOutTitle => r'Sign Out';
  @override
  String get signInTitle => r'Sign in';
  @override
  String get recoverPasswordTitle => r'Recover password';

  @override
  String get passwordLabel => r'Password';
  @override
  String get nextButtonLabel => r'NEXT';
  @override
  String get cancelButtonLabel => r'CANCEL';
  @override
  String get signInLabel => r'SIGN IN';
  @override
  String get saveLabel => r'SAVE';
  @override
  String get troubleSigningInLabel => 'Trouble signing in ?';
  @override
  String get recoverHelpLabel =>
      r'Get instructions sent to this email ' +
      'that explain how to reset your password';
  @override
  String get sendButtonLabel => r'SEND';
  @override
  String get nameLabel => r'First & last name';

  @override
  String get passwordDigitMessage =>
      r'Password must contain at least one number (0-9)';
  @override
  String get passwordLetterMessage =>
      r'Password must contain at least one letter';
  @override
  String get passwordInvalidMessage =>
      r'The password is invalid or the user does not have password.';
  @override
  String get errorOccurredMessage => r'An error occurred';
  @override
  String allReadyEmailMessage(String email, String providerName) {
    return '''You have already used $email.
              Sign in with $providerName to continue.''';
  }

  @override
  String get passwordLengthMessage =>
      r'The password must be 6 characters long or more';
  @override
  String get emailNotValidMessage => r'Email Is Not Valid';
  @override
  String get nameLengthMessage => r'Name must be more than 2 charater';

  @override
  String recoverDialog(String email) {
    return 'Follow the instructions sent to $email to recover your password';
  }

  @override
  String get signInFacebook => r'Sign in with Facebook';
  @override
  String get signInGoogle => r'Sign in with Google';
  @override
  String get signInAnonymous => r'Log in Anonymously';
  @override
  String get signInEmail => r'Sign in with email';
}

TranslationBundle translationBundleForLocale(Locale locale) {
  switch (locale.languageCode) {
    case 'fr':
      return const _Bundle_fr();
    case 'en':
      return const _Bundle_en();
  }
  return const TranslationBundle(null);
}
