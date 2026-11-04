import 'dart:math';
import '../models/attraction.dart';
import 'haversine.dart';

double _cosine(List<double> a, List<double> b) {
  double dot = 0, na = 0, nb = 0;
  for (var i = 0; i < a.length; i++) {
    dot += a[i] * b[i];
    na += a[i] * a[i];
    nb += b[i] * b[i];
  }
  return na == 0 || nb == 0 ? 0 : dot / (sqrt(na) * sqrt(nb));
}

Set<String> itemTags(Attraction a) => {...a.tags, a.category};

/// Kontentga asoslangan filtrlash: qiziqishlar vektori bilan joy teglari vektori
/// orasidagi kosinus o'xshashligi + reyting + (bo'lsa) yaqinlik.
List<Attraction> recommend(List<Attraction> items, Set<String> interests,
    {double? lat, double? lon, int limit = 30}) {
  final vocab = <String>{...interests, for (final a in items) ...itemTags(a)}.toList()..sort();
  List<double> vec(Set<String> tags) => [for (final t in vocab) tags.contains(t) ? 1.0 : 0.0];
  final user = vec(interests);
  for (final a in items) {
    final sim = _cosine(user, vec(itemTags(a)));
    var prox = 0.0;
    if (lat != null && lon != null) {
      a.distanceKm = haversineKm(lat, lon, a.lat, a.lon);
      prox = 1 / (1 + a.distanceKm! / 50);
    }
    a.score = 0.7 * sim + 0.2 * a.rating / 5 + 0.1 * prox;
  }
  final ranked = [...items]..sort((x, y) => y.score.compareTo(x.score));
  return ranked.take(limit).toList();
}
