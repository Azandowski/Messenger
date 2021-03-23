import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';

import '../../../../../core/services/network/paginatedResult.dart';
import '../../../../../core/utils/pagination.dart';
import '../../../../chat/domain/usecases/get_chat_members.dart';
import '../../../../chat/domain/usecases/params.dart';
import '../../../domain/entities/contact.dart';
import '../../../domain/usecases/fetch_contacts.dart';

part 'contact_event.dart';
part 'contact_state.dart';

abstract class ContactMode {}

class GetChatMembersMode implements ContactMode {
  final int id;

  GetChatMembersMode(this.id);
}

class GetUserContactsMode implements ContactMode {}

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc({
    this.fetchContacts,
    this.getChatMembers,
    this.mode,
  }) : super(const ContactState()) {
    if (this.mode == null) {
      mode = GetUserContactsMode();
    }
  }

  ContactMode mode;
  final FetchContacts fetchContacts;
  final GetChatMembers getChatMembers;

  @override
  Stream<ContactState> mapEventToState(ContactEvent event) async* {
    if (event is ContactFetched) {
      var status = state.status;

      yield state.copyWith(status: ContactStatus.loading);

      yield await _mapPostFetchedToState(state, status);
    } else if (event is RefreshContacts) {
      var status = state.status;
      _pagintaion = Pagination();
      yield state.copyWith(
          status: ContactStatus.loading, contacts: [], hasReachedMax: false);

      yield await _mapPostFetchedToState(state, status);
    } else if (event is ContactReset) {
      yield state.copyWith(
        status: ContactStatus.initial,
        hasReachedMax: false,
        contacts: []
      );
    }
  }

  var _pagintaion = Pagination();

  Future<ContactState> _mapPostFetchedToState(
      ContactState state, ContactStatus status) async {
    if (state.hasReachedMax)
      return state.copyWith(status: ContactStatus.success);
    try {
      if (status == ContactStatus.initial) {
        PaginatedResult<ContactEntity> response = await _getData(_pagintaion);
        _pagintaion.next();

        return state.copyWith(
            status: ContactStatus.success,
            contacts: response.data,
            hasReachedMax: !response.paginationData.hasNextPage,
            maxTotal: response.paginationData.total);
      } else {
        PaginatedResult<ContactEntity> response = await _getData(_pagintaion);

        if (response.data.isEmpty) {
          return state.copyWith(hasReachedMax: true);
        } else {
          _pagintaion.next();
          return state.copyWith(
              status: ContactStatus.success,
              contacts: List.of(state.contacts)..addAll(response.data),
              hasReachedMax: !response.paginationData.hasNextPage);
        }
      }
    } catch (e) {
      return state.copyWith(status: ContactStatus.failure);
    }
  }

  Future<PaginatedResult<ContactEntity>> _getData(Pagination pagination) async {
    if (mode is GetChatMembersMode) {
      return _getChatMembers(pagination);
    } else {
      return _fetchContacts(pagination);
    }
  }

  Future<PaginatedResult<ContactEntity>> _fetchContacts(
      Pagination pagination) async {
    var failOrContacts = await fetchContacts(pagination);

    return failOrContacts.fold(
      (l) => throw Exception,
      (r) => r,
    );
  }

  Future<PaginatedResult<ContactEntity>> _getChatMembers(
      Pagination pagination) async {
    var failOrContacts = await getChatMembers(GetChatMembersParams(
        id: (mode as GetChatMembersMode).id, pagination: pagination));

    return failOrContacts.fold(
      (l) => throw Exception,
      (r) => r,
    );
  }
}
