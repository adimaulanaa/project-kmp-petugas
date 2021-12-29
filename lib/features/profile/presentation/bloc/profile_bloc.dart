import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/dashboard_model.dart';
import 'package:kmp_petugas_app/features/dashboard/data/models/region_model.dart';
import 'package:kmp_petugas_app/features/profile/domain/usecases/profile_usecase.dart';
import 'package:kmp_petugas_app/features/profile/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/framework/core/usecases/usecase.dart';
import 'package:kmp_petugas_app/framework/managers/helper.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required ProfileUseCase profile,
    required HiveDbServices dbServices,
    required EditProfileUseCase editProfile,
    required ChangePasswordUseCase changePassword,
  })  : _profile = profile,
        _dbServices = dbServices,
        _editProfile = editProfile,
        _changePassword = changePassword,
        super(ProfileInitial());

  final ProfileUseCase _profile;
  final EditProfileUseCase _editProfile;
  final HiveDbServices _dbServices;
  final ChangePasswordUseCase _changePassword;

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is GetProfileEvent) {
      yield ProfileLoading();

      final failureOrSuccess = await _profile(NoParams());
      yield failureOrSuccess.fold(
        (failure) => ProfileFailure(error: mapFailureToMessage(failure)),
        (success) => ProfileLoaded(data: success),
      );
    }

    if (event is EditLoadProfile) {
      final data = await _dbServices.getData(HiveDbServices.boxDashboard);
      if (data == null) {
        yield ProfileFailure(error: 'Data Tidak Ditemukan');
      }
      final dashboard = dashboardModelFromJson(data.toString());
      final listVillage = dashboard.client!.villages;
      final dataRegion = await _dbServices.getData(HiveDbServices.boxRegions);

      final listRegion = regionsModelFromJson(dataRegion);

      yield EditProfileLoaded(listVillage: listVillage, listRegion: listRegion);
    }

    if (event is EditProfileEvent) {
      final failureOrSuccess = await _editProfile(event.profileEdit);
      yield failureOrSuccess.fold(
          (failure) => ProfileFailure(error: mapFailureToMessage(failure)),
          (loaded) => EditProfileSuccess(isSuccess: loaded));
    }
    if (event is ChangePasswordEvent) {
      final failureOrSuccess = await _changePassword(event.changePassword);
      yield failureOrSuccess.fold(
          (failure) => ProfileFailure(error: mapFailureToMessage(failure)),
          (loaded) => ChangePasswordSuccess(isSuccess: loaded));
    }
  }
}
