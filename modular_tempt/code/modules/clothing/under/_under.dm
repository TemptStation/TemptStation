/obj/item/clothing/under
	var/is_skirt = FALSE //used for skirt peeking

/obj/item/clothing/under/Destroy()
	QDEL_LIST(attached_accessories)
	return ..()
