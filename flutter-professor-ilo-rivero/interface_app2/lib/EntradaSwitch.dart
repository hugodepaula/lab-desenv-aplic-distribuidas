import 'package:flutter/material.dart';

class EntradaSwitch extends StatefulWidget {
  @override
  _EntradaSwitchState createState() => _EntradaSwitchState();
}

class _EntradaSwitchState extends State<EntradaSwitch> {
  bool _gmail = false;
  bool _whatsapp = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificações"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
            ),
            SwitchListTile(
                activeColor: Colors.red,
                title: Text("Gmail: "),
                value: _gmail,
                onChanged: (bool valor) {
                  setState(() {
                    _gmail = valor;
                  });
                }
            ),
            SwitchListTile(
                activeColor: Colors.red,
                title: Text("WhatsApp: "),
                value: _whatsapp,
                onChanged: (bool valor) {
                  setState(() {
                    _whatsapp = valor;
                  });
                }
            ),
            ElevatedButton(
                child: Text("Salvar"),
                onPressed: () {
                  if (_gmail)
                    print("Escolha: ativar Gmail");
                  else
                    print("Escolha: desativar Gmail");
                  if (_whatsapp)
                    print("Escolha: ativar WhatsApp");
                  else
                    print("Escolha: desativar WhatsApp");
                }
            ),

            /*Text("Gmail: "),
            Switch(
                value: _selecionado,
                onChanged: (bool valor){
                  setState(() {
                    _selecionado = valor;
                  });
                }
            ),*/
          ],
        ),
      ),
    );
  }
}
