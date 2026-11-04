import 'package:latlong2/latlong.dart';
import '../models/attraction.dart';
import '../models/route_plan.dart';
import 'astar.dart';
import 'genetic_algorithm.dart';
import 'haversine.dart';

const citySpeed = 30.0, intercitySpeed = 70.0; // km/soat

/// GA tashrif tartibini topadi, A* har bir bo'g'in yo'lini hisoblaydi,
/// so'ng vaqt limiti bo'yicha kunlarga bo'linadi.
RoutePlan planRoute(List<Attraction> items, {double? startLat, double? startLon, int maxMinutes = 480}) {
  final hasStart = startLat != null && startLon != null;
  final coords = [
    if (hasStart) [startLat, startLon],
    for (final a in items) [a.lat, a.lon],
  ];
  final offset = hasStart ? 1 : 0;
  final order = geneticTsp(distanceMatrix(coords));
  final graph = buildGraph(coords);

  final days = <DayPlan>[];
  var cur = DayPlan(1);
  int? prev;
  for (final idx in order) {
    if (hasStart && idx == 0) {
      cur.path.add(LatLng(coords[0][0], coords[0][1]));
      prev = 0;
      continue;
    }
    final a = items[idx - offset];
    var km = 0.0, tm = 0.0;
    var seg = [idx];
    if (prev != null) {
      final (p, d) = astar(graph, coords, prev, idx);
      km = d;
      tm = km / (km > 80 ? intercitySpeed : citySpeed) * 60;
      seg = p;
    }
    final need = tm + a.visitMinutes;
    if (cur.stops.isNotEmpty && cur.minutes + need > maxMinutes) {
      days.add(cur);
      cur = DayPlan(days.length + 1);
    }
    cur.stops.add(Stop(a, km, tm.round()));
    cur.distanceKm += km;
    cur.minutes += need;
    cur.costUsd += a.costUsd;
    cur.path.addAll(seg.map((i) => LatLng(coords[i][0], coords[i][1])));
    prev = idx;
  }
  days.add(cur);
  return RoutePlan(days);
}
