import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../../../core/error/failures.dart';

abstract class MediaRepository {
  Future<Either<Failure, File>> getImage(ImageSource source);
  Future<Either<Failure, List<Asset>>> getImagesFromGallery();
  Future<Either<Failure, List<File>>> getAudio();

}
