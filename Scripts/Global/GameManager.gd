extends Node

signal game_start

enum GAMEMODE {MENU, BATTLE}

func start_game(): game_start.emit()
