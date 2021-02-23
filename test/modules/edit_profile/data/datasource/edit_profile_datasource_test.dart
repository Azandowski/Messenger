import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/edit_profile/data/datasources/edit_profile_datasource.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockMultipartRequest extends Mock implements http.MultipartRequest {
  @override
  final Map<String, String> headers = {};

  @override
  final fields = <String, String>{};

  @override
  final files = <http.MultipartFile>[];
}

main() { 
  TestWidgetsFlutterBinding.ensureInitialized();
  EditProfileDataSourceImpl editProfileDataSourceImpl;
  MockMultipartRequest httpMultipartRequest;

  setUp(() async { 
    httpMultipartRequest = MockMultipartRequest();
    editProfileDataSourceImpl = EditProfileDataSourceImpl(request: httpMultipartRequest);
  });

  // MARK: - Local props

  final user = UserModel(
    name: 'Yerkebulan',
    phoneNumber: '+77470726323'
  );


  test('Should Update Profile', () async { 
    when(httpMultipartRequest.send()).thenAnswer((_) async => http.StreamedResponse(
      Stream.value([0]), 200
    ));
    
    final result = await editProfileDataSourceImpl.updateUser(
      token: '', isTest: true
    );

    verify(httpMultipartRequest.send());
  });
}