import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
