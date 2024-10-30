import 'package:flutter/material.dart';

class Perfil extends StatelessWidget {
  final String texto;

  Perfil(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}