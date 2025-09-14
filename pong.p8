pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--pong

player_points = 0
comp_points = 0
scored = ""

function _init()
	--variables
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
		c = 8,
		w = 3,
		h = 12,
		r = 0,
		speed = 1
	}

	ball = {
		x = 63,
		y = 63,
		c = 7,
		w = 3,
		r = 0,
		dx = 0.6,
		dy = flr(rnd(2)) - 0.5,
		speed = 1,
		speedup = 0.05
	}

	--sound
	if scored == "player" then
		sfx(3)
	elseif scored == "comp" then
		sfx(4)
	else
		sfx(5)
	end

	--court
	c_left = 0
	c_right = 127
	c_top = 10
	c_bottom = 127

	--court line
	line_x = 63
	line_y = 10
	line_length = 4
end

function _update60()
	--player controls
	if btn(⬆️)
			and player.y > c_top + 1 then
		player.y -= player.speed
	end
	if btn(⬇️)
			and player.y + player.h < c_bottom then
		player.y += player.speed
	end

	--computer controls
	mid_comp = comp.y + (comp.h / 2)

	if ball.dx > 0 then
		if mid_comp > ball.y
				and comp.y > c_top + 1 then
			comp.y -= comp.speed
		end
		if mid_comp < ball.y
				and comp.y + comp.h < c_bottom then
			comp.y += comp.speed
		end
	else
		if mid_comp > c_bottom - 48 then
			comp.y -= comp.speed
		end
		if mid_comp < c_top + 48 then
			comp.y += comp.speed
		end
	end

	--collide with comp
	if ball.dx > 0
			and ball.x + ball.w >= comp.x
			and ball.x + ball.w <= comp.x + comp.w
			and ball.y >= comp.y
			and ball.y + ball.w <= comp.y + comp.h then
		ball.dx = -(ball.dx + ball.speedup)
		sfx(0)
	end

	--collide with player

	--collide with court
	if ball.y + ball.w >= c_bottom
			or ball.y <= c_top + 1 then
		ball.dy = -ball.dy
		sfx(2)
	end

	--score

	--ball movement
	ball.x += ball.dx
	ball.y += ball.dy
end

function _draw()
	cls()

	--court
	rect(c_left, c_top, c_right, c_bottom, 5)

	--dashed line
	repeat
		line(line_x, line_y, line_x, line_y + line_length, 5)
		line_y += line_length * 2
	until line_y > c_bottom
	line_y = c_top

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
	print(player_points, 30, 2, player.c)
	print(comp_points, 95, 2, comp.c)
end
