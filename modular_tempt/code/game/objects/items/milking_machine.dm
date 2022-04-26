//sand, your code sucks and i will use this file to bash you wherever possible.
/obj/item/milking_machine
	icon = 'modular_sand/icons/obj/milking_machine.dmi'
	name = "milking machine"
	icon_state = "Off"
	item_state = "Off"
	desc = "A pocket sized pump and tubing assembly designed to collect and store products from mammary glands."
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS
	var/on = FALSE
	var/obj/item/reagent_containers/inserted_item = null
	var/milking_speed = 50
	var/target_zone  = ORGAN_SLOT_BREASTS //target_zone is slightly more clear than target_organ
	var/in_use = FALSE //bool defines are more clear than 1/0

/obj/item/milking_machine/Destroy()
	inserted_item.forceMove(loc) //edge case of being inside another object which i don't care about
	inserted_item = null //null your refs
	return ..()

/obj/item/milking_machine/examine(mob/user)
	. = ..()
	to_chat(user, span_notice("[src] is currently [on ? "on" : "off"].")) //span defines are cleaner
	if(inserted_item)
		to_chat(user, span_notice("[inserted_item] contains [inserted_item.reagents.total_volume]/[inserted_item.reagents.maximum_volume] units.")) //use your periods.

/obj/item/milking_machine/attackby(obj/item/wielded, mob/user, params)
	if(!istype(wielded, /obj/item/reagent_containers)) //the slash at the end was bugging me so hard.
		return ..()

	if(inserted_item)
		to_chat(user, span_warning("There's already a [inserted_item] inside \the [src]!"))
		return

	if(!user.transferItemToLoc(wielded, src))
		to_chat(user, span_warning("\The [wielded] is stuck to your hand!"))
		return

	inserted_item = wielded
	update_icon_state() //this is a proc that exists, you know

/obj/item/milking_machine/interact(mob/user)
	. = ..() //call parent
	if(issilicon(user))
		return //use early returns
	if(!inserted_item)
		to_chat(user, span_warning("There's no container inside!")) //give the player feedback
		return
	on = !on
	to_chat(user, span_notice("You turn \the [src] [on ? "on" : "off"].")) //text ternaries are good (if not in excess amounts)
	update_icon_state()

/obj/item/milking_machine/update_icon_state()
	. = ..()
	icon_state = "[on ? "On" : "Off"][inserted_item ? "Beaker" : ""]" //hardcoding icon states isn't particularly good
	item_state = icon_state //but i'll leave it since i don't want to fuck with icons


/obj/item/milking_machine/AltClick(mob/living/user)
	add_fingerprint(user)
	user.put_in_hands(inserted_item)
	inserted_item = null
	on = FALSE
	update_icon_state()

/obj/item/milking_machine/penis
	name = "cock milker"
	icon_state = "PenisOff"
	item_state = "PenisOff"
	desc = "A pocket sized pump and tubing assembly designed to collect and store products from the penis."
	target_zone = ORGAN_SLOT_PENIS

/obj/item/milking_machine/penis/update_icon_state()
	. = ..()
	icon_state = "Penis[icon_state]" //for the record, i'm not doing icon states any better than sand.
	item_state = icon_state

/obj/item/milking_machine/afterattack(mob/living/carbon/human/victim, mob/living/user) //use clear argument names, "H" is quite unclear
	if(!istype(victim) || !istype(user)) //check if we actually have the type we're expecting
		return ..()

	. = TRUE //returning true nukes afterattack, no need for nobludgeon
	if(!on)
		to_chat(user, span_notice("You can't use \the [src] while it's off."))
		return

	var/obj/item/organ/genital/genital = victim.getorganslot(target_zone)
	if(!genital)
		return
	if(in_use) //existance comparison is enough for booleans
		return

	if(!genital?.is_exposed()) //early returns are better
		to_chat(user, span_notice("You don't see anywhere to use this on."))
		return

	in_use = TRUE
	if(victim != user) //!(x == y) equals x != y except the latter is clearer
		victim.visible_message(span_love("[user] pumps [victim]'s [genital.name] using [user.p_their()] [src.name]."), //ironically enough we don't need \ at the ends
			span_userlove("[user] pumps your [genital.name] with [user.p_their()] [src.name]."), //dunno why cit is insistent on doing that
			span_userlove("Someone is pumping your [genital.name].")
		)
	else
		user.visible_message(span_love("[user] sets [src] to suck on [user.p_their()] [genital.name]."), //p_their refered to the milker, not the user
			span_userlove("You pump your [genital.name] using \the [src]."),
			span_userlove("You pump your [genital.name] into the machine.")
		)
	playsound(src, 'sound/vehicles/carrev.ogg', 30, 1, -1) //we're not changing the sound anywhere, storing the sound in a var is pointless
	if(!do_mob(user, victim, 3 SECONDS))
		in_use = FALSE
		return
	playsound(src, 'modular_sand/sound/lewd/slaps.ogg', 20, 1, -1)
	if(prob(30))
		victim.emote("moan")

	victim.add_lust(20 + rand(0, 50))
	if(victim.get_lust() >= (victim.get_lust_tolerance() * 3)) //checked before + if a human doesn't have dna something is seriously wrong
		victim.mob_fill_container(genital, inserted_item, milking_speed, src) //why is this a mob proc
		victim.do_jitter_animation()

	in_use = FALSE //one set-to-false is enough

//you saw the comment at the start?
//i'm tired now, you get a break
/obj/item/milking_machine/pleasuremaw
	name = "pleasure maw"
	desc = "A module that makes hound maws become slippery, warm, sticky, and soft, perfect place to slip your dick inside and relax, feed and help charge the borgs."
	icon = 'modular_sand/icons/mob/dogborg.dmi'
	icon_state = "pleasuremaw"
	on = TRUE
	var/toggle_process_reagents = FALSE
	var/consumption_rate = 2
	var/mob/living/silicon/robot/borg_self = null

/obj/item/milking_machine/pleasuremaw/Initialize()
	. = ..()
	inserted_item = new /obj/item/reagent_containers/glass/beaker/large(src)
	inserted_item.name = "cyborg stomach"
	inserted_item.desc = "A cyborg stomach. It seems integrated into \the [src]'s machinery."

/obj/item/milking_machine/pleasuremaw/Destroy()
	STOP_PROCESSING(SSobj, src) //please no
	borg_self = null
	return ..()

/obj/item/milking_machine/pleasuremaw/interact(mob/user)
	toggle_process_reagents = !toggle_process_reagents
	if(toggle_process_reagents)
		to_chat(user, span_notice("You start churning the sexual fluids from your [inserted_item] into energy."))
		borg_self = user
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
		to_chat(user, span_notice("You stop processing the fluids from \the [inserted_item]."))

/obj/item/milking_machine/pleasuremaw/process()
	if(inserted_item.reagents.total_volume < consumption_rate)
		src.interact(borg_self)
		return
	inserted_item.reagents.remove_all(consumption_rate)
	borg_self.cell.charge = min(borg_self.cell.charge + borg_self.cell.maxcharge/50, borg_self.cell.maxcharge)

/obj/item/milking_machine/pleasuremaw/AltClick(mob/living/user)
	return

/obj/item/milking_machine/pleasuremaw/afterattack(atom/target, mob/living/silicon/robot/user, proximity)
	if(!proximity || !check_allowed_items(target) || !istype(user))
		return

	if(istype(target, /obj/item/reagent_containers))
		if(inserted_item?.reagents?.total_volume <= 1) //oh noes my 0.62 units of extra luxurious semen
			to_chat(user, span_info("Pleasure maw tank empty."))
			return
		user.visible_message(span_notice("You open your mouth and dispense the contents of your [src.name]'s storage into \the [target]."),
			span_notice("[user] opens [p_their()] [src.name] and dispenses something sticky into \the [target]!")
		)
		inserted_item.reagents.trans_to(target, inserted_item.reagents.total_volume)
		return

	if(!ishuman(target))
		return
	var/mob/living/carbon/human/victim = target
	target_zone = null

	switch(user.zone_selected) //i can't make it pretty jeremy
		if(BODY_ZONE_PRECISE_MOUTH)
			user.visible_message(span_warning("[user] kisses [victim]!"),
				span_notice("You kiss [victim]!")
			)
			playsound(src.loc, 'sound/effects/attackblob.ogg', 30, 1)
			victim.add_lust(10)
		if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_EYES) //get your head out of the gutter mos
			user.visible_message(span_warning("[user] licks [victim]'s ears!"),
				span_notice("You lick [victim]'s ears!")
			)
			playsound(src.loc, 'sound/effects/attackblob.ogg', 30, 1)
			victim.add_lust(5)
		if(BODY_ZONE_CHEST)
			var/obj/item/organ/genital/breasts/breasts = victim.getorganslot(ORGAN_SLOT_BREASTS)
			if(breasts?.is_exposed())
				user.visible_message(span_warning("[user] sucks on [victim]'s [breasts.name]]!"),
					span_notice("You suck on [victim]'s [breasts.name]]!")
				)
				playsound(src.loc, 'sound/effects/attackblob.ogg', 30, 1)
				victim.add_lust(10)
				return ..() //this is giving me chain aneurisms but i don't have the patience to fix this
			else
				to_chat(user, span_info("Lickable breasts not found!"))
		if(BODY_ZONE_PRECISE_GROIN)
			var/static/list/possible_choices = sortList(list(
				"Penis" = image(icon = 'icons/obj/genitals/penis.dmi', icon_state = "penis"),
				"Testicles" = image(icon= 'icons/obj/genitals/testicles.dmi', icon_state = "testicles"),
				"Vagina" = image(icon= 'icons/obj/genitals/vagina.dmi', icon_state = "vagina"),
				"Butt" = image(icon= 'icons/obj/genitals/breasts.dmi', icon_state = "butt"),
				"Belly" = image(icon= 'modular_sand/icons/obj/genitals/belly_onmob.dmi', icon_state = "belly_pair_4_0_FRONT")
			))
			var/choice = show_radial_menu(user, src, possible_choices)
			if(!choice)
				return
			switch(choice)
				if("Penis")
					var/obj/item/organ/genital/penis/penis = victim.getorganslot(ORGAN_SLOT_PENIS)
					if(penis?.is_exposed())
						target_zone = ORGAN_SLOT_PENIS
						user.visible_message(span_warning("[user] blows [victim]'s [penis.name]!"),
							span_notice("You blow [victim]'s [penis.name]!")
						)
						playsound(src.loc, 'sound/effects/attackblob.ogg', 30, 1)
						victim.add_lust(10)
						return ..()
					else
						to_chat(user, span_info("Lickable penis not found!"))
				if("Testicles")
					var/obj/item/organ/genital/testicles/testicles = victim.getorganslot(ORGAN_SLOT_TESTICLES)
					if(testicles?.is_exposed())
						user.visible_message(span_warning("[user] laps [victim]'s [testicles.name]!"),
							span_notice("You lap [victim]'s [testicles.name]!")
						)
						playsound(src.loc, 'sound/effects/attackblob.ogg', 30, 1)
						victim.add_lust(10)
						return ..()
					else
						to_chat(user, span_info("Lickable testicles not found!"))
				if("Vagina")
					var/obj/item/organ/genital/vagina/vagina = victim.getorganslot(ORGAN_SLOT_VAGINA)
					if(vagina?.is_exposed())
						target_zone = ORGAN_SLOT_VAGINA
						user.visible_message(span_warning("[user] tongue fucks [victim]'s [vagina.name]!"),
							span_notice("You tongue fuck [victim]'s [vagina.name]!")
						)
						playsound(src.loc, 'sound/effects/attackblob.ogg', 30, 1)
						victim.add_lust(10)
						return ..()
					else
						to_chat(user, span_info("Lickable pussy not found!"))
				if("Butt")
					var/obj/item/organ/genital/butt/butt = victim.getorganslot(ORGAN_SLOT_BUTT)
					if(butt?.is_exposed())
						user.visible_message(span_warning("[user]'s giving [victim] a rimjob!"),
							span_notice("You rim [victim]'s [butt.name]!")
						)
						playsound(src.loc, 'sound/effects/attackblob.ogg', 30, 1)
						victim.add_lust(15)
					else
						to_chat(user, span_info("Lickable ass not found!"))
				if("Belly")
					var/obj/item/organ/genital/belly/belly = victim.getorganslot(ORGAN_SLOT_BELLY)
					if(belly?.is_exposed())
						user.visible_message(span_notice("[user]'s lapping [victim]'s [belly.name]!"),
							span_notice("You lick [victim]'s [belly.name]!")
						)
						playsound(src, 'sound/effects/attackblob.ogg', 30, 1)
						victim.add_lust(5)
					else
						to_chat(user, span_info("Lickable belly not found!"))
