# scope_tracker_171223

## Overview

A tank battle game where you write code that controls your tank automatically. Battle in bracketed tournaments or all-out brawls against other tanks.

## Play space

Play is confined to a 3-dimensional battle area with pseudorandom spawn points.
This arena will be defined by an ascii text file either at runtime or in the editor.

## How to Play

Create a script that inherits from the 'Agent' class.
This parent class has all the functions and fields required to control your tank.

## Tank Functions and Fields

### Available Fields

#### name: String

#### owner: String

#### color: Color

#### chassis_position: Vector2

#### chassis_rotation: float

#### chassis_linear_velocity: Vector2

#### chassis_angular_velocity: float

#### turret_rotation: Vector2

#### turret_angular_velocity: Vector2

#### scanner_rotation: float

#### scanner_angular_velocity: float

#### gun_heat: float

#### current_hp: float

#### reloading: bool

#### overheat: bool

#### can_shoot: bool

### Available Functions

#### shoot(power: float): void

#### drive(direction: float): void

- drive the tank forward and backward
  - direction: a float clamped between -1 and 1 that determines if the tank drives forward or backward

#### turn(direction: float): void

- turn the tank left and right
  - direction: a float clamped between -1 and 1 that determines if the tank turns clockwise or counter-clockwise

#### pan(direction: float): void

- turn the tank's turret left and right
  - direction: a float clamped between -1 and 1 that determines if the turret pans clockwise or counter-clockwise

#### tilt(direction: float): void

- turh the tank's turret up and down
  - direction: a float clamped between -1 and 1 that determines if the turret tilts up or down

#### scan(direction: float): void

- turn the tank's scanner left and right
  - direction: a float clamped between -1 and 1 that determines if the scanner scans clockwise or counter-clockwise

#### on_obstacle_scanned(scan_info: ScanInfo, obstacle_data: Obstacle): void

- callback triggered when the scanner detects an obstacle
  - scan_info: information about the scan that detected the obstacle such as the position
  - obstacle_data: additional data about the detected obstacle

#### on_agent_scanned(scan_info: ScanInfo, iff: int, instantaneous_id: String): void

- callback triggered when the scanner detects another tank
  - scan_info: information about the scan that detected the obstacle such as the position
  - instantaneous_id: a numeric identifier that is valid for this frame only

#### focus(instantaneous_id: int): String

- collect additional information about an entity at the cost of revealing your position to it
  - instantaneous_id: a numeric identifier received from the on_entity_scanned callback
  - return: a hexadecimal string state containing the agent's id, position, rotation, velocity, etc.

#### on_focused(source_position: Vector2): void

- callback triggered when focused by another agent
  - source_position: the position of the entity that focused you

## Tournament Setup

## Camera

## Menus

## Naming Conventions

## Casting UI

- Needs to show player names above tanks
- Needs to show tank status
  - Health
  - Gun Heat

## Arena

## Script Importing

## Tank Physics

- fixed accel and decel (linear and angular)
- does getting hit knock you around?

## Unknowns

- Should there be elevation changes in the terrain?
- Should you be able to scan up and down?
- powerups?
- environmental hazards?
