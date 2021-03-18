import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_members.dart';
import 'package:messenger_mobile/modules/creation_module/domain/usecases/fetch_contacts.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
import 'package:mockito/mockito.dart';

class MockFetchContacts extends Mock implements FetchContacts {}

class MockGetChatMembers extends Mock implements GetChatMembers {}

class MockContactMode extends Mock implements ContactMode {}

void main() {
  ContactBloc bloc;
  MockFetchContacts mockFetchContacts;
  MockGetChatMembers mockGetChatMembers;
  MockContactMode mockContactMode;

  setUp(() {
    mockFetchContacts = MockFetchContacts();
    mockGetChatMembers = MockGetChatMembers();
    mockContactMode = MockContactMode();
    bloc = ContactBloc(
      fetchContacts: mockFetchContacts,
      getChatMembers: mockGetChatMembers,
      mode: mockContactMode,
    );
  });

  test('initial state should be ContactState', () {
    expect(bloc.state, equals(ContactState()));
  });

  group('ContactFetched', () {
    blocTest('should',
        build: () => bloc,
        act: (ContactBloc bloc) {
          bloc.add(ContactFetched());
        },
        expect: []);
  });
}
