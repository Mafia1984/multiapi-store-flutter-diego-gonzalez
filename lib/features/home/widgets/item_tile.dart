
import 'package:flutter/material.dart';
import '../../../state/app_state.dart';

class ItemTile extends StatelessWidget {
  final CombinedItem item;
  final bool favorite;
  final VoidCallback onToggle;
  const ItemTile({super.key, required this.item, required this.favorite, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isPost = item.source == SourceType.post;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(isPost ? 'P' : 'C')),
        title: Text(isPost ? (item.title ?? '') : (item.name ?? '')),
        subtitle: Text(isPost ? 'POST' : 'CHARACTER'),
        trailing: IconButton(
          icon: Icon(favorite ? Icons.star : Icons.star_border),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
