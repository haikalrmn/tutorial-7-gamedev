extends Interactable

var moving:bool = false
var body: KinematicBody

func interact(body: KinematicBody):
	if body.name == "Player":
		moving = !moving
		if moving:
			self.body = body
	
func _physics_process(delta):
	if moving:
		var camera = body.get_node('Head/Camera') as Camera
		(camera.get_node('Label3D') as Label3D).text = "Held item: Lamp"
		self.global_transform = camera.global_transform.translated(Vector3(3, 0, -3))
		
