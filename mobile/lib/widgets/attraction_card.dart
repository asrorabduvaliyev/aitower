import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/attraction.dart';

class AttractionCard extends StatelessWidget {
  final Attraction a;
  final bool selected;
  final VoidCallback onTap, onToggle;
  const AttractionCard({super.key, required this.a, required this.selected, required this.onTap, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final lang = Lang.current.value;
    final cost = a.costUsd == 0 ? tr('free') : '\$${a.costUsd.toStringAsFixed(0)}';
    final dist = a.distanceKm == null ? '' : ' • ${a.distanceKm!.round()} ${tr('km')}';
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(a.nameIn(lang), style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${tr(a.city)} • ★ ${a.rating} • ${a.visitMinutes} ${tr('min')} • $cost$dist\n'
            '${a.descriptionIn(lang)}', maxLines: 3, overflow: TextOverflow.ellipsis),
        isThreeLine: true,
        trailing: IconButton(
          tooltip: tr(selected ? 'remove_from_route' : 'add_to_route'),
          onPressed: onToggle,
          icon: Icon(selected ? Icons.check_circle : Icons.add_circle_outline, color: selected ? Colors.teal : null),
        ),
      ),
    );
  }
}
