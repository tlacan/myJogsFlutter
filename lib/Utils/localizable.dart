import 'package:flutter/material.dart';

class Localizable {
  static String valuefor({String key, BuildContext context}) {
    Locale locale = Localizations.localeOf(context);
    String countryCode = _values.containsKey(locale.languageCode) ? locale.languageCode : "en";
    return _values[countryCode].containsKey(key) ? _values[countryCode][key] : "";
  }

  static final _values = {
    "fr": {
      "ONBOARDING.STEP.1.DESCRIPTION":
          "Yaourt",
    },
    "en": {
      "Main.App.Title": "My Jogs",
/*
 *********************************
 ** COMMON
 */
      "COMMON.TEXTFIELD.REQUIRED": "Required",
      "COMMON.OK": "OK",

/*
 *********************************
 ** ONBOARDING
 */

      "ONBOARDING.STEP.1.TITLE": " My Jogs",
      "ONBOARDING.STEP.1.DESCRIPTION":
          "Welcome to My Jogs\nthe application \nwhich tracks your jogs.",
      "ONBOARDING.STEP.2.DESCRIPTION":
          "When you are ready to Run, Press Record",
      "ONBOARDING.STEP.3.DESCRIPTION":
          "Track your runs put challenges and see your improvements.",
      "ONBOARDING.END.BUTTON": "Let's Go",

/*
 *********************************
 ** Tabbar
 */

      "TABBAR.ITEM.1": "Record",
      "TABBAR.ITEM.2": "History",
      "TABBAR.ITEM.3": "Settings",

/*
 *********************************
 ** Jog view
 */

      "JOG.SAVE.BUTTON": "Save",
      "JOG.CANCEL.BUTTON": "Cancel",
      "JOG.START.BUTTON": "Start",
      "JOG.PAUSE.BUTTON": "Pause",
      "JOG.RESUME.BUTTON": "Resume",
      "JOG.STOP.BUTTON": "Stop",
      "JOG.SPEED.LABEL": "%@ Km/h",

/*
 *********************************
 ** LOGIN
 */

      "LOGIN.TITLE": "My Jogs",
      "LOGIN.BARITEM.SIGNUP": "Sign Up",
      "LOGIN.EMAIL.TEXTFIELD": "Email",
      "LOGIN.PASSWORD.TEXTFIELD": "Password",
      "LOGIN.LOGIN.BUTTON": "Login",

/*
 *********************************
 ** SIGNUP
 */

      "SIGNUP.TITLE": "My Jogs",
      "SIGNUP.BARITEM.LOGIN": "Login",
      "SIGNUP.EMAIL.TEXTFIELD": "Email",
      "SIGNUP.EMAIL.NOTVALID": "Email address not valid",
      "SIGNUP.PASSWORD.TEXTFIELD": "Password",
      "SIGNUP.PASSWORD_CONFIRM.TEXTFIELD": "Password confirm",
      "SIGNUP.PASSWORD.NOTVALID": "Password must be at least 8 characters",
      "SIGNUP.PASSWORD.DIFFERENT": "Passwords different",
      "SIGNUP.SIGNUP.BUTTON": "Sign up",

/*
 *********************************
 ** API ERROR
 */

      "APIERROR.UNHANDLED_ERROR_CODE": "Unknown error",
      "APIERROR.NONETWORK_ERROR": "Lost network connection",
      "APIERROR.NETWORK_ERROR": "Network error",
      "APIERROR.COMMON": "An error happened. Retry in a moment",
      "APIERROR.UNEXPECTED_RESPONSE": "Unexpected error",
      "APIERROR.UNEXPECTED_ERROR": "Unexpected error",
      "APIERROR.NOT_CONNECTED": "Not connected",
      "APIERROR.ACCESS_DENIED": "Access denied",
      "APIERROR.UNKNWON_EMAIL": "Unknown email",
      "APIERROR.UNKNWON_USER": "Email unknown",
      "APIERROR.USER_EXISTS": "User already exists",
      "APIERROR.LOGIN_ERROR": "Name or Password unknown (reconnect)",
      "APIERROR.WRONG_CREDENTIALS": "Email or password incorrect",
    },
  };
}
