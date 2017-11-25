{DeviceOrientationManager} = require "DeviceOrientationManager"
orientationManager = new DeviceOrientationManager
Screen.backgroundColor = "28affa"

{ mapboxgl } = require "npm"

#mapSetup
mapLayer = new Layer
	height: Screen.height
	width: Screen.width
	parent:nullLayer

mapLayer.html = "<div id='map'></div>"
mapLayer.ignoreEvents = false
mapElement = mapLayer.querySelector("#map")
mapElement.style.height = Screen.height + 'px'

# Set your Mapbox access token here
mapboxgl.accessToken = 'pk.eyJ1Ijoia2V5dXJqYWluMjEiLCJhIjoiY2lpamk4eWl5MDEycXVka242bTB5aXk5MCJ9.YwZqFTtsJKymb8vAENy3wA'


map = new mapboxgl.Map
	container: mapElement
	zoom: 13
	center: [12.608,55.680]
# 	style: 'mapbox://styles/keyurjain21/cj9n6g9zf36wv2slnar5m3vxd'
	style: 'mapbox://styles/keyurjain21/cja64usxb45mc2qlj8kfw8nuq'





coordinates = {latitude : 55.679, longitude : 12.579}
success = (p) ->
	coordinates.latitude = p.coords.latitude
	coordinates.longitude = p.coords.longitude
# 	print coordinates
	locationCircle.backgroundColor="rgba(0,255,0,0.5)"
	
	return

error = (msg) ->
#   print "error"
  locationCircle.backgroundColor="rgba(255,0,0,0.3)"


locationCircle.onTap (event, layer) ->
	navigator.geolocation.getCurrentPosition(success, error)
	Utils.delay 1, ->
		map.flyTo({center: [coordinates.longitude, coordinates.latitude]});



	
#distance
distance = (originCoordinates, destinationCoordinates) ->
	degToRad = Math.PI / 180
	lat1 = originCoordinates.latitude
	lon1 = originCoordinates.longitude
	
	lat2 = destinationCoordinates.latitude
	lon2 = destinationCoordinates.longitude
	
	R = 6371000 # metres
	
	φ1 = lat1 * degToRad
	φ2 = lat2 * degToRad
	Δφ = (lat2-lat1) * degToRad
	Δλ = (lon2-lon1) * degToRad
	a = Math.sin(Δφ/2) * Math.sin(Δφ/2) + Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ/2) * Math.sin(Δλ/2)
	c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
	d = R * c
	return d

# heading
heading = (originCoordinates, destinationCoordinates) ->
	degToRad = Math.PI / 180

	lat1 = originCoordinates.latitude * degToRad
	lon1 = originCoordinates.longitude * degToRad
	lat2 = destinationCoordinates.latitude * degToRad
	lon2 = destinationCoordinates.longitude * degToRad

	angle = Math.atan2(Math.sin(lon2 - lon1) * Math.cos(lat2), Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1))
	headingAngle = angle * 180 / Math.PI
	headingAngle += 360 if headingAngle < 0
	return headingAngle

# Section 2



# errorText = new TextLayer
# 	color: "black"
# 	textAlign: "center"
# 	fontSize: 30
# 	opacity:1



rotationNormalizer = Utils.rotationNormalizer()

orientationManager.onOrientationChange (data) ->
	compassHeading = data.compassHeading
	compassHeading *= -1 if data.elevation < 0
	NorthAngle = rotationNormalizer(compassHeading)

	
	r=Math.floor(data.compassHeading)
	
	if r<=180
		b = -r
	else b=360-r
	
# 	errorText.html = b

	r=200
	if Math.abs(b) > 60
		pulseparent.opacity=1

	else
		pulseparent.opacity=0


	disk.animate
		properties: rotation: NorthAngle
		time: 0.1

	opacityVal= Utils.modulate(Math.abs(b),[0,60],[0,1])
	overlay.opacity=opacityVal

pulseUp = new Animation
	layer: pulse
	properties:
		scale: 1.03
		opacity: .7
	time: 1.5
 
shrink = new Animation
	layer: pulse
	properties: 
		scale: 1.01
		opacity: .2
	time: 1
 
# Alternate between the two animations 
pulseUp.on(Events.AnimationEnd, shrink.start)
shrink.on(Events.AnimationEnd, pulseUp.start)
 
pulseUp.start()

