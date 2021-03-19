import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/core/error/failures.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/modules/chat/domain/usecases/get_chat_members.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
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

  setUp(() {
    mockFetchContacts = MockFetchContacts();
    mockGetChatMembers = MockGetChatMembers();
  });

  final tPaginatedResult = PaginatedResult<ContactEntity>(
    data: [],
    paginationData: PaginationData(nextPageUrl: Uri.parse("nextPageUrl")),
  );

  group('GetUserContactsMode', () {
    setUp(() {
      bloc = ContactBloc(
        fetchContacts: mockFetchContacts,
        getChatMembers: mockGetChatMembers,
        mode: GetUserContactsMode(),
      );
    });

    group('ContactFetched', () {
      blocTest(
        'should emit [ContactStatus.loading, ContactStatus.success] on success',
        build: () => bloc,
        act: (ContactBloc bloc) {
          when(mockFetchContacts(any))
              .thenAnswer((_) async => Right(tPaginatedResult));
          bloc.add(ContactFetched());
        },
        expect: [
          ContactState(status: ContactStatus.loading),
          ContactState(status: ContactStatus.success),
        ],
      );

      blocTest(
        'should emit [ContactStatus.loading, ContactStatus.failure] on exception',
        build: () => bloc,
        act: (ContactBloc bloc) {
          when(mockFetchContacts(any))
              .thenAnswer((_) async => Left(ServerFailure(message: "message")));
          bloc.add(ContactFetched());
        },
        expect: [
          ContactState(status: ContactStatus.loading),
          ContactState(status: ContactStatus.failure),
        ],
      );
    });

    group('RefreshContacts', () {
      blocTest(
        'should emit [ContactStatus.loading, ContactStatus.success] on success',
        build: () => bloc,
        act: (ContactBloc bloc) {
          when(mockFetchContacts(any))
              .thenAnswer((_) async => Right(tPaginatedResult));
          bloc.add(RefreshContacts());
        },
        expect: [
          ContactState(status: ContactStatus.loading),
          ContactState(status: ContactStatus.success),
        ],
      );

      blocTest(
        'should emit [ContactStatus.loading, ContactStatus.failure] on exception',
        build: () => bloc,
        act: (ContactBloc bloc) {
          when(mockFetchContacts(any))
              .thenAnswer((_) async => Left(ServerFailure(message: "message")));
          bloc.add(RefreshContacts());
        },
        expect: [
          ContactState(status: ContactStatus.loading),
          ContactState(status: ContactStatus.failure),
        ],
      );
    });
  });

  group('GetChatMembersMode', () {
    setUp(() {
      bloc = ContactBloc(
        fetchContacts: mockFetchContacts,
        getChatMembers: mockGetChatMembers,
        mode: GetChatMembersMode(1),
      );
    });

    group('ContactFetched', () {
      blocTest(
        'should emit [ContactStatus.loading, ContactStatus.success] on success',
        build: () => bloc,
        act: (ContactBloc bloc) {
          when(mockGetChatMembers(any))
              .thenAnswer((_) async => Right(tPaginatedResult));
          bloc.add(ContactFetched());
        },
        expect: [
          ContactState(status: ContactStatus.loading),
          ContactState(status: ContactStatus.success),
        ],
      );

      blocTest(
        'should emit [ContactStatus.loading, ContactStatus.failure] on exception',
        build: () => bloc,
        act: (ContactBloc bloc) {
          when(mockGetChatMembers(any))
              .thenAnswer((_) async => Left(ServerFailure(message: "message")));
          bloc.add(ContactFetched());
        },
        expect: [
          ContactState(status: ContactStatus.loading),
          ContactState(status: ContactStatus.failure),
        ],
      );
    });

    group('RefreshContacts', () {
      blocTest(
        'should emit [ContactStatus.loading, ContactStatus.success] on success',
        build: () => bloc,
        act: (ContactBloc bloc) {
          when(mockGetChatMembers(any))
              .thenAnswer((_) async => Right(tPaginatedResult));
          bloc.add(RefreshContacts());
        },
        expect: [
          ContactState(status: ContactStatus.loading),
          ContactState(status: ContactStatus.success),
        ],
      );

      blocTest(
        'should emit [ContactStatus.loading, ContactStatus.failure] on exception',
        build: () => bloc,
        act: (ContactBloc bloc) {
          when(mockGetChatMembers(any))
              .thenAnswer((_) async => Left(ServerFailure(message: "message")));
          bloc.add(RefreshContacts());
        },
        expect: [
          ContactState(status: ContactStatus.loading),
          ContactState(status: ContactStatus.failure),
        ],
      );
    });
  });
}
