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
      body: Padding(
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
                height: MediaQuery.of(context).size.height * .3,
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: Image(
                    image: AssetImage('assets/logorb.png'),
                    width: MediaQuery.of(context).size.width * .45,
                    height: MediaQuery.of(context).size.height * .45,
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
                  lc.LoginGoogle();
                },
                text: 'Login pelo Google',
              ),
              CustomButton(
                onPressed: () {
                  lc.LoginInstagram().then((result) {
                    print(result.toString());
                  });
                },
                color: Colors.purple,
                textColor: Colors.white,
                text: 'Login pelo Instagram',
                image: MdiIcons.instagram,
              ),
              FacebookSignInButton(
                onPressed: () {
                  lc.LoginFacebook().then((result) {
                    print(result.toString());
                  });
                },
                text: 'Login pelo Facebook',
              ),
              TwitterSignInButton(
                onPressed: () {
                  lc.LoginTwitter();
                },
                text: 'Login pelo Twitter',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
