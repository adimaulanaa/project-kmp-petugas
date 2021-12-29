import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kmp_petugas_app/features/authentication/data/models/user_model.dart';
import 'package:kmp_petugas_app/features/profile/data/models/post_password.dart';
import 'package:kmp_petugas_app/features/profile/domain/entities/post_profile.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_petugas_app/framework/managers/http_manager.dart';
import 'package:mime/mime.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfiles();
  Future<bool> editProfile(PostProfile data);
  Future<UserModel> getSession();
  Future<bool> changePassword(PostPassword data);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  @override
  Future<UserModel> getUserProfiles() =>
      _getUserProfilesFromUrl('/users/session');

  Future<UserModel> _getUserProfilesFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.get(
      url: url,
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );

    if (response != null && response.statusCode == 201) {
      return UserModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> editProfile(PostProfile data) =>
      _editProfileFromUrl('/users/me', data);

  Future<bool> _editProfileFromUrl(String url, PostProfile data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.put(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "id_card": data.idCard,
      "name": data.name,
      "gender": data.gender,
      "sub_district": data.subDistrict,
      "street": data.street,
      "rt": data.rt,
      "rw": data.rw,
      "email": data.email,
      "phone": data.phone,
    });

    if (response != null && response.statusCode == 201) {
      if (data.path!.isNotEmpty) {
        return _postImageProfileFromUrl('/files/upload_me', data);
      } else {
        return true;
      }
    } else {
      throw ServerException();
    }
  }

  Future<bool> _postImageProfileFromUrl(String url, PostProfile data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final mimeTypes = lookupMimeType(data.path!)!.split('/');
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(data.path!,
          contentType: MediaType(mimeTypes[0], mimeTypes[1])),
      "type": "avatar",
      "is_compress": true,
    });

    final response = await httpManager.post(
      url: url,
      formData: formData,
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
      isUploadImage: true,
    );

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getSession() =>
      _getUserSessionFromUrl('/home?with_region=true');

  Future<UserModel> _getUserSessionFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.get(
      url: url,
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );

    if (response != null && response.statusCode == 201) {
      return UserModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> changePassword(PostPassword data) =>
      _changePasswordFromUrl('/users/me/change_password', data);

  Future<bool> _changePasswordFromUrl(String url, PostPassword data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.put(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "old_password": data.oldPassword,
      "new_password": data.newPassword,
      "confirm_password": data.confirmPassword
    });

    if (response != null && response.statusCode == 201) {
      return true;
    } else {
      throw ServerException();
    }
  }
}
