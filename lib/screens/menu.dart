import 'package:flutter/material.dart';
import 'list_tarefa.dart';
import 'cep.dart';
import 'feriados.dart';
import 'contatos.dart';
import 'cotacoes.dart';

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
        onPageChanged: setPaginaAtual,
        children: [ListaTarefas(), Cep(), Feriados(), Contatos(), CotacaoScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(icon: Icon(Icons.perm_contact_calendar_sharp), label: "Contatos"),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on), label: "Moeda"),
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
