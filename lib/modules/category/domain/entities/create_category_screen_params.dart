import 'package:easy_localization/easy_localization.dart';

enum CreateCategoryScreenMode {
  create, edit
}

extension CreateCategoryScreenModeUIExtension on CreateCategoryScreenMode {
  String get title {
    switch (this) {
      case CreateCategoryScreenMode.create:
        return 'create_category'.tr();
      case CreateCategoryScreenMode.edit:
        return 'edit'.tr();
    }
  }
}