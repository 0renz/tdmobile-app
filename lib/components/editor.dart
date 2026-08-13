import 'package:flutter/material.dart';



class Editor extends StatelessWidget{

  TextEditingController controlador;

  String rotulo;
  String dica;
  IconData? icone; // ? serve para opcionalidade - pode receber valor nulo

  Editor(this.controlador, this.rotulo, this.dica, [this.icone]);

  @override
  Widget build(BuildContext context) {

    return Padding(padding: EdgeInsets.all(16),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Campo obrigatório';
          }
          return null;
        },
        controller: this.controlador,
        style: TextStyle(fontSize: 16),
        decoration: InputDecoration(
            icon : icone != null ? Icon(this.icone) : null,
            labelText: rotulo,
            hintText: dica,
        ),
      ),);

  }

}