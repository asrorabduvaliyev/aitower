import 'package:latlong2/latlong.dart';
import 'attraction.dart';

class Stop {
  final Attraction place;
  final double travelKm;
  final int travelMinutes;
  Stop(this.place, this.travelKm, this.travelMinutes);
}

class DayPlan {
  final int day;
  double minutes = 0, distanceKm = 0, costUsd = 0;
  final stops = <Stop>[];
  final path = <LatLng>[];
  DayPlan(this.day);
}

class RoutePlan {
  final List<DayPlan> days;
  RoutePlan(this.days);
  double get totalKm => days.fold(0.0, (s, d) => s + d.distanceKm);
  double get totalCost => days.fold(0.0, (s, d) => s + d.costUsd);
}
