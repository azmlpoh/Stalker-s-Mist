import flixel.math.FlxBasePoint;
import funkin.backend.MusicBeatState;

public var doCameraMove = true;

public var cameraFocusPos = {
	x:null,
	y:null
};

public var cameraTargetNum = 0;

public var cameraMoveStrength = 15;
var cameraOffset = new FlxBasePoint();

public var cameraDoAngles = false;
public var cameraAngleStrength = 1;
public var cameraAngleLerp = 0.05;

public var camGameAngle = 0;

public var targetCustom:Character = null;

public var cameraOffsets = {
	x:0,
	y:0
};

var anims = [
//  "animName" => {x:0, y:0, angle:0}
	"left" => {x:-1, angle:-1},
	"down" => {y:1},
	"up" => {y:-1},
	"right" => {x:1, angle:1}
];

var excludeAnims = [
	"danceLeft",
	"danceRight"
];

public var cameraStartPos;
public var startSnapCam;

public function snapCamera(sprite)
{
	camGame.scroll.x = sprite.x - camGame.deadzone.x;
	camGame.scroll.y = sprite.y - camGame.deadzone.y;
}

var tweenCam;
public function stopCameraTween() if (tweenCam != null) tweenCam.cancel();

public function tweenCamera(pos, length, options)
{
	var op = options;
	op.onUpdate = {function func(){snapCamera(camFollow);}};
	op.onStart = {function func(){camFollow.setPosition(camGame.scroll.x + camGame.deadzone.x, camGame.scroll.y + camGame.deadzone.y);}};
	stopCameraTween();
	tweenCam = FlxTween.tween(camFollow, pos, length, op);
}

function create() if (startSnapCam == null) startSnapCam = !MusicBeatState.skipTransIn;

function create()
{
	if (startSnapCam)
	{
		var char = strumLines.members[curCameraTarget].characters[cameraTargetNum];
		if (cameraStartPos == null) cameraStartPos = char.getCameraPosition();
		snapCamera(cameraStartPos);
	}
}

function onCameraMove(camEvent)
{
	if (cameraFocusPos != null)
	{
		if (cameraFocusPos.x != null) camEvent.position.x = cameraFocusPos.x;
		if (cameraFocusPos.y != null) camEvent.position.y = cameraFocusPos.y;
	}
	var char = camEvent.strumLine.characters[cameraTargetNum];
	if (targetCustom != null) char = targetCustom;
	if (char != null && doCameraMove)
	{
		var charAnim = char.animation.name;
		var angleGame = 0;
		cameraOffset.set(0, 0);
		if (!excludeAnims.contains(charAnim)) for (curAnim in anims.keys()) if (StringTools.contains(charAnim.toLowerCase(), curAnim.toLowerCase()))
		{
			offsets = anims.get(curAnim);
			cameraOffset.set(offsets.x * cameraMoveStrength, offsets.y * cameraMoveStrength);
			if (cameraDoAngles) angleGame = offsets.angle;
		}
		camEvent.position.x += cameraOffset.x;
		camEvent.position.y += cameraOffset.y;
		FlxG.camera.angle = lerp(FlxG.camera.angle, camGameAngle + cameraAngleStrength * angleGame, cameraAngleLerp);
	};
	else camEvent.cancel();
}