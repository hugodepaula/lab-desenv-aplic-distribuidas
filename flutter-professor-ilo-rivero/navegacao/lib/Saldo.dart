import 'package:flutter/material.dart';

class Saldo extends StatelessWidget {
  final String texto;

  Saldo(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}