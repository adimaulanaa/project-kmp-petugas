import 'package:dartz/dartz.dart';
import 'package:kmp_petugas_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';

class GetAllToCacheUseCase implements UseCase<bool, NoParams> {
  GetAllToCacheUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      repository.getAllToCache();
}
