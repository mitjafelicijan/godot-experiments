extends OmniLight3D

enum NoiseType {
	TYPE_SIMPLEX = 0,
	TYPE_SIMPLEX_SMOOTH = 1,
	TYPE_CELLULAR = 2,
	TYPE_PERLIN = 3,
	TYPE_VALUE_CUBIC = 4,
	TYPE_VALUE = 5
}

@export_enum("Simplex", "Simplex Smooth", "Cellular", "Perlin", "Value Cubic", "Value") var noise_type: int = NoiseType.TYPE_PERLIN
@export_range(0.01, 1.0, 0.01) var noise_frequency: float = 0.2

var noise: NoiseTexture3D
var time_passed: float = 0.0

func _ready() -> void:
	noise = NoiseTexture3D.new()
	noise.noise = FastNoiseLite.new()
	noise.noise.set_noise_type(noise_type)
	noise.noise.set_frequency(noise_frequency)

func _process(delta: float) -> void:
	time_passed += delta
	var sampled_noise = abs(noise.noise.get_noise_1d(time_passed))
	light_energy = sampled_noise
