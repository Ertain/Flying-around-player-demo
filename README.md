Flying around player demo
===

This is a little demo I whipped up to answer [this question](https://godotengine.org/qa/30656/how-to-implement-variation-in-movement-along-a-vector) in the Q&A section of the Godot Engine site.

Short description: the player is moved around by the left and right arrows. As the player moves near the flying chicken, it starts to pursue him. Under the hood, a number of `Vector2D`s are created. These are combined with a `Curve2D` and this is used to move the chicken towards the player. While the code isn't perfect, it demonstrates the idea.
