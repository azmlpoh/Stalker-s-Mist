public var camVideo = new FlxCamera();
camVideo.visible = false;
camVideo.bgColor = null;
FlxG.cameras.remove(camHUD, false);
FlxG.cameras.add(camVideo, false);
FlxG.cameras.add(camHUD, false);

public var camNotes = new HudCamera();
camNotes.bgColor = null;
var defaultNoteZoom = 1;
public var camNoteZoomLerp = 0.05;
camNotes.zoom = defaultNoteZoom;
FlxG.cameras.add(camNotes, false);

camGame.bgColor = null;

function create()
{
	for (strumLine in strumLines) strumLine.cameras = [camNotes];
}

function update()
{
	camNotes.downscroll = downscroll;
	if (camZooming)
	{
		camNotes.zoom = lerp(camNotes.zoom, defaultNoteZoom, camNoteZoomLerp);
	}
}

function beatHit(curBeat)
{
	if (Options.camZoomOnBeat && camZooming && curBeat % camZoomingInterval == 0)
	{
		camNotes.zoom += 0.03 * camZoomingStrength;
	}
}