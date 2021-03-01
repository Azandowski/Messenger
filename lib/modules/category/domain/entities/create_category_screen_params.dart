enum CreateCategoryScreenMode {
  create, edit
}

extension CreateCategoryScreenModeUIExtension on CreateCategoryScreenMode {
  String get title {
    switch (this) {
      case CreateCategoryScreenMode.create:
        return 'Создать категорию';
      case CreateCategoryScreenMode.edit:
        return 'Редактировать';
    }
  }
}