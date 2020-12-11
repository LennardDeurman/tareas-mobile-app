class AssetPaths {
  
  
  static const String localization = "assets/i18n";
  static const String images = "assets/images";
  static const String categoryImages = "assets/images/categories";
  static const String icons = "assets/icons";
  
  
  static String svg(String key, { String base = AssetPaths.icons }) => "$base/$key.svg";
  static String imagePng(String key, { String base = AssetPaths.images }) => "$base/$key.png";
  static String imageGif(String key, { String base = AssetPaths.images }) => "$base/$key.gif";
  static String imageJpg(String key, { String base = AssetPaths.images }) => "$base/$key.jpg";

}



class IconAssetPaths {
  
  static String calculator = AssetPaths.svg("calculator");
  static String calendarStar = AssetPaths.svg("calendar_star");
  static String check = AssetPaths.svg("check");
  static String clock = AssetPaths.svg("clock");
  static String ellipsisH = AssetPaths.svg("ellipsis_h");
  static String handsHelping = AssetPaths.svg("hands_helping");
  static String megaphone = AssetPaths.svg("megaphone");
  static String mugHot = AssetPaths.svg("mug_hot");
  static String pennant = AssetPaths.svg("pennant");
  static String save = AssetPaths.svg("save");
  static String slidersHSquare = AssetPaths.svg("sliders_h_square");
  static String tasks = AssetPaths.svg("tasks");
  static String thLarge = AssetPaths.svg("th_large");
  static String thumbsUp = AssetPaths.svg("thumbs_up");
  static String undo = AssetPaths.svg("undo");
  static String user = AssetPaths.svg("user");
  static String walking = AssetPaths.svg("walking");
  static String whistle = AssetPaths.svg("whistle");
  static String engineWarning = AssetPaths.svg("engine_warning");
  static String signOutAlt = AssetPaths.svg("sign_out_alt");
  static String calendarPlus = AssetPaths.svg("calendar_plus");
  static String globe = AssetPaths.svg("globe");
  static String book = AssetPaths.svg("book");
  static String kite = AssetPaths.svg("kite");
  static String imagePolaroid = AssetPaths.svg("image_polaroid");
  static String shieldCheck = AssetPaths.svg("shield_check");
  static String sitemap = AssetPaths.svg("sitemap");

}

class ImageAssetPaths {

  static String loginLogo = AssetPaths.imagePng("logo_login_tareas");
  static String loginBackground = AssetPaths.imagePng("icon_background_mobile");
  static String tasksNoResults = AssetPaths.imagePng("placeholder_no_tasks");
  static String loading = AssetPaths.imageGif("loading");
  static String listLoading = AssetPaths.imagePng("list_loading");
  static String listError = AssetPaths.imagePng("list_error");
  static String listNoResults = AssetPaths.imagePng("list_no_subcribed_activities");
  static String listNoSubscribedActivities = AssetPaths.imagePng("list_no_results");
  static String categoryActivities = AssetPaths.imageJpg("activiteiten", base: AssetPaths.categoryImages);
  static String categoryAdministration = AssetPaths.imageJpg("administratie", base: AssetPaths.categoryImages);
  static String categoryEvents = AssetPaths.imageJpg("evenement", base: AssetPaths.categoryImages);
  static String categoryBar = AssetPaths.imageJpg("kantine", base: AssetPaths.categoryImages);
  static String categorySocial = AssetPaths.imageJpg("maatschappelijk", base: AssetPaths.categoryImages);
  static String categoryOther = AssetPaths.imageJpg("overig", base: AssetPaths.categoryImages);
  static String categorySportpark = AssetPaths.imageJpg("sportpark", base: AssetPaths.categoryImages);
  static String categoryMatchRelated = AssetPaths.imageJpg("wedstrijd", base: AssetPaths.categoryImages);
}

