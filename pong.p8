pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--pico-pong!

player_points = 0
comp_points = 0

function _init()
	player = {
		x = 8,
		y = 63,
		c = 12,
		w = 3,
		h = 12,
		r = 0,
		speed = 1
	}

	comp = {
		x = 117,
		y = 63,
		c = 14,
		w = 3,
		h = 12,
		r = 0,
		speed = 0.6
	}

	ball = {
		x = 63,
		y = 63,
		c = 7,
		w = 3,
		r = 0,
		dx = 0.8,
		dy = flr(rnd(2)) - 0.5,
		speedup = 0.05
	}

	court = {
		left = 0,
		right = 127,
		top = 10,
		bottom = 127,
		c = 13
	}

	line = {
		x = 63,
		y = 10,
		w = 2,
		c = 13
	}
end

function _update60()
	--player controls
	if btn(⬆️)
			and player.y >= court.top + 2 then
		player.y -= player.speed
	end
	if btn(⬇️)
			and player.y + player.h < court.bottom then
		player.y += player.speed
	end

	--computer controls
	mid_comp = comp.y + (comp.h / 2)

	if ball.dx > 0 then
		if mid_comp > ball.y
				and comp.y >= court.top + 2 then
			comp.y -= comp.speed
		end
		if mid_comp < ball.y
				and comp.y + comp.h < court.bottom then
			comp.y += comp.speed
		end
	else
		if mid_comp > court.bottom - 48 then
			comp.y -= comp.speed
		end
		if mid_comp < court.top + 48 then
			comp.y += comp.speed
		end
	end

	--collide with comp
	if ball.dx > 0
			and ball.x + ball.w >= comp.x
			and ball.x + ball.w <= comp.x + comp.w
			and ball.y + ball.w > comp.y
			and ball.y < comp.y + comp.h then
		ball.dx = -(ball.dx + ball.speedup)
		print "\ac"
	end

	--collide with player
	if ball.dx < 0
			and ball.x >= player.x
			and ball.x <= player.x + player.w
			and ball.y + ball.w > player.y
			and ball.y < player.y + player.h then
		if btn(⬆️) then
			if ball.dy > 0 then
				ball.dy = -ball.dy
				ball.dy -= ball.speedup * 2
			else
				ball.dy -= ball.speedup * 2
			end
		end
		if btn(⬇️) then
			if ball.dy < 0 then
				ball.dy = -ball.dy
				ball.dy += ball.speedup * 2
			else
				ball.dy += ball.speedup * 2
			end
		end
		ball.dx = -(ball.dx - ball.speedup)
		print "\ag"
	end

	--collide with court
	if ball.y + ball.w >= court.bottom
			or ball.y <= court.top + 1 then
		ball.dy = -ball.dy
		print "\ae"
	end

	--score
	if ball.x > court.right then
		player_points += 1
		print "\ac..e..g"
		_init()
	end
	if ball.x < court.left then
		comp_points += 1
		print "\ag..e..c"
		_init()
	end

	--ball movement
	ball.x += ball.dx
	ball.y += ball.dy
end

function _draw()
	cls()

	--court
	rect(
		court.left,
		court.top,
		court.right,
		court.bottom,
		court.c
	)

	--dashed line
	repeat
		rrect(
			line.x,
			line.y,
			line.w,
			line.w,
			line.r,
			line.c
		)
		line.y += line.w * 2
	until line.y > court.bottom
	line.y = court.top

	--ball
	rrectfill(
		ball.x,
		ball.y,
		ball.w,
		ball.w,
		ball.r,
		ball.c
	)

	--player
	rrectfill(
		player.x,
		player.y,
		player.w,
		player.h,
		player.r,
		player.c
	)

	--computer
	rrectfill(
		comp.x,
		comp.y,
		comp.w,
		comp.h,
		comp.r,
		comp.c
	)

	--scores
	print(player_points, player.x, 2, player.c)
	print(comp_points, comp.x, 2, comp.c)

	--title
	print("pico-pong!", 46, 2, 7)
end
