#define ASH_WALKER_SPAWN_THRESHOLD 2
//The ash walker den consumes corpses or unconscious mobs to create ash walker eggs. For more info on those, check ghost_role_spawners.dm
/obj/structure/lavaland/ash_walker
	name = "necropolis tendril nest"
	desc = "A vile tendril of corruption. It's surrounded by a nest of rapidly growing eggs..."
	icon = 'icons/mob/nest.dmi'
	icon_state = "ash_walker_nest"
	move_resist=INFINITY // just killing it tears a massive hole in the ground, let's not move it
	anchored = TRUE
	density = TRUE
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	max_integrity = 200
	var/faction = list("ashwalker")
	var/meat_counter = 6
	var/spawned_egg = /obj/effect/mob_spawn/human/ash_walker
	var/spawned_species = /datum/species/lizard/ashwalker

	var/datum/team/linked_team

/obj/structure/lavaland/ash_walker/Initialize(mapload)
	.=..()
	var/datum/objective/protect_object/objective = new /datum/objective/protect_object(src)
	objective.set_target(src)

	linked_team = new /datum/team/ashwalkers()
	linked_team.objectives += objective

	//it somewhat annoys me and could be redone by just listening to the neighbor tiles' on-enter signal
	//but this works for now
	START_PROCESSING(SSprocessing, src)

/obj/structure/lavaland/ash_walker/Destroy()
	linked_team = null

	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/lavaland/ash_walker/deconstruct(disassembled)
	new /obj/item/assembly/signaler/anomaly (get_step(loc, pick(GLOB.alldirs)))
	new /obj/effect/collapse(loc)
	return ..()

/obj/structure/lavaland/ash_walker/process()
	consume()
	spawn_mob()

/obj/structure/lavaland/ash_walker/proc/consume()
	for(var/mob/living/H in view(src, 1)) //Only for corpse right next to/on same tile
		if(!H.stat)
			continue

		for(var/obj/item/W in H)
			if(!H.dropItemToGround(W))
				qdel(W)

		var/mob_mind = H.mind
		if(mob_mind && (mob_mind in linked_team.members) && (H.key || H.get_ghost(FALSE, TRUE))) //this does mean cross-tribe sacrifices, yes
			visible_message(span_warning("Serrated tendrils carefully pull [H] to [src], absorbing the body and creating it anew."))
			var/who_to_bother = H.key ? H : H.get_ghost(FALSE, TRUE)
			to_chat(who_to_bother, "Your body has been returned to the nest. You are being remade anew, and will awaken shortly. </br><b>Your memories will remain intact in your new body, as your soul is being salvaged.</b>")

			playsound(src, sound('sound/magic/enter_blood.ogg'), )
			SEND_SOUND(who_to_bother, sound('sound/magic/enter_blood.ogg',volume=100))

			addtimer(CALLBACK(src, .proc/remake_walker, mob_mind, H.real_name, H.gender), 20 SECONDS)
			new /obj/effect/gibspawner/generic(get_turf(H))
			qdel(H)
			continue

		if(issilicon(H)) //no advantage to sacrificing borgs...
			H.gib()
			visible_message(span_notice("Serrated tendrils eagerly pull [H] apart, but find nothing of interest."))
			continue

		playsound(get_turf(src),'sound/magic/demon_consume.ogg', 100, TRUE)
		visible_message(span_warning("Serrated tendrils eagerly pull [H] to [src], tearing the body apart as its blood seeps over the eggs."))

		meat_counter += ismegafauna(H) ? 20 : 1
		H.gib()

		obj_integrity = min(obj_integrity + max_integrity*0.05,max_integrity)//restores 5% hp of tendril

		for(var/mob/living/L in view(src, 5))
			if(L.mind?.has_antag_datum(/datum/antagonist/ashwalker))
				SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "headspear", /datum/mood_event/sacrifice_good)
			else
				SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "headspear", /datum/mood_event/sacrifice_bad)

/obj/structure/lavaland/ash_walker/proc/remake_walker(datum/mind/oldmind, oldname, oldgender)
	var/mob/living/carbon/human/M = new /mob/living/carbon/human(get_step(loc, pick(GLOB.alldirs)))
	M.set_species(spawned_species)
	M.real_name = oldname
	M.gender = oldgender
	M.underwear = "Nude"
	M.undershirt = "Nude"
	M.socks = "Nude"
	M.update_body()
	M.remove_language(/datum/language/common)
	oldmind.transfer_to(M)
	M.mind.grab_ghost()
	to_chat(M, "<b>You have been pulled back from beyond the grave, with a new body and renewed purpose. Glory to the Necropolis!</b>")
	playsound(get_turf(M),'sound/magic/exit_blood.ogg', 100, TRUE)

/obj/structure/lavaland/ash_walker/proc/spawn_mob()
	if(meat_counter < ASH_WALKER_SPAWN_THRESHOLD)
		return
	new spawned_egg(get_step(loc, pick(GLOB.alldirs)), linked_team)
	visible_message("<span class='danger'>One of the eggs swells to an unnatural size and tumbles free. It's ready to hatch!</span>")
	meat_counter -= ASH_WALKER_SPAWN_THRESHOLD


/obj/structure/lavaland/ash_walker/western
	spawned_egg = /obj/effect/mob_spawn/human/ash_walker/western
	spawned_species = /datum/species/lizard/ashwalker/western

/obj/structure/lavaland/ash_walker/eastern
	spawned_egg = /obj/effect/mob_spawn/human/ash_walker/eastern
	spawned_species = /datum/species/lizard/ashwalker/eastern
