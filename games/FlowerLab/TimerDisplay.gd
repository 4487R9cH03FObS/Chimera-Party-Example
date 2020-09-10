extends RichTextLabel

var timepassed=0
var freezed=false 

func _process(delta):
	if(freezed):
		return
	timepassed += delta
	bbcode_text="t = \n"+str(timepassed).left(5)

func _on_freeze():
	freezed=true
