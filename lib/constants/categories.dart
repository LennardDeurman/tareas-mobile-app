
import 'package:tareas/constants/asset_paths.dart';

class CategoryData {

  String iconAssetPath;
  String imageAssetPath;

  CategoryData ({ this.iconAssetPath, this.imageAssetPath });

}


class Categories {

  //TODO: Dedicated image assets per category

  static Map<String, CategoryData> map = {
    "Kantine": CategoryData(
      iconAssetPath: IconAssetPaths.mugHot,
      imageAssetPath: ImageAssetPaths.categoryBar
    ),
    "Wedstrijd": CategoryData(
      iconAssetPath: IconAssetPaths.whistle,
      imageAssetPath: ImageAssetPaths.categoryMatchRelated
    ),
    "Activiteiten": CategoryData(
      iconAssetPath: IconAssetPaths.walking,
      imageAssetPath: ImageAssetPaths.categoryActivities
    ),
    "Sportpark": CategoryData(
      iconAssetPath: IconAssetPaths.pennant,
      imageAssetPath: ImageAssetPaths.categorySportpark
    ),
    "Maatschappelijk": CategoryData(
      iconAssetPath: IconAssetPaths.handsHelping,
      imageAssetPath: ImageAssetPaths.categorySocial
    ),
    "Administratie": CategoryData(
      iconAssetPath: IconAssetPaths.calculator,
      imageAssetPath: ImageAssetPaths.categoryAdministration
    ),
    "Overig": CategoryData(
      iconAssetPath: IconAssetPaths.ellipsisH,
      imageAssetPath: ImageAssetPaths.categoryOther
    ),
    "Evenement": CategoryData(
      iconAssetPath: IconAssetPaths.megaphone,
      imageAssetPath: ImageAssetPaths.categoryEvents
    ),
    "Beleid": CategoryData(
      iconAssetPath: IconAssetPaths.book,
      imageAssetPath: ImageAssetPaths.categoryAdministration
    ),
    "Fun": CategoryData(
      iconAssetPath: IconAssetPaths.kite,
      imageAssetPath: ImageAssetPaths.categoryEvents
    ),
    "Grafisch/Communicatie": CategoryData(
      iconAssetPath: IconAssetPaths.imagePolaroid,
      imageAssetPath: ImageAssetPaths.categoryOther
    ),
    "Organisatorisch": CategoryData(
      iconAssetPath: IconAssetPaths.sitemap,
      imageAssetPath: ImageAssetPaths.categoryActivities
    ),
    "Ondersteunend": CategoryData(
      iconAssetPath: IconAssetPaths.handsHelping,
      imageAssetPath: ImageAssetPaths.categorySocial
    ),
    "Veiligheid": CategoryData(
      iconAssetPath: IconAssetPaths.shieldCheck,
      imageAssetPath: ImageAssetPaths.categorySocial
    )
  };

  static String findIconPath(String key) {
    if (map.containsKey(key)) {
      return map[key].iconAssetPath;
    }
    return "";
  }



}