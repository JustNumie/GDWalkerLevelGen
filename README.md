# GDWalkerLevelGen

**GDWalkerLevelGen** is a procedural level generation system for **Godot 4.4.1**, written in **GDScript**. It creates dungeon-like layouts inspired by *Nuclear Throne*, using a "walker" algorithm that simulates agents moving through a grid to carve out floors.

This project is inspired by [skylarbeaty/ProceduralGenerationOfNuclearThrone](https://github.com/skylarbeaty/ProceduralGenerationOfNuclearThrone).

## Previews

![image](https://github.com/user-attachments/assets/bd5da5f2-0719-4ea4-971d-8ecb837c3e0e)
![image](https://github.com/user-attachments/assets/b18c579a-ee84-4c22-944f-f22c5936f993)
![image](https://github.com/user-attachments/assets/1059d313-a91d-4ce9-adc0-17f7114ff626)

## Features

- Walker-based floor generation
- Dynamic spawning, direction change, and destruction of walkers
- Auto-generated walls with cleanup of isolated wall tiles
- Easy-to-tweak parameters
- TileMap support for visualization

## Getting Started

1. Open the project in **Godot 4.4.1**
2. Make sure the scene contains a `Node2D` with a `TileMap` node named `"TileMapLayer"`
3. Run the scene to see a generated level

## Configuration Parameters

You can customize generation by changing the following exported variables in the script:

- `room_width`, `room_height`: Room size
- `chance_walker_change_dir`: How often walkers change direction
- `chance_walker_spawn`: Chance of spawning a new walker
- `chance_walker_destroy`: Chance of removing a walker
- `max_walkers`: Max number of walkers at once
- `percent_to_fill`: Percent of the map to fill with floors
- `amount_of_iterations`: Upper limit of generation steps

## License

This project is licensed under the **MIT** license.

See the [`LICENSE`](LICENSE) file for details.

## Credits

Based on the ideas in [skylarbeaty/ProceduralGenerationOfNuclearThrone](https://github.com/skylarbeaty/ProceduralGenerationOfNuclearThrone)

## Contributing

Pull requests and suggestions are welcome!
