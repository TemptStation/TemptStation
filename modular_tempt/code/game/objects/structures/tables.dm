/obj/structure/table/ComponentInitialize()
	. = ..()
	AddElement(/datum/element/crawl_under)

/obj/structure/table/CanPass(atom/movable/mover, turf/target)
	if(mover.pass_flags & PASSCRAWL)
		return TRUE
	return ..()
