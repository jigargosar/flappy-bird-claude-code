# Flappy Bird - Development Roadmap

## Completed

1. Bird rotation animation: Bird tilts based on velocity
2. Bird sprite extraction: Separated into Sprites.elm module
3. Position bounds: Bird stays within 0-600 viewBox height
4. Theme system: 13 themes with bg/fg naming convention
5. Bird scaling: Visual size matches birdSize constant (currently 40)
6. Pipe gapY bounds: Clamped to 100-350 for playable range

## In Progress

1. Hash-based pipe variation: Replace deterministic pattern with better pseudo-random
   - Current: modBy 250 (frameCount // 10) creates predictable sawtooth
   - Target: (frameCount * 2654435761) |> modBy 250 for even distribution
   - Location: src/Main.elm line ~248-249

## Next Up

### High Priority
1. Re-enable collision detection: Uncomment line 164 when testing complete
2. Pipe visual improvements:
   - Extract to Sprites module
   - Add caps on top/bottom
   - Add decorative details (bolts, gradients)

### Medium Priority
1. Wing flap animation: Animate bird wing on jump or frame-based
2. High score tracking: localStorage persistence, show on game over
3. Sound effects: Jump, score, collision sounds

### Low Priority
1. Difficulty progression: Increase pipe speed based on score
2. Particle effects: Collision sparks, bird trail
3. Parallax background: Multi-layer scrolling

## Technical Notes

1. Coordinate system: All coordinates use viewBox (400x600), not pixel dimensions
2. Bird sprite: Designed for size 30, scales to birdSize constant
3. Collision vs bounds: Collision detection separate from position bounds
4. Grass: Decorative only, not gameplay boundary
5. Theme controls: Prevent event propagation to game (stopPropagation on click/mouse/key events)
6. Position clamping: Bird clamped to 0 <= y <= (gameHeight - birdSize) in updateBird
7. Collision disabled: Line 164 commented out for testing
8. Bird rendering: Sprites.elm renders at 0,0, Main.elm handles translate/rotate/scale transforms

## Architecture

```
src/
├── Main.elm         - Game logic, update loop, main view, position/collision
├── Sprites.elm      - Visual components (bird renders at 0,0 origin)
├── Themes.elm       - Theme definitions, getTheme function, defaultTheme
├── index.html       - Entry point
└── styles.css       - Tailwind imports
```
