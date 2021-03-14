import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/category/domain/repositories/category_repository.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/delete_category.dart';
import 'package:messenger_mobile/modules/category/domain/usecases/reorder_category.dart';
import 'package:mockito/mockito.dart';

class MockCategoryRepository extends Mock implements CategoryRepository{}
class MockDeleteCategory extends Mock implements DeleteCategory{}
class MockReorderCategories extends Mock implements ReorderCategories{}


void main() {
  testWidgets('category bloc ...', (tester) async {
    // TODO: Implement test
  });
}