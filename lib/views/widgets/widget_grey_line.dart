part of 'widgets.dart';

class WidgetGreyLine extends StatelessWidget {
  const WidgetGreyLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 10,
        color: Colors.grey.shade200);
  }
}
