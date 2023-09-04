# family initialising.gd
extends State

# This state doesn't do anything and is only needed because the StateMachine requires
# an intial state when instantiated. This game implementation is structured such that
# game objects are usually instantiated and initialised via the LevelManager, not via
# the initial state of the object.
