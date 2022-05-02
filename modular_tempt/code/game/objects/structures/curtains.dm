/obj/structure/curtain
	icon = 'modular_tempt/icons/obj/structures/bathroom.dmi'

/obj/structure/curtain/goliath
	icon = 'modular_tempt/icons/obj/structures/bathroom.dmi'

/obj/structure/curtain/update_icon_state()
	if(!open)
		icon_state = "[initial(icon_state)]_closed"
		layer = WALL_OBJ_LAYER
		density = TRUE
		open = FALSE
		opacity = TRUE

	else
		icon_state = initial(icon_state)
		layer = SIGN_LAYER
		density = FALSE
		open = TRUE
		opacity = FALSE
