import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'models/employer.dart';
import 'commission_views/today_view.dart';
import 'logic/app_state.dart';
import 'history_page/history_view.dart';
import 'account_dialog.dart';
import 'calculator_page/calculator_page.dart';
import 'main.dart';

class _HomeViewModel {
  _HomeViewModel(
      {this.employers,
      this.onGetCurrentEmployer,
      this.currentUser,
      this.onLogout});
  final List<Employer> employers;
  final Function() onGetCurrentEmployer;
  final FirebaseUser currentUser;
  final Function() onLogout;
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.onSignedOut}) : super(key: key);
  final String title;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  

  BannerAd bannerAd;
  InterstitialAd interstitialAd;

  BannerAd buildBanner() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.smartBanner,
        listener: (MobileAdEvent event) {
          print(event);
        });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: APP_ID);
    bannerAd = buildBanner()..load();
  }

  @override
  void dispose() {
    bannerAd?.dispose();
    interstitialAd?.dispose();
    super.dispose();
  }

  void _openAddEntryDialog(_HomeViewModel viewModel) async {
    bool justLogOut = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return new AccountDialog(onSignedOut: widget.onSignedOut);
            },
            fullscreenDialog: true));
    if (justLogOut != null && justLogOut) {
      widget.onSignedOut();
      viewModel.onLogout();
      await FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seen', false);
    }
  }

  InterstitialAd buildInterstitial() {
    return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          if (event == MobileAdEvent.failedToLoad) {
            interstitialAd..load();
          } else if (event == MobileAdEvent.closed) {
            interstitialAd = buildInterstitial()..load();
          }

          print(event);
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [TodayView(), HistoryView(), CalculatorPage()];
    //bannerAd..show(anchorOffset: 50.0);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset('assets/icon-retangle.png'),
            Text(widget.title),
          ],
        ),
        actions: <Widget>[
          StoreConnector<AppState, _HomeViewModel>(converter: (store) {
            return _HomeViewModel(
                currentUser: store.state.currentUser,
                onLogout: () => store.dispatch(new LogoutAction()));
          }, builder: (BuildContext context, _HomeViewModel viewModel) {
            Widget accountIcon = Icon(Icons.account_circle);
            if (viewModel.currentUser.photoUrl != null) {
              accountIcon = CircleAvatar(
                backgroundImage: NetworkImage(viewModel.currentUser.photoUrl),
                maxRadius: 16.0,
              );
            }
            return IconButton(
              icon: accountIcon,
              onPressed: () => _openAddEntryDialog(viewModel),
            );
          }),
        ],
      ),
      //drawer: MyDrawer(),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColorLight,
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('History'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assessment), title: Text('Calculator'))
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
