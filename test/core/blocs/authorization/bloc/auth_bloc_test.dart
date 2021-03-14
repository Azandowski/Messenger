import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/blocs/authorization/bloc/auth_bloc.dart';
import 'package:messenger_mobile/modules/authentication/domain/repositories/authentication_repository.dart';
import 'package:messenger_mobile/modules/authentication/domain/usecases/logout.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockLogout extends Mock implements Logout {}

void main() {
  AuthBloc bloc;
  MockAuthenticationRepository mockAuthenticationRepository;
  MockLogout mockLogout;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    mockLogout = MockLogout();

    bloc = AuthBloc(
      authRepositiry: mockAuthenticationRepository,
      logoutUseCase: mockLogout,
    );

    StreamController<AuthParams> params =
        StreamController<AuthParams>.broadcast();

    when(mockAuthenticationRepository.params).thenReturn(params);
  });

  test('initial state shoud be Unknown', () {
    expect(bloc.state, isA<Unknown>());
  });
}
