part of 'widgets.dart';

class WidgetButtonOutline extends StatelessWidget {
  final String btnText;
  final Function btnFunction;
  final bool? isLoading;
  final Color? textColor;
  const WidgetButtonOutline(
      {Key? key,
      required this.btnText,
      required this.btnFunction,
      this.isLoading = false,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: kPrimaryColor)
            //color: Theme.of(context).accentColor,
            ),
        child: TextButton(
            onPressed: () {
              btnFunction();
            },
            child: (isLoading!)
                ? SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kPrimaryColor),
                        strokeWidth: 3))
                : Text(btnText,
                    textAlign: TextAlign.center,
                    style: blackTextStyle.copyWith(
                        color: textColor,
                        fontWeight: semibold,
                        fontSize: 16))));
  }
}
