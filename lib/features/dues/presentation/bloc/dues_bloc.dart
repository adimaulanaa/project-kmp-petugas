import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kmp_petugas_app/features/dues/domain/usecases/dues_usecase.dart';
import 'package:kmp_petugas_app/features/dues/entities/data.dart';
import 'package:kmp_petugas_app/features/dues/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';

class DuesBloc extends Bloc<DuesEvent, DuesState> {
  DuesBloc(
      {
      // required DuesUseCase dues,
      required DuesFromCacheUseCase duesFromCache,
      required LoadHouseListUsecase getListHouse,
      required ListHousesFromCacheUseCase houseList,
      // required HiveDbServices dbServices,
      required PostDuesUseCase addDues,
      required GetMonthYearUsecase getDataHouses})
      : _duesFromCache = duesFromCache,
        // _dues = dues,

        // _dbServices = dbServices,
        _getMonthYear = getDataHouses,
        _houseList = houseList,
        _getListHouse = getListHouse,
        _addDues = addDues,
        super(DuesInitial());

  // final DuesUseCase _dues;
  final PostDuesUseCase _addDues;
  final GetMonthYearUsecase _getMonthYear;
  final DuesFromCacheUseCase _duesFromCache;
  final ListHousesFromCacheUseCase _houseList;
  final LoadHouseListUsecase _getListHouse;
  // final HiveDbServices _dbServices;

  @override
  Stream<DuesState> mapEventToState(
    DuesEvent event,
  ) async* {
    if (event is LoadHouseEvent) {
      yield HouseListLoading();

      final failureOrSuccess = await _getListHouse(NoParams());
      yield failureOrSuccess.fold(
        (failure) => DuesFailure(error: mapFailureToMessage(failure)),
        (success) => HouseListLoaded(houseData: success),
      );
    }

    if (event is GetMonthYearEvent) {
      final failureOrSuccess = await _getMonthYear(
          GetDataHouse(idHouse: event.idHouse!, year: event.year!));
      yield failureOrSuccess.fold(
          (failure) => DuesFailure(error: mapFailureToMessage(failure)),
          (loaded) => MonthYearLoaded(data: loaded));
    }

    if (event is AddDuesEvent) {
      yield HouseListLoading();
      final failureOrSuccess = await _addDues(event.postDues);
      yield failureOrSuccess.fold(
          (failure) => DuesFailure(error: mapFailureToMessage(failure)),
          (loaded) => DuesSuccess(isSuccess: loaded));
    }
  }
}
