GLOBAL_VAR_INIT(nuke_serial, generate_random_serial(6, 5))

/obj/machinery/nuclearbomb
	var/serial_auth

/obj/machinery/nuclearbomb/Initialize()
	. = ..()
	serial_auth = GLOB.nuke_serial

/obj/machinery/nuclearbomb/disk_check(obj/item/disk/nuclear/D)
	if(D.serial_code != serial_auth)
		say("Authentication failure; disk not recognised.")
		return FALSE
	else
		return TRUE


/obj/item/disk/nuclear
	var/serial_code

/obj/item/disk/nuclear/Initialize()
	. = ..()
	serial_code = get_nuke_auth()

/obj/item/disk/nuclear/proc/get_nuke_auth()
	if(!fake)
		return GLOB.nuke_serial
	//i wanted to be evil and return an almost identical code
	return generate_random_serial(6, 5) //you get to live, cappie.

/obj/item/disk/nuclear/examine(mob/user)
	. = ..()
	if(isobserver(user) && fake)
		. += span_warning("The serial numbers on [src] are incorrect.")

/obj/item/disk/nuclear/examine_more(mob/user)
	. = ..()
	if(serial_code)
		. += "There's a serial code imprinted on the back.."
		. += "\"<b>serial_code</b>\""

/obj/item/disk/nuclear/fake/obvious/Initialize()
	. = ..()
	serial_code = null

/mob/living/proc/handle_disk_verifier()
	if(!mind)
		if(HAS_TRAIT(src, TRAIT_DISK_VERIFIER))
			to_chat(src, span_warning("It seems you don't have a mind datum, so we can't modify your notes. Here's the serial code, copy it to clipboard or whatever.\n[GLOB.nuke_serial]"))
		return

	var/to_insert = "NAD's serial code: \"<b>[GLOB.nuke_serial]</b>\"<BR>"
	if(HAS_TRAIT(src, TRAIT_DISK_VERIFIER))
		mind.memory += to_insert
	else
		var/index = findtext(mind.memory, to_insert)
		mind.memory = splicetext(mind.memory, index, findtext(mind.memory, "<BR>", index) + 4)

/obj/item/paper/fluff/nuke_serial
	name = "important looking paper"
	info = "If you see this, it means Null did a Mosley."

/obj/item/paper/fluff/nuke_serial/Initialize()
	. = ..()
	info = \
"---UNAUTHORISED DISTRIBUTION OF THIS DOCUMENT IS PUNISHABLE BY DEATH---<BR>\
<BR>\
The current serial code for the nuclear authentication disk is: \"<b>[GLOB.nuke_serial]</b>\"\
"
