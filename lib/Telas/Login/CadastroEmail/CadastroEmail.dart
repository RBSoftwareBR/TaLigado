import 'package:flutter/material.dart';

class CadastroEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CadastroEmail'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('CadastroEmail'),
          onPressed: () {
            // Navigate to second route when tapped.
          },
        ),
      ),
    );
  }
}
