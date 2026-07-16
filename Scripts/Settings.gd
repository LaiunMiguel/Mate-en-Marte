extends Node

var drag_line_enabled := false
var show_tutorial := true
var arg_mode := false

enum Difficulty {
	EASY,
	NORMAL,
	HARD,
	VERYHARD
}

var difficulty := Difficulty.NORMAL
