import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../l10n/strings.dart';
import '../models/attraction.dart';
import '../widgets/map_links.dart';

class DetailScreen extends StatefulWidget {
  final Attraction a;
  final bool selected;
  final VoidCallback onToggle;
  const DetailScreen({super.key, required this.a, required this.selected, required this.onToggle});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool selected = widget.selected;

  Widget _row(IconData icon, String label, String value) => ListTile(
        dense: true,
        leading: Icon(icon),
        title: Text(label),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      );

  @override
  Widget build(BuildContext context) {
    final a = widget.a;
    final lang = Lang.current.value;
    final point = LatLng(a.lat, a.lon);
    return Scaffold(
      appBar: AppBar(title: Text(a.nameIn(lang))),
      body: ListView(children: [
        SizedBox(
          height: 220,
          child: FlutterMap(
            options: MapOptions(initialCenter: point, initialZoom: 15),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'uz.tourism.ai_smart_tourism'),
              MarkerLayer(markers: [Marker(point: point, child: const Icon(Icons.place, color: Colors.deepOrange, size: 36))]),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${tr(a.city)} • ${tr(a.category)}', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(a.descriptionIn(lang), style: Theme.of(context).textTheme.bodyLarge),
          ]),
        ),
        _row(Icons.star, tr('rating'), '★ ${a.rating}'),
        _row(Icons.schedule, tr('visit_time'), '${a.visitMinutes} ${tr('min')}'),
        _row(Icons.payments, tr('ticket'), a.costUsd == 0 ? tr('free') : '\$${a.costUsd.toStringAsFixed(0)}'),
        if (a.distanceKm != null) _row(Icons.near_me, tr('distance'), '${a.distanceKm!.round()} ${tr('km')}'),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            FilledButton.icon(
              onPressed: () {
                widget.onToggle();
                setState(() => selected = !selected);
              },
              icon: Icon(selected ? Icons.remove_circle_outline : Icons.add_circle_outline),
              label: Text(tr(selected ? 'remove_from_route' : 'add_to_route')),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(onPressed: () => openPlace(a), icon: const Icon(Icons.map), label: Text(tr('open_maps'))),
          ]),
        ),
      ]),
    );
  }
}
