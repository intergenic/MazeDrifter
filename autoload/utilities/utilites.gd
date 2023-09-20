extends Node


func seconds2mmss(total_seconds: float) -> String:
	#total_seconds = 12345
	var seconds:float = fmod(total_seconds , 60.0)
	var minutes:int   =  int(total_seconds / 60.0) % 60
	#var hours:  int   =  int(total_seconds / 3600.0)
	var mmss_string:String = "%02d:%05.2f" % [minutes, seconds]
	return mmss_string
