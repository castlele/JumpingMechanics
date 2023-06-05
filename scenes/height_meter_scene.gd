extends Node2D

const TILE_SIZE = 16.0

@export var is_config_hidden = false

@onready var player: = $Player
@onready var settingsLabel: = $SettingsLabel
@onready var settingsToggle: = $SettingsToggle

var minX = 0.0
var maxX = ProjectSettings.get_setting("display/window/size/viewport_width")


func _ready():
    show_config()

    settingsToggle.button_pressed = not is_config_hidden


func _physics_process(_delta: float):
    teleport()


func show_config():
    if is_config_hidden:
        settingsLabel.hide()
        return

    var properties = player.preferences.get_property_list().filter(Callable(self, "filter_properties"))
    var settings = create_settings(properties)

    settingsLabel.text = str(settings)
    settingsLabel.show()


func teleport():
    var pos: Vector2 = player.position

    if pos.x < minX:
        player.position.x = maxX - TILE_SIZE
    elif pos.x > maxX:
        player.position.x = minX + TILE_SIZE

# MARK: - Actions

func _on_settings_toggle_toggled(button_pressed: bool):
    is_config_hidden = not button_pressed
    show_config()

# MARK: - Helpers

func filter_properties(properties: Dictionary):
    var usage = properties["usage"]

    if not usage:
        return false

    return usage == 4102


func create_settings(properties: Array[Dictionary]) -> String:
    var preferences = player.preferences
    var settings = ""

    for p in properties:
        var pName = p["name"]
        var value = preferences.get(pName)
        settings += "%s: %s\n" % [pName, value]

    return settings
