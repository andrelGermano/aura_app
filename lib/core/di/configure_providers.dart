import 'package:aura_novo/services/auth_service.dart';
import 'package:aura_novo/services/history_service.dart'; // Import do HistoryService
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfigureProviders {
  final List<SingleChildWidget> providers;

  ConfigureProviders({required this.providers});

  static Future<ConfigureProviders> createDependencyTree() async {
    final authService = AuthService();
    final historyService = HistoryService();

    return ConfigureProviders(providers: [
      Provider<AuthService>.value(value: authService),
      Provider<HistoryService>.value(value: historyService),
    ]);
  }
}
