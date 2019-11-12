import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taligado/globalStore.dart';
import 'package:taligado/selecionar_categorias.dart';

import 'Helpers.dart';

class PerfilPage extends StatefulWidget {
  PerfilPage({Key key}) : super(key: key);

  @override
  _PerfilPageState createState() {
    return _PerfilPageState();
  }
}

class _PerfilPageState extends State<PerfilPage> {
  Future getImage() async {

                    File image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);

                    lc.inImage.add(image);
                    lc.updateProfile(user.displayName, image, user);
  }

  LoginController lc;
  TextEditingController tec;

  @override
  void initState() {
    super.initState();
    if (lc == null) {
      lc = new LoginController();
    }
    tec = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              child: Stack(children: <Widget>[
                Center(
                  child: StreamBuilder<FirebaseUser>(
                      stream: lc.outUser,
                      builder: (context, snapshot) {
                        return snapshot.data != null? CircleAvatar(
                          maxRadius: 60,
                          minRadius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: snapshot.data.photoUrl!=null
                              ? CachedNetworkImageProvider(snapshot.data.photoUrl)
                              : AssetImage(
                                  'assets/selfie.png',
                                ),
                        ):Container();
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
            StreamBuilder<FirebaseUser>(
              stream: lc.outUser,
              builder: (context, snapshot) {
                print('AQUI USUARIO ${snapshot.data.displayName}');
                if(tec.text.isEmpty){
                  if(snapshot.data!= null) {
                    if(snapshot.data.displayName != null) {
                      tec = TextEditingController(text: snapshot.data.displayName);
                    }
                  }
                }
                return TextField(
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
                );
              }
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width*.6,
              child: MaterialButton(
                child: Text('Alterar categorias favoritas',style: TextStyle(color: Colors.white,fontSize: 16),),
                color: Helpers.brightness == null
                    ? Colors.indigo
                    : Helpers.brightness ? Colors.black : Colors.indigo,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SelecionarCategorias()));
                },
              ),
            ),
            StreamBuilder<File>(
                stream: lc.outImage,
                builder: (context, snapshot) {
                  return Container(
                    width: MediaQuery.of(context).size.width*.6,
                    child: RaisedButton(
                      child: Text("Atualizar Perfil",
                          style: TextStyle(fontSize: 16)),
                      padding: EdgeInsets.all(12),
                      color: Helpers.brightness == null
                          ? Colors.indigo
                          : Helpers.brightness ? Colors.black : Colors.indigo,
                      textColor: Colors.white,
                      onPressed: () {
                        if (tec.text.length != 0) {
                          //if (snapshot.data != null) {
                          lc.updateProfile(tec.text, user.photoUrl, user);
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
                    ),
                  );
                })
          ],
        ),
      ),
    ));
  }
}
