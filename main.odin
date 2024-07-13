package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

Player :: struct {
	pos:     rl.Vector2,
	vel:     rl.Vector2,
	speed:   f32,
	texture: rl.Texture2D,
}

Gun :: struct {
	vel:     rl.Vector2,
	speed:   f32,
	texture: rl.Texture2D,
}

Bullet :: struct {
    speed: f32,
    texture: rl.Texture2D,
    vel: rl.Vector2,
    pos: rl.Vector2,
}

main :: proc() {
	rl.InitWindow(1280, 720, "")

	player := Player {
		speed   = 400.0,
		texture = rl.LoadTexture("Assets/Art/player.png"),
		pos     = {0, 0},
		vel     = {0, 0},
	}

    bullet := Bullet {
        speed = 1000.0,
        texture = rl.LoadTexture("Assets/Art/bullet.png")
    }

	cam := rl.Camera2D {
		offset = {f32(rl.GetScreenWidth() / 2), f32(rl.GetScreenHeight() / 2)},
		zoom   = 0.5,
		target = player.pos,
	}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.BeginMode2D(cam)
		rl.ClearBackground({150, 190, 220, 225})

		// move player horizontally
		if (rl.IsKeyDown(.A)) {
			player.vel.x = -1
		} else if (rl.IsKeyDown(.D)) {
			player.vel.x = 1
		} else {
			player.vel.x = 0
		}

		// move player vertically 
		if (rl.IsKeyDown(.W)) {
			player.vel.y = -1
		} else if (rl.IsKeyDown(.S)) {
			player.vel.y = 1
		} else {
			player.vel.y = 0
		}

		// normalize player velocity
		if (player.vel.y != 0 || player.vel.x != 0) {
			player.vel = rl.Vector2Normalize(player.vel)
		}

		player.pos += player.vel * player.speed * rl.GetFrameTime()

        // calculate the players look direction
		mousePos := rl.GetScreenToWorld2D(rl.GetMousePosition(), cam)
		lookDir := player.pos - mousePos
		angle := math.atan2_f32(lookDir.y, lookDir.x)
		angle_in_degrees := math.to_degrees_f32(angle) - 90

        srcRect := rl.Rectangle{0, 0, f32(player.texture.width), f32(player.texture.height)}

        // Center the destination rectangle around the player's position
        dstRect := rl.Rectangle {
            player.pos.x - f32(player.texture.width) * 0.5,
            player.pos.y - f32(player.texture.height) * 0.5,
            f32(player.texture.width),
            f32(player.texture.height),
        }

        // Set the origin to the center of the texture
        player_origin := rl.Vector2{f32(player.texture.width) * 0.5, f32(player.texture.height) * 0.5}

        if (rl.IsMouseButtonPressed(.LEFT)) {
            // TODO: shoot
        }

        rl.DrawTexturePro(player.texture, srcRect, dstRect, player_origin, angle_in_degrees, rl.WHITE)

		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
