extends Resource
class_name Attack

enum TYPE { Bang, Sak, Stun }

@export_enum("Seeker", "Hider") var team : int
@export_enum("Bang", "Sak", "Stun") var type : int
