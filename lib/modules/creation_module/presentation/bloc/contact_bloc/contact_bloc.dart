import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../../../core/utils/pagination.dart';
import '../../../data/models/contact_response.dart';
import '../../../domain/entities/contact.dart';
import '../../../domain/usecases/fetch_contacts.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  
  ContactBloc({
    @required this.fetchContacts,
  }) : super(const ContactState());

  final FetchContacts fetchContacts;
  
  @override
  Stream<ContactState> mapEventToState(ContactEvent event) async* {
    if (event is ContactFetched) {
      var status = state.status;

      yield state.copyWith(
        status: ContactStatus.loading
      );

      yield await _mapPostFetchedToState(state, status);
    } else if (event is RefreshContacts) {
      var status = state.status;
      _pagintaion = Pagination();
      yield state.copyWith(
        status: ContactStatus.loading,
        contacts: [],
        hasReachedMax: false
      );
      
      yield await _mapPostFetchedToState(state, status);
    }
  }
  
  var _pagintaion = Pagination();

  Future<ContactState> _mapPostFetchedToState(
    ContactState state, ContactStatus status
  ) async {
    if (state.hasReachedMax) return state.copyWith(status: ContactStatus.success);
    try {
      if (status == ContactStatus.initial) {
        ContactResponse response = await _fetchContacts(_pagintaion);
        _pagintaion.next();
        
        return state.copyWith(
          status: ContactStatus.success,
          contacts: response.contacts.data,
          hasReachedMax: _hasReachedMax(response.contacts.data.length, response.contacts.total),
          maxTotal: response.contacts.total,
        );
      } else {
        ContactResponse response = await _fetchContacts(_pagintaion);
        
        if (response.contacts.data.isEmpty) {
          return state.copyWith(hasReachedMax: true);
        } else {
          _pagintaion.next();
          return state.copyWith(
            status: ContactStatus.success,
            contacts: List.of(state.contacts)..addAll(response.contacts.data),
            hasReachedMax: _hasReachedMax(response.contacts.data.length, state.maxTotal,)
          );
        }
      }
    } on Exception {
      return state.copyWith(status: ContactStatus.failure);
    }
  }

  bool _hasReachedMax(int contactsCount, int totalCount) => contactsCount < totalCount ? false : true;

  Future<ContactResponse> _fetchContacts(Pagination pagination) async {
    var failOrContacts =  await fetchContacts(pagination);
    return failOrContacts.fold((l) => throw Exception, (r) {
      return r;
    });
  }
}