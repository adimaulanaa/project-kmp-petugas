import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';

import 'package:kmp_petugas_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';

class PersistTokenUseCase implements UseCase<bool, TokenParams> {
  PersistTokenUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(TokenParams params) =>
      repository.persistToken(params.userData);
}

class TokenParams extends Equatable {
  TokenParams({
    required this.userData,
  });

  final UserModel userData;

  @override
  List<Object> get props => [userData];
}
