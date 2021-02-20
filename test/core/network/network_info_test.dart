import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/services/network/network_info.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

main() {
  MockDataConnectionChecker mockDataConnectionChecker;
  NetworkInfoImpl networkDataImpl;
  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkDataImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  test('should get DataConnection.hasConnection', () async {
    //arrange
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    //act
    final result = await networkDataImpl.isConnected;
    //verify
    verify(mockDataConnectionChecker.hasConnection);
    expect(result, true);
  });
}
