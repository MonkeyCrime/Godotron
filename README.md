# Godotron 2024
###### A Godot 4.1 learning project
![Intro Screen](/art/github_title.png)

## Intro
This game is my rendition of [Robotron 2084](https://en.wikipedia.org/wiki/Robotron:_2084), originally written by Eugene Jarvis and Larry DeMar in 1982 for Williams Electronics, Inc. They took 6 months to write the arcade game. I tried to do mine in 6 weeks with a hard deadline as a way of learning Godot. It was an enjoyable experience.

## Design Notes
I've tried to capture the feel of the game without being a perfectionist in every aspect. If you're looking for an arcade-quality clone please try MAME. The current build differs in many areas:
- Not all enemies are implemented. Tank and Brain robotrons are left as an exercise for the reader.
- Sound is not implemented at all. Again, left as an exercise for the reader.
- The difficulty model is my own interpretation and in no way reflects that of the original game.

I've tried to follow Godot best practice; there are many areas that highlight my inexperience with the engine (hey, it's my first time with Godot):
- AnimationTrees - I should have used this instead of using Sprite2D and AnimationPlayer.
- Collision detection - I'm not happy with the mixture of disabling CollisionShape2D and CollisionLayers. It shows an incomplete understanding of both systems.
- UI - A lot of learning to do here.

![In Game Screen](/art/github_ingame.png)

## Next Steps
If I were to continue with the game I would probably:
- Implement Tank robotrons first. The support is already there for limiting the maximum number of projectiles on screen via the level_manager.
- Implement Brain robotrons next. A lot more complex, given they hunt down humans and turn them into Progs, however the state machine implementation should help this.
- Add high score tables. I really like [Loot Locker](https://www.lootlocker.com), however I'm not across their latest pricing restructure and what it means.
- Add power-ups. Basically ripping off the power-up model from Smash TV I suppose.
- Still a few bugs left (family characters don't have their alpha set correctly some times), suspect multiple collisions from Enforcer projectiles can take more than one life from the player.
- Difficulty tuning

## Thanks
- The entire Godot team. I found the engine really accessible after using Unity and it was quick to get things up and running.
- The State design pattern at Godot Docs was well worth the effort of retro-fitting. Adding new enemies and behaviours became very simple after this.
- People I work with for keeping me motivated
- Everyone who makes tutorial videos. Right now I'm inspired by [DevDuck](https://www.youtube.com/@DevDuck) and [BiteMe Games](https://www.youtube.com/@bitemegames)
