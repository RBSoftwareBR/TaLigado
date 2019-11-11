import 'package:flutter/material.dart';

import 'Controllers/CategoriasController.dart';
import 'Objetos/Categoria.dart';
import './categoriesList.dart' as categoriesList;

class SelecionarCategorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Selecione as categorias interessam!"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder<List<Categoria>>(
              stream: cc.outCategorias,
              builder: (context, snapshot) {
                return GridView.builder(
                  itemCount: categoriesList.list.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, mainAxisSpacing: 25.0),
                  padding: const EdgeInsets.all(10.0),
                  itemBuilder: (context, index) {
                    bool isCategoriaFavorita = false;
                    if (snapshot.data != null) {
                      if (snapshot.data.length != 0) {
                        for (Categoria c in snapshot.data) {
                          if (c.id == categoriesList.list[index].id) {
                            isCategoriaFavorita = true;
                          }
                        }
                      }
                    }
                    return CategoriaItem(
                        categoriesList.list[index], isCategoriaFavorita);
                  },
                );
              }),
          Positioned(
              bottom: 10,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(onPressed: (){
                    Navigator.of(context).pop();
                  },
                    child: Text('Pronto!'),
                  ))),
        ],
      ),
    );
  }

  Widget CategoriaItem(Categoria c, bool isCategoriaFavorita) {
    return new GridTile(
        footer: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Flexible(
                child: new SizedBox(
                  height: 16.0,
                  width: 100.0,
                  child: new Text(
                    c.name,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ]),
        child: new Container(
          height: 500.0,
          child: new GestureDetector(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new SizedBox(
                  height: 100.0,
                  width: 100.0,
                  child: new Row(
                    children: <Widget>[
                      new Stack(
                        children: <Widget>[
                          new SizedBox(
                            child: new Container(
                              child: new CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 40.0,
                                child: new Icon(c.icon,
                                    size: 40.0, color: c.color),
                              ),
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                            ),
                          ),
                          isCategoriaFavorita
                              ? Positioned(
                                  right: 5,
                                  top: 5,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 45,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              if (isCategoriaFavorita) {
                cc.removeCategoria(c);
              } else {
                cc.addCategoria(c);
              }
            },
          ),
        ));
  }
}
