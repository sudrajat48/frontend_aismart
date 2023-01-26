part of '../pages.dart';

class DetailAdminVoucherPage extends StatefulWidget {
  final int id;
  const DetailAdminVoucherPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailAdminVoucherPage> createState() => _DetailAdminVoucherPageState();
}

class _DetailAdminVoucherPageState extends State<DetailAdminVoucherPage> {
  bool isLoadingPage = false, isContent = false;
  String nameVoucher = "",
      point = "",
      image = "",
      description = "",
      isDiscount = "",
      discountPercent = "",
      discountPrice = "",
      activeAt = "",
      expiredAt = "",
      createdAt = "",
      totalDiscount = "",
      totalClaim = "",
      totalUse = "";
  Future<void> getDetailVoucher() async {
    setState(() {
      isLoadingPage = true;
    });
    GlobalModel response = await GlobalService.getData(
        '${BaseURL.apiDetailAdminVouchers}?voucher_id=${widget.id}', context);
    setState(() {
      isLoadingPage = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      setState(() {
        nameVoucher = response.result['name_voucher'] ?? '';
        point = response.result['point'] ?? '';
        image = response.result['image'] ?? '';
        description = response.result['description'] ?? '';
        isDiscount = response.result['is_discount'] ?? '';
        discountPercent = response.result['discount_percent'] ?? '';
        discountPrice = response.result['discount_price'] ?? '';
        activeAt = response.result['active_at'] ?? '';
        expiredAt = response.result['expired_at'] ?? '';
        createdAt = response.result['created_at'] ?? '';
        totalDiscount = response.result['total_discount'] ?? '0';
        totalClaim = response.result['total_claim'] ?? '';
        totalUse = response.result['total_use'] ?? '';
        isContent = true;
      });
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  @override
  void initState() {
    super.initState();
    getDetailVoucher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Detail Promotional Offer')),
        body: WidgetLoadingOverlay(
            isLoading: isLoadingPage,
            child: (!isContent)
                ? const SizedBox()
                : ListView(children: [
                    SizedBox(
                        width: double.infinity,
                        height: 180,
                        child: (image == '')
                            ? Image.asset('$assetImagePath/placeholder.png',
                                fit: BoxFit.cover)
                            : Image.network(
                                '${BaseURL.pahtImageNetwork}/vouchers/$image',
                                fit: BoxFit.cover)),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: defaultMargin),
                        padding:
                            EdgeInsets.symmetric(horizontal: defaultMargin),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(nameVoucher,
                                  style: blackTextStyle.copyWith(
                                      fontWeight: semibold, fontSize: 15)),
                              const SizedBox(height: 5),
                              Text(
                                  (description == '')
                                      ? 'Not Description'
                                      : description,
                                  textAlign: TextAlign.justify,
                                  style: blackTextStyle),
                              const SizedBox(height: 10),
                              Row(children: [
                                Text("Total Discount : ",
                                    textAlign: TextAlign.justify,
                                    style: blackTextStyle.copyWith(
                                        fontWeight: semibold)),
                                Expanded(
                                    child: Text(
                                        (isDiscount == '1')
                                            ? '$discountPercent%'
                                            : 'Rp ${Helpers.formatCurrencyID(discountPrice)}',
                                        textAlign: TextAlign.justify,
                                        style: blackTextStyle))
                              ]),
                              const SizedBox(height: 10),
                              Row(children: [
                                Text("Valid Until : ",
                                    textAlign: TextAlign.justify,
                                    style: blackTextStyle.copyWith(
                                        fontWeight: semibold)),
                                Expanded(
                                    child: Text(
                                        (expiredAt == '')
                                            ? ''
                                            : Helpers.formatDateTime(expiredAt),
                                        textAlign: TextAlign.justify,
                                        style: blackTextStyle))
                              ]),
                              SizedBox(height: defaultMargin),
                              Text("Report Exchange",
                                  style: blackTextStyle.copyWith(
                                      fontWeight: semibold)),
                              const SizedBox(height: 10),
                              reportExchangeCardWidget(
                                  const Color(0XFF425F57),
                                  'Total Discount Used',
                                  'Rp ${Helpers.formatCurrencyID(totalDiscount)}'),
                              const SizedBox(height: 5),
                              Row(children: [
                                Expanded(
                                    child: reportExchangeCardWidget(
                                        const Color(0XFF749F82),
                                        'Total Voucher Claim',
                                        totalClaim)),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: reportExchangeCardWidget(
                                        const Color(0XFFA9AF7E),
                                        'Total Voucher Used',
                                        totalUse))
                              ])
                            ]))
                  ])),
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: defaultMargin, vertical: 10),
              child: WidgetButtonPrimary(
                  label: 'Update Voucher',
                  onClick: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => FormVoucherAdminPage(
                                    voucherModel: VoucherModel(
                                        id: widget.id.toString(),
                                        name: nameVoucher,
                                        image: image,
                                        description: description, //
                                        discountPercent: int.parse(
                                            (discountPercent == '')
                                                ? '0'
                                                : discountPercent),
                                        discountPrice: int.parse(
                                            (discountPrice == '')
                                                ? '0'
                                                : discountPrice),
                                        activeAt: activeAt,
                                        expiredAt: expiredAt,
                                        isDiscount: int.parse(isDiscount),
                                        point: int.parse(point),
                                        createdAt: createdAt))))
                        .then((value) async {
                      setState(() {
                        isContent = false;
                      });
                      await getDetailVoucher();
                    });
                  }))
        ]));
  }

  Widget reportExchangeCardWidget(Color color, String title, String subtitle) =>
      Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                textAlign: TextAlign.justify,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: whiteTextStyle),
            const SizedBox(height: 3),
            Text(subtitle,
                textAlign: TextAlign.justify,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    whiteTextStyle.copyWith(fontSize: 18, fontWeight: semibold))
          ]));
}
