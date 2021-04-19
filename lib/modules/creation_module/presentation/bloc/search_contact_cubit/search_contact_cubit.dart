import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/services/network/paginatedResult.dart';
import '../../../../chat/presentation/chats_screen/pages/chat_screen_import.dart';
import '../../../domain/entities/contact.dart';
import '../../../domain/usecases/params.dart';
import '../../../domain/usecases/search_contacts.dart';

part 'search_contact_state.dart';

class SearchContactCubit extends Cubit<SearchContactState> {
  final SearchContacts searchContacts;

  SearchContactCubit({
    @required this.searchContacts
  }) : super(SearchContactsLoading(
    contacts: PaginatedResult(
      paginationData: PaginationData(
        nextPageUrl: null 
      ),
      data: []
    ), 
    isPagination: false
  ));


  Future<void> search ({
    @required String phoneNumber,
    @required bool isPagination,
  }) async {
    showLoading(isPagination: isPagination);
    
    var response = await searchContacts(SearchContactParams(
      nextPageURL: isPagination && state.contacts.paginationData?.nextPageUrl != null ? 
        state.contacts.paginationData.nextPageUrl : null, 
      phoneNumber: phoneNumber
    ));
    
    response.fold((failure) => emit(
      SearchContactsError(
        message: failure.message,
        contacts: state.contacts
      )
    ), (result) => emit(
      SearchContactsLoaded(
        contacts: isPagination ? PaginatedResult(
          paginationData: result.paginationData,
          data: state.contacts.data + result.data
        ) : result
      )
    ));
  }


  initInitialContacts (List<ContactEntity> contacts) {
    emit(SearchContactsLoaded(
      contacts: PaginatedResult(
        paginationData: PaginationData(
          nextPageUrl: null
        ),
        data: contacts
      )
    ));
  }

  void showLoading ({
    bool isPagination
  }) {
    emit(SearchContactsLoading(
      contacts: isPagination ? this.state.contacts : PaginatedResult(
        data: [],
        paginationData: PaginationData(
          nextPageUrl: null 
        ),
      ),
      isPagination: isPagination
    ));
  }
}
