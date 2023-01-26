part of 'pages.dart';

class DetailNotificationPage extends StatelessWidget {
  final String id;
  const DetailNotificationPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<NotificationModel?> getDetailNotification() async {
      GlobalModel response =
          // ignore: use_build_context_synchronously
          await GlobalService.getData(
              "${BaseURL.apiGetDetailNotifications}?id=$id", context);
      if (response.status == 'success') {
        NotificationModel? notification;
        notification = NotificationModel(
            id: response.result['id'],
            userID: response.result['user_id'],
            title: response.result['title'],
            description: response.result['description'],
            isRead: int.parse(response.result['is_read']),
            createdAt: response.result['created_at']);
        return notification;
      } else {
        // ignore: use_build_context_synchronously
        Utilities.showAlertDialog(
            context, alertPeringatan, response.errorMessage);
        return null;
      }
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Detail Notification')),
        body: FutureBuilder(
            future: getDetailNotification(),
            builder: (context, snapshot) {
              NotificationModel? notification;
              if (snapshot.hasData) {
                notification = snapshot.data as NotificationModel;
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(
                    padding: EdgeInsets.symmetric(vertical: defaultMargin),
                    children: [
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: defaultMargin),
                          // alignment: Alignment.centerLeft,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.mark_email_read_outlined,
                                    size: 40),
                                const SizedBox(height: 8),
                                Text('Incoming Message',
                                    style:
                                        blackTextStyle.copyWith(fontSize: 15)),
                                const SizedBox(height: 5),
                                Text(
                                    (notification?.createdAt == null)
                                        ? ''
                                        : Helpers.formatDateTime(
                                            notification!.createdAt!),
                                    style: greyTextStyle),
                                const SizedBox(height: 10),
                              ])),
                      Divider(height: 0, color: kGreyColor),
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: defaultMargin),
                          // alignment: Alignment.centerLeft,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(notification?.title ?? '',
                                    style: blackTextStyle.copyWith(
                                        fontWeight: semibold, fontSize: 16)),
                                const SizedBox(height: 5),
                                Text(notification?.description ?? '',
                                    style: blackTextStyle)
                              ]))
                    ]);
              }
              return const Center(child: WidgetLoadingProcess());
            }));
  }
}
