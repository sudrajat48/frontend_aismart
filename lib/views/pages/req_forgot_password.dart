part of 'pages.dart';

class ReqForgotPassword extends StatefulWidget {
  const ReqForgotPassword({Key? key}) : super(key: key);

  @override
  State<ReqForgotPassword> createState() => _ReqForgotPasswordState();
}

class _ReqForgotPasswordState extends State<ReqForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  List<String> errValEmail = [];

  Future<void> reqCodeVerification() async {
    setState(() {
      isLoading = true;
    });
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiReqForgotPassword, {'email': emailController.text}, context);
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      Utilities.showToast(response.result['message'], context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => OTPFieldPage(
                  code: response.result['data'], email: emailController.text)));
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Helpers.focusScope(context);
      },
      child: Scaffold(
          appBar: AppBar(title: const Text('Forgot Password')),
          body: ListView(children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                    "Enter the registered Email Address. We will send a Verification code via Email.",
                    textAlign: TextAlign.justify,
                    style: blackTextStyle)),
            Container(
                margin: EdgeInsets.only(top: defaultMargin),
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                child: WidgetInputBox(
                    controller: emailController,
                    label: 'Email Address',
                    prefixIcon: const Icon(Icons.mail_outline),
                    hintText: 'Email Address',
                    keyboardType: TextInputType.emailAddress,
                    errVal: errValEmail)),
            Container(
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                child: WidgetButtonPrimary(
                    isLoading: isLoading,
                    label: 'SEND CODE VERIFICATION',
                    onClick: () {
                      setState(() {
                        errValEmail.clear();
                        if (emailController.text.isEmpty) {
                          errValEmail.add('Email must not be empty');
                        }
                        if (!EmailValidator.validate(emailController.text)) {
                          errValEmail.add('Email is not valid');
                        }
                        if (errValEmail.isEmpty) {
                          reqCodeVerification();
                        }
                      });
                    })),
          ])),
    );
  }
}
