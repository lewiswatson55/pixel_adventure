import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late final CameraComponent cam;
  late JoystickComponent joystick;
  bool showJoystick = false;

  // Default character set here
  Player player = Player(character: "Mask Dude");

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    final world = Level(player: player, levelName: "level-01");

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.priority = 0;
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);

    if (showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick(dt);
    }
    super.update(dt);
  }

// Joystick graphics can be created programatically which could be cool for customisation or game dependent colours!
  void addJoystick() {
    joystick = JoystickComponent(
        priority: 1,
        knobRadius: 40,
        knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/Knob.png'))),
        background: SpriteComponent(
            sprite: Sprite(images.fromCache('HUD/Joystick.png'))),
        margin: const EdgeInsets.only(bottom: 32, left: 32));

    add(joystick);
  }

  void updateJoystick(double dt) {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        //player.playerDirection = PlayerDirection.left;
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        //player.playerDirection = PlayerDirection.right;
        player.horizontalMovement = 1;
        break;
      default:
        //player.playerDirection = PlayerDirection.none;
        player.horizontalMovement = 0;
        break;
    }
  }
}
