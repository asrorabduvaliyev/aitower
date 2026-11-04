import 'package:collection/collection.dart';
import 'haversine.dart';

const roadFactor = 1.3; // to'g'ri chiziq -> yo'l masofasi taxmini

double _d(List<double> a, List<double> b) => haversineKm(a[0], a[1], b[0], b[1]);

/// Har bir nuqta eng yaqin k ta qo'shnisi bilan bog'lanadi (ikki tomonlama).
List<Map<int, double>> buildGraph(List<List<double>> coords, {int k = 4}) {
  final n = coords.length;
  final g = List.generate(n, (_) => <int, double>{});
  for (var i = 0; i < n; i++) {
    final near = [for (var j = 0; j < n; j++) if (j != i) j]
      ..sort((a, b) => _d(coords[i], coords[a]).compareTo(_d(coords[i], coords[b])));
    for (final j in near.take(k)) {
      final w = _d(coords[i], coords[j]) * roadFactor;
      g[i][j] = w;
      g[j][i] = w;
    }
  }
  return g;
}

/// A*: heuristika = Haversine. Qaytaradi (yo'l indekslari, masofa km).
(List<int>, double) astar(List<Map<int, double>> graph, List<List<double>> coords, int start, int goal) {
  double h(int n) => _d(coords[n], coords[goal]);
  final heap = PriorityQueue<(double, double, int)>((a, b) => a.$1.compareTo(b.$1))..add((h(start), 0.0, start));
  final best = <int, double>{start: 0.0};
  final came = <int, int>{};
  while (heap.isNotEmpty) {
    var (_, g, cur) = heap.removeFirst();
    if (cur == goal) {
      final path = [cur];
      while (came.containsKey(cur)) {
        cur = came[cur]!;
        path.add(cur);
      }
      return (path.reversed.toList(), g);
    }
    if (g > (best[cur] ?? double.infinity)) continue;
    graph[cur].forEach((nb, w) {
      final ng = g + w;
      if (ng < (best[nb] ?? double.infinity)) {
        best[nb] = ng;
        came[nb] = cur;
        heap.add((ng + h(nb), ng, nb));
      }
    });
  }
  return ([start, goal], _d(coords[start], coords[goal]) * roadFactor);
}
