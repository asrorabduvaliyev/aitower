class Attraction {
  final int id;
  final String city, category;
  final List<String> tags;
  final Map<String, String> name, description;
  final double lat, lon, rating, costUsd;
  final int visitMinutes;
  double score = 0;
  double? distanceKm;

  Attraction.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        city = j['city'],
        category = j['category'],
        tags = List<String>.from(j['tags']),
        name = Map<String, String>.from(j['name']),
        description = Map<String, String>.from(j['description']),
        lat = (j['lat'] as num).toDouble(),
        lon = (j['lon'] as num).toDouble(),
        rating = (j['rating'] as num).toDouble(),
        costUsd = (j['cost_usd'] as num).toDouble(),
        visitMinutes = j['visit_minutes'];

  String nameIn(String lang) => name[lang] ?? name['en']!;
  String descriptionIn(String lang) => description[lang] ?? description['en']!;
}
