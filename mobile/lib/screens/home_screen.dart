import 'package:flutter/material.dart';
import '../algorithms/content_filtering.dart';
import '../l10n/strings.dart';
import '../models/attraction.dart';
import '../services/data_service.dart';
import '../widgets/attraction_card.dart';
import 'detail_screen.dart';
import 'route_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const tags = ['tarix', 'foto', 'taom', 'bozor', 'hunar', 'tabiat'];
  static const cities = ['tashkent', 'samarkand', 'bukhara', 'khiva', 'fergana'];
  final data = DataService();
  final interests = <String>{'tarix'};
  final selected = <int>{};
  String? city;
  List<Attraction> all = [], items = [];
  bool loading = true;
  double? lat, lon;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    all = await data.attractions();
    _rank();
    setState(() => loading = false);
    final pos = await data.currentPosition();
    if (pos != null && mounted) {
      lat = pos.latitude;
      lon = pos.longitude;
      setState(_rank);
    }
  }

  void _rank() {
    final pool = city == null ? all : all.where((a) => a.city == city).toList();
    items = recommend(pool, interests, lat: lat, lon: lon);
  }

  void _toggle(int id) => setState(() => selected.contains(id) ? selected.remove(id) : selected.add(id));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('app_title')),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (code) async {
              await Lang.set(code);
              setState(() {});
            },
            itemBuilder: (_) => [
              for (final e in Lang.names.entries)
                CheckedPopupMenuItem(value: e.key, checked: Lang.current.value == e.key, child: Text(e.value)),
            ],
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(children: [
                  Text(tr('interests'), style: Theme.of(context).textTheme.titleSmall),
                  const Spacer(),
                  DropdownButton<String?>(
                    value: city,
                    underline: const SizedBox(),
                    items: [
                      DropdownMenuItem(value: null, child: Text(tr('all_cities'))),
                      for (final c in cities) DropdownMenuItem(value: c, child: Text(tr(c))),
                    ],
                    onChanged: (v) => setState(() {
                      city = v;
                      _rank();
                    }),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(
                    spacing: 8,
                    children: tags
                        .map((t) => FilterChip(
                              label: Text(tr(t)),
                              selected: interests.contains(t),
                              onSelected: (v) => setState(() {
                                v ? interests.add(t) : interests.remove(t);
                                _rank();
                              }),
                            ))
                        .toList()),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(tr('tap_to_add'), style: Theme.of(context).textTheme.bodySmall),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(child: Text(tr('nothing')))
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 88),
                        children: items
                            .map((a) => AttractionCard(
                                  a: a,
                                  selected: selected.contains(a.id),
                                  onToggle: () => _toggle(a.id),
                                  onTap: () async {
                                    await Navigator.push(context, MaterialPageRoute(
                                        builder: (_) => DetailScreen(
                                            a: a, selected: selected.contains(a.id), onToggle: () => _toggle(a.id))));
                                    setState(() {});
                                  },
                                ))
                            .toList()),
              ),
            ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: selected.isEmpty
            ? null
            : () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => RouteScreen(places: all.where((a) => selected.contains(a.id)).toList(), lat: lat, lon: lon))),
        backgroundColor: selected.isEmpty ? Colors.grey.shade300 : null,
        icon: const Icon(Icons.route),
        label: Text('${tr('route')} (${selected.length})'),
      ),
    );
  }
}
