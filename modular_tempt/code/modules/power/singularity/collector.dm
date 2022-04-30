/obj/machinery/power/rad_collector/interact(mob/user)
	if(!anchored)
		return
	if(locked)
		to_chat(user, span_warning("The controls are locked!"))
		return

	toggle_power()
	user.visible_message("[user.name] turns the [src.name] [active? "on":"off"].", \
	"<span class='notice'>You turn the [src.name] [active? "on":"off"].</span>")
	if(loaded_tank)
		var/fuel = loaded_tank.air_contents.get_moles(GAS_PLASMA)
		investigate_log("turned [active?"<font color='green'>on</font>":"<font color='red'>off</font>"] by [key_name(user)]. [loaded_tank?"Fuel: [round(fuel/0.29)]%":"<font color='red'>It is empty</font>"].", INVESTIGATE_SINGULO)
