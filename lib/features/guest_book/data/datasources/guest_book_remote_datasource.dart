import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:kmp_petugas_app/features/dues/data/models/house_model.dart';
import 'package:kmp_petugas_app/features/guest_book/data/models/guest_book_model.dart';
import 'package:kmp_petugas_app/features/guest_book/domain/entities/post_guest_book.dart';
import 'package:kmp_petugas_app/framework/core/exceptions/app_exceptions.dart';
import 'package:kmp_petugas_app/framework/managers/hive_db_helper.dart';
import 'package:kmp_petugas_app/framework/managers/http_manager.dart';

abstract class GustBookRemoteDataSource {
  Future<GuestBookModel> getGuestBook();
  Future<bool> postGuestBook(PostGuestBook data);
  Future<HousesModel> getHouse();
  // Future<bool> editGustBook(PostGuestBook data);
}

class GustBookRemoteDataSourceImpl implements GustBookRemoteDataSource {
  GustBookRemoteDataSourceImpl({
    required this.httpManager,
    required this.dbServices,
  });

  final HttpManager httpManager;
  final HiveDbServices dbServices;

  // @override
  // Future<GuestBookModel> getGuestBook() =>
  //     _getDasboardFromUrl('/visitors/today');

  // Future<GuestBookModel> _getDasboardFromUrl(String url) async {
  //   var token = await dbServices.getData(HiveDbServices.boxToken);

  //   final response = await httpManager.post(url: url, headers: {
  //     HttpHeaders.authorizationHeader: 'bearer $token',
  //   }, body: {
  //     "date": DateTime.now().toString()
  //   });

  //   if (response != null && response.statusCode == 201) {
  //     return GuestBookModel.fromJson(response.data);
  //   } else {
  //     throw ServerException();
  //   }
  // }

  @override
  Future<GuestBookModel> getGuestBook() =>
      _getDasboardFromUrl('/visitors/pagination');

  Future<GuestBookModel> _getDasboardFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "limit": -1,
      "page": 0,
      "sort": "-accepted_at"
    });

    if (response != null && response.statusCode == 201) {
      return GuestBookModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<HousesModel> getHouse() => _getHousesFromUrl('/houses/pagination');

  Future<HousesModel> _getHousesFromUrl(String url) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);
// !Ubah Link Sesuaikan dengan House
    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "limit": -1,
      "page": 0,
      "sort": "house_block"
    });

    if (response != null && response.statusCode == 201) {
      return HousesModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> postGuestBook(PostGuestBook data) =>
      _postGuestBookFromUrl('/visitors', data);

  Future<bool> _postGuestBookFromUrl(String url, PostGuestBook data) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final response = await httpManager.post(url: url, headers: {
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      "name": data.name,
      "phone": data.phone,
      "necessity": data.necessity,
      "guest_count": data.guestCount,
      "destination_person_name": data.destinationPersonName,
      "house": data.house
    });

    if (response != null && response.statusCode == 201) {
      var id = response.data['_id'];
      if (data.path!.isNotEmpty) {
        //ini konfir isi foto harus apa tidak
        await _postImageGuestBookFromUrl('/files/upload', data, id);
      } else {
        return true;
      }
      if (data.pathself!.isNotEmpty) {
        //ini konfir isi foto harus apa tidak
        await _postImageSelfGuestBookFromUrl('/files/upload', data, id);
      } else {
        return true;
      }
      return true;
    } else {
      throw ServerException();
    }
  }

  Future<bool> _postImageGuestBookFromUrl(
      String url, PostGuestBook data, String id) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final mimeTypes = lookupMimeType(data.path!)!.split('/');
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(data.path!,
          contentType: MediaType(mimeTypes[0], mimeTypes[1])),
      "type": "visitor",
      "is_compress": true,
      "id": id,
      "index": 1
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
      print("-------------------------FOTO KTP");
      return true;
    } else {
      throw ServerException();
    }
  }

  Future<bool> _postImageSelfGuestBookFromUrl(
      String url, PostGuestBook data, String id) async {
    var token = await dbServices.getData(HiveDbServices.boxToken);

    final mimeTypes = lookupMimeType(data.pathself!)!.split('/');
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(data.pathself!,
          contentType: MediaType(mimeTypes[0], mimeTypes[1])),
      "type": "visitor",
      "is_compress": true,
      "id": id,
      "index": 2
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
      print("-------------------------FOTO SELFI");
      return true;
    } else {
      throw ServerException();
    }
  }
}
