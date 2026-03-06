import 'package:exotic/data/models/homepage_page_model.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 11)
class TabsCache extends HiveObject {
  @HiveField(0)
  final List<HomepagePageModel> tabs;

  @HiveField(1)
  final String versionKey;

  TabsCache({required this.tabs, required this.versionKey});

  /// Optional helper: regenerate version from current tabs
  static String generateVersionKey(List<HomepagePageModel> tabs) {
    return tabs.map((e) => e.createdAt).join('|');
  }
}
