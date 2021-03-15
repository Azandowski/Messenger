part of 'search_contact_cubit.dart';

abstract class SearchContactState extends Equatable {
  const SearchContactState({
    @required this.contacts
  });

  final PaginatedResult<ContactEntity> contacts;

  @override
  List<Object> get props => [
    contacts
  ];
}

class SearchContactsLoaded extends SearchContactState {
  final PaginatedResult<ContactEntity> contacts;

  SearchContactsLoaded({
    @required this.contacts
  });

  @override
  List<Object> get props => [
    contacts
  ];
}

class SearchContactsLoading extends SearchContactState {
  final PaginatedResult<ContactEntity> contacts; 
  final bool isPagination;

  SearchContactsLoading({
    @required this.contacts,
    @required this.isPagination
  }) : super(contacts: contacts);

  @override
  List<Object> get props => [
    contacts, 
    isPagination
  ];
}

class SearchContactsError extends SearchContactState {
  final String message;
  final PaginatedResult<ContactEntity> contacts; 

  SearchContactsError({
    @required this.message,
    @required this.contacts
  });

  @override
  List<Object> get props => [
    message,
    contacts
  ];
}
