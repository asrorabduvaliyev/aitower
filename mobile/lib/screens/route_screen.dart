import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../algorithms/optimizer.dart';
import '../l10n/strings.dart';
import '../models/attraction.dart';
import '../models/route_plan.dart';
import '../widgets/map_links.dart';

class RouteScreen extends StatefulWidget {
  final List<Attraction> places;
  final double? lat, lon;
  const RouteScreen({super.key, required this.places, this.lat, this.lon});
  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  late final RoutePlan plan = planRoute(widget.places, startLat: widget.lat, startLon: widget.lon);
  int day = 0;

  @override
  Widget build(BuildContext context) {
    final lang = Lang.current.value;
    final d = plan.days[day];
    return Scaffold(
      appBar: AppBar(title: Text(tr('optimal_route'))),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text('${tr('total')}: ${plan.totalKm.toStringAsFixed(1)} ${tr('km')} • \$${plan.totalCost.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleMedium),
        ),
        Wrap(spacing: 8, children: [
          for (var i = 0; i < plan.days.length; i++)
            ChoiceChip(label: Text(dayLabel(i + 1)), selected: day == i, onSelected: (_) => setState(() => day = i)),
        ]),
        SizedBox(
          height: 260,
          child: FlutterMap(
            key: ValueKey(day),
            options: d.path.length > 1
                ? MapOptions(initialCameraFit: CameraFit.coordinates(coordinates: d.path, padding: const EdgeInsets.all(40), maxZoom: 15))
                : MapOptions(initialCenter: d.path.first, initialZoom: 15),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'uz.tourism.ai_smart_tourism'),
              PolylineLayer(polylines: [Polyline(points: d.path, strokeWidth: 4, color: Colors.teal)]),
              MarkerLayer(markers: [
                for (var i = 0; i < d.stops.length; i++)
                  Marker(
                    point: LatLng(d.stops[i].place.lat, d.stops[i].place.lon),
                    child: CircleAvatar(radius: 12, backgroundColor: Colors.deepOrange,
                        child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 12))),
                  ),
              ]),
            ],
          ),
        ),
        Expanded(
          child: ListView(children: [
            for (var i = 0; i < d.stops.length; i++)
              ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text(d.stops[i].place.nameIn(lang)),
                subtitle: Text('${d.stops[i].place.visitMinutes} ${tr('min')}'
                    '${d.stops[i].travelKm > 0 ? ' • ${tr('travel')}: ${d.stops[i].travelKm.toStringAsFixed(1)} ${tr('km')}, ${d.stops[i].travelMinutes} ${tr('min')}' : ''}'),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: OutlinedButton.icon(
                onPressed: () => openDirections(d.stops.map((s) => s.place).toList()),
                icon: const Icon(Icons.navigation),
                label: Text(tr('navigate_day')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Text(tr('how_it_works'), style: Theme.of(context).textTheme.bodySmall),
            ),
          ]),
        ),
      ]),
    );
  }
}
