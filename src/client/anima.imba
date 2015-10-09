import 'create-keyframe-animation' as animations

var spring = [
	[0, 60]
	[4, 34.082] 
	[7.91, 6.677]
	[11.91, -11.365]
	[15.82, -16.549]
	[20.42, -11.771]
	[24.92, -3.562] 
	[29.53, 2.418]
	[34.03, 4.156]
	[43.14, 0.879]
	[52.15, -1.044]
	[70.37, 0.262] 
	[88.59, -0.066]
	[100, 1]
]

# generate bounce effect
var bounce-up = {}, bounce-down = {}
spring.reduce((|p, c|
	bounce-up["{c[0]}%"] = [0, c[1]]
	bounce-down["{c[0]}%"] = [0, -c[1]]
	p+1)
, 0)

animations.registerAnimation({
	name: "bounce-up-1",
	animation: bounce-up,
	presets: {
		duration: 1000,
		easing: "linear"
	}
})

animations.registerAnimation({
	name: "bounce-up-2",
	animation: bounce-up,
	presets: {
		duration: 1000,
		easing: "linear"
	}
})

animations.registerAnimation({
	name: "bounce-down-1",
	animation: bounce-down,
	presets: {
		duration: 1000,
		easing: "linear"
	}
})

animations.registerAnimation({
	name: "bounce-down-2",
	animation: bounce-down,
	presets: {
		duration: 1000,
		easing: "linear"
	}
})

# generate heart fly effects
var fly-time = [0, 40, 50, 60, 80, 100]
var fly-1 = [
	[
		opacity: 0
		translate: [0, 8]
	]
	[
		opacity: 0.3
		translate: [6, -20]
	]
	[
		opacity: 0.1
		translate: [0, -30]
	]
	[
		opacity: 0.2
		translate: [2, -40]
	]
	[
		translate: [7, -50]
	]
	[
		opacity: 0
		translate: [12, -90]
	]
]

var fly-2 = [
	[
		opacity: 0
		translate: [0, 0]
	]
	[
		opacity: 0.2
		translate: [3, -20]
	]
	[
		opacity: 0.3
		translate: [8, -30]
	]
	[
		opacity: 0.2
		translate: [6, -40]
	]
	[
		translate: [5, -50]
	]
	[
		opacity: 0
		translate: [4, -80]
	]
]

var fly-3 = [
	[
		opacity: 0
		translate: [3, 0]
	]
	[
		opacity: 0.2
		translate: [8, -30]
	]
	[
		opacity: 0.35
		translate: [11, -40]
	]
	[
		opacity: 0.2
		translate: [9, -50]
	]
	[
		translate: [7, -60]
	]
	[
		opacity: 0
		translate: [5, -80]
	]
]

var fly-animation-1 = {}, fly-animation-2 = {}, fly-animation-3 = {}
fly-time.reduce((|p, c|
	fly-animation-1["{c}"] = fly-1[p][0]
	fly-animation-2["{c}"] = fly-2[p][0]
	fly-animation-3["{c}"] = fly-3[p][0]
	p+1)
, 0)

# register animations
animations.registerAnimation(
	name: "fly-1"
	animation: fly-animation-1
	presets:
		duration: 2500
		easing: "linear"
)

animations.registerAnimation(
	name: "fly-2"
	animation: fly-animation-2
	presets:
		duration: 1800
		easing: "linear"
)

animations.registerAnimation(
	name: "fly-3"
	animation: fly-animation-3
	presets:
		duration: 3300
		easing: "linear"
)

# play registered animation
export def play dom, name, cb
	animations.runAnimation(dom, name, cb)
