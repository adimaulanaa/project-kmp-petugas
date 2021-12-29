import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}
class LoadGuestBook extends DashboardEvent {}
class LoadDashboard extends DashboardEvent {}

class LoadWorkOrder extends DashboardEvent {
  const LoadWorkOrder({
    required this.data,
  });

  final String data;

  @override
  List<Object> get props => [data];
}

class LoadJobCard extends DashboardEvent {
  const LoadJobCard({
    required this.data,
  });

  final String data;

  @override
  List<Object> get props => [data];
}

