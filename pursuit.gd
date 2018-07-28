extends Node2D

var array_of_vectors = []
var curvy_line = Curve2D.new()
var curvy_vector_pool = []
var pursue_player = false
onready var flight_of_bee = $"Flight of the Bumblebee"
var music_offset = 0

func make_curvy_line_of_vectors(enemy, player):
    var prey = enemy.get_position()
    var predator = player.get_position()
    
    for i in range(0,2):
        # Create random points between the predator and the
        # prey
        var temp = predator.linear_interpolate( prey, randf() )
        var random_y = rand_range(-100.0, 100.0)
        # Randomly translate the vectors up and down the y-axis.
        temp.y += random_y
        # Append these vectors to the array of vectors.
        array_of_vectors.append(temp)
    
    # Make the first element in the vector array the position
    # of the predator
    array_of_vectors.push_front(predator)
    # Append the position of the prey at the end.
    array_of_vectors.append(prey)
    # Sort the vectors so that they are
    # in order.
    array_of_vectors.sort()
    array_of_vectors.invert()
    
    # place the points from the array of vectors
    # in the curve.
    for g in array_of_vectors:
        curvy_line.add_point(g)
    
    # Get a PoolVector2Array from the curve.
    curvy_vector_pool = curvy_line.tessellate()

# Based upon official "navigation" demo
func move_along_path(distance, predator):
    var last_point = predator.get_position()
    for thing in range( curvy_vector_pool.size() ):
        var distance_between_points = last_point.distance_to( curvy_vector_pool[0] )
        if distance <= distance_between_points and distance >= 0.0:
            predator.position = last_point.linear_interpolate( curvy_vector_pool[0], distance / distance_between_points )
            break
        elif distance < 0.0:
            predator.position = curvy_vector_pool[0]
            # I'm iffy on this part.
            set_process(false)
            break
        distance -= distance_between_points
        last_point = curvy_vector_pool[0]
        curvy_vector_pool.remove(0)

func _ready():
    randomize()

func _process(change_in_frame):
    if pursue_player:
        if curvy_vector_pool.size() == 0:
            make_curvy_line_of_vectors($bird, $player)
        var distance = 200.0 * change_in_frame
        move_along_path(distance, $bird)

func _on_area_of_detection_body_entered(body):
    if body.get_name() == "player":
        print("Pursuing player!")
        pursue_player = true
        if not flight_of_bee.is_playing():
            flight_of_bee.play(music_offset)

func _on_area_of_detection_body_exited(body):
    if body.get_name() == "player":
        print("Leaving player alone...")
        pursue_player = false
        curvy_vector_pool = []
        if flight_of_bee.is_playing():
            music_offset = flight_of_bee.get_playback_position()
            flight_of_bee.stop()
