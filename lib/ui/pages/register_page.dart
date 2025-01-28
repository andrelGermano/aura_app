import 'package:aura_novo/services/auth_service.dart';
import 'package:aura_novo/ui/widgets/custom_password_form_field.dart';
import 'package:aura_novo/ui/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_button.dart';

// Página de Cadastro
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.onTap});

  // Callback opcional para alternar para a página de login
  final void Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controladores para os campos de email, senha e confirmação de senha
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();

  // Função para realizar o cadastro
  void signUp() async {
    // Verifica se as senhas são iguais
    if (passwordController.value.text != rePasswordController.value.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("As senhas não coincidem."), // Mensagem de erro
        ),
      );
      return; // Sai da função se as senhas não forem iguais
    }

    // Obtém a instância do AuthService
    final AuthService authService =
    Provider.of<AuthService>(context, listen: false);

    try {
      // Tenta realizar o cadastro com email e senha
      await authService.signUpWithEmailAndPassword(
        emailController.value.text, // Email inserido
        passwordController.value.text, // Senha inserida
      );
    } on Exception catch (e) {
      // Exibe uma mensagem de erro caso o cadastro falhe
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()), // Mostra o erro como texto
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtém o tema atual para aplicar estilizações
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer, // Cor de fundo
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), // Espaçamento lateral
        child: Center(
          child: SingleChildScrollView(
            // Permite rolagem caso o conteúdo seja maior que a tela
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza o conteúdo verticalmente
              crossAxisAlignment: CrossAxisAlignment.center, // Centraliza o conteúdo horizontalmente
              children: [
                // Ícone representando o perfil
                Icon(
                  Icons.account_circle_outlined,
                  size: 120, // Tamanho do ícone
                  color: theme.colorScheme.primary, // Cor do ícone
                ),
                const SizedBox(height: 30), // Espaçamento
                // Título da página
                Text(
                  "Crie sua conta",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold, // Texto em negrito
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 10),
                // Subtítulo explicativo
                Text(
                  "Insira suas informações abaixo para começar",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center, // Centraliza o texto
                ),
                const SizedBox(height: 40),
                // Campo para inserir o email
                CustomTextFormField(
                  labelText: "Email",
                  controller: emailController, // Controlador do campo
                ),
                const SizedBox(height: 15),
                // Campo para inserir a senha
                CustomPasswordFormField(
                  labelText: "Senha",
                  controller: passwordController, // Controlador do campo
                ),
                const SizedBox(height: 15),
                // Campo para confirmar a senha
                CustomPasswordFormField(
                  labelText: "Confirmar Senha",
                  controller: rePasswordController, // Controlador do campo
                ),
                const SizedBox(height: 30),
                // Botão para realizar o cadastro
                CustomButton(
                  text: "Cadastrar",
                  height: 50, // Altura do botão
                  onClick: signUp, // Chama a função de cadastro ao clicar
                ),
                const SizedBox(height: 20),
                // Texto com opção de alternar para a página de login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Já possui conta?", // Texto fixo
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap, // Alterna para a página de login
                      child: Text(
                        "Entrar agora",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold, // Texto em negrito
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Texto de rodapé
                Text(
                  'Aura App - Priorize seu bem-estar',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center, // Centraliza o texto
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
