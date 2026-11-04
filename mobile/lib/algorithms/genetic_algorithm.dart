import 'dart:math';

/// Genetik algoritm (TSP): 0-indeks boshlang'ich nuqta, qolganlari tartibi optimallanadi.
List<int> geneticTsp(List<List<double>> dm,
    {int pop = 80, int gens = 200, double mut = 0.25, int seed = 42}) {
  final n = dm.length;
  if (n <= 3) return List.generate(n, (i) => i);
  final rnd = Random(seed);
  double cost(List<int> r) {
    var s = 0.0;
    for (var i = 0; i < n - 1; i++) {
      s += dm[r[i]][r[i + 1]];
    }
    return s;
  }

  List<int> randomRoute() => [0, ...(List.generate(n - 1, (i) => i + 1)..shuffle(rnd))];

  List<int> pick(List<List<int>> p) {
    // Turnir tanlovi (3 ta)
    var best = p[rnd.nextInt(p.length)];
    for (var k = 0; k < 2; k++) {
      final c = p[rnd.nextInt(p.length)];
      if (cost(c) < cost(best)) best = c;
    }
    return best;
  }

  (int, int) twoIdx() {
    final i = 1 + rnd.nextInt(n - 1);
    var j = 1 + rnd.nextInt(n - 1);
    while (j == i) {
      j = 1 + rnd.nextInt(n - 1);
    }
    return i < j ? (i, j) : (j, i);
  }

  List<int> crossover(List<int> a, List<int> b) {
    // Order crossover
    final (i, j) = twoIdx();
    final mid = a.sublist(i, j + 1);
    final rest = b.where((g) => g != 0 && !mid.contains(g)).toList();
    return [0, ...rest.sublist(0, i - 1), ...mid, ...rest.sublist(i - 1)];
  }

  List<int> mutate(List<int> r) {
    if (rnd.nextDouble() < mut) {
      // 2-opt
      final (i, j) = twoIdx();
      final rev = r.sublist(i, j + 1).reversed.toList();
      r.setRange(i, j + 1, rev);
    }
    return r;
  }

  var p = List.generate(pop, (_) => randomRoute());
  for (var g = 0; g < gens; g++) {
    p.sort((x, y) => cost(x).compareTo(cost(y)));
    final next = [p[0], p[1]];
    while (next.length < pop) {
      next.add(mutate(crossover(pick(p), pick(p))));
    }
    p = next;
  }
  p.sort((x, y) => cost(x).compareTo(cost(y)));
  return p.first;
}
