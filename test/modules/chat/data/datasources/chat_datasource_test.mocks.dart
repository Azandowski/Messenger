import 'package:mockito/mockito.dart' as _i1;
import 'package:messenger_mobile/core/services/network/socket_service.dart'
    as _i2;
import 'package:http/src/client.dart' as _i3;
import 'package:http/src/multipart_request.dart' as _i4;

/// A class which mocks [SocketService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSocketService extends _i1.Mock implements _i2.SocketService {
  MockSocketService() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [Client].
///
/// See the documentation for Mockito's code generation for more information.
class MockClient extends _i1.Mock implements _i3.Client {
  MockClient() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [MultipartRequest].
///
/// See the documentation for Mockito's code generation for more information.
class MockMultipartRequest extends _i1.Mock implements _i4.MultipartRequest {
  MockMultipartRequest() {
    _i1.throwOnMissingStub(this);
  }
}
