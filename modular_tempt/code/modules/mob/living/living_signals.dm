/mob/living/ComponentInitialize()
	. = ..()
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_FLOORED), .proc/update_mobility)
	RegisterSignal(src, SIGNAL_TRAIT(TRAIT_DISK_VERIFIER), .proc/handle_disk_verifier)
