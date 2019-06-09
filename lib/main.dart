import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './BookmarkScreen.dart' as BookmarkScreen;
import './CategoriesScreen.dart' as CategoriesScreen;
import './HomeFeedScreen.dart' as HomeFeedScreeen;
import './SourceLibraryScreen.dart' as SourceLibraryScreen;
import './globalStore.dart' as globalStore;
import 'Helpers.dart';

Future main() async {
  Brightness brightness;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  brightness =
      (prefs.getBool("isDark") ?? false) ? Brightness.dark : Brightness.light;
  Helpers.brightness = prefs.getBool("isDark" ?? false);
  runApp(MyApp(
    brightness: brightness,
  ));
}

class MyApp extends StatelessWidget {
  var brightness;

  MyApp({this.brightness});
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => brightness.index == 0
            ? new ThemeData(
                primarySwatch: Colors.teal,
                buttonColor: Colors.white,
                bottomAppBarColor: Colors.teal,
                primaryIconTheme: IconThemeData(color: Colors.white),
                accentIconTheme: IconThemeData(color: Colors.white),
                buttonTheme: ButtonThemeData(
                  buttonColor: Colors.white,
                ),
                iconTheme: IconThemeData(color: Colors.white, size: 15),
                bottomAppBarTheme:
                    BottomAppBarTheme(color: Colors.teal, elevation: 10),
                tabBarTheme: TabBarTheme(
                  indicator: BoxDecoration(
                      color: Colors.teal, shape: BoxShape.rectangle),
                  labelColor: Colors.white,
                  labelPadding: EdgeInsets.all(3),
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.grey[400],
                ),
                brightness: brightness,
              )
            : new ThemeData(
                primarySwatch: Colors.indigo,
                bottomAppBarColor: Colors.indigo,
                bottomAppBarTheme:
                    BottomAppBarTheme(color: Colors.indigo, elevation: 10),
                tabBarTheme: TabBarTheme(
                  indicator: BoxDecoration(
                      color: Colors.indigo, shape: BoxShape.rectangle),
                  labelColor: Colors.white,
                  labelPadding: EdgeInsets.all(3),
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.grey[400],
                ),
                brightness: brightness,
              ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ta Ligado',
            theme: theme,
            home: new TaLigado(),
          );
        });
  }
}

class TaLigado extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  final userRef = Firestore.instance.collection('Users').reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  createState() => new TaLigadoState();
}

class TaLigadoState extends State<TaLigado>
    with SingleTickerProviderStateMixin {
  TabController controller;
  SharedPreferences prefs;
  bool brightness;
  Future ensureLogIn() async {
    await globalStore.logIn;
  }

  @override
  Future initState() {
    super.initState();
    this.ensureLogIn();

    controller = new TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
    Helpers.brightness =
        Theme.of(context).brightness == Brightness.dark ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Ta Ligado"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.brightness_4),
              onPressed: () {
                changeBrightness();
              },
            )
          ],
        ),
        bottomNavigationBar: new Material(
            child: new TabBar(controller: controller, tabs: <Tab>[
          new Tab(icon: new Icon(Icons.view_headline, size: 30.0)),
          new Tab(icon: new Icon(Icons.view_module, size: 30.0)),
          new Tab(icon: new Icon(Icons.explore, size: 30.0)),
          new Tab(icon: new Icon(Icons.bookmark, size: 30.0)),
        ])),
        body: new TabBarView(controller: controller, children: <Widget>[
          new HomeFeedScreeen.HomeFeedScreen(),
          new SourceLibraryScreen.SourceLibraryScreen(),
          new CategoriesScreen.CategoriesScreen(),
          new BookmarkScreen.BookmarksScreen(),
        ]));
  }
}
