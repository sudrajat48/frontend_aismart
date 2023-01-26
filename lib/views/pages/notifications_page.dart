part of 'pages.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool isLoading = false;
  Future<List<NotificationModel?>> getNotifications() async {
    SharedPreferences sharedPref = await GlobalService.sharedPreference;
    String? id = sharedPref.getString(UserPreferenceModel.userID);
    GlobalModel response =
        // ignore: use_build_context_synchronously
        await GlobalService.getData(
            "${BaseURL.apiGetNotifications}?user_id=$id", context);
    if (response.status == 'success') {
      List<NotificationModel> notifications = [];
      for (var item in response.result['data']) {
        notifications.add(NotificationModel.fromJson(item));
      }
      return notifications;
    } else {
      // ignore: use_build_context_synchronously
      Utilities.showAlertDialog(
          context, alertPeringatan, response.errorMessage);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: FutureBuilder(
            future: getNotifications(),
            builder: (context, snapshot) {
              List<NotificationModel>? notificationsModel;
              if (snapshot.hasData) {
                notificationsModel = snapshot.data as List<NotificationModel>;
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return WidgetLoadingOverlay(
                    isLoading: isLoading,
                    child: RefreshIndicator(
                        onRefresh: () async {
                          await getNotifications();
                        },
                        child: ListView(
                            children: notificationsModel!
                                .map((e) => Column(children: [
                                      ListTile(
                                          onTap: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            GlobalModel response =
                                                await GlobalService.postData(
                                                    BaseURL
                                                        .apiReadNotifications,
                                                    {'id': e.id},
                                                    context);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            if (!mounted) return;
                                            if (response.status == 'success') {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          DetailNotificationPage(
                                                              id: e.id!))).then(
                                                  (value) {
                                                setState(() {});
                                              });
                                            } else {
                                              Utilities.showAlertDialog(
                                                  context,
                                                  alertPeringatan,
                                                  response.errorMessage);
                                            }
                                          },
                                          horizontalTitleGap: 5,
                                          leading: SizedBox(
                                              height: double.infinity,
                                              child: Icon(
                                                  (e.isRead == 0)
                                                      ? Icons
                                                          .mark_email_unread_outlined
                                                      : Icons
                                                          .mark_email_read_outlined,
                                                  color: (e.isRead == 0)
                                                      ? kBlackColor
                                                      : kGreyColor)),
                                          title: Text(
                                              e.title.toString().allInCaps,
                                              style: blackTextStyle.copyWith(
                                                  fontWeight: semibold)),
                                          subtitle: Text(
                                              (e.createdAt == null)
                                                  ? ''
                                                  : Helpers.formatDateTime(
                                                      e.createdAt!),
                                              style: blackTextStyle)),
                                      Divider(height: 0, color: kGreyColor)
                                    ]))
                                .toList())));
              }
              return const Center(child: WidgetLoadingProcess());
            }));
  }
}
