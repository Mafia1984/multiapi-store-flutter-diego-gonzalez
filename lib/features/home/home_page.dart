

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/providers.dart';
import 'widgets/item_tile.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _loading = false;
  String? _error;

  // Flag para disparar la carga UNA sola vez tras el primer build (web-safe)
  bool _didLoad = false;

  @override
  Widget build(BuildContext context) {
    // Estos watch garantizan que exista un listener al provider antes de cargar datos
    final s = ref.watch(appControllerProvider);
    final items = ref.watch(filteredListProvider);

    // Dispara la carga luego del primer frame, una sola vez
    if (!_didLoad) {
      _didLoad = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await _refresh();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MultiAPI – diego gonzalez (Desarrollo de Software y Programación)',
        ),
        actions: [
          IconButton(
            tooltip: 'Cambiar tema',
            icon: const Icon(Icons.brightness_6),
            onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por título o nombre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) =>
                  ref.read(appControllerProvider.notifier).setSearchQuery(v),
            ),
          ),
          if (s.lastUpdated != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Última actualización: ${s.lastUpdated}'),
              ),
            ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Error: $_error',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final fav = s.favorites.contains(item.id);
                        return ItemTile(
                          item: item,
                          favorite: fav,
                          onToggle: () => ref
                              .read(appControllerProvider.notifier)
                              .toggleFavorite(item.id),
                        );
                      },
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: s.page > 1 && !_loading
                      ? () =>
                          ref.read(appControllerProvider.notifier).prevPage()
                      : null,
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Anterior'),
                ),
                Text('Página: ${s.page}'),
                ElevatedButton.icon(
                  onPressed: !_loading
                      ? () =>
                          ref.read(appControllerProvider.notifier).nextPage()
                      : null,
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('Siguiente'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ref.read(appControllerProvider.notifier).loadData();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }
}
