part of 'pages.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newConfirmPasswordController =
      TextEditingController();

  List<String> errNewPassword = [],
      errOldPassword = [],
      errNewConfirmPassword = [];

  bool isLoading = false;

  Future<void> updatePassword() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await GlobalService.sharedPreference;
    String? userID = prefs.getString(UserPreferenceModel.userID);
    if (!mounted) return;
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiUpdatePassword,
        {
          'user_id': userID,
          'old_password': oldPasswordController.text,
          'new_password': newPasswordController.text
        },
        context);
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      Navigator.pop(context);
      Utilities.showToast(response.result['message'], context);
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    newConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Helpers.focusScope(context);
      },
      child: Scaffold(
          appBar: AppBar(title: const Text('Change Password')),
          body: ListView(padding: EdgeInsets.all(defaultMargin), children: [
            WidgetInputBox(
                controller: oldPasswordController,
                label: 'Old Password',
                prefixIcon: const Icon(Icons.lock_outline),
                obscureText: true,
                hintText: 'Old Password',
                errVal: errOldPassword),
            WidgetInputBox(
                controller: newPasswordController,
                label: 'New Password',
                prefixIcon: const Icon(Icons.lock_outline),
                obscureText: true,
                hintText: 'New Password',
                errVal: errNewPassword),
            WidgetInputBox(
                controller: newConfirmPasswordController,
                label: 'Re-Type New Password',
                prefixIcon: const Icon(Icons.lock_outline),
                obscureText: true,
                hintText: 'Re-Type New Password',
                errVal: errNewConfirmPassword),
            WidgetButtonPrimary(
                label: 'SAVE PASSWORD',
                isLoading: isLoading,
                onClick: () {
                  setState(() {
                    errOldPassword.clear();
                    errNewPassword.clear();
                    errNewConfirmPassword.clear();
                    if (oldPasswordController.text.isEmpty) {
                      errOldPassword.add('Old Password must not be empty');
                    }
                    if (oldPasswordController.text.length < 8) {
                      errOldPassword
                          .add('Old Password must be at least 8 characters');
                    }
                    if (newPasswordController.text.isEmpty) {
                      errNewPassword.add('New Password must not be empty');
                    }
                    if (newPasswordController.text.length < 8) {
                      errNewPassword
                          .add('New Password must be at least 8 characters');
                    }
                    if (newConfirmPasswordController.text.isEmpty) {
                      errNewConfirmPassword
                          .add('Password New Confirm must not be empty');
                    }
                    if (newConfirmPasswordController.text.length < 8) {
                      errNewConfirmPassword.add(
                          'Password New Confirm must be at least 8 characters');
                    }
                    if (newConfirmPasswordController.text !=
                        newPasswordController.text) {
                      errNewConfirmPassword.add(
                          'Confirmations password must match the new password');
                    }

                    if (errNewPassword.isEmpty &&
                        errNewPassword.isEmpty &&
                        errNewConfirmPassword.isEmpty) {
                      updatePassword();
                    }
                  });
                })
          ]))
    );
  }
}
