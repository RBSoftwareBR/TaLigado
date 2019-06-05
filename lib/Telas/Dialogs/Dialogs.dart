import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:kivaga/Objetos/Carro.dart';
import 'package:kivaga/Objetos/Rua.dart';

import 'CadastrarCarroController.dart';

class Dialogs {
  addCarroDlg(context, {Carro carro}) {
    CadastrarCarroController ccc = CadastrarCarroController(carro: carro);

    bool isEditing = carro != null;
    MaskedTextController controllerPlaca = new MaskedTextController(
        text: carro != null ? carro.placa : '', mask: 'AAA-0000');
    TextEditingController controllerCor =
        new TextEditingController(text: carro != null ? carro.cor : '');
    TextEditingController controllerModelo =
        new TextEditingController(text: carro != null ? carro.modelo : '');
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Cadastrar novo Veículo'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    controllerPlaca.text = value.toUpperCase();
                  },
                  controller: controllerPlaca,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    labelText: 'Placa',
                    labelStyle: TextStyle(color: Colors.blue, fontSize: 22),
                    hintText: "ABC-1111",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: controllerCor,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    labelText: 'Cor',
                    labelStyle: TextStyle(color: Colors.blue, fontSize: 22),
                    hintText: "Prata",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: controllerModelo,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    labelText: 'Modelo',
                    labelStyle: TextStyle(color: Colors.blue, fontSize: 22),
                    hintText: "Gol G4 2006",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<Color>(
                    stream: ccc.outCor,
                    builder: (context, snapshot) {
                      return Center(
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.time_to_leave,
                              size: 60,
                              color: snapshot.data,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(60)),
                                      color: Colors.red),
                                  height: 30,
                                  width: 30,
                                ),
                                new Slider(
                                  value: snapshot.data.red.toDouble(),
                                  onChanged: (value) {
                                    Color c = new Color.fromARGB(
                                        255,
                                        value.toInt(),
                                        snapshot.data.green,
                                        snapshot.data.blue);
                                    ccc.UpdateCarColor(c);
                                  },
                                  max: 255,
                                  min: 1,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(60)),
                                      color: Colors.green),
                                  height: 30,
                                  width: 30,
                                ),
                                new Slider(
                                  value: snapshot.data.green.toDouble(),
                                  onChanged: (value) {
                                    Color c = new Color.fromARGB(
                                        255,
                                        snapshot.data.red,
                                        value.toInt(),
                                        snapshot.data.blue);
                                    ccc.UpdateCarColor(c);
                                  },
                                  max: 255,
                                  min: 1,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(60)),
                                      color: Colors.blue),
                                  height: 30,
                                  width: 30,
                                ),
                                new Slider(
                                  value: snapshot.data.blue.toDouble(),
                                  onChanged: (value) {
                                    Color c = new Color.fromARGB(
                                      255,
                                      snapshot.data.red,
                                      snapshot.data.green,
                                      value.toInt(),
                                    );
                                    ccc.UpdateCarColor(c);
                                    Navigator.pop(context);
                                  },
                                  max: 255,
                                  min: 1,
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cadastrar', semanticsLabel: 'Registrar Veículo'),
              onPressed: () {
                ccc.CadastrarCarro(controllerCor.text, controllerModelo.text,
                    controllerPlaca.text); // Perform some action
              },
            ),
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert
              },
            ),
          ],
        );
      },
    );
  }

  estacionarDlg(context, Rua r) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('title'),
          content: Text('dialogBody'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert
              },
            ),
          ],
        );
      },
    );
  }

  addCreditoDlg(context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('title'),
          content: Text('dialogBody'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert
              },
            ),
          ],
        );
      },
    );
  }
}
