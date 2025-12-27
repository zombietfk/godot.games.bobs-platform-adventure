class_name Level;
extends Node2D;

# SETTINGS
@export var level_binding_box: Rect2;
@export var spawn_locations: Array[Marker2D];
@export var camera_zoom_to: Vector2 = Vector2(1.0, 1.0);
@export var camera_zoom_speed = 0.1;
@export var pathfinding_tilemap: TileMapLayer;
var _camera_zoom_timer: float = 2.0;
var _c_camera_zoom_timer: float = 0;
var astar_pathfinding_grid: AStarGrid2D;

# LIFECYCLE
func _ready()->void:
	if !pathfinding_tilemap:
		for c in get_children():
			if c is TileMapLayer:
				pathfinding_tilemap = c;
	if pathfinding_tilemap:
		astar_pathfinding_grid = AStarGrid2D.new()
		_setup_astar();

func _process(delta: float) -> void:
	if Main.instance.player.camera.zoom != camera_zoom_to:
		_c_camera_zoom_timer += delta * camera_zoom_speed;
		Main.instance.player.camera.zoom = (
			lerp(
				Main.instance.player.camera.zoom,
				camera_zoom_to,
				_c_camera_zoom_timer / _camera_zoom_timer
			)
		);
		if _c_camera_zoom_timer >= _camera_zoom_timer:
			Main.instance.player.camera.zoom = camera_zoom_to;

func _setup_astar():
	astar_pathfinding_grid.region = pathfinding_tilemap.get_used_rect();
	astar_pathfinding_grid.cell_size = pathfinding_tilemap.tile_set.tile_size;
	astar_pathfinding_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES;
	astar_pathfinding_grid.offset = pathfinding_tilemap.tile_set.tile_size / 2;
	astar_pathfinding_grid.update();
	for cell in pathfinding_tilemap.get_used_cells():
		var tile_data = pathfinding_tilemap.get_cell_tile_data(cell);
		if tile_data and tile_data.get_collision_polygons_count(
			0
		) > 0:
			astar_pathfinding_grid.set_point_solid(cell, true);
			
func find_path(from: Vector2, to: Vector2):
	var from_node = pathfinding_tilemap.local_to_map(
		pathfinding_tilemap.to_local(from)
	);
	var to_node = pathfinding_tilemap.local_to_map(
		pathfinding_tilemap.to_local(to)
	);
	if !astar_pathfinding_grid.is_in_boundsv(from_node):
		push_warning('Unable to find path, from_node, is OOB');
		return []
	if !astar_pathfinding_grid.is_in_boundsv(to_node):
		push_warning('Unable to find path, to_node, is OOB');
		return []
	var output: PackedVector2Array = [];
	for n in astar_pathfinding_grid.get_point_path(from_node, to_node):
		output.append(
			pathfinding_tilemap.to_global(
				n
			)
		);
	return output;
