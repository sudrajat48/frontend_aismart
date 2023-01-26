part of 'pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            onPageChanged: (page) {
              setState(() {
                currentPage = page;
              });
            },
            children: const [
              HomePage(),
              VouchersPage(),
              MyVoucherPage(),
              ProfilePage()
            ]),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentPage,
            items: [
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  label: 'Home',
                  activeIcon: Icon(Icons.home, color: kPrimaryColor)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.verified_outlined),
                  label: 'Promotions',
                  activeIcon: Icon(Icons.verified, color: kPrimaryColor)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.confirmation_num_outlined),
                  label: 'My Vouchers',
                  activeIcon:
                      Icon(Icons.confirmation_num, color: kPrimaryColor)),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outlined),
                  label: 'Profile',
                  activeIcon: Icon(Icons.person, color: kPrimaryColor))
            ],
            onTap: (val) {
              pageController.jumpToPage(val);
            }));
  }
}
