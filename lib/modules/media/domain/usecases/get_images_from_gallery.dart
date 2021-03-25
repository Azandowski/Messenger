import 'package:dartz/dartz.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/media_repository.dart';

class GetImagesFromGallery implements UseCase<List<Asset>, NoParams> {
  final MediaRepository repository;

  GetImagesFromGallery(this.repository);

  @override
  Future<Either<Failure, List<Asset>>> call(NoParams params) async {
    return await repository.getImagesFromGallery();
  }
}
