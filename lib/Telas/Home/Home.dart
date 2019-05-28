import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kivaga/Helpers/Helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kivaga/Objetos/Cidade.dart';
import 'package:kivaga/Objetos/User.dart';
import 'package:kivaga/Telas/Home/PaginaPrincipalController.dart';
import 'package:kivaga/Telas/Map/CadastrarRuaPage.dart';
import 'package:kivaga/Telas/Map/EstacionarPage.dart';
import 'package:latlong/latlong.dart';
import 'package:shimmer/shimmer.dart';

final Color backgroundColor = Colors.white;

class HomePage extends StatefulWidget {
  Helper h = new Helper();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  final PagesController pc = new PagesController(0);
  bool openedDL = false;

  PageController pageController;
  int page = 0;

  User u;
  var page0;
  var page1;
  var page2 = Container(child: Container());
  var page3 = Container(child: Container());
  var page4 = Container(child: Container());
  bool openNews = true;
  Color c = Colors.black87;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  var page0,page1,page2,page3;

  KivagaLogo(context, m1, m2) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * m1,
      height: MediaQuery.of(context).size.height * m2,
      child: Container(
        padding: EdgeInsets.all(1),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * m1,
        height: MediaQuery.of(context).size.height * m2,
        color: Colors.transparent,
        child: Image(
          image: AssetImage('assets/logo_kivaga.png'),
          width: MediaQuery.of(context).size.width * m1,
          height: MediaQuery.of(context).size.height * m2,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.currentUser().then((user) {
      print(user);
      if (user != null) {
        Helper.user = user;
        print(Helper.user);
      }
    });
    pageController = new PageController(initialPage: this.page, keepPage: true);
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  Separator(context) {
    return Container(
        width: MediaQuery.of(context).size.width * .5,
        height: 2,
        color: Colors.grey[200]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    FirebaseDynamicLinks.instance.retrieveDynamicLink().then((v) {
      print('AQUI DINAMIC LINK DEMONIO');
      Uri deepLink = null;
      if (v != null) {
        deepLink = v.link;
      }
      print('AQUI BUSCANDO' + deepLink.toString());

      /* if (deepLink != null) {
        var a = deepLink.path.split('/');
        print('DEEP LINK ' + a.toString());
        print(a.last);
        if (!openedDL) {
          mlc.getProtocoloFromDL(a.last).then((p) {
            if (p != null) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ComentarioPage(p)));
              openedDL = true;
            }
          }).catchError((err) {
            print('Error: ${err.toString()}');
          });
        }
      }*/
    });

    return StreamBuilder<int>(
        stream: pc.outPageController,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.data != null) {
            return WillPopScope(
                onWillPop: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // return object of type Dialog
                        return AlertDialog(
                          shape: Border.all(),
                          title: new Text('Deseja Sair?'),
                          content: Text('Tem Certeza?'),
                          actions: <Widget>[
                            MaterialButton(
                              child: Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.blue),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            MaterialButton(
                              child: Text(
                                'Sair',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                SystemNavigator.pop();
                              },
                            )
                          ],
                        );
                      });
                },
                child: Scaffold(
                  key: scaffoldKey,
                  backgroundColor: backgroundColor,
                  body: Stack(
                    children: <Widget>[
                      menu(context),
                      dashboard(context, snapshot),
                    ],
                  ),
                ));
          } else {
            return Container();
          }
        });
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 64, 0, 0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: CachedNetworkImageProvider(Helper.user !=
                              null
                          ? Helper.user.photoUrl
                          : 'https://www.fkbga.com/wp-content/uploads/2018/07/person-icon-6.png'),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Helper.user != null
                              ? Helper.user.displayName
                              : 'Carregando Usuario',
                          style: TextStyle(
                              fontSize: 24, fontStyle: FontStyle.normal),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '@' + Helper.user.displayName.replaceAll(' ', '.'),
                          style: TextStyle(
                              color: Colors.orange,
                              fontStyle: FontStyle.italic),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 16),
                Separator(context),
                SizedBox(
                  height: 16,
                ),
                MenuButton(
                    context, 'Editar Perfil', Icons.person, false, () {}),
                MenuButton(context, 'Adicionar Creditos', Icons.credit_card,
                    false, () {}),
                MenuButton(
                    context, 'Configurações', Icons.settings, false, () {}),
                MenuButton(context, 'Ajuda', Icons.help, false, () {}),
                MenuButton(context, 'Logout', Icons.exit_to_app, true, () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MenuButton(context, text, icon, isLogout, onPress) {
    return Container(
        width: MediaQuery.of(context).size.width * .5,
        height: 40,
        child: MaterialButton(
          onPressed: onPress,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 5),
              Icon(
                icon,
                color: !isLogout ? Colors.orange : Colors.grey,
                size: 24,
              ),
              SizedBox(
                width: 3,
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400),
              ),
              //Icon(Icons.arrow_forward_ios)
            ],
          ),
        ));
  }

  Widget dashboard(context, snapshot) {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          elevation: 8,
          color: backgroundColor,
          child: PageContent(context, snapshot),
        ),
      ),
    );
  }

  WidgetTopMenu(context, Widget page) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .8,
        padding: const EdgeInsets.only(left: 0, right: 0, top: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.blue,
                height: MediaQuery.of(context).size.height * .1,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      child: Icon(Icons.menu, color: Colors.white),
                      onTap: () {
                        setState(() {
                          if (isCollapsed)
                            _controller.forward();
                          else
                            _controller.reverse();

                          isCollapsed = !isCollapsed;
                        });
                      },
                    ),
                    KivagaLogo(context, .2, .05),
                    Icon(Icons.settings, color: Colors.white),
                  ],
                ),
              ),
              page
            ]));
  }

  PageContent(context, snapshot) {
    page0 = WidgetTopMenu(
        context,
        Column(
          children: <Widget>[
            Text(
              "Transactions",
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .75,
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Macbook"),
                        subtitle: Text("Apple"),
                        trailing: Text("-2900"),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(height: 16);
                    },
                    itemCount: 10))
          ],
        ));

    page1 = WidgetTopMenu(context,
        Column(children: <Widget>[CadastrarRuaPage(cidade: Helper.OuroPreto)]));
    page2 = WidgetTopMenu(context,
        Column(children: <Widget>[EstacionarPage(cidade: Helper.OuroPreto)]));
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          bottomNavigationBar: BottomAppBar(
              shape: CircularNotchedRectangle(),
              color: Colors.grey[200],
              child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    snapshot.data == 0
                        ? Shimmer.fromColors(
                            baseColor: Colors.blue,
                            highlightColor: Colors.white,
                            direction: ShimmerDirection.ttb,
                            period: Duration(seconds: 6),
                            child: IconButton(
                              tooltip: 'Principal',
                              icon: new Icon(Icons.home),
                              color: Colors.blue,
                              iconSize: 35,
                              onPressed: () => onTap(1),
                            ))
                        : IconButton(
                            tooltip: 'Principal',
                            icon: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Icon(Icons.home),
                              ],
                            ),
                            color: Colors.grey[600],
                            iconSize: 35,
                            onPressed: () {
                              onTap(0);
                            },
                          ),
                    snapshot.data == 1
                        ? Shimmer.fromColors(
                            baseColor: Colors.blue,
                            highlightColor: Colors.white,
                            direction: ShimmerDirection.ttb,
                            period: Duration(seconds: 6),
                            child: IconButton(
                              tooltip: 'Procurar',
                              icon: new Icon(Icons.search),
                              color: Colors.blue,
                              iconSize: 35,
                              onPressed: () => onTap(1),
                            ))
                        : IconButton(
                            tooltip: 'Procurar',
                            icon: new Icon(Icons.search),
                            color: Colors.grey[600],
                            iconSize: 35,
                            onPressed: () => onTap(1),
                          ),
                    snapshot.data == 2
                        ? Shimmer.fromColors(
                            baseColor: Colors.blue,
                            highlightColor: Colors.white,
                            direction: ShimmerDirection.ttb,
                            period: Duration(seconds: 6),
                            child: IconButton(
                              tooltip: 'Mapa da Cidade',
                              icon: new Icon(Icons.shopping_cart),
                              color: Colors.grey[600],
                              iconSize: 35,
                              onPressed: () => onTap(2),
                            ),
                          )
                        : IconButton(
                            tooltip: 'Mapa da Cidade',
                            icon: new Icon(Icons.shopping_cart),
                            color: Colors.grey[600],
                            iconSize: 35,
                            onPressed: () => onTap(2),
                          ),
                    snapshot.data == 3
                        ? Shimmer.fromColors(
                            baseColor: Colors.blue,
                            highlightColor: Colors.white,
                            direction: ShimmerDirection.ttb,
                            period: Duration(seconds: 6),
                            child: IconButton(
                              tooltip: 'Perfil',
                              icon: new Icon(Icons.person),
                              color: Colors.blue,
                              iconSize: 35,
                              onPressed: () => onTap(3),
                            ),
                          )
                        : IconButton(
                            tooltip: 'Perfil',
                            icon: new Icon(Icons.person),
                            color: Colors.grey[600],
                            iconSize: 35,
                            onPressed: () => onTap(3),
                          ),
                    snapshot.data == 4
                        ? Shimmer.fromColors(
                            baseColor: Colors.blue,
                            highlightColor: Colors.white,
                            direction: ShimmerDirection.ttb,
                            period: Duration(seconds: 6),
                            child: IconButton(
                              tooltip: 'Feed de Relatos',
                              icon: new Icon(Icons.work),
                              color: Colors.blue,
                              iconSize: 35,
                              onPressed: () => onTap(4),
                            ))
                        : IconButton(
                            tooltip: 'Feed de Relatos',
                            icon: new Icon(Icons.work),
                            color: Colors.grey[600],
                            iconSize: 35,
                            onPressed: () => onTap(4),
                          ),

                    /*new BottomNavigationBarItem(
                              icon: new Icon(Icons.location_on),
                              title: new Text("Mapa")),
                          new BottomNavigationBarItem(
                              icon: new Icon(Icons.account_circle),
                              title: new Text("Perfil"))*/
                  ])),
          body: PageView(
              physics: snapshot.data == 1
                  ? NeverScrollableScrollPhysics()
                  : BouncingScrollPhysics(),
              children: [page0, page1, page2, page3, page4],
              controller: pageController,
              onPageChanged: onPageChanged),
        ));
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
