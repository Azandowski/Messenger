part of 'typename_cubit.dart';

abstract class TypeNameState extends Equatable {
  const TypeNameState();

  @override
  List<Object> get props => [];
}

class TypenameInitial extends TypeNameState {}

class FileSelected extends TypeNameState {
  final File imageFile;

  FileSelected({this.imageFile});
}

class ErrorSelecting extends TypeNameState {}

class UpdatingUser extends TypeNameState {}

class ErrorUploading extends TypeNameState {}