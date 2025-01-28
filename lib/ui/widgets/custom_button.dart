import 'package:flutter/material.dart';

// Botão personalizado com altura, texto e ação ao clicar
class CustomButton extends StatelessWidget {
  final double height; // Altura do botão
  final String text; // Texto exibido no botão
  final void Function()? onClick; // Função chamada ao pressionar o botão

  const CustomButton({
    super.key,
    required this.height,
    required this.text,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema atual
    return SizedBox(
      width: double.infinity, // Botão ocupa toda a largura
      height: height, // Define a altura do botão
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary, // Cor de fundo do botão
            foregroundColor: Colors.black, // Cor do texto
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Bordas arredondadas
            ),
          ),
          onPressed: onClick, // Ação ao clicar no botão
          child: Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold, // Texto em negrito
              color: Colors.black, // Cor preta para o texto
            ),
          ),
        ),
      ),
    );
  }
}

