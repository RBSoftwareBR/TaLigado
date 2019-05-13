import 'package:flutter/material.dart';

class CadastroTelefone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CadastroTelefone'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('CadastroTelefone'),
          onPressed: () {
            // Navigate to second route when tapped.
          },
        ),
      ),
    );
  }
}
