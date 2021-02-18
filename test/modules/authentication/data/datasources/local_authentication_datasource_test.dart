import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/config/storage.dart';
import 'package:messenger_mobile/modules/authentication/data/datasources/local_authentication_datasource.dart';
import 'package:mockito/mockito.dart';

class MockStorage extends Mock implements Storage {}

main() {
  MockStorage storage;
  AuthenticationLocalDataSourceImpl localDataSource;
  setUp(() {
    storage = MockStorage();
    localDataSource = AuthenticationLocalDataSourceImpl();
  });

  test('should get token when there is token', () async {
    //arrange
    final token = 'fnsjfkds';
    when(localDataSource.getToken().then((value) => token));
    //act
    final result = await localDataSource.getToken();
    //verify
    verify(localDataSource.getToken());
    expect(result, token);
  });
}
