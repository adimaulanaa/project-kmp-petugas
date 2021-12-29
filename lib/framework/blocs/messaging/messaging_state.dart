import 'package:equatable/equatable.dart';

abstract class MessagingState extends Equatable {
  List<Object> get props => [];
}

/// UnInitialized
class MessagingUninitialized extends MessagingState {}

class MessagingInitialized extends MessagingState {
  MessagingInitialized({
    this.isInternetConnected = false,
    this.lastMessage = '',
  });

  final bool isInternetConnected;
  final String lastMessage;

  @override
  String toString() => 'MessagingInitialized $isInternetConnected $lastMessage';
}

/// Initialized
class InMessagingState extends MessagingState {
  InMessagingState({this.message = '', this.isConnected = false});

  final String message;
  final bool isConnected;

  @override
  String toString() => 'InMessagingState $message $isConnected';
}

class InternetConnectionState extends MessagingState {
  InternetConnectionState(this.isConnected);

  final bool isConnected;

  @override
  String toString() => 'InternetConnectionState $isConnected';
}

class ErrorMessagingState extends MessagingState {
  final String errorMessage;

  ErrorMessagingState(this.errorMessage);

  @override
  String toString() => 'ErrorMessagingState';
}
