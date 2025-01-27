import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String name;
  final String description;
  final String image;
  final VoidCallback onPressed;

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
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centralizando verticalmente
          crossAxisAlignment: CrossAxisAlignment.center, // Centralizando horizontalmente
          children: [
            // Garantindo que a imagem ocupe todo o espaço disponível horizontalmente e seja centralizada
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                image,
                height: 100,
                fit: BoxFit.contain, // Ajusta a imagem proporcionalmente
              ),
            ),
            SizedBox(height: 8),
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onPressed,
              child: Text("Mudar Atividade"),
            ),
          ],
        ),
      ),
    );
  }
}
