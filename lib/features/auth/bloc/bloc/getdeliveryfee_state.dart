part of 'getdeliveryfee_bloc.dart';

abstract class GetdeliveryfeeState extends Equatable {
  const GetdeliveryfeeState();

  @override
  List<Object> get props => <Object>[];
}

class GetdeliveryfeeInitial extends GetdeliveryfeeState {}

class GetdeliveryfeeLoading extends GetdeliveryfeeState {}

class GetdeliveryfeeLoaded extends GetdeliveryfeeState {
  const GetdeliveryfeeLoaded(this.fee);
  final int fee;
}

class GetdeliveryfeeError extends GetdeliveryfeeState {
  const GetdeliveryfeeError(this.message);

  final String message;
}
