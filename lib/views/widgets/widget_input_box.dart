part of 'widgets.dart';

class WidgetInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final List<String>? errVal;
  final String label;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool readOnly;
  final bool enabled;
  final Function(String)? onchange;
  final int? maxLength;
  final int? maxLines;
  final TextStyle? style;
  final List<TextInputFormatter>? inputFormatter;
  const WidgetInputBox(
      {Key? key,
      required this.controller,
      this.hintText = "",
      this.keyboardType = TextInputType.text,
      this.prefixIcon,
      this.suffixIcon,
      this.obscureText = false,
      this.errVal,
      this.label = "",
      this.textInputAction,
      this.autofocus = false,
      this.readOnly = false,
      this.enabled = true,
      this.onchange,
      this.maxLength,
      this.maxLines = 1,
      this.style,
      this.inputFormatter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (label != "")
        Text(label, style: blackTextStyle.copyWith(fontWeight: medium)),
      if (label != "") const SizedBox(height: 5),
      TextFormField(
          autofocus: autofocus,
          enabled: enabled,
          readOnly: readOnly,
          textInputAction: textInputAction,
          obscureText: obscureText,
          keyboardType: keyboardType,
          controller: controller,
          maxLength: maxLength,
          maxLines: maxLines,
          style: style,
          onChanged: onchange,
          // cursorColor: Colors.white,
          inputFormatters: inputFormatter,
          cursorColor: kBlackColor.withOpacity(0.5),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 15, vertical: (maxLines == null) ? 10 : 0),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintText: hintText,
              // hintStyle: TextStyle(
              //   // fontSize: 18.0,
              //   color: Theme.of(context).primaryColor,
              // ),
              fillColor: Colors.grey.shade200,
              filled: readOnly,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                      color: kPrimaryColor.withOpacity(0.5), width: 2.0)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                      color: kPrimaryColor.withOpacity(0.5), width: 1.0)),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                      color: kGreyColor.withOpacity(0.5), width: 1.0)))),
      if (errVal != null && errVal!.isNotEmpty) const SizedBox(height: 6),
      if (errVal != null && errVal!.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: errVal!
                    .map((e) => Text(e.capitalizeFirstofEach,
                        style: redTextStyle.copyWith(fontSize: 13)))
                    .toList())),
      const SizedBox(height: 10)
    ]);
  }
}
