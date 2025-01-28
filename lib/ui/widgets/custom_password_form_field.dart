import 'package:flutter/material.dart';

// Campo de senha personalizado com a opção de mostrar/ocultar a senha
class CustomPasswordFormField extends StatefulWidget {
  final String labelText; // Texto do rótulo
  final String? Function(String?)? validateFunction; // Função de validação
  final TextEditingController? controller; // Controlador do texto
  final TextInputType? keyboardType; // Tipo de teclado a ser usado

  const CustomPasswordFormField({
    super.key,
    required this.labelText,
    this.validateFunction,
    this.controller,
    this.keyboardType,
  });

  @override
  State<CustomPasswordFormField> createState() =>
      _CustomPasswordFormFieldState();
}

class _CustomPasswordFormFieldState extends State<CustomPasswordFormField> {
  late bool obscured = true; // Variável para controlar a visibilidade da senha

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema atual
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        keyboardType: widget.keyboardType, // Tipo de teclado
        controller: widget.controller, // Controlador do campo
        validator: widget.validateFunction, // Função de validação
        obscureText: obscured, // Aplica a visibilidade da senha
        decoration: InputDecoration(
          labelText: widget.labelText, // Rótulo
          labelStyle: TextStyle(color: theme.colorScheme.primary), // Estilo do rótulo
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscured = !obscured; // Alterna entre mostrar e ocultar a senha
              });
            },
            icon: Icon(
              obscured
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined, // Ícone de visibilidade
              color: theme.colorScheme.primary,
            ),
          ),
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
