
part of 'contact_bloc.dart';

abstract class ContactEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ContactFetched extends ContactEvent {}