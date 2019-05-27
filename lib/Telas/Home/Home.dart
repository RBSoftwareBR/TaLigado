import 'package:flutter/material.dart';
import 'package:kivaga/Helpers/Helper.dart';
import 'package:kivaga/Telas/Home/PaginaPrincipalController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
final Color backgroundColor = Colors.white;
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
   bool isCollapsed = true;

 final PagesController pc = new PagesController(1);
 
  PageController pageController;
  int page = 1;
  double screenWidth, screenHeight;

  final Duration duration = const Duration(milliseconds: 300);

  AnimationController _controller;

  Animation<double> _scaleAnimation;

  Animation<double> _menuScaleAnimation;

  Animation<Offset> _slideAnimation;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(_controller);
    pageController = new PageController(initialPage: this.page, keepPage: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          menu(context),
          dashboard(context),
        ],
      ),
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Dashboard", style: TextStyle(color: Colors.white, fontSize: 22)),
                SizedBox(height: 10),
                Text("Messages", style: TextStyle(color: Colors.white, fontSize: 22)),
                SizedBox(height: 10),
                Text("Utility Bills", style: TextStyle(color: Colors.white, fontSize: 22)),
                SizedBox(height: 10),
                Text("Funds Transfer", style: TextStyle(color: Colors.white, fontSize: 22)),
                SizedBox(height: 10),
                Text("Branches", style: TextStyle(color: Colors.white, fontSize: 22)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: StreamBuilder<int>(
        stream: pc.outPageController,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.data != null) {return Scaffold(
                    key: scaffoldKey,
                    backgroundColor: Colors.white,
                    body: PageView(
                        physics: snapshot.data == 2
                            ? NeverScrollableScrollPhysics()
                            : BouncingScrollPhysics(),
                        children: [page0, page1, page2, page3],
                        controller: pageController,
                        onPageChanged: onPageChanged),
                    bottomNavigationBar: BottomAppBar(
                        shape: CircularNotchedRectangle(),
                        color: Colors.white,
                        child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              snapshot.data == 0
                                  ? IconButton(
                                      tooltip: 'Novidades',
                                      icon: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          snapshot.data == 0
                                              ? Shimmer.fromColors(
                                                  baseColor:
                                                      Helper.blue_default,
                                                  highlightColor: Colors.white,
                                                  child: Icon(
                                                      Icons.notifications,
                                                      color: Helper
                                                          .blue_default))
                                              : Icon(Icons.notifications,
                                                  color: Helper.blue_default),
                        
                                        ],
                                      ),
                                      color:
                                          snapshot.data == 0 ? Helper.blue_default : Colors.white,
                                      iconSize: 25,
                                      onPressed: () {
                                        onTap(0);
                              
                                      },
                                    )
                                  : IconButton(
                                      tooltip: 'Novidades',
                                      icon: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.notifications,
                                            color: Helper.blue_default,
                                          ),
                                        ],
                                      ),
                                      color: Colors.white,
                                      iconSize: 30,
                                      onPressed: () {
                                        onTap(0);
                            
                                      },
                                    ),
                              snapshot.data == 1
                                  ? Shimmer.fromColors(
                                      baseColor: Helper.blue_default,
                                      highlightColor: Colors.white,
                                      child: IconButton(
                                        tooltip: 'Feed de Relatos',
                                        icon: new Icon(Icons.dehaze),
                                        color: Helper.blue_default,
                                        iconSize: 30,
                                        onPressed: () => onTap(1),
                                      ))
                                  : IconButton(
                                      tooltip: 'Feed de Relatos',
                                      icon: new Icon(Icons.dehaze),
                                      color: Helper.blue_default,
                                      iconSize: 30,
                                      onPressed: () => onTap(1),
                                    ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                              ),
                              snapshot.data == 2
                                  ? Shimmer.fromColors(
                                      baseColor: Helper.blue_default,
                                      highlightColor: Colors.white,
                                      child: IconButton(
                                        tooltip: 'Mapa da Cidade',
                                        icon: new Icon(Icons.map),
                                        color: Helper.blue_default,
                                        iconSize: 30,
                                        onPressed: () => onTap(2),
                                      ),
                                    )
                                  : IconButton(
                                      tooltip: 'Mapa da Cidade',
                                      icon: new Icon(Icons.map),
                                      color: Helper.blue_default,
                                      iconSize: 30,
                                      onPressed: () => onTap(2),
                                    ),
                              snapshot.data == 3
                                  ? Shimmer.fromColors(
                                      baseColor: Helper.blue_default,
                                      highlightColor: Colors.white,
                                      child: IconButton(
                                        tooltip: 'Perfil',
                                        icon: new Icon(Icons.people),
                                        color: Helper.blue_default,
                                        iconSize: 30,
                                        onPressed: () => onTap(3),
                                      ),
                                    )
                                  : IconButton(
                                      tooltip: 'Perfil',
                                      icon: new Icon(Icons.people),
                                      color: Helper.blue_default,
                                      iconSize: 30,
                                      onPressed: () => onTap(3),
                                    )

                              /*new BottomNavigationBarItem(
                              icon: new Icon(Icons.location_on),
                              title: new Text("Mapa")),
                          new BottomNavigationBarItem(
                              icon: new Icon(Icons.account_circle),
                              title: new Text("Perfil"))*/
                            ])));}else{return Container();}})
      ),
    );
  }

    void onTap(int index) {
    pc.inPageController.add(index);
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    pc.inPageController.add(page);
  }
}