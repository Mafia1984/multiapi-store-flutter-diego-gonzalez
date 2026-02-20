
import 'dart:convert';

enum SourceType { post, character }

class CombinedItem {
  final SourceType source;
  final int id;
  final String? title;
  final String? name;

  CombinedItem({required this.source, required this.id, this.title, this.name});

  Map<String, dynamic> toJson() => {
        'source': source.name,
        'id': id,
        'title': title,
        'name': name,
      };

  factory CombinedItem.fromJson(Map<String, dynamic> json) => CombinedItem(
        source: (json['source'] as String) == 'post' ? SourceType.post : SourceType.character,
        id: json['id'] as int,
        title: json['title'] as String?,
        name: json['name'] as String?,
      );
}

class AppState {
  final List<CombinedItem> combined;
  final Set<int> favorites;
  final DateTime? lastUpdated;
  final int page; // Rick & Morty page
  final String searchQuery;

  const AppState({
    required this.combined,
    required this.favorites,
    required this.lastUpdated,
    required this.page,
    required this.searchQuery,
  });

  AppState copyWith({
    List<CombinedItem>? combined,
    Set<int>? favorites,
    DateTime? lastUpdated,
    int? page,
    String? searchQuery,
  }) => AppState(
        combined: combined ?? this.combined,
        favorites: favorites ?? this.favorites,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        page: page ?? this.page,
        searchQuery: searchQuery ?? this.searchQuery,
      );

  Map<String, dynamic> toJson() => {
        'combined': combined.map((e) => e.toJson()).toList(),
        'favorites': favorites.toList(),
        'lastUpdated': lastUpdated?.toIso8601String(),
        'page': page,
        'searchQuery': searchQuery,
      };

  factory AppState.fromJson(Map<String, dynamic> json) => AppState(
        combined: (json['combined'] as List<dynamic>? ?? [])
            .map((e) => CombinedItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        favorites: ((json['favorites'] as List<dynamic>? ?? []).map((e) => e as int)).toSet(),
        lastUpdated: json['lastUpdated'] == null ? null : DateTime.tryParse(json['lastUpdated'] as String),
        page: (json['page'] as int?) ?? 1,
        searchQuery: (json['searchQuery'] as String?) ?? '',
      );

  static String encode(AppState s) => jsonEncode(s.toJson());
  static AppState decode(String s) => AppState.fromJson(jsonDecode(s) as Map<String, dynamic>);

  static AppState initial() => const AppState(
        combined: [],
        favorites: {},
        lastUpdated: null,
        page: 1,
        searchQuery: '',
      );
}
