import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './BookmarkScreen.dart' as BookmarkScreen;
import './CategoriesScreen.dart' as CategoriesScreen;
import './HomePage.dart' as HomeFeedScreeen;
import './SourceLibraryScreen.dart' as SourceLibraryScreen;
import 'Helpers.dart';
import 'globalStore.dart';

Future main() async {
  Brightness brightness;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  brightness =
      (prefs.getBool("isDark") ?? false) ? Brightness.dark : Brightness.light;
  Helpers.brightness = prefs.getBool("isDark" ?? false);
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'TaLigado',
    options: FirebaseOptions(
      googleAppID: Platform.isIOS
          ? '1:853257329399:android:0adaf19ba1eabc9a'
          : '1:853257329399:android:0adaf19ba1eabc9a',
      gcmSenderID: '853257329399',
      apiKey: 'AIzaSyCWK6ZLrKyfP9LI-wQVhXfYszJPFngspug',
      projectID: 'taligado-60ebc',
    ),
  );
  final FirebaseStorage storage = FirebaseStorage(
      app: app, storageBucket: 'gs://taligado-60ebc.appspot.com');
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

  @override
  Future initState() {
    super.initState();

    controller = new TabController(vsync: this, length: 2);
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
    LoginController lc = new LoginController();
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
            ),
            /*IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                lc.logOf();
              },
            )*/
          ],
        ),
        bottomNavigationBar: StreamBuilder(
            stream: lc.outUser,
            builder: (context, snap) {
              return snap.data != null
                  ? new Material(
                      child: new TabBar(controller: controller, tabs: <Tab>[
                      new Tab(icon: new Icon(Icons.view_headline, size: 30.0)),
                      //new Tab(icon: new Icon(Icons.view_module, size: 30.0)),
                      //new Tab(icon: new Icon(Icons.explore, size: 30.0)),
                      new Tab(icon: new Icon(Icons.bookmark, size: 30.0)),
                    ]))
                  : Container(
                      height: 0,
                    );
            }),
        body: StreamBuilder(
            stream: lc.outUser,
            builder: (context, snap) {
              return StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return snap.data != null
                      ? new TabBarView(controller: controller, children: <Widget>[
                          new HomeFeedScreeen.HomePage(),
                          //new SourceLibraryScreen.SourceLibraryScreen(),
                          //new CategoriesScreen.CategoriesScreen(),
                          new BookmarkScreen.BookmarksScreen(),
                        ])
                      : LoginPage(lc);
                }
              );
            }));
  }
}

class LoginPage extends StatefulWidget {
  LoginController lc;
  LoginPage(this.lc);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future getImage() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                FlatButton.icon(
                  icon: const Icon(Icons.camera_alt, size: 18.0),
                  label: const Text('Camera', semanticsLabel: 'Camera'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    File image =
                        await ImagePicker.pickImage(source: ImageSource.camera);

                    widget.lc.inImage.add(image);
                  },
                ),
                FlatButton.icon(
                  icon: const Icon(Icons.photo, size: 18.0),
                  label: const Text('Galeria', semanticsLabel: 'Galeria'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    File image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);

                    widget.lc.inImage.add(image);
                  },
                )
              ],
            ),
          );
        });
  }

  TextEditingController tec = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Helpers.brightness == null
                    ? [Colors.indigo, Colors.white]
                    : Helpers.brightness
                        ? [Colors.black, Colors.white]
                        : [Colors.indigo, Colors.white])),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bem vindo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Vamos te ajudar a ficar por dentro das principais Noticias',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: Stack(children: <Widget>[
                Center(
                  child: StreamBuilder<File>(
                      stream: widget.lc.outImage,
                      builder: (context, snapshot) {
                        return CircleAvatar(
                          maxRadius: 60,
                          minRadius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: snapshot.hasData
                              ? FileImage(snapshot.data)
                              : AssetImage(
                                  'assets/selfie.png',
                                ),
                        );
                      }),
                ),
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Helpers.brightness == null
                            ? Colors.indigo
                            : Helpers.brightness ? Colors.black : Colors.indigo,
                        borderRadius: BorderRadius.all(Radius.circular(60))),
                    child: Icon(
                      Icons.file_upload,
                      size: 45,
                    ),
                  ),
                  bottom: 10,
                  left: (MediaQuery.of(context).size.width / 2) - 25,
                ),
              ]),
              onTap: () {
                getImage();
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: tec,
              textCapitalization: TextCapitalization.words,
              style: TextStyle(
                fontSize: 22,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                labelText: 'Qual seu nome?',
                hintText: 'João',
                hintStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.grey[600],
                ),
                labelStyle: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<File>(
                stream: widget.lc.outImage,
                builder: (context, snapshot) {
                  return RaisedButton(
                    child: Text("Começar", style: TextStyle(fontSize: 16)),
                    padding: EdgeInsets.all(12),
                    color: Helpers.brightness == null
                        ? Colors.indigo
                        : Helpers.brightness ? Colors.black : Colors.indigo,
                    textColor: Colors.white,
                    onPressed: () {
                      if (tec.text.length != 0) {
                        //if (snapshot.data != null) {
                        widget.lc.createUser(tec.text, snapshot.data);
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                          'Registrando, isso pode levar alguns segundos!',
                          style: TextStyle(color: Colors.white),
                        )));
                        /*} else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            action: SnackBarAction(
                                label: 'Tirar Foto',
                                onPressed: () {
                                  getImage();
                                }),
                            content: Text(
                              'Ops! parece que você não escolheu uma foto, que tal tirar uma?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ));
                        }*/
                      } else {
                        print('Mostando Snack');
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Ops! parece que você não disse seu nome =/',
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      }
                    },
                  );
                })
          ],
        ),
      ),
    ));
  }
}
