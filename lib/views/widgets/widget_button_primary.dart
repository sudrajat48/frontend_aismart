part of 'widgets.dart';

class WidgetButtonPrimary extends StatelessWidget {
  final String label;
  final double height;
  final bool isLoading;
  final Function onClick;
  const WidgetButtonPrimary(
      {Key? key,
      required this.label,
      this.height = 45,
      this.isLoading = false,
      required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
            onPressed: () {
              if (isLoading == false) {
                onClick();
              }
            },
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor, // background
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5) // <-- Radius
                    ) // foreground
                ),
            child: (isLoading == true)
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 3))
                : Text(label,
                    textAlign: TextAlign.center,
                    style: whiteTextStyle.copyWith(
                        fontWeight: semibold, fontSize: 16))));
  }
}
