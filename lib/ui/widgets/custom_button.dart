import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final String text;
  final void Function()? onClick;

  const CustomButton({
    super.key,
    required this.height,
    required this.text,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.black, // Define a cor do texto como preta
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onClick,
          child: Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black, // Garante que o texto permaneça preto
            ),
          ),
        ),
      ),
    );
  }
}
