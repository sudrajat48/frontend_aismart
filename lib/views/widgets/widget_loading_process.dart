part of 'widgets.dart';

class WidgetLoadingProcess extends StatelessWidget {
  final Color? color;
  const WidgetLoadingProcess({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      size: 30,
      color: color ?? kPrimaryColor,
    );
  }
}
