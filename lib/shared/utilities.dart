// Utility file is a file that contains the help function for information that is used repeatedly such as alerts etc
part of 'shared.dart';

class Utilities {
  static showAlertDialog(
      BuildContext context, String alertTitle, String alertMessage) {
    // set up the buttons
    Widget cancelButton = TextButton(
        child:
            Text("Close", style: blackTextStyle.copyWith(fontWeight: semibold)),
        onPressed: () {
          Navigator.pop(context);
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        title: Text(alertTitle, style: blackTextStyle),
        content: SingleChildScrollView(
            child: ListBody(
                children: <Widget>[Text(alertMessage, style: blackTextStyle)])),
        actions: [cancelButton]);

    // show the dialog
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  static showAlertDialogWithFunction(BuildContext context, String alertTitle,
      String alertMessage, Function alertFunction) {
    // set up the buttons
    Widget cancelButton = TextButton(
        child:
            Text("Close", style: blackTextStyle.copyWith(fontWeight: semibold)),
        onPressed: () {
          Navigator.pop(context);
          alertFunction();
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        title: Text(alertTitle, style: blackTextStyle),
        content: SingleChildScrollView(
            child: ListBody(
                children: <Widget>[Text(alertMessage, style: blackTextStyle)])),
        actions: [cancelButton]);

    // show the dialog
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async {
                Navigator.pop(context);
                alertFunction();
                return false;
              },
              child: alert);
        });
  }

  static showConfirmationDialog(BuildContext context, String alertTitle,
      String alertMessage, Function alertFunction) {
    // set up the buttons
    Widget cancelButton = TextButton(
        child: Text("No",
            style: blackTextStyle.copyWith(
                fontWeight: semibold, color: kRedColor)),
        onPressed: () {
          Navigator.pop(context);
        });
    Widget functionButton = TextButton(
        child: Text("Yes",
            style: blackTextStyle.copyWith(
                fontWeight: semibold, color: kPrimaryColor)),
        onPressed: () {
          Navigator.pop(context);
          alertFunction();
        });

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        title: Text(alertTitle, style: blackTextStyle),
        content: SingleChildScrollView(
            child: ListBody(
                children: <Widget>[Text(alertMessage, style: blackTextStyle)])),
        actions: [cancelButton, functionButton]);

    // show the dialog
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  static showToast(message, context, {status}) {
    Color backgroundColor(status) {
      switch (status) {
        case 'success':
          return kPrimaryColor;
        case 'error':
          return kRedColor;
        default:
          return kPrimaryColor;
      }
    }

    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: backgroundColor(status),
        content:
            Text(message, style: blackTextStyle.copyWith(color: kWhiteColor)),
        duration: const Duration(seconds: 2)));
  }

  Future<void> urlLaunchMethod(String url, {LaunchMode? mode}) async {
    if (!await launchUrl(Uri.parse(url.replaceAll(RegExp(r".+(?=http)"), '')),
        mode: mode ?? LaunchMode.platformDefault)) {
      throw 'Could not launch $url';
    }
  }
}
