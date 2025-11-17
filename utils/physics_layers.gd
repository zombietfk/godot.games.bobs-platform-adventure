class_name PhysicsLayers;

enum NAMES {
	ACTORS_1 = 1, # Player Layer
	ACTORS_2 = 2, # Enemies Layer
	ACTORS_3 = 3, # Nonhostile Layer
	OBJECTS_1 = 4, # Player-Interactable Objects
	OBJECTS_2 = 5, # Enemy-Interactable Objects
	OBJECTS_3 = 6, # Other Objects
	LEVEL_1 = 7, # Standard Level Features
	LEVEL_2 = 8, # One-Way Level Features
	LEVEL_3 = 9, # Only Player Blocking Level Features
	LEVEL_4 = 13, # Only Enemy Blocking Level Features
	FATAL_1 = 10, # Fatal To Player Only
	FATAL_2 = 11, # Fatal To Players And Enemies
	FATAL_3 = 12, # Fatal Only to Enemies
};
