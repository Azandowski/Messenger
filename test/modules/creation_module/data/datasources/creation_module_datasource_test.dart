import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/creation_module/data/datasources/creation_module_datasource.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_model.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockAuthConfig extends Mock implements AuthConfig {}

void main() {
  CreationModuleDataSourceImpl dataSource;
  MockHttpClient httpClient;
  MockAuthConfig authConfig;
  setUp(() {
    httpClient = MockHttpClient();
    authConfig = MockAuthConfig();
    dataSource = CreationModuleDataSourceImpl(
        client: httpClient, authConfig: authConfig);
  });

  group('fetchContacts', () {
    test(
        'should return PaginatedResult<ContactEntity> if response is successful',
        () async {
      when(httpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async =>
            http.Response(fixture("creation_module_datasource.json"), 200),
      );

      final result = await dataSource.fetchContacts(Pagination());

      final PaginatedResult<ContactEntity> expected = PaginatedResult(
        data: [
          ContactModel(
              name: "name",
              surname: "surname",
              patronym: "patronym",
              avatar: "avatar",
              id: 1)
        ],
        paginationData: PaginationData(
            nextPageUrl: Uri.parse("next_page_url"), isFirstPage: false),
      );

      expect(result, equals(expected));
    });
  });

  test('should throw ServerFailure when resnonse is not successfull', () {
    when(httpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(
        fixture("creation_module_datasource.json"),
        400,
      ),
    );
    expect(
      () => dataSource.fetchContacts(Pagination()),
      throwsA(isA<ServerFailure>()),
    );
  });
}
