import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/core/constant.dart';
import 'package:snake_game/screens/dialog_box.dart';

part 'snake_home_state.dart';

class SnakeHomeCubit extends Cubit<SnakeHomeState> {
  SnakeHomeCubit() : super(SnakeHomeInitial());

  int noOfGrid = 500;
  int gridSize = 20;
  List<int> snake = [284, 285, 286, 287];
  late SnakeDirection snakeDirection;
  int foodPosition = 0;
  Random randomPosition = Random();
  int playerScore = 0;
  bool isStarted = false;

  setRandomPosition() {
    do {
      foodPosition = randomPosition.nextInt(noOfGrid);
    } while (snake.contains(foodPosition));
  }

  initGame() {
    playerScore = 0;
    snakeDirection = SnakeDirection.right;
    isStarted = true;
    setRandomPosition();
  }

  startGame(context) {
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      updateSnakePosition(context);
      if (isStarted) timer.cancel();
    });
    emit(UpdateSnakeMovement());
  }

  updateSnakePosition(context) {
    if (!isStarted) {
      switch (snakeDirection) {
        case SnakeDirection.down:
          if (snake.last > noOfGrid) {
            snake.add(snake.last + gridSize - (noOfGrid + gridSize));
          } else {
            snake.add(snake.last + gridSize);
          }
        case SnakeDirection.up:
          if (snake.last < gridSize) {
            snake.add(snake.last - gridSize + (noOfGrid + gridSize));
          } else {
            snake.add(snake.last - gridSize);
          }
        case SnakeDirection.right:
          if ((snake.last + 1) % gridSize == 0) {
            snake.add(snake.last + 1 - gridSize);
          } else {
            snake.add(snake.last + 1);
          }
        case SnakeDirection.left:
          if (snake.last % gridSize == 0) {
            snake.add(snake.last - 1 + gridSize);
          } else {
            snake.add(snake.last - 1);
          }
      }
      if (snake.last != foodPosition) {
        snake.removeAt(0);
      } else {
        playerScore += 1;
        setRandomPosition();
      }
      if (gameOver()) {
        isStarted = !isStarted;
        showGameDialog(context, playerScore, () {
          resetGame();
          Navigator.pop(context);
          emit(UpdateSnakeMovement());
        });
      }
    }
    emit(UpdateSnakeMovement());
  }

  resetGame() {
    playerScore = 0;
    snake = [284, 285, 286, 287];
    setRandomPosition();
    snakeDirection = SnakeDirection.right;
    isStarted = true;
  }

  bool gameOver() {
    for (int i = 0; i < snake.length - 1; i++) {
      if (snake[i] == snake.last) return true;
    }
    return false;
  }
}
