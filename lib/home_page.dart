import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_admob/firebase_admob.dart';

import 'commission_views/today_view.dart';
//import 'history_page/history_view.dart';
import 'account_dialog.dart';
//import 'calculator_page/calculator_page.dart';
//import 'main.dart';
import 'package:Calmission/common/employer_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.onSignedOut}) : super(key: key);
  final String title;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  /*BannerAd bannerAd;
  InterstitialAd interstitialAd;

  BannerAd buildBanner() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.smartBanner,
        listener: (MobileAdEvent event) {
          print(event);
        });
  }*/

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    //FirebaseAdMob.instance.initialize(appId: APP_ID);
    //bannerAd = buildBanner()..load();
  }

  @override
  void dispose() {
    //bannerAd?.dispose();
    //interstitialAd?.dispose();
    super.dispose();
  }

  void _openAddEntryDialog() async {
    bool justLogOut = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) {
              return new AccountDialog(onSignedOut: widget.onSignedOut);
            },
            fullscreenDialog: true));
    if (justLogOut != null && justLogOut) {
      widget.onSignedOut();
      await FirebaseAuth.instance.signOut();
      await resetCurrentEmployer();
    }
  }

  /*InterstitialAd buildInterstitial() {
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
  }*/

  @override
  Widget build(BuildContext context) {
    //bannerAd..show(anchorOffset: 50.0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: <Widget>[
            Image.asset('assets/icon-retangle-rounder.png'),
            SizedBox(
              width: 5.0,
            ),
            Text(widget.title),
          ],
        ),
        actions: <Widget>[
          FutureBuilder(
              future: FirebaseAuth.instance.currentUser(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                FirebaseUser currentUser = snapshot.data;
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    Widget accountIcon = Icon(Icons.account_circle);
                    if (currentUser.photoUrl != null) {
                      accountIcon = CircleAvatar(
                        backgroundImage: NetworkImage(currentUser.photoUrl),
                        maxRadius: 16.0,
                      );
                    }
                    return IconButton(
                      icon: accountIcon,
                      onPressed: () => _openAddEntryDialog(),
                    );
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else
                      return Text('Result: ${snapshot.data}');
                }
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: _currentIndex != 0,
            child: TickerMode(
                enabled: _currentIndex == 0,
                child: TodayView()), // Text("TodayView")), //
          ),
          Offstage(
            offstage: _currentIndex != 1,
            child: TickerMode(
                enabled: _currentIndex == 1,
                child: Text("HistoryView")), //HistoryView()),
          ),
          Offstage(
              offstage: _currentIndex != 2,
              child: TickerMode(
                  enabled: _currentIndex == 2,
                  child: Text("CalculatorPage")) //CalculatorPage()),
              )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColorLight,
            icon: Icon(Icons.home),
            title: Text('Today'),
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
