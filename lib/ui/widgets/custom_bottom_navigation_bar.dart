import 'package:flutter/material.dart';

// Barra de navegação personalizada com 4 itens (Início, Lembretes, Histórico, Configurações)
class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex; // Índice do item selecionado
  final ValueChanged<int> onItemTapped; // Função chamada ao tocar em um item

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer, // Cor de fundo da barra
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home), // Ícone de Início
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_alarm), // Ícone de Lembretes
          label: 'Lembretes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history), // Ícone de Histórico
          label: 'Histórico',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings), // Ícone de Configurações
          label: 'Configurações',
        ),
      ],
      currentIndex: selectedIndex, // Ítem atualmente selecionado
      selectedItemColor: Theme.of(context).colorScheme.primary, // Cor do item selecionado
      unselectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer, // Cor do item não selecionado
      onTap: onItemTapped, // Ação ao tocar em um item
    );
  }
}
