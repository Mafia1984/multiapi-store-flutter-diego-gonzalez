
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/apis/json_placeholder_api.dart';
import '../data/apis/rick_api.dart';
import '../models/post.dart';
import '../models/character.dart';
import '../services/persistence.dart';
import 'app_state.dart';

// SharedPreferences singleton
final sharedPrefsProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

// Persistence wrapper
final persistenceProvider = Provider<PersistenceService?>((ref) {
  final prefsAsync = ref.watch(sharedPrefsProvider);
  return prefsAsync.maybeWhen(data: (p) => PersistenceService(p), orElse: () => null);
});

// APIs
final jsonApiProvider = Provider<JsonPlaceholderApi>((ref) => JsonPlaceholderApi());
final rickApiProvider = Provider<RickApi>((ref) => RickApi());

// ThemeMode persisted
final themeModeProvider = StateNotifierProvider<ThemeController, ThemeMode>((ref) {
  final persistence = ref.watch(persistenceProvider);
  return ThemeController(persistence);
});

class ThemeController extends StateNotifier<ThemeMode> {
  final PersistenceService? _p;
  ThemeController(this._p) : super(ThemeMode.system) {
    final idx = _p?.loadThemeMode();
    if (idx != null) {
      state = ThemeMode.values[idx.clamp(0, ThemeMode.values.length - 1)];
    }
  }
  Future<void> toggle() async {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _p?.saveThemeMode(state.index);
  }
}

// App Controller
final appControllerProvider = StateNotifierProvider<AppController, AppState>((ref) {
  final persistence = ref.watch(persistenceProvider);
  final jsonApi = ref.watch(jsonApiProvider);
  final rickApi = ref.watch(rickApiProvider);
  return AppController(persistence, jsonApi, rickApi);
});

class AppController extends StateNotifier<AppState> {
  final PersistenceService? _p;
  final JsonPlaceholderApi _jsonApi;
  final RickApi _rickApi;

  AppController(this._p, this._jsonApi, this._rickApi) : super(AppState.initial()) {
    // Intentar cargar estado previo
    final cached = _p?.loadAppState();
    if (cached != null) {
      try { state = AppState.decode(cached); } catch (_) {}
    }
  }

  Future<void> loadData() async {
    try {
      final posts = await _jsonApi.getPosts(limit: 10);
      final chars = await _rickApi.getCharacters(state.page);
      final combined = _alternate(posts, chars);
      state = state.copyWith(combined: combined, lastUpdated: DateTime.now());
      await _save();
    } catch (e) {
      // En un proyecto real, manejaríamos el error con un estado separado
      rethrow;
    }
  }

  List<CombinedItem> _alternate(List<Post> posts, List<Character> chars) {
    final p = posts.map((e) => CombinedItem(source: SourceType.post, id: e.id, title: e.title)).toList();
    final c = chars.map((e) => CombinedItem(source: SourceType.character, id: e.id, name: e.name)).toList();
    final out = <CombinedItem>[];
    final maxLen = p.length > c.length ? p.length : c.length;
    for (var i = 0; i < maxLen; i++) {
      if (i < p.length) out.add(p[i]);
      if (i < c.length) out.add(c[i]);
    }
    return out;
  }

  Future<void> toggleFavorite(int id) async {
    final favs = Set<int>.from(state.favorites);
    if (favs.contains(id)) {
      favs.remove(id);
    } else {
      favs.add(id);
    }
    state = state.copyWith(favorites: favs);
    await _save();
  }

  Future<void> setSearchQuery(String q) async {
    state = state.copyWith(searchQuery: q);
    await _save();
  }

  Future<void> nextPage() async {
    state = state.copyWith(page: state.page + 1);
    await loadData();
  }

  Future<void> prevPage() async {
    if (state.page <= 1) return;
    state = state.copyWith(page: state.page - 1);
    await loadData();
  }

  Future<void> _save() async {
    await _p?.saveAppState(AppState.encode(state));
  }
}

// Selector: lista filtrada por búsqueda
final filteredListProvider = Provider<List<CombinedItem>>((ref) {
  final s = ref.watch(appControllerProvider);
  final q = s.searchQuery.trim().toLowerCase();
  if (q.isEmpty) return s.combined;
  return s.combined.where((e) {
    final text = (e.title ?? e.name ?? '').toLowerCase();
    return text.contains(q);
  }).toList();
});
