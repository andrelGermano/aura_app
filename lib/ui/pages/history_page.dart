import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aura_novo/services/history_service.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  DateTime? _selectedMonth;

  void _addActivity(HistoryService historyService) async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isNotEmpty && description.isNotEmpty) {
      await historyService.addActivityToHistory(name: name, description: description);
      _nameController.clear();
      _descriptionController.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final historyService = Provider.of<HistoryService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () async {
              final selectedMonth = await showMonthPicker(context: context, initialDate: DateTime.now());
              if (selectedMonth != null) {
                setState(() {
                  _selectedMonth = selectedMonth;
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Pesquisar por nome",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: historyService.getHistoryGroupedByDate(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhuma atividade registrada."));
                }

                var groupedData = snapshot.data!;

                // Filtra pelo mês selecionado
                if (_selectedMonth != null) {
                  groupedData = groupedData.where((group) {
                    final dateParts = group['date']!.split('-');
                    final date = DateTime(
                      int.parse(dateParts[0]), // Ano
                      int.parse(dateParts[1]), // Mês
                    );

                    // Comparação correta com ano e mês
                    return date.year == _selectedMonth!.year && date.month == _selectedMonth!.month;
                  }).toList();
                }

                // Filtra pelo nome
                if (_searchQuery.isNotEmpty) {
                  groupedData = groupedData.map((group) {
                    final filteredActivities = (group['activities'] as List<Map<String, dynamic>>)
                        .where((activity) =>
                        activity['name'].toString().toLowerCase().contains(_searchQuery))
                        .toList();

                    return {
                      'date': group['date'],
                      'activities': filteredActivities,
                    };
                  }).where((group) => (group['activities'] as List).isNotEmpty).toList();
                }

                if (groupedData.isEmpty) {
                  return const Center(child: Text("Nenhuma atividade encontrada."));
                }

                return ListView.builder(
                  itemCount: groupedData.length,
                  itemBuilder: (context, index) {
                    final group = groupedData[index];
                    final date = group['date'] as String;
                    final activities = group['activities'] as List<Map<String, dynamic>>;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ...activities.map((activity) {
                            final activityName = activity['name'] as String;
                            final activityDescription = activity['description'] as String;
                            final activityId = activity['id'] as String;

                            return Card(
                              child: ListTile(
                                title: Text(activityName),
                                subtitle: Text(activityDescription),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await historyService.deleteActivity(activityId);
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Adicionar Atividade"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: "Nome"),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: "Descrição"),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancelar"),
                  ),
                  ElevatedButton(
                    onPressed: () => _addActivity(historyService),
                    child: const Text("Adicionar"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<DateTime?> showMonthPicker({required BuildContext context, required DateTime initialDate}) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return child ?? const SizedBox.shrink();
      },
    );
  }
}
