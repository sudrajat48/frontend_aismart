part of 'pages.dart';

class OTPFieldPage extends StatefulWidget {
  final String code;
  final String email;
  const OTPFieldPage({Key? key, required this.code, required this.email})
      : super(key: key);

  @override
  State<OTPFieldPage> createState() => _OTPFieldPageState();
}

class _OTPFieldPageState extends State<OTPFieldPage> {
  final OtpFieldController otpFieldController = OtpFieldController();
  late Timer _timer;
  final interval = const Duration(seconds: 1);
  bool isLoading = false, sendAgain = false;
  int currentSeconds = 0, timerMaxSecond = 30;
  String errVal = "", code = "", codeVerification = "";

  String get timerText =>
      '${int.parse(((timerMaxSecond - currentSeconds) % 60).toString().padLeft(2, '0'))} detik';

  startTimeout([int? milliseconds]) {
    setState(() {
      code = "";
      sendAgain = false;
    });
    var duration = interval;
    setState(() {
      currentSeconds = 0;
    });
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        // print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSecond) {
          timer.cancel();
          sendAgain = true;
        }
      });
    });
  }

  Future<void> reqCodeVerification() async {
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiReqForgotPassword, {'email': widget.email}, context);
    if (!mounted) return;
    if (response.status == 'success') {
      Utilities.showToast(response.result['message'], context);
      setState(() {
        errVal = "";
        codeVerification = response.result['data'];
      });
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  Future<void> verification() async {
    setState(() {
      isLoading = true;
    });
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiVerifyUniqCode, {'uniqcode': code}, context);
    setState(() {
      isLoading = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      Utilities.showToast(response.result, context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => NewPasswordPage(email: widget.email)));
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    codeVerification = widget.code;
    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Helpers.focusScope(context);
        },
        child: Scaffold(
            body: Column(
          children: [
            Expanded(
                child: ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                    children: [
                  SizedBox(height: defaultMargin * 4),
                  Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text('Enter the verification code',
                          style: blackTextStyle.copyWith(
                              fontSize: 22, fontWeight: semibold),
                          textAlign: TextAlign.center)),
                  Container(
                    margin: EdgeInsets.only(bottom: defaultMargin * 2),
                    child: RichText(
                        text: TextSpan(
                            text:
                                "We have sent an verification code via Email Address ",
                            children: [
                              TextSpan(
                                  text: "${widget.email} $codeVerification",
                                  style: blackTextStyle.copyWith(
                                      fontWeight: semibold))
                            ],
                            style: greyTextStyle),
                        textAlign: TextAlign.center),
                  ),
                  OTPTextField(
                      length: 6,
                      controller: otpFieldController,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: 45,
                      fieldStyle: FieldStyle.box,
                      outlineBorderRadius: 5,
                      obscureText: true,
                      style: blackTextStyle.copyWith(fontSize: 17),
                      onChanged: (pin) {
                        if (kDebugMode) {
                          print("Changed: $pin");
                        }
                      },
                      onCompleted: (pin) {
                        code = pin;
                        setState(() {});
                      }),
                  if (errVal != "") const SizedBox(height: 6),
                  if (errVal != "")
                    Text(errVal.capitalizeFirstofEach,
                        style: redTextStyle.copyWith(fontSize: 13)),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: defaultMargin),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Did not receive code?',
                                style: blackTextStyle),
                            InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: (!sendAgain)
                                    ? null
                                    : () {
                                        startTimeout();
                                        otpFieldController.clear();
                                        reqCodeVerification();
                                      },
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        (!sendAgain)
                                            ? 'Wait $timerText'
                                            : 'Resend Code',
                                        style: blackTextStyle.copyWith(
                                            fontWeight: semibold,
                                            color: kPrimaryColor))))
                          ])),
                  WidgetButtonPrimary(
                      isLoading: isLoading,
                      label: 'VERIFICATION',
                      onClick: () {
                        setState(() {
                          errVal = "";
                          if (code.isEmpty || code.length < 6) {
                            errVal =
                                "Code Verification must be at least 6 characters";
                          }
                          if (errVal == "") {
                            verification();
                          }
                        });
                      })
                ])),
            Container(
                height: 60,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('$assetImagePath/logo_primary.png'))))
          ],
        )));
  }
}
