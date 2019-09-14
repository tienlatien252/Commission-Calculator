import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'commission_page/today_view.dart';
import 'package:Calmission/profile_page/account_page.dart';
import 'package:Calmission/calculator_page/calculator_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.onSignedOut}) : super(key: key);
  final String title;
  final VoidCallback onSignedOut;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin , AutomaticKeepAliveClientMixin<HomePage> {
  bool onLogout = false;
  GlobalKey _scaffold = GlobalKey();
  TabController _controller;

  List<Widget> _pages = [TodayView(), CalculatorPage(), AccountPage()];

  void _onTabTapped(int index) {
    _controller.animateTo(index);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _pages.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffold,
      body: TabBarView(
          controller: _controller,
          children: _pages.map<Widget>((Widget page) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Container(
                  key: ObjectKey(page),
                  //padding: const EdgeInsets.all(12.0),
                  child: page),
            );
          }).toList()),
      bottomNavigationBar: CustomBottomBar(
        controller: _controller,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomBottomBar extends StatefulWidget {
  final TabController controller;

  CustomBottomBar({Key key, this.controller}) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  void _onPressed(int index) {
    widget.controller.animateTo(index);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TabIcon(
            selected: widget.controller.index == 0,
            icon: Icons.home,
            onPressed: () => _onPressed(0),
            text: 'Today',
          ),
          TabIcon(
            selected: widget.controller.index == 1,
            icon: Icons.assessment,
            onPressed: () => _onPressed(1),
            text: 'Calculator',
          ),
          TabIcon(
            selected: widget.controller.index == 2,
            icon: Icons.account_circle,
            onPressed: () => _onPressed(2),
            text: 'Profile',
          ),
        ],
      ),
    );
  }
}

class TabIcon extends StatefulWidget {
  final IconData icon;
  final Function onPressed;
  final bool selected;
  final String text;

  TabIcon({Key key, this.icon, this.onPressed, this.selected, this.text})
      : super(key: key);

  @override
  _TabIconState createState() => _TabIconState();
}

class _TabIconState extends State<TabIcon> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          padding: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                widget.icon,
                color: widget.selected
                    ? Theme.of(context).primaryColor
                    : Colors.blueGrey,
              ),
              Text(
                widget.text,
                style: TextStyle(
                    color: widget.selected
                        ? Theme.of(context).primaryColor
                        : Colors.blueGrey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
