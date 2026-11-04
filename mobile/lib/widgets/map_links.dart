import 'package:url_launcher/url_launcher.dart';
import '../models/attraction.dart';

Future<void> openPlace(Attraction a) => launchUrl(
    Uri.parse('https://www.google.com/maps/search/?api=1&query=${a.lat},${a.lon}'),
    mode: LaunchMode.externalApplication);

/// Kunning barcha to'xtash joylari bilan Google Maps yo'nalishi.
Future<void> openDirections(List<Attraction> stops) {
  final pts = stops.map((a) => '${a.lat},${a.lon}').toList();
  final params = {
    'api': '1',
    'destination': pts.last,
    if (pts.length > 1) 'waypoints': pts.sublist(0, pts.length - 1).join('|'),
  };
  return launchUrl(Uri.https('www.google.com', '/maps/dir/', params), mode: LaunchMode.externalApplication);
}
