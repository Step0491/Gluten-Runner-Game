extends Label

@onready var ready_label = $"."  # This Label node
@onready var anim = $"../AnimationPlayer"
@onready var countdown_voice = $CountdownVoice
@onready var timer = $Timer  # A Timer node child of this Label node

func wait_time(seconds: float) -> void:
	timer.stop()
	timer.wait_time = seconds
	timer.start()
	await timer.timeout

func _ready() -> void:
	await wait_time(2.5)

	ready_label.text = "Are you Ready?"
	anim.play("ready_visible")
	await anim.animation_finished
	await wait_time(1)

	# ▶️ Countdown Sound
	countdown_voice.play()

	# Countdown 3
	anim.play_backwards("ready_visible")
	await anim.animation_finished
	ready_label.text = "            3"
	anim.play("ready_visible")
	await anim.animation_finished
	await wait_time(0.3)

	# Countdown 2
	anim.play_backwards("ready_visible")
	await anim.animation_finished
	ready_label.text = "            2"
	anim.play("ready_visible")
	await anim.animation_finished
	await wait_time(0.3)

	# Countdown 1
	anim.play_backwards("ready_visible")
	await anim.animation_finished
	ready_label.text = "            1"
	anim.play("ready_visible")
	await anim.animation_finished
	await wait_time(0.3)

	# GO!
	anim.play_backwards("ready_visible")
	await anim.animation_finished
	ready_label.text = "           Go!"
	anim.play("ready_visible")
	await anim.animation_finished
	await wait_time(0.3)

	anim.play_backwards("ready_visible")
