import 'dart:math';

const double rKm = 6371.0088;

/// Ikki nuqta (lat, lon gradusda) orasidagi katta doira masofasi (km). Haversine formulasi.
double haversineKm(double lat1, double lon1, double lat2, double lon2) {
  double rad(double d) => d * pi / 180;
  final h = pow(sin((rad(lat2) - rad(lat1)) / 2), 2) +
      cos(rad(lat1)) * cos(rad(lat2)) * pow(sin((rad(lon2) - rad(lon1)) / 2), 2);
  return 2 * rKm * asin(sqrt(h));
}

List<List<double>> distanceMatrix(List<List<double>> coords) {
  final n = coords.length;
  final m = List.generate(n, (_) => List.filled(n, 0.0));
  for (var i = 0; i < n; i++) {
    for (var j = i + 1; j < n; j++) {
      m[i][j] = m[j][i] = haversineKm(coords[i][0], coords[i][1], coords[j][0], coords[j][1]);
    }
  }
  return m;
}
