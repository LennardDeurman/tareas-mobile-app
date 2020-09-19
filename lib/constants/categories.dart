
import 'package:tareas/constants/asset_paths.dart';

class CategoryData {

  String iconAssetPath;
  String imageAssetPath;

  CategoryData ({ this.iconAssetPath, this.imageAssetPath });

}


class Categories {

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
    )
  };

}