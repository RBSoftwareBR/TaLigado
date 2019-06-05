import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:kivaga/Helpers/features/widget/CustomButton.dart';
import 'package:kivaga/Telas/Login/LoginController.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Login extends StatelessWidget {
  LoginController lc = new LoginController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/bg_login.png'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 40.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.height * .12,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * .3,
                    height: MediaQuery.of(context).size.height * .12,
                    color: Colors.transparent,
                    child: Image(
                      image: AssetImage('assets/logo_kivaga.png'),
                      width: MediaQuery.of(context).size.width * .7,
                      height: MediaQuery.of(context).size.height * .7,
                    ),
                  ),
                ),
                CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/loginemail');
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  text: 'Login pelo Email',
                  image: Icons.email,
                ),
                CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/logintelefone');
                  },
                  color: Colors.green,
                  textColor: Colors.white,
                  text: 'Login pelo Telefone',
                  image: Icons.phone,
                ),
                GoogleSignInButton(
                  onPressed: () {
                    lc.LoginGoogle().then((r) {
                      if (r == 0) {
                        pushHome(context);
                      } else {
                        print(r.toString());
                      }
                    }).catchError((onError));
                  },
                  text: 'Login pelo Google',
                ),
                CustomButton(
                  onPressed: () {
                    lc.LoginInstagram().then((r) {
                      print('Retornou Login Instagram $r');
                      if (r == 0) {
                        pushHome(context);
                      } else {
                        print(r.toString());
                      }
                    }).catchError((onError));
                  },
                  color: Colors.purple,
                  textColor: Colors.white,
                  text: 'Login pelo Instagram',
                  image: MdiIcons.instagram,
                ),
                FacebookSignInButton(
                  onPressed: () {
                    lc.LoginFacebook().then((r) {
                      if (r == 0) {
                        pushHome(context);
                      } else {
                        print(r.toString());
                      }
                    }).catchError((onError));
                  },
                  text: 'Login pelo Facebook',
                ),
                TwitterSignInButton(
                  onPressed: () {
                    lc.LoginTwitter().then((r) {
                      if (r == 0) {
                        pushHome(context);
                      } else {
                        print(r.toString());
                      }
                    }).catchError((onError));
                  },
                  text: 'Login pelo Twitter',
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  onError(err) {
    print('Error: ${err.toString()}');
  }

  pushHome(context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
