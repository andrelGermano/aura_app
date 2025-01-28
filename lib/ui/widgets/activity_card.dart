import 'package:flutter/material.dart';

// Card que exibe uma atividade com seu nome, descrição, imagem e um botão para mudar a atividade
class ActivityCard extends StatelessWidget {
  final String name; // Nome da atividade
  final String description; // Descrição da atividade
  final String image; // Caminho da imagem relacionada à atividade
  final VoidCallback onPressed; // Função chamada ao pressionar o botão

  const ActivityCard({
    super.key,
    required this.name,
    required this.description,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Adiciona sombra ao card
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(image, height: 100), // Exibe a imagem da atividade
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge, // Estilo do nome da atividade
            ),
            SizedBox(height: 8),
            Text(description), // Descrição da atividade
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onPressed, // Chama a função ao pressionar o botão
              child: Text("Mudar Atividade"),
            ),
          ],
        ),
      ),
    );
  }
}
