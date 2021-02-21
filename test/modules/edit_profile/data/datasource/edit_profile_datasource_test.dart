import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/services/network/Endpoints.dart';
import 'package:messenger_mobile/modules/edit_profile/data/datasources/edit_profile_datasource.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockMultipartRequest extends Mock implements http.MultipartRequest {}

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

  void handleUserUpdate ({
    @required String token, 
    Map data, 
    List<File> files
  }) async {
    httpMultipartRequest.headers["Authorization"] = "Bearer $token";
    httpMultipartRequest.headers["Accept"] = 'application/json';

    (data ?? {}).keys.forEach((e) { httpMultipartRequest.fields[e] = data[e]; });

    httpMultipartRequest.files.addAll(await editProfileDataSourceImpl.getFilesList(files));

    when(httpMultipartRequest.send()).thenAnswer((_) async => http.StreamedResponse(
      Stream.value([0]), 200
    ));
  }

  test('Should Update Profile', () async { 
    handleUserUpdate(token: '');
    
    final result = editProfileDataSourceImpl.updateUser(
      token: ''
    );

    verify(httpMultipartRequest.send());
  });
}