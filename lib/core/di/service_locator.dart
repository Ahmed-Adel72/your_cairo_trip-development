// lib/core/di/service_locator.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:your_cairo_trip/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:your_cairo_trip/features/profile/data/repository/profile_repository.dart';
import 'package:your_cairo_trip/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:your_cairo_trip/features/settings/data/data_sources/support_remote_data_source.dart';
import 'package:your_cairo_trip/features/settings/data/repositories/support_repository.dart';
import 'package:your_cairo_trip/features/settings/presentation/cubit/support_cubit.dart';
import '../network/dio_client.dart';

// ── Auth ──
import '../../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/signup_cubit.dart';

// ── Places ──
import '../../features/places/data/data_sources/places_remote_data_source.dart';
import '../../features/places/data/repositories/places_repository.dart';
import '../../features/places/presentation/cubit/places_cubit.dart';

// ── Booking ──
import '../../features/booking/data/data_sources/booking_remote_data_source.dart';
import '../../features/booking/data/repositories/booking_repository.dart';
import '../../features/booking/presentation/cubit/booking_cubit.dart';

// ── Explore ──
import '../../features/explore/data/data_sources/explore_remote_data_source.dart';
import '../../features/explore/data/repositories/explore_repository.dart';
import '../../features/explore/presentation/cubit/explore_cubit.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // ── Core ──
  sl.registerLazySingleton<Dio>(() => DioClient.getInstance());

  // ── Auth ──
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl()));
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
  sl.registerFactory<SignUpCubit>(() => SignUpCubit(sl()));

  // ── Places ──
  sl.registerLazySingleton<PlacesRemoteDataSource>(
    () => PlacesRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<PlacesRepository>(() => PlacesRepository(sl()));
  sl.registerFactory<PlacesCubit>(() => PlacesCubit(sl()));

  // ── Booking ──
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<BookingRepository>(() => BookingRepository(sl()));
  sl.registerFactory<BookingCubit>(() => BookingCubit(sl()));

  // ── Explore ──
  sl.registerLazySingleton<ExploreRemoteDataSource>(
    () => ExploreRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<ExploreRepository>(() => ExploreRepository(sl()));
  sl.registerFactory<ExploreCubit>(() => ExploreCubit(sl()));

  // ── Profile ──
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepository(sl()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl()));

  // ── Settings / Support ──
  sl.registerLazySingleton<SupportRemoteDataSource>(
    () => SupportRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<SupportRepository>(() => SupportRepository(sl()));
  sl.registerFactory<SupportCubit>(() => SupportCubit(sl()));
}
