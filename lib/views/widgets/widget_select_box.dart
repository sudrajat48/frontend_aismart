part of 'widgets.dart';

class WidgetSelectBox extends StatelessWidget {
  final String label;
  final String valueItem;
  final String hintText;
  final List listItems;
  final Function onChange;
  final List<String>? errVal;
  const WidgetSelectBox({
    Key? key,
    required this.label,
    required this.valueItem,
    required this.listItems,
    required this.onChange,
    this.errVal,
    this.hintText = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: blackTextStyle.copyWith(fontWeight: medium)),
      const SizedBox(height: 5),
      DropdownButtonFormField(
          isExpanded: true,
          style: blackTextStyle.copyWith(fontStyle: FontStyle.italic),
          hint: Text(hintText, style: blackTextStyle),
          decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                      color: kPrimaryColor.withOpacity(0.5), width: 2.0)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                      color: kPrimaryColor.withOpacity(0.5), width: 1.0)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
          value: valueItem,
          items: listItems.map((item) {
            return DropdownMenuItem(
              value: item['value'].toString(),
              child: Text(item['label'].toString()),
            );
          }).toList(),
          onChanged: (value) async {
            onChange(value);
          }),
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
