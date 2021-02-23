import 'package:dartz/dartz.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/locator.dart';
import 'package:messenger_mobile/modules/profile/presentation/bloc/index.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/profile/domain/usecases/get_user.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetUser extends Mock implements GetUser {}

void main() {
  ProfileCubit cubit;
  MockGetUser mockGetUser;

  setUp(() {
    mockGetUser = MockGetUser();
    cubit = ProfileCubit(getUser: mockGetUser);
  });

  test('initialState should be Loading State', () {
    // assert
    expect(cubit.state, equals(ProfileLoading()));
  });

  test('should return error if there is an error', () {
    when(mockGetUser(any))
        .thenAnswer((_) async => Left(ServerFailure(message: 'ERROR')));

    // assert layer
    final expected = [ProfileLoading(), ProfileError(message: 'ERROR')];
  });

  test('If success state becomes profile loaded', () {
    sl.registerLazySingleton(() => AuthConfig());
    final User user = User(name: 'Yerkebulan', phoneNumber: '+77470726323');

    when(mockGetUser(any)).thenAnswer((_) async => Right(user));

    // assert layer
    final expected = [ProfileLoading(), ProfileLoaded(user: user)];
  });
}
