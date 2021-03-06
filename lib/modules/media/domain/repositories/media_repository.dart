import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failures.dart';

abstract class MediaRepository {
  Future<Either<Failure, File>> getImage(ImageSource source);
}
