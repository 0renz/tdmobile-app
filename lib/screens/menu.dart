import 'package:flutter/material.dart';
import 'list_tarefa.dart';
import 'cep.dart';
import 'feriados.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends State<Menu> {
  int paginaAtual = 0;
  PageController? pc = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [ListaTarefas(), Cep(), Feriados()],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        onTap: (index) {
          setState(() {
            paginaAtual = index;
            pc!.animateToPage(
              index,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tarefas"),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: "CEP"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Feriados"),
        ],
      ),
    );
  }

  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  setPaginaAtual(int pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }
}
