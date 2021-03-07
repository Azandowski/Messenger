part of 'contact_bloc.dart';

enum ContactStatus { initial, success, failure }

class ContactState extends Equatable {
  const ContactState({
    this.status = ContactStatus.initial,
    this.contacts = const <ContactEntity>[],
    this.hasReachedMax = false,
    this.maxTotal,
  });

  final ContactStatus status;
  final List<ContactEntity> contacts;
  final bool hasReachedMax;
  final int maxTotal;

  ContactState copyWith({
    ContactStatus status,
    List<ContactEntity> contacts,
    bool hasReachedMax,
    int maxTotal,
  }) {
    return ContactState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      maxTotal: maxTotal ?? this.maxTotal,
    );
  }

  @override
  List<Object> get props => [status, contacts, hasReachedMax, maxTotal];
}