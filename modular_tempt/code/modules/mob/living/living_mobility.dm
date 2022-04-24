//Force-set resting variable, without needing to resist/etc.
/mob/living/proc/set_resting(new_resting, silent = FALSE, updating = TRUE)
	if(new_resting == resting)
		return
	if(new_resting && HAS_TRAIT(src, TRAIT_FLOORED))
		return
	if(resting && HAS_TRAIT(src, TRAIT_MOBILITY_NOREST)) //forcibly block resting from all sources - BE CAREFUL WITH THIS TRAIT
		return
	resting = new_resting
	if(!silent)
		to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"].</span>")
	if(resting == 1)
		SEND_SIGNAL(src, COMSIG_LIVING_RESTING)
	update_resting(updating)
