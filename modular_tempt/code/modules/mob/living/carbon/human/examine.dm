#define PAIRLESS_PANTIES list(\
	/obj/item/clothing/underwear/briefs/jockstrap,\
	/obj/item/clothing/underwear/briefs/panties/thong,\
	/obj/item/clothing/underwear/briefs/mankini\
)


/mob/living/carbon/human/examine(mob/user)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/living = user
	if((living.mobility_flags & ~MOBILITY_STAND) && (user.loc == living.loc) && (istype(src.w_uniform, /obj/item/clothing/under/color/jumpskirt)))
		var/string = "Peeking under [src]'s skirt, you can see "
		var/obj/item/clothing/underwear/worn_underwear = src.w_underwear
		if(worn_underwear)
			string += "a "
			if(!(worn_underwear.type in PAIRLESS_PANTIES)) //a pair of thong
				string += "pair of "
			if(worn_underwear.color)
				string += "<font color='[worn_underwear.color]'>[worn_underwear.name]</font>."
			else
				string += "[worn_underwear.color]."


		else
			string += "[p_theyre()] not wearing anything - [p_their()] "
			for(var/obj/item/organ/genital/genital in internal_organs)
				if(genital.genital_flags & (GENITAL_INTERNAL|GENITAL_HIDDEN))
					continue

