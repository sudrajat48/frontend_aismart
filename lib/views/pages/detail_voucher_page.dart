part of 'pages.dart';

class VoucherDetailPage extends StatefulWidget {
  final VoucherModel voucherModel;
  final int coinsUser;
  final String userID;
  const VoucherDetailPage(
      {Key? key,
      required this.voucherModel,
      required this.coinsUser,
      required this.userID})
      : super(key: key);

  @override
  State<VoucherDetailPage> createState() => _VoucherDetailPageState();
}

class _VoucherDetailPageState extends State<VoucherDetailPage> {
  bool isLoadingBtn = false, isLoadingPage = false;
  int voucherClaim = -1;
  String stepExchange = "";
  Future<void> claimVoucher() async {
    Map<String, dynamic> postParams = {
      'owner_id': widget.voucherModel.userID,
      'user_claim': widget.userID,
      'voucher_id': widget.voucherModel.id,
      // 'name_voucher': widget.voucherModel.name,
      // 'description': widget.voucherModel.description,
      // 'coins_voucher': widget.voucherModel.coins.toString(),
      // 'image_voucher': widget.voucherModel.image,
      // 'is_discount': widget.voucherModel.isDiscount.toString(),
      // 'discount_percent': widget.voucherModel.discountPercent.toString(),
      // 'discount_price': widget.voucherModel.discountPrice.toString()
    };
    setState(() {
      isLoadingBtn = true;
    });
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiClaimVouchers, postParams, context);
    setState(() {
      isLoadingBtn = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      Utilities.showAlertDialogWithFunction(
          context, 'Success ...', response.result['message'], () {
        return Utilities.showAlertDialogWithFunction(
            context, 'How to use vouchers ?', response.result['step_exchange'],
            () async {
          await checkClaimVoucher();
        });
      });
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  Future<void> checkClaimVoucher() async {
    setState(() {
      isLoadingPage = true;
    });
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiCheckClaimStatus,
        {'voucher_id': widget.voucherModel.id, 'user_id': widget.userID},
        context);
    setState(() {
      isLoadingPage = false;
    });
    if (response.status == 'success') {
      setState(() {
        voucherClaim = response.result['is_claim'];
        stepExchange = response.result['step_exchange'];
      });
    } else {
      if (!mounted) return;
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  @override
  void initState() {
    super.initState();
    checkClaimVoucher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Detail Voucher')),
        body: WidgetLoadingOverlay(
          isLoading: isLoadingPage,
          child: ListView(children: [
            SizedBox(
                width: double.infinity,
                height: 180,
                child: (widget.voucherModel.image == '')
                    ? Image.asset('$assetImagePath/placeholder.png',
                        fit: BoxFit.cover)
                    : Image.network(
                        '${BaseURL.pahtImageNetwork}/vouchers/${widget.voucherModel.image}',
                        fit: BoxFit.cover)),
            Container(
                margin: EdgeInsets.symmetric(vertical: defaultMargin),
                padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.voucherModel.name ?? '',
                          style: blackTextStyle.copyWith(
                              fontWeight: semibold, fontSize: 15)),
                      const SizedBox(height: 5),
                      Text(widget.voucherModel.description ?? "",
                          textAlign: TextAlign.justify, style: blackTextStyle),
                      const SizedBox(height: 10),
                      Row(children: [
                        Text("Valid Until : ",
                            textAlign: TextAlign.justify,
                            style:
                                blackTextStyle.copyWith(fontWeight: semibold)),
                        Expanded(
                            child: Text(
                                (widget.voucherModel.expiredAt == null)
                                    ? ''
                                    : Helpers.formatDateTime(widget
                                        .voucherModel.expiredAt
                                        .toString()),
                                textAlign: TextAlign.justify,
                                style: blackTextStyle))
                      ]),
                      SizedBox(height: defaultMargin),
                      Text("How to use vouchers ?",
                          style: blackTextStyle.copyWith(fontWeight: semibold)),
                      const SizedBox(height: 3),
                      Text(stepExchange,
                          textAlign: TextAlign.justify,
                          style: blackTextStyle.copyWith(height: 1.5)),
                      const SizedBox(height: 10)
                    ]))
          ]),
        ),
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          if (voucherClaim == 0)
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultMargin, vertical: 10),
                child: Column(children: [
                  Container(
                      margin: EdgeInsets.only(
                          bottom: (widget.coinsUser <
                                      widget.voucherModel.point! ||
                                  widget.voucherModel.userID == widget.userID)
                              ? 5
                              : 10),
                      child: Row(children: [
                        Expanded(
                            child: Text("Claim voucher with : ",
                                textAlign: TextAlign.justify,
                                style: blackTextStyle)),
                        Text(
                            "${Helpers.formatCurrencyID(widget.voucherModel.point.toString())} Pts",
                            textAlign: TextAlign.justify,
                            style: blackTextStyle.copyWith(
                                fontWeight: semibold, fontSize: 15))
                      ])),
                  if (widget.coinsUser >= widget.voucherModel.point! &&
                      !(widget.voucherModel.userID == widget.userID))
                    WidgetButtonPrimary(
                        label: 'Claim Voucher',
                        onClick: () {
                          Utilities.showConfirmationDialog(
                              context,
                              alertPeringatan,
                              'Are you sure want to claim the voucher? Your coins will be deducted by ${Helpers.formatCurrencyID(widget.voucherModel.point.toString())} for this voucher',
                              () {
                            claimVoucher();
                          });
                        }),
                  if (widget.coinsUser < widget.voucherModel.point! &&
                      !(widget.voucherModel.userID == widget.userID))
                    Text(
                        "You can't redeem this voucher yet because you don't have enough coins",
                        textAlign: TextAlign.justify,
                        style: redTextStyle)
                ])),
          if (voucherClaim == 1)
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultMargin, vertical: 10),
                child: Text("-- You have redeemed this voucher --",
                    textAlign: TextAlign.justify, style: greyTextStyle))
        ]));
  }
}
