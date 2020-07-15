extends CoolDownActionSpot

func execute(player):
	get_parent().get_node("ItemSpawner").spawn_item("WoodBlock")
