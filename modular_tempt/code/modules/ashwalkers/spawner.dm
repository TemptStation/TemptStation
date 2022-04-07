/obj/effect/mob_spawn/human/ash_walker
	name = "ash walker egg"
	desc = "A man-sized yellow egg, spawned from some unfathomable creature. A humanoid silhouette lurks within."
	mob_name = "an ash walker"
	job_description = "Ashwalker"
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "large_egg"
	mob_species = /datum/species/lizard/ashwalker
	roundstart = FALSE
	death = FALSE
	anchored = FALSE
	move_resist = MOVE_FORCE_NORMAL
	density = FALSE
	short_desc = "You are an ash walker. Your tribe worships the Necropolis."
	flavour_text = "The wastes are sacred ground, its monsters a blessed bounty. You would never willingly leave your homeland behind. \
	You have seen lights in the distance... they foreshadow the arrival of outsiders to your domain. \
	Ensure your nest remains protected at all costs."
	assignedrole = "Ash Walker"
	var/datum/team/ashwalkers/egg_team
	var/obj/structure/ash_walker_eggshell/eggshell
	var/gender_bias

/obj/effect/mob_spawn/human/ash_walker/Initialize(mapload, datum/team/ashwalkers/ashteam)
	. = ..()
	var/area/A = get_area(src)
	egg_team = ashteam
	eggshell = new /obj/structure/ash_walker_eggshell(get_turf(loc))
	eggshell.yolk = src
	src.forceMove(eggshell)
	if(A)
		notify_ghosts("An ash walker egg is ready to hatch in \the [A.name].", source = src, action=NOTIFY_ATTACK, flashwindow = FALSE, ignore_key = POLL_IGNORE_ASHWALKER, ignore_dnr_observers = TRUE)

/obj/effect/mob_spawn/human/ash_walker/Destroy()
	eggshell = null
	return ..()

/obj/effect/mob_spawn/human/ash_walker/equip(mob/living/carbon/human/H)
	if(!isnull(gender_bias) && prob(90))
		H.gender = gender_bias
	return ..()

/obj/effect/mob_spawn/human/ash_walker/special(mob/living/new_spawn)
	new_spawn.real_name = random_unique_lizard_name(gender)
	if(is_mining_level(eggshell.z))
		to_chat(new_spawn, "<b>Drag the corpses of men and beasts to your nest. It will absorb them to create more of your kind. Glory to the Necropolis!</b>")
	else
		to_chat(new_spawn, "<span class='userdanger'>You have been born outside of your natural home! Whether you decide to return home, or make due with your new home is your own decision.</span>")

	if(!ishuman(new_spawn))
		return

	var/mob/living/carbon/human/H = new_spawn
	H.underwear = "Nude"
	H.undershirt = "Nude"
	H.socks = "Nude"
	H.update_body()
	if(egg_team)
		new_spawn.mind.add_antag_datum(/datum/antagonist/ashwalker, egg_team)
		egg_team.players_spawned += (new_spawn.key)

	eggshell.yolk = null
	QDEL_NULL(eggshell)

/obj/effect/mob_spawn/human/ash_walker/western
	job_description = "Western Ashwalker"
	short_desc = "You are a Farlander. Your tribe worships the home tendril."
	flavour_text = "Your original home and tribe razed by Calamity, whoever remained set off to find a new place to live - \
	these ashen grounds making for a good staying place, filled with flora and huntmeat alike. You're not alone here however, these grounds' natives \
	restless about your tribe's arrival. Though surely they can be reasoned with.. right?\n\n\
	Ensure the safety of your tribe. The elders didn't sacrifice themselves for it to perish here."
	mob_species = /datum/species/lizard/ashwalker/western
	gender_bias = FEMALE

/obj/effect/mob_spawn/human/ash_walker/eastern
	job_description = "Eastern Ashwalker"
	flavour_text = "You've shelter in the Necropolis, it's sacred walls housing your nest, bringing in new kin for your tribe and breathing new life \
	into your fallen bretheren. Recently however, a foreign tribe came to these grounds, their foul hands threatening your hunt - furthermore, the sky's angels \
	descend onto these lands, demise of this world as their goal.\n\n\
	Ensure the safety of your nest, let no abomination even graze your home."
	mob_species = /datum/species/lizard/ashwalker/eastern
	gender_bias = MALE



/obj/structure/ash_walker_eggshell
	name = "ash walker egg"
	desc = "A man-sized yellow egg, spawned from some unfathomable creature."
	icon = 'icons/mob/lavaland/lavaland_monsters.dmi'
	icon_state = "large_egg"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | FREEZE_PROOF
	max_integrity = 80
	var/obj/effect/mob_spawn/human/ash_walker/yolk

/obj/structure/ash_walker_eggshell/Destroy()
	if(!yolk)
		return ..()
	var/mob/living/carbon/human/giblets = new /mob/living/carbon/human/(get_turf(src))
	giblets.fully_replace_character_name(null,random_unique_lizard_name(gender))
	giblets.set_species(/datum/species/lizard/ashwalker)
	giblets.underwear = "Nude"
	giblets.update_body()
	giblets.gib()
	QDEL_NULL(yolk)
	return ..()

/obj/structure/ash_walker_eggshell/attack_ghost(mob/user)
	if(yolk) //Pass on ghost clicks to the mob spawner
		yolk.attack_ghost(user)
	. = ..()

/obj/structure/ash_walker_eggshell/examine(mob/user)
	. = ..()
	. += yolk ? "A humanoid sillouette lurks within." : "It looks.. hollow inside."

/obj/structure/ash_walker_eggshell/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0) //lifted from xeno eggs
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(loc, 'sound/effects/attackblob.ogg', 100, TRUE)
			else
				playsound(src, 'sound/weapons/tap.ogg', 50, TRUE)
		if(BURN)
			if(damage_amount)
				playsound(loc, 'sound/items/welder.ogg', 100, TRUE)
