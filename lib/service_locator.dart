import 'package:kmp_petugas_app/features/authentication/data/datasources/index.dart';
import 'package:kmp_petugas_app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:kmp_petugas_app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:kmp_petugas_app/features/authentication/domain/usecases/get_all_to_cache_token_usecase.dart';
import 'package:kmp_petugas_app/features/authentication/domain/usecases/index.dart';
import 'package:kmp_petugas_app/features/authentication/presentation/bloc/bloc.dart';
import 'package:kmp_petugas_app/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:kmp_petugas_app/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:kmp_petugas_app/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:kmp_petugas_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:kmp_petugas_app/features/dashboard/domain/usecases/dashboard_usecase.dart';
import 'package:kmp_petugas_app/features/dues/data/datasources/dues_local_datasource.dart';
import 'package:kmp_petugas_app/features/dues/data/datasources/dues_remote_datasource.dart';
import 'package:kmp_petugas_app/features/dues/data/repositories/dues_repository_impl.dart';
import 'package:kmp_petugas_app/features/dues/domain/repositories/dues_repository.dart';
import 'package:kmp_petugas_app/features/dues/domain/usecases/dues_usecase.dart';
import 'package:kmp_petugas_app/features/financial/data/datasources/financial_statement_local_datasource.dart';
import 'package:kmp_petugas_app/features/financial/domain/repositories/financial_statement_repository.dart';
import 'package:kmp_petugas_app/features/financial/domain/usecases/financial_statement_usecase.dart';
import 'package:kmp_petugas_app/features/guest_book/data/datasources/guest_book_local_datasource.dart';
import 'package:kmp_petugas_app/features/guest_book/data/datasources/guest_book_remote_datasource.dart';
import 'package:kmp_petugas_app/features/guest_book/data/repositories/guest_book_repository_impl.dart';
import 'package:kmp_petugas_app/features/guest_book/domain/repositories/guest_book_repository.dart';
import 'package:kmp_petugas_app/features/guest_book/domain/usecases/guest_book_usecase.dart';
import 'package:kmp_petugas_app/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:kmp_petugas_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:kmp_petugas_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:kmp_petugas_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:kmp_petugas_app/features/profile/domain/usecases/profile_usecase.dart';
import 'package:kmp_petugas_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:kmp_petugas_app/features/report/data/datasources/report_local_datasource.dart';
import 'package:kmp_petugas_app/features/report/data/datasources/report_remote_datasource.dart';
import 'package:kmp_petugas_app/features/report/data/repositories/report_repository_impl.dart';
import 'package:kmp_petugas_app/features/report/domain/repositories/report_repository.dart';
import 'package:kmp_petugas_app/features/report/domain/usecases/report_usecase.dart';
import 'package:kmp_petugas_app/framework/blocs/messaging/index.dart';
//
import 'package:kmp_petugas_app/framework/core/network/network_info.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_petugas_app/framework/managers/http_manager.dart';
//
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:get_it/get_it.dart';

import 'features/dashboard/presentation/bloc/bloc.dart';
import 'features/dues/presentation/bloc/dues_bloc.dart';
import 'features/financial/data/datasources/financial_statement_remote_datasource.dart';
import 'features/financial/data/repositories/cash_book_repository_impl.dart';
import 'features/financial/presentation/bloc/financial_statement_bloc.dart';
import 'features/guest_book/presentation/bloc/guest_book_bloc.dart';
import 'features/login/presentation/bloc/bloc.dart';
import 'features/report/presentation/bloc/bloc.dart';
//

GetIt serviceLocator = GetIt.instance;

Future<void> initDependencyInjection() async {
  // ************************************************ //
  //! Features - Authentication
  // Bloc
  // Authentication Bloc
  serviceLocator.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(
        checkSignIn: serviceLocator(),
        getAllToCache: serviceLocator(),
        signOut: serviceLocator(),
        prefs: serviceLocator(),
        dbServices: serviceLocator(),
        persistToken: serviceLocator(),
      ));
  // Login Bloc
  serviceLocator.registerFactory<LoginBloc>(() => LoginBloc(
        prefs: serviceLocator(),
        signIn: serviceLocator(),
        dbServices: serviceLocator(),
      ));
  // Messaging Bloc
  serviceLocator.registerFactory<MessagingBloc>(() => MessagingBloc());

  // Use Cases
  serviceLocator
      .registerLazySingleton(() => CheckSigninUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PersistTokenUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetAllToCacheUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SigninUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignOutUseCase(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
        networkInfo: serviceLocator(),
      ));

  // Data Sources
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbService: serviceLocator(),
          ));
  serviceLocator
      .registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbService: serviceLocator(),
          ));

  // ************************************************ //
  //! Features - Dashboard
  // Bloc
  // Dashboard Bloc
  serviceLocator.registerFactory<DashboardBloc>(() => DashboardBloc(
        dashboard: serviceLocator(),
        dashboardFromCache: serviceLocator(),
        dbServices: serviceLocator(),
        guestBook: serviceLocator(),
      ));

  // Use Cases
  serviceLocator
      .registerLazySingleton(() => DashboardUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GuestBookUseCases(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DashboardFromCacheUseCase(serviceLocator()));

  // Repository
  serviceLocator
      .registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(
            remoteDataSource: serviceLocator(),
            localDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
          ));

  // Data Sources
  serviceLocator.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<DashboardLocalDataSource>(
      () => DashboardLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  // ************************************************ //

  //! Features - Dues
  // Bloc
  // Dues Bloc
  serviceLocator.registerFactory<DuesBloc>(() => DuesBloc(
      duesFromCache: serviceLocator(),
      getDataHouses: serviceLocator(),
      getListHouse: serviceLocator(),
      houseList: serviceLocator(),
      addDues: serviceLocator()));

  // Use Cases
  serviceLocator.registerLazySingleton(() => DuesUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => PostDuesUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => DuesFromCacheUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetMonthYearUsecase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => LoadHouseListUsecase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => ListHousesUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => ListHousesFromCacheUseCase(serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<DuesRepository>(() => DuesRepositoryImpl(
        remoteDataSource: serviceLocator(),
        localDataSource: serviceLocator(),
        networkInfo: serviceLocator(),
      ));

  // Data Sources
  serviceLocator.registerLazySingleton<DuesRemoteDataSource>(
      () => DuesRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator
      .registerLazySingleton<DuesLocalDataSource>(() => DuesLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //
  //! Features - GustBook
  // Bloc
  // Subscriptions Bloc
  serviceLocator.registerFactory<GuestBookBloc>(() => GuestBookBloc(
        dbServices: serviceLocator(),
        guestBook: serviceLocator(),
        // guestBookFromCache: serviceLocator(),
        addGuestBook: serviceLocator(),
        houses: serviceLocator(),
      ));

  // Use Cases
  serviceLocator
      .registerLazySingleton(() => GuestBookUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => HousesUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PostGuestBookUseCase(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => GuestBookFromCacheUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => HousesFromCacheUseCase(serviceLocator()));

  // Repository
  serviceLocator
      .registerLazySingleton<GuestBookRepository>(() => GuestBookRepositoryImpl(
            remoteDataSource: serviceLocator(),
            localDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
          ));

  // Data Sources
  serviceLocator.registerLazySingleton<GustBookRemoteDataSource>(
      () => GustBookRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<GustBookLocalDataSource>(
      () => GustBookLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //
  // **************** //

  //! Features - Financial Statement
  // Bloc
  serviceLocator
      .registerFactory<FinancialStatementBloc>(() => FinancialStatementBloc(
            cashBookFinancial: serviceLocator(),
            cashBookFinancialFromCache: serviceLocator(),
            pdfReport: serviceLocator(),
            session: serviceLocator(),
          ));

  // Use Cases
  serviceLocator
      .registerLazySingleton(() => FinancialStatementUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SessionUseCases(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => FinancialStatementFromCacheUseCase(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => PdfReportUseCase(serviceLocator()));
  // Repository
  serviceLocator.registerLazySingleton<FinancialStatementRepository>(() =>
      FinancialStatementRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          networkInfo: serviceLocator()));

  // Data Sources
  serviceLocator.registerLazySingleton<FinancialStatementRemoteDataSource>(
      () => FinancialStatementRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<FinancialStatementLocalDataSource>(
      () => FinancialStatementLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //
   //! Features - Report
  // Bloc
  serviceLocator
      .registerFactory<ReportBloc>(() => ReportBloc(
            cashBookFinancial: serviceLocator(),
            cashBookFinancialFromCache: serviceLocator(),
            pdfReport: serviceLocator(),
            session: serviceLocator(),
          ));

  // Use Cases
  serviceLocator
      .registerLazySingleton(() => ReportUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SessionUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => ReportFromCacheUseCase(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => PdfReportUseCases(serviceLocator()));
  // Repository
  serviceLocator.registerLazySingleton<ReportRepository>(() =>
      ReportRepositoryImpl(
          remoteDataSource: serviceLocator(),
          localDataSource: serviceLocator(),
          networkInfo: serviceLocator()));

  // Data Sources
  serviceLocator.registerLazySingleton<ReportRemoteDataSource>(
      () => ReportRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<ReportLocalDataSource>(
      () => ReportLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //
  //! Features - Profile
  //Profile
  serviceLocator.registerFactory(() => ProfileBloc(
        profile: serviceLocator(),
        editProfile: serviceLocator(),
        dbServices: serviceLocator(),
        changePassword: serviceLocator(),
      ));

  // Use Cases
  serviceLocator.registerLazySingleton(() => ProfileUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => ChangePasswordUseCase(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => EditProfileUseCase(serviceLocator()));

  // // Repository
  serviceLocator
      .registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(
            remoteDataSource: serviceLocator(),
            localDataSource: serviceLocator(),
            networkInfo: serviceLocator(),
          ));

  // // Data Sources
  serviceLocator.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(
            httpManager: serviceLocator(),
            dbServices: serviceLocator(),
          ));
  serviceLocator.registerLazySingleton<ProfileLocalDataSource>(
      () => ProfileLocalDataSourceImpl(
            sharedPreferences: serviceLocator(),
            dbServices: serviceLocator(),
          ));

  // ************************************************ //

  //! Core
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()));
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());

  //! Managers
  final sharedPreferences = await SharedPreferences.getInstance();
  //
  serviceLocator.registerSingleton<SharedPreferences>(sharedPreferences);
  serviceLocator.registerSingleton<HiveDbServices>(HiveDbServices());
  serviceLocator.registerLazySingleton<HttpManager>(() => AppHttpManager());
  //
}
