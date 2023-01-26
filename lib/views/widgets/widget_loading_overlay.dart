part of 'widgets.dart';

class WidgetLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  const WidgetLoadingOverlay(
      {Key? key, required this.isLoading, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      child,
      if (isLoading)
        Opacity(
            opacity: 0.8,
            child: ModalBarrier(
                dismissible: false, color: kGreyColor.withOpacity(0.3))),
      if (isLoading) const WidgetLoadingProcess()
    ]);
  }
}
