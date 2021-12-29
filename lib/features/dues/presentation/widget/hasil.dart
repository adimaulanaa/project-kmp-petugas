import 'package:equatable/equatable.dart';
import 'package:kmp_petugas_app/features/dues/entities/data.dart';

// ignore: must_be_immutable
class Hasil extends Equatable {
  String bulan;
  String tahun;
  double total;
  List<GetDataHouse> dues;

  Hasil({
    required this.bulan,
    required this.tahun,
    required this.total,
    required this.dues,
  });

  @override
  List<Object> get props => [bulan, tahun, total, dues];
}
