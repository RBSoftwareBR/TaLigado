import 'package:flutter/material.dart';

class EsqueceuSenha extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EsqueceuSenha'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('EsqueceuSenha'),
          onPressed: () {
            // Navigate to second route when tapped.
          },
        ),
      ),
    );
  }
}
