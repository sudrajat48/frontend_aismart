part of 'widgets.dart';

class WidgetCardProduct extends StatelessWidget {
  final Function? onTap;
  final String? title;
  final String? address;
  final String? image;
  final double? rating;
  final double? width;
  final bool? isExpanded;
  const WidgetCardProduct(
      {Key? key,
      this.onTap,
      this.title,
      this.address,
      this.image,
      this.rating,
      this.width,
      this.isExpanded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Material(
            color: kGreyColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            child: Container(
                width: width ?? MediaQuery.of(context).size.width * 0.4,
                height: (isExpanded!) ? 200 : null,
                padding: const EdgeInsets.all(8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isExpanded!)
                        Expanded(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: (image != null)
                                  ? Image.network(
                                      "${BaseURL.pahtImageNetwork}/product/$image",
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 100)
                                  : Image.asset(
                                      '$assetImagePath/img_preview_product.png',
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover)),
                        ),
                      if (!isExpanded!)
                        ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: (image != null)
                                ? Image.network(
                                    "${BaseURL.pahtImageNetwork}/product/$image",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 100)
                                : Image.asset(
                                    '$assetImagePath/img_preview_product.png',
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover)),
                      const SizedBox(height: 8),
                      Text(title ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: blackTextStyle.copyWith(
                              fontWeight: semibold, fontSize: 15)),
                      const SizedBox(height: 5),
                      RatingBar.builder(
                          initialRating: rating ?? 0.0,
                          minRating: 0,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 16,
                          ignoreGestures: true,
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (val) {
                            null;
                          }),
                      const SizedBox(height: 8),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on,
                                color: kPrimaryColor, size: 18),
                            const SizedBox(width: 5),
                            Expanded(
                                child: Text(address ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: greyTextStyle))
                          ])
                    ]))));
  }
}
