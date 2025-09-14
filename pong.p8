pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--pong

player_points = 0
comp_points = 0

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
		c = 14,
		w = 3,
		h = 12,
		r = 0,
		speed = 0.5
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

	--court
	c_left = 0
	c_right = 127
	c_top = 10
	c_bottom = 127

	--court line
	line_x = 63
	line_y = 10
	line_length = 2
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
		print "\ac"
	end

	--collide with player
	if ball.dx < 0
			and ball.x >= player.x
			and ball.x <= player.x + player.w
			and ball.y >= player.y
			and ball.y + ball.w <= player.y + player.h then
		--control ball dy if hit and press up or down
		if btn(⬆️) then
			if ball.dy > 0 then
				--ball moves down
				ball.dy = -ball.dy
				ball.dy -= ball.speedup * 2
			else
				--ball moves up
				ball.dy -= ball.speedup * 2
			end
		end
		if btn(⬇️) then
			if ball.dy < 0 then
				--ball moves up
				ball.dy = -ball.dy
				ball.dy += ball.speedup * 2
			else
				--ball moves down
				ball.dy += ball.speedup * 2
			end
		end
		--flip ball dx and add speed
		ball.dx = -(ball.dx - ball.speedup)
		print "\ag"
	end

	--collide with court
	if ball.y + ball.w >= c_bottom
			or ball.y <= c_top + 1 then
		ball.dy = -ball.dy
		print "\ae"
	end

	--score
	if ball.x > c_right then
		player_points += 1
		print "\ac..e..g"
		_init()
	end
	if ball.x < c_left then
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
	rect(c_left, c_top, c_right, c_bottom, 13)

	--dashed line
	repeat
		rrect(line_x, line_y, line_length, line_length, 0, 13)
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
	print(player_points, player.x, 2, player.c)
	print(comp_points, comp.x, 2, comp.c)

	--title
	print("pico-pong!", 46, 2, 7)
end
