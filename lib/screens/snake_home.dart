import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snake_game/core/constant.dart';
import 'package:snake_game/cubit/snake_home_cubit.dart';

class SnakeHome extends StatefulWidget {
  const SnakeHome({super.key});

  @override
  State<SnakeHome> createState() => _SnakeHomeState();
}

class _SnakeHomeState extends State<SnakeHome>
    with SingleTickerProviderStateMixin {
  late SnakeHomeCubit snakeHomeCubit;
  late AnimationController animationController;
  late Animation snakeAnimation;
  @override
  void initState() {
    snakeHomeCubit = BlocProvider.of<SnakeHomeCubit>(context);
    snakeHomeCubit.initGame();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    snakeAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 45, 14, 51),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<SnakeHomeCubit, SnakeHomeState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Snake Game',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Score: ${snakeHomeCubit.playerScore}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: GestureDetector(
                          onHorizontalDragUpdate: (drag) {
                            if (drag.delta.dx > 0 &&
                                snakeHomeCubit.snakeDirection !=
                                    SnakeDirection.left) {
                              snakeHomeCubit.snakeDirection =
                                  SnakeDirection.right;
                            } else if (drag.delta.dx < 0 &&
                                snakeHomeCubit.snakeDirection !=
                                    SnakeDirection.right) {
                              snakeHomeCubit.snakeDirection =
                                  SnakeDirection.left;
                            }
                          },
                          onVerticalDragUpdate: (drag) {
                            if (drag.delta.dy > 0 &&
                                snakeHomeCubit.snakeDirection !=
                                    SnakeDirection.up) {
                              snakeHomeCubit.snakeDirection =
                                  SnakeDirection.down;
                            } else if (drag.delta.dy < 0 &&
                                snakeHomeCubit.snakeDirection !=
                                    SnakeDirection.down) {
                              snakeHomeCubit.snakeDirection = SnakeDirection.up;
                            }
                          },
                          child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snakeHomeCubit.noOfGrid +
                                  snakeHomeCubit.gridSize,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: snakeHomeCubit.gridSize),
                              itemBuilder: (context, index) {
                                return Center(
                                    child: Container(
                                  padding: const EdgeInsets.all(1.5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Container(
                                        color:
                                            snakeHomeCubit.snake.contains(index)
                                                ? Colors.white
                                                : snakeHomeCubit.foodPosition ==
                                                        index
                                                    ? Colors.greenAccent
                                                    : const Color.fromARGB(
                                                        255, 78, 0, 92)),
                                  ),
                                ));
                              }),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (snakeHomeCubit.isStarted) {
                              animationController.forward();
                            } else {
                              animationController.reverse();
                            }
                            snakeHomeCubit.isStarted =
                                !snakeHomeCubit.isStarted;
                            snakeHomeCubit.startGame(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 61, 18, 68)),
                          child: Text(
                            snakeHomeCubit.isStarted ? 'Start' : 'Pause',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            snakeHomeCubit.resetGame();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 61, 18, 68)),
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
