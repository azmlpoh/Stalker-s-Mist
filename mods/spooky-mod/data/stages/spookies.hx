import hxvlc.flixel.FlxVideoSprite;
import funkin.editors.charter.Charter;
import openfl.display.BlendMode;

var gameoverCharImg = "deathfog";

curCameraTarget = 1;

maxCamZoom = 9;

var glitchShader;
var lineShader;
var chromShader;
var contrastShader;
var warpShader;
if (Options.gameplayShaders)
{
	glitchShader = new CustomShader("glitch");
	glitchShader.MODE = 4;
	glitchShader.gps = 15;
	glitchShader.GLITCH_THR = 1;
	glitchShader.GLITCH_RECT_DIVISION = 0.001;
	glitchShader.GLITCH_RECT_ITR = 0.01;
	
	lineShader = new CustomShader("lines");
	lineShader.glitchAmplitude = 0;
	lineShader.glitchNarrowness = 25;
	lineShader.glitchBlockiness = 2;
	lineShader.glitchMinimizer = 0.1;
	
	chromShader = new CustomShader("chromaticAberration");
	var chromIntens = 0.0015;
	chromShader.redOff = [chromIntens, 0];
	chromShader.blueOff = [-chromIntens, 0];
	
	contrastShader = new CustomShader("contwast");
	contrastShader.contrast = 1;
	contrastShader.brightness = 0;
	contrastShader.saturation = 1;
	
	warpShader = new CustomShader("warp");
	warpShader.distortion = 0.5;
}

var legOffsets = {
	x:45,
	y:465
};

var videoSprite = new FlxVideoSprite();
videoSprite.load(Assets.getPath(Paths.video("Spooky_Shitters")));
videoSprite.bitmap.onFormatSetup.add(function() {
	videoSprite.setGraphicSize(FlxG.width, FlxG.height);
	videoSprite.screenCenter();
});
add(videoSprite);

var videoStartTime = 123183.946488294;

var fuckinTweens = [];

var warpVal;
public function tweenWarp(value, length, options) if (Options.gameplayShaders)
{
	if (fuckinTweens[0] != null) fuckinTweens[0].cancel();
	fuckinTweens[0] = FlxTween.num(warpVal, value, length, options, (val:Float) -> {
		warpVal = val;
		warpShader.distortion = warpVal;
	});
}

var chromVal;
public function tweenChrom(value, length, options) if (Options.gameplayShaders)
{
	if (fuckinTweens[1] != null) fuckinTweens[1].cancel();
	fuckinTweens[1] = FlxTween.num(chromVal, value, length, options, (val:Float) -> {
		chromVal = val;
		chromShader.redOff = [chromVal, 0];
		chromShader.blueOff = [-chromVal, 0];
	});
}

var JUMPSCAREAAA = new FunkinSprite().loadGraphic(Paths.image("stage/jumpscare1"));
JUMPSCAREAAA.scrollFactor.set();
JUMPSCAREAAA.zoomFactor = 0;
JUMPSCAREAAA.visible = false;

function maxHP() if (PlayState.opponentMode) health = 0;
else health = maxHealth;

function create()
{
	preLoadedSprites.add(gameovaimg = new FlxSprite().loadGraphic(Paths.image("characters/" + gameoverCharImg)));
	gameovaimg.visible = false;
	preLoadedSprites.add(jumpscarePreload = new FlxSprite().loadGraphic(Paths.image("stage/jumpscare2")));
	jumpscarePreload.visible = false;
}

var bgSpeeds = [
	-325,
	-400,
	-500
];
function postCreate()
{
	GameOverSubstate.script = "data/scripts/gameover";

	videoSprite.cameras = [camVideo];

    fade.blend = BlendMode.MULTIPLY;

	for (i in [realTrees, p2bg1, dad, bgfinale, healthBar, healthBarBG, iconP1, iconP2]) i.visible = false;
	for (i in [fade]) i.updateHitbox();
	for (i=>bg in [bg1, bg1ex, bg2, bg2ex, fog, fogex])
	{
		bg.moves = true;
		bg.velocity.x = bgSpeeds[Math.floor(i/2)];
		bg.x = bg.width * i%2;
	}
	for (cam in [camGame, camVideo]) for (shader in [contrastShader, chromShader, warpShader, lineShader]) cam.addShader(shader);

	for (cam in [camHUD, camNotes]) cam.alpha = 0;

	maxHealth = 1;
	maxHP();

	strumLines.members[0].visible = false;
	add(JUMPSCAREAAA);
}

var shaderTime = 0;
function postUpdate(elapsed)
{
	if (boyfriend.curCharacter == "notbf" && boyfriend.visible)
	{
		legs.setPosition(boyfriend.x + legOffsets.x, boyfriend.y + legOffsets.y);
		legs.visible = true;
		if (boyfriend.animation.curAnim.name == "idle")
		{
			boyfriend.animation.curAnim.paused = true;
			boyfriend.animation.curAnim.curFrame = legs.animation.curAnim.curFrame;
		}
	}
	else legs.visible = false;

	if (dad.curCharacter == "monsterfinal" && dad.visible)
	{
		mlegs.setPosition(dad.x + legOffsets.x, dad.y + legOffsets.y);
		mlegs.visible = true;
		if (dad.animation.curAnim.name == "idle")
		{
			dad.animation.curAnim.paused = true;
			dad.animation.curAnim.curFrame = mlegs.animation.curAnim.curFrame;
		}
	}
	else mlegs.visible = false;

	for (i in [bg1, bg1ex, bg2, bg2ex, fog, fogex]) if (i.x < -i.width) i.x = i.x+i.width*2;

	if (Options.gameplayShaders)
	{
		var sat = health/maxHealth;
		if (PlayState.opponentMode) sat = -sat + 1;
		if (sat <= 1) contrastShader.saturation = sat;
		else contrastShader.saturation = 1;
	
		shaderTime += elapsed;
		for (shader in [lineShader, glitchShader]) shader.iTime = shaderTime;
	}
}

function video()
{
	if (Options.gameplayShaders) contrastShader.brightness = 0;
	else camGame.alpha = 1;
	camGame.visible = false;
	camVideo.visible = true;
	videoSprite.play();
	if (PlayState.chartingMode && Charter.startHere && Charter.startTime > videoStartTime) videoSprite.bitmap.time = Charter.startTime - videoStartTime;
	vocals.volume = 1;
	maxHP();
	if (camNotesTween != null) camNotesTween.cancel();
	for (cam in [camHUD, camNotes]) cam.alpha = 0;
}

function videoend() {camVideo.visible = false; camGame.visible = true; remove(videoSprite);}

function resumeVideo()
{
	videoSprite.resume();
	videoSprite.bitmap.time = Conductor.songPosition - videoStartTime;
}

function onSubstateOpen()
{
	videoSprite.pause();
}

function onSubstateClose() if (camVideo.visible)
{
	resumeVideo();
}

function onPlayerHit(event)
{
	event.showRating = false;
}

var bfTween;
function onSongStart()
{
	var pos = boyfriend.x;
	boyfriend.x -= 1800;
	snapCamera(boyfriend.getCameraPosition());
	bfTween = FlxTween.tween(boyfriend, {x:pos}, 10, {ease: FlxEase.quadOut});
	var zom = defaultCamZoom;
	defaultCamZoom = 0.8;
	camGame.zoom = defaultCamZoom;
	defaultCamZoom = zom;
}

var camNotesTween;
function showNotes()
{
	if (camNotesTween != null) camNotesTween.cancel();
	camNotesTween = FlxTween.tween(camNotes, {alpha:1}, 1, {ease: FlxEase.quadOut});
}

function hideNotes()
{
	if (camNotesTween != null) camNotesTween.cancel();
	camNotesTween = FlxTween.tween(camNotes, {alpha:0}, 1, {ease: FlxEase.quadOut});
}

function blackScreen() camGame.visible = false;

function trans1()
{
	for (bg in [bg1, bg1ex, bg2, bg2ex, fog, fogex]) bg.velocity.x = 0;
	legs.animation.curAnim.paused = true;

	doCameraMove = false;
	tweenCamera({x:-550, y:boyfriend.getCameraPosition().y}, 1, {ease: FlxEase.quintIn, startDelay:0.5});
	tweenChrom(0.01, 2.6, {ease: FlxEase.quintIn});
	tweenWarp(3, 2.6, {ease: FlxEase.quintIn});
}

function monsterShow()
{
	FlxTween.tween(monsterstart, {alpha:1}, 0.1);
	monsterstart.playAnim("idle");
	camZooms = "p2";
	camTarget(0);
}

function p2()
{
	strumLines.members[0].visible = true;
	for (bg in [bg1, bg2, fog, bg1ex, bg2ex, fogex, legs, fade, monsterstart]) remove(bg);
	for (i in [p2bg1, dad]) i.visible = true;
	stopCameraTween();
	doCameraMove = true;
	if (bfTween != null) bfTween.cancel();
	boyfriend.setPosition(1850, 1150);
	tweenChrom(0.0015, 2, {ease: FlxEase.quintOut});
	tweenWarp(0.5, 2, {ease: FlxEase.quintOut});
	snapCamera(dad.getCameraPosition());
	camGame.visible = true;
	camZooms = "p2";
	camTarget(1);
	camHUD.alpha = 1;
}

function prep3()
{
	tweenChrom(0.03, 0.3, {ease: FlxEase.expoIn});
	tweenWarp(1.5, 0.3, {ease: FlxEase.expoIn});
}

function p3()
{
	for (bg in [p2bg1]) remove(bg);
	for (i in [realTrees]) i.visible = true;
	if (bfTween != null) bfTween.cancel();
	boyfriend.setPosition(900, 275);
	dad.setPosition(0, -100);
	defaultCamZoom = 0.85;
	cameraMoveStrength = 20;
	cameraFocusPos = {
		x:realTrees.width/2,
		y:realTrees.height/2
	};
	snapCamera(cameraFocusPos);
	camZooms = null;
	tweenChrom(0.0015, 2, {ease: FlxEase.quintOut});
	tweenWarp(0.5, 2, {ease: FlxEase.quintOut});
}

function p3Darken()
{
	if (Options.gameplayShaders) contrastShader.brightness = -0.75;
	else camGame.alpha = 0.25;
	if (camNotesTween != null) camNotesTween.cancel();
	camNotes.alpha = 0.5;
	camHUD.alpha = 0;
}

function tvScreams()
{
	tweenChrom(0.05, 0.3, {ease: FlxEase.expoIn, onComplete: function(){
		tweenChrom(0.025, 2, {ease: FlxEase.sineOut});
	}});
	tweenWarp(4, 0.3, {ease: FlxEase.expoIn, onComplete: function(){
		tweenWarp(2, 2, {ease: FlxEase.sineOut});
	}});
}

function p4()
{
	legOffsets = {
		x:150,
		y:350
	};
	for (i in [realTrees]) remove(i);
	for (i in [bgfinale, mlegs]) i.visible = true;
	dad.setPosition(150, 200);
	boyfriend.setPosition(1000, 200);
	cameraFocusPos = null;
	camZooms = "p4";
	camTarget(0);
	tweenChrom(0.005, 2, {ease: FlxEase.quintOut});
	tweenWarp(1, 2, {ease: FlxEase.quintOut});
	camShakeStrength = 5;
	smolCamShake = true;
	for (i in [dad, mlegs]) i.shader = glitchShader;
	if (Options.gameplayShaders) lineShader.glitchAmplitude = 0.01;
	camHUD.alpha = 1;

	doTheFuckingTweens();
}

function doTheFuckingTweens()
{
	fuckinTweens[49] = FlxTween.tween(boyfriend, {x:boyfriend.x + 75}, 1.5, {type:4, ease: FlxEase.sineInOut, startDelay:0.75});
	fuckinTweens[8] = FlxTween.tween(dad, {x:dad.x + 75}, 1.5, {type:4, ease: FlxEase.sineInOut});
}

function finaleCenter()
{
	cameraFocusPos = {
		x:bgfinale.width/2,
		y:bgfinale.height/2
	};
	camZooms = "";
	defaultCamZoom = 0.7;
}

var endTweens = [];
function bye()
{
	endTweens[0] = FlxTween.tween(boyfriend, {x:boyfriend.x + 400, y:boyfriend.y + 150}, 1.3, {ease: FlxEase.quintIn});
	endTweens[1] = FlxTween.tween(dad, {x:dad.x + 200, y:dad.y + 100}, 1.3, {ease: FlxEase.quintIn});
	endTweens[3] = FlxTween.tween(bgfinale, {x:bgfinale.x + 100, y:bgfinale.y + 50}, 1.3, {ease: FlxEase.quintIn});
}

function end() for (cam in [camGame, camNotes, camHUD, camVideo]) cam.visible = false;

var camZooms;
var oldCamTarget;
function camTarget(target)
{
	var props = {};
	switch(camZooms)
	{
		case "p2" : props = (switch(target)
		{
			case 0 : {z:0.6, cams:60};
			case 1 : {z:0.8, cams:20};
		});
		case "p4" : props = (switch(target)
		{
			case 0 : {z:0.8, cams:60};
			case 1 : {z:0.7, cams:30};
		});
	}
	if (props.z != null) defaultCamZoom = props.z;
	if (props.cams != null) cameraMoveStrength = props.cams;
}

function onCameraMove(camEvent)
{
	if (oldCamTarget != curCameraTarget) camTarget(curCameraTarget);
	oldCamTarget = curCameraTarget;
}

function onPlayerMiss(event) if (event.noteType == "No Mute") event.muteVocals = false;

function destroy() remove(videoSprite);

function FUCKJUMPSCAREBITCH() //I have no time lol
{
	JUMPSCAREAAA.visible = true;
}

function byeJumpscare() JUMPSCAREAAA.visible = false;

function scare2() JUMPSCAREAAA.loadGraphic(Paths.image("stage/jumpscare2"));

function onGameOver() camGame.visible = true;