part of 'pages.dart';

class DetailMyVoucher extends StatefulWidget {
  final String id;
  const DetailMyVoucher({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailMyVoucher> createState() => _DetailMyVoucherState();
}

class _DetailMyVoucherState extends State<DetailMyVoucher> {
  final TextEditingController totalAmountController = TextEditingController();
  bool isLoadingPage = false, isContent = false, isLoadingButton = false;
  String nameVoucher = "",
      descriptionVoucher = "",
      pointVoucher = "",
      imageVoucher = "",
      isDiscount = "",
      discountPercent = "",
      discountPrice = "",
      isClaim = "",
      isUse = "",
      claimAt = "",
      useAt = "",
      stepExchange = "",
      userID = "",
      expiredAt = '';

  Future<void> getDetailMyVoucher() async {
    setState(() {
      isLoadingPage = true;
    });
    GlobalModel response = await GlobalService.getData(
        '${BaseURL.apiDetailMyVouchers}?voucher_claim_id=${widget.id}',
        context);
    if (response.status == 'success') {
      setState(() {
        userID = response.result['data']['user_claim'];
        nameVoucher = response.result['data']['name_voucher'];
        descriptionVoucher = response.result['data']['description'];
        pointVoucher = response.result['data']['point_voucher'];
        imageVoucher = response.result['data']['image_voucher'];
        isDiscount = response.result['data']['is_discount'];
        discountPercent = response.result['data']['discount_percent'];
        discountPrice = response.result['data']['discount_price'];
        isClaim = response.result['data']['is_claim'];
        isUse = response.result['data']['is_use'] ?? "0";
        claimAt = response.result['data']['claim_at'];
        useAt = response.result['data']['use_at'] ?? "";
        expiredAt = response.result['data']['expired_at'] ?? "";
        stepExchange = response.result['step_exchange'];
        isContent = true;
      });
    } else {
      if (!mounted) return;
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
    setState(() {
      isLoadingPage = false;
    });
  }

  int totalPaid() {
    int total = 0;
    if (isDiscount == "1") {
      total = int.parse(totalAmountController.text) -
          (int.parse(discountPercent) /
                  100 *
                  int.parse(totalAmountController.text))
              .round();
    }
    if (isDiscount == "0") {
      total = int.parse(totalAmountController.text) - int.parse(discountPrice);
    }
    return total;
  }

  Future<void> useVoucher(StateSetter setter) async {
    setter(() {
      isLoadingButton = true;
    });
    GlobalModel response = await GlobalService.postData(
        BaseURL.apiUseVoucher,
        {
          'user_id': userID,
          'id_voucher_claim': widget.id,
          'total_purchase': totalAmountController.text
              .replaceAll(',', '')
              .replaceAll('.', ''),
          'total_after_discount': totalPaid().toString()
        },
        context);
    setter(() {
      isLoadingButton = false;
    });
    if (!mounted) return;
    if (response.status == 'success') {
      Utilities.showAlertDialogWithFunction(
          context, 'Congratulations !', response.result, () async {
        Navigator.pop(context);
        await getDetailMyVoucher();
      });
    } else {
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
    }
  }

  @override
  void dispose() {
    totalAmountController.dispose();
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getDetailMyVoucher();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Detail My Voucher')),
        body: WidgetLoadingOverlay(
            isLoading: isLoadingPage,
            child: (!isContent)
                ? const SizedBox()
                : ListView(children: [
                    SizedBox(
                        width: double.infinity,
                        height: 180,
                        child: Image.network(
                            '${BaseURL.pahtImageNetwork}/vouchers/$imageVoucher',
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
                              Text(descriptionVoucher,
                                  textAlign: TextAlign.justify,
                                  style: blackTextStyle),
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
                              Text("How to use vouchers ?",
                                  style: blackTextStyle.copyWith(
                                      fontWeight: semibold)),
                              const SizedBox(height: 3),
                              Text(stepExchange,
                                  textAlign: TextAlign.justify,
                                  style: blackTextStyle.copyWith(height: 1.5)),
                              const SizedBox(height: 10)
                            ]))
                  ])),
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          if (isUse == "0")
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultMargin, vertical: 10),
                child: WidgetButtonPrimary(
                    label: 'Use Voucher',
                    onClick: () {
                      totalAmountController.clear();
                      showModalBottomSheetFunction();
                    })),
          if (isUse == "1")
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultMargin, vertical: 10),
                child: Row(children: [
                  Text("Voucher has been used on : ",
                      textAlign: TextAlign.justify,
                      style: blackTextStyle.copyWith(fontWeight: semibold)),
                  Expanded(
                      child: Text(
                          (useAt == '') ? '' : Helpers.formatDateTime(useAt),
                          textAlign: TextAlign.justify,
                          style: blackTextStyle))
                ]))
        ]));
  }

  showModalBottomSheetFunction() => showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) => Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                  // ListTile(
                  //     title: Text('Exchange Voucher',
                  //         style: blackTextStyle)),
                  const SizedBox(height: 10),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultMargin),
                      child: Column(children: [
                        WidgetInputBox(
                            controller: totalAmountController,
                            label: "How Much Total Shopping",
                            hintText: 'Enter total shopping',
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            onchange: (val) {
                              if (WidgetsBinding
                                      .instance.window.viewInsets.bottom ==
                                  0.0) {
                                setState(() {
                                  if (val != '' || val.isNotEmpty) {
                                    totalAmountController.text = val;
                                  }
                                });
                              }
                            },
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                        if (totalAmountController.text.isNotEmpty)
                          Column(children: [
                            Row(children: [
                              Expanded(
                                  child: Text('Total Purchase',
                                      style: blackTextStyle)),
                              Text(
                                  'Rp ${Helpers.formatCurrencyID(totalAmountController.text)}',
                                  textAlign: TextAlign.justify,
                                  style: blackTextStyle.copyWith(
                                      fontWeight: semibold))
                            ]),
                            const SizedBox(height: 5),
                            Row(children: [
                              Expanded(
                                  child:
                                      Text('Discounts', style: blackTextStyle)),
                              Text(
                                  (isDiscount == '1')
                                      ? '$discountPercent %'
                                      : Helpers.formatCurrencyID(discountPrice),
                                  textAlign: TextAlign.justify,
                                  style: blackTextStyle.copyWith(
                                      fontWeight: semibold))
                            ]),
                            const SizedBox(height: 3),
                            Divider(height: 0, color: kGreyColor),
                            const SizedBox(height: 3),
                            Row(children: [
                              Expanded(
                                  child: Text('Total Must Be Paid',
                                      style: blackTextStyle)),
                              Text(
                                  "Rp ${Helpers.formatCurrencyID(totalPaid().toString())}",
                                  textAlign: TextAlign.justify,
                                  style: blackTextStyle.copyWith(
                                      fontWeight: semibold))
                            ]),
                            const SizedBox(height: 10)
                          ]),
                        if (totalAmountController.text.isNotEmpty)
                          WidgetButtonPrimary(
                              label: 'Confirmation',
                              isLoading: isLoadingButton,
                              onClick: () {
                                Utilities.showConfirmationDialog(
                                    context,
                                    alertPeringatan,
                                    'Is the nominal entered correct ?', () {
                                  useVoucher(setState);
                                });
                              })
                      ])),
                  const SizedBox(height: 10)
                ]))));
      });
}
