part of 'snake_home_cubit.dart';

@immutable
sealed class SnakeHomeState {}

final class SnakeHomeInitial extends SnakeHomeState {}

final class UpdateSnakeMovement extends SnakeHomeState {}

