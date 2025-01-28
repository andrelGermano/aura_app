import 'package:flutter/material.dart';

// Campo de texto personalizado com validação e controle do teclado
class CustomTextFormField extends StatelessWidget {
  final String labelText; // Texto do rótulo
  final String? Function(String?)? validateFunction; // Função de validação
  final TextEditingController? controller; // Controlador do campo
  final TextInputType? keyboardType; // Tipo de teclado

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.validateFunction,
    this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema atual
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        keyboardType: keyboardType, // Tipo de teclado
        controller: controller, // Controlador do campo
        validator: validateFunction, // Função de validação
        decoration: InputDecoration(
          labelText: labelText, // Rótulo
          labelStyle: TextStyle(color: theme.colorScheme.primary), // Estilo do rótulo
          border: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.secondary),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.secondary),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: theme.colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: theme.colorScheme.surface,
          filled: true, // Preenchimento do campo
        ),
      ),
    );
  }
}
