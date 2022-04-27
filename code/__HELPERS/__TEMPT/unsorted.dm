/proc/generate_random_serial(groups = 4, group_length = 5)
	for(var/i in 1 to groups)
		. += random_string(group_length, GLOB.alphabet + GLOB.alphabet_upper + GLOB.numerals)
		. += "-"
	return copytext(., 1, -1)
