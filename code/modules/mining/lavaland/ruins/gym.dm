/obj/structure/punching_bag
	name = "punching bag"
	desc = "A punching bag. Can you get to speed level 4???"
	icon = 'goon/icons/obj/fitness.dmi'
	icon_state = "punchingbag"
	anchored = TRUE
	layer = WALL_OBJ_LAYER
	var/list/hit_sounds = list('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg',\
	'sound/weapons/punch1.ogg', 'sound/weapons/punch2.ogg', 'sound/weapons/punch3.ogg', 'sound/weapons/punch4.ogg')

/obj/structure/punching_bag/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	flick("[icon_state]2", src)
	playsound(loc, pick(hit_sounds), 25, TRUE, -1)
	if(isliving(user))
		var/mob/living/L = user
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "exercise", /datum/mood_event/exercise)
		L.apply_status_effect(STATUS_EFFECT_EXERCISED)

/obj/structure/betaversion_strength_tester // wyci
	name = "Strongman Game"
	desc = "An attraction commonly used in fairs for testing one's strength. All you have to do is pick up the nearby mallet then strike it with all of your might! Or you could just stomp down on it. Not like anyone is looking..."
	icon = 'icons/mob/32x64.dmi'
	icon_state = "strength_test"
	anchored = TRUE
	layer = WALL_OBJ_LAYER
	var/list/hit_sounds = list('sound/effects/bang.ogg', 'sound/weapons/resonator_blast.ogg', 'sound/mecha/mechstep.ogg') // only someone too afraid of sound copyright would think these sounds make any damn sense...

/obj/structure/betaversion_strength_tester/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	flick("[icon_state]2", src)
	playsound(loc, pick(hit_sounds), 25, TRUE, -1)
	if(isliving(user))
		var/mob/living/L = user
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "exercise", /datum/mood_event/exercise)
		L.apply_status_effect(STATUS_EFFECT_EXERCISED)

/obj/structure/lazy_mr_bones
	name = "Animatronic Mr. Bones"
	desc = "This animatronic of Mr. Bones isn't quite like the real deal however he'll still work as a reminder that there's a riddle to solve if you want out! Just punch his shoulder or something, I guess."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "skeletonman"
	max_integrity = 9999
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	density = TRUE
	anchored = TRUE
	layer = 3
	var/list/hit_sounds = list('sound/voice/mrbones/roleplay.ogg', 'sound/voice/mrbones/solve_the_riddle.ogg', 'sound/voice/mrbones/error_incorrect.ogg', 'sound/voice/mrbones/repeat.ogg')

/obj/structure/lazy_mr_bones/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	playsound(loc, pick(hit_sounds), 25)
	new /obj/effect/temp_visual/source_mic(get_turf(src))

/obj/structure/weightmachine
	name = "weight machine"
	desc = "Just looking at this thing makes you feel tired."
	density = TRUE
	anchored = TRUE
	var/icon_state_inuse

/obj/structure/weightmachine/proc/AnimateMachine(mob/living/user)
	return

/obj/structure/weightmachine/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(obj_flags & IN_USE)
		to_chat(user, "<span class='warning'>It's already in use - wait a bit!</span>")
		return
	else
		obj_flags |= IN_USE
		icon_state = icon_state_inuse
		user.setDir(SOUTH)
		user.Stun(80)
		user.forceMove(src.loc)
		var/bragmessage = pick("pushing it to the limit","going into overdrive","burning with determination","rising up to the challenge", "getting strong now","getting ripped")
		user.visible_message("<B>[user] is [bragmessage]!</B>")
		AnimateMachine(user)

		playsound(user, 'sound/machines/click.ogg', 60, TRUE)
		obj_flags &= ~IN_USE
		user.pixel_y = 0
		var/finishmessage = pick("You feel stronger!","You feel like you can take on the world!","You feel robust!","You feel indestructible!")
		SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "exercise", /datum/mood_event/exercise)
		icon_state = initial(icon_state)
		to_chat(user, finishmessage)
		user.apply_status_effect(STATUS_EFFECT_EXERCISED)

/obj/structure/weightmachine/stacklifter
	icon = 'goon/icons/obj/fitness.dmi'
	icon_state = "fitnesslifter"
	icon_state_inuse = "fitnesslifter2"

/obj/structure/weightmachine/stacklifter/AnimateMachine(mob/living/user)
	var/lifts = 0
	while (lifts++ < 6)
		if (user.loc != src.loc)
			break
		sleep(3)
		animate(user, pixel_y = -2, time = 3)
		sleep(3)
		animate(user, pixel_y = -4, time = 3)
		sleep(3)
		playsound(user, 'goon/sound/effects/spring.ogg', 60, TRUE)

/obj/structure/weightmachine/weightlifter
	icon = 'goon/icons/obj/fitness.dmi'
	icon_state = "fitnessweight"
	icon_state_inuse = "fitnessweight-c"

/obj/structure/weightmachine/weightlifter/AnimateMachine(mob/living/user)
	var/mutable_appearance/swole_overlay = mutable_appearance(icon, "fitnessweight-w", WALL_OBJ_LAYER)
	add_overlay(swole_overlay)
	var/reps = 0
	user.pixel_y = 5
	while (reps++ < 6)
		if (user.loc != src.loc)
			break
		for (var/innerReps = max(reps, 1), innerReps > 0, innerReps--)
			sleep(3)
			animate(user, pixel_y = (user.pixel_y == 3) ? 5 : 3, time = 3)
		playsound(user, 'goon/sound/effects/spring.ogg', 60, TRUE)
	sleep(3)
	animate(user, pixel_y = 2, time = 3)
	sleep(3)
	cut_overlay(swole_overlay)
