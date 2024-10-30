import 'package:flutter/material.dart';

class Mapa extends StatelessWidget {
  final String texto;

  Mapa(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}