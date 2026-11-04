import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ilova tili: uz / en / ru. Tanlangan til telefonda eslab qolinadi.
class Lang {
  static final current = ValueNotifier<String>('uz');
  static const names = {'uz': "O'zbekcha", 'en': 'English', 'ru': 'Русский'};

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    current.value = prefs.getString('lang') ?? 'uz';
  }

  static Future<void> set(String code) async {
    current.value = code;
    (await SharedPreferences.getInstance()).setString('lang', code);
  }
}

String tr(String key) => _t[key]?[Lang.current.value] ?? _t[key]?['en'] ?? key;

const _t = <String, Map<String, String>>{
  'app_title': {'uz': 'Aqlli sayohat', 'en': 'Smart Tourism', 'ru': 'Умный туризм'},
  'interests': {'uz': 'Qiziqishlaringiz', 'en': 'Your interests', 'ru': 'Ваши интересы'},
  'all_cities': {'uz': 'Barcha shaharlar', 'en': 'All cities', 'ru': 'Все города'},
  'route': {'uz': 'Marshrut', 'en': 'Route', 'ru': 'Маршрут'},
  'optimal_route': {'uz': 'Optimal marshrut', 'en': 'Best route', 'ru': 'Оптимальный маршрут'},
  'tap_to_add': {'uz': 'Joylarni tanlang va marshrut tuzing', 'en': 'Pick places and build your route', 'ru': 'Выберите места и постройте маршрут'},
  'nothing': {'uz': 'Hech narsa topilmadi', 'en': 'Nothing found', 'ru': 'Ничего не найдено'},
  'min': {'uz': 'daq', 'en': 'min', 'ru': 'мин'},
  'km': {'uz': 'km', 'en': 'km', 'ru': 'км'},
  'day': {'uz': '-kun', 'en': 'Day ', 'ru': 'День '},
  'total': {'uz': 'Jami', 'en': 'Total', 'ru': 'Итого'},
  'travel': {'uz': "yo'l", 'en': 'travel', 'ru': 'в пути'},
  'visit_time': {'uz': 'Tashrif vaqti', 'en': 'Visit time', 'ru': 'Время посещения'},
  'ticket': {'uz': 'Kirish narxi', 'en': 'Entry price', 'ru': 'Цена входа'},
  'free': {'uz': 'Bepul', 'en': 'Free', 'ru': 'Бесплатно'},
  'rating': {'uz': 'Reyting', 'en': 'Rating', 'ru': 'Рейтинг'},
  'distance': {'uz': 'Sizdan masofa', 'en': 'Distance from you', 'ru': 'Расстояние от вас'},
  'add_to_route': {'uz': "Marshrutga qo'shish", 'en': 'Add to route', 'ru': 'Добавить в маршрут'},
  'remove_from_route': {'uz': "Marshrutdan olib tashlash", 'en': 'Remove from route', 'ru': 'Убрать из маршрута'},
  'open_maps': {'uz': "Google Xaritada ochish", 'en': 'Open in Google Maps', 'ru': 'Открыть в Google Картах'},
  'navigate_day': {'uz': "Shu kunni xaritada yo'l bilan ochish", 'en': 'Navigate this day in Google Maps', 'ru': 'Проложить день в Google Картах'},
  'start_point': {'uz': "Siz shu yerdasiz", 'en': 'You are here', 'ru': 'Вы здесь'},
  'how_it_works': {
    'uz': "Marshrut telefonda hisoblanadi: genetik algoritm tartibni, A* esa yo'lni topadi. Kuniga 8 soatdan oshmaydi.",
    'en': 'Calculated on your phone: a genetic algorithm picks the order, A* finds the path. Max 8 hours per day.',
    'ru': 'Считается на телефоне: генетический алгоритм выбирает порядок, A* — путь. Не более 8 часов в день.'
  },
  // Toifalar / teglar
  'tarix': {'uz': 'Tarix', 'en': 'History', 'ru': 'История'},
  'foto': {'uz': 'Foto', 'en': 'Photo spots', 'ru': 'Фото'},
  'taom': {'uz': 'Taom', 'en': 'Food', 'ru': 'Еда'},
  'bozor': {'uz': 'Bozor', 'en': 'Markets', 'ru': 'Базары'},
  'hunar': {'uz': 'Hunarmandchilik', 'en': 'Crafts', 'ru': 'Ремёсла'},
  'tabiat': {'uz': 'Tabiat', 'en': 'Nature', 'ru': 'Природа'},
  'shahar': {'uz': 'Shahar', 'en': 'City', 'ru': 'Город'},
  // Shaharlar
  'tashkent': {'uz': 'Toshkent', 'en': 'Tashkent', 'ru': 'Ташкент'},
  'samarkand': {'uz': 'Samarqand', 'en': 'Samarkand', 'ru': 'Самарканд'},
  'bukhara': {'uz': 'Buxoro', 'en': 'Bukhara', 'ru': 'Бухара'},
  'khiva': {'uz': 'Xiva', 'en': 'Khiva', 'ru': 'Хива'},
  'fergana': {'uz': "Farg'ona vodiysi", 'en': 'Fergana Valley', 'ru': 'Ферганская долина'},
};

String dayLabel(int n) => Lang.current.value == 'uz' ? '$n${tr('day')}' : '${tr('day')}$n';
