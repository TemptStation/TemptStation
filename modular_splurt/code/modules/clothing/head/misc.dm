// This icon fixes blue-ish tint on the helmet
/obj/item/clothing/head/assu_helmet
	icon = 'modular_splurt/icons/obj/clothing/head.dmi'
	mob_overlay_icon = 'modular_splurt/icons/mob/clothing/head.dmi'

/obj/item/clothing/head/bridgeofficer
	name = "bridge officer cap"
	desc = "A generic blue cap for the back ground officer"
	icon_state = "bridgeseccap"
	item_state = "bridgeseccap"
	icon = 'modular_splurt/icons/obj/clothing/head.dmi'
	mob_overlay_icon = 'modular_splurt/icons/mobs/head.dmi'
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)
	strip_delay = 25
	dynamic_hair_suffix = ""
	dog_fashion = null

/obj/item/clothing/head/bridgeofficer/beret
	name = "bridge officer beret"
	desc = "A generic blue beret for the back ground officer"
	icon_state = "beret_bridgesec"
	item_state = "beret_bridgesec"
	mob_overlay_icon = 'modular_splurt/icons/mob/clothing/head.dmi'

/obj/item/clothing/head/press_helmet
	name = "press helmet"
	icon_state = "press_helmet"
	item_state = "press_helmet"
	desc = "A lightweight helmet for reporting on security. It looks carelessly cobbled together with spare plastic and cloth."
	icon = 'modular_splurt/icons/obj/clothing/head.dmi'
	mob_overlay_icon = 'modular_splurt/icons/mob/clothing/head.dmi'
	flags_inv = HIDEHAIR

/obj/item/clothing/head/helmet/sec/warden
	name = "Warden's helmet"
	desc = "The warden's personalized helmet."
	icon_state = "wardenhelmet"
	icon = 'modular_splurt/icons/obj/clothing/head.dmi'
	mob_overlay_icon = 'modular_splurt/icons/mob/clothing/head.dmi'
	armor = list(MELEE = 40, BULLET = 30, LASER = 30, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 30, ACID = 60)

/obj/item/clothing/head/helmet/sec/hos
	name = "Head of Security's helmet"
	desc = "The Head of Security's personalized helmet."
	icon_state = "hoshelmet"
	icon = 'modular_splurt/icons/obj/clothing/head.dmi'
	mob_overlay_icon = 'modular_splurt/icons/mob/clothing/head.dmi'
	armor = list(MELEE = 40, BULLET = 30, LASER = 25, ENERGY = 10, BOMB = 25, BIO = 10, RAD = 0, FIRE = 50, ACID = 60)
	strip_delay = 80

//CBRN/MOPP helmets

/obj/item/clothing/head/helmet/cbrn
	name = "CBRN Hood"
	desc = "Chemical, Biological, Radiological and Nuclear. A hood designed for harsh environmental conditions short of atmospheric hazards."
	icon_state = "cbrnhood"
	item_state = "cbrnhood"
	icon = 'modular_splurt/icons/obj/clothing/head.dmi'
	mob_overlay_icon = 'modular_splurt/icons/mob/clothing/head.dmi'
	armor = list("melee" = 5, "bullet" = 0, "laser" = 5,"energy" = 5, "bomb" = 0, "bio" = 100, "rad" = 100, "fire" = 40, "acid" = 100)
	w_class = WEIGHT_CLASS_NORMAL
	gas_transfer_coefficient = 0.5
	permeability_coefficient = 0.5
	strip_delay = 60
	equip_delay_other = 60
	body_parts_covered = HEAD
	clothing_flags = THICKMATERIAL
	flags_inv = HIDEHAIR|HIDEEARS
	resistance_flags = ACID_PROOF
	rad_flags = RAD_PROTECT_CONTENTS | RAD_NO_CONTAMINATE

/obj/item/clothing/head/helmet/cbrn/mopp
	name = "MOPP Hood"
	desc = "Mission Oriented Protective Posture. A hood designed for harsh combat conditions short of atmospheric hazards. This one has a helmet stitched onto the hood for added protection."
	icon_state = "mopphood"
	item_state = "mopphood"
	can_flashlight = 1
	armor = list("melee" = 40, "bullet" = 30, "laser" = 30,"energy" = 10, "bomb" = 25, "bio" = 100, "rad" = 100, "fire" = 40, "acid" = 100)

/obj/item/clothing/head/helmet/cbrn/mopp/advance
	name = "Advanced MOPP Hood"
	desc = "Mission Oriented Protective Posture. A hood designed for harsh combat conditions short of atmospheric conditions. This is an advanced version for ERT units and Central Command Staff."
	can_flashlight = 1
	armor = list("melee" = 50, "bullet" = 40, "laser" = 40,"energy" = 20, "bomb" = 35, "bio" = 110, "rad" = 110, "fire" = 50, "acid" = 110)
	clothing_flags = NONE


// research nods
/datum/design/cbrn/cbrnhood
	name = "CBRN Hood"
	desc = "A CBRN hood."
	id = "cbrn_hood"
	build_type = PROTOLATHE
	materials = list(/datum/material/plastic = 200, /datum/material/uranium = 50, /datum/material/iron = 200)
	build_path = /obj/item/clothing/head/helmet/cbrn
	category = list("Equipment")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY | DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SERVICE | DEPARTMENTAL_FLAG_CARGO | DEPARTMENTAL_FLAG_SCIENCE | DEPARTMENTAL_FLAG_MEDICAL

/datum/design/cbrn/mopphood
	name = "MOPP Hood"
	desc = "A MOPP hood with an integrated helmet."
	id = "mopp_hood"
	build_type = PROTOLATHE
	materials = list(/datum/material/plastic = 200, /datum/material/uranium = 50, /datum/material/iron = 200)
	build_path = /obj/item/clothing/head/helmet/cbrn/mopp
	category = list("Armor")
	departmental_flags = DEPARTMENTAL_FLAG_SECURITY

