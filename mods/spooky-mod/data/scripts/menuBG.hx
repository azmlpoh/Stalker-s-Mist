var imageFolder = "menus/";

var camGame = FlxG.camera;

var defaultCamZoom = camGame.zoom = 0.975;

var chromShader;
chromShader = new CustomShader("chromaticAberration");
var chromIntens = 0.0015;
chromShader.redOff = [chromIntens, 0];
chromShader.blueOff = [-chromIntens, 0];

var warpShader = new CustomShader("warp");
warpShader.distortion = 0.25;

for (shader in [chromShader, warpShader]) camGame.addShader(shader);

public var menuBGGroup = new FlxSpriteGroup();
add(menuBGGroup);

menuBGGroup.add(menuBG = new FunkinSprite());
menuBG.frames = Paths.getSparrowAtlas(imageFolder + "menuBG");
menuBG.animation.addByPrefix("idle", "idle",24,true);
menuBG.playAnim("idle");
menuBG.scale.set(0.67, 0.67);
menuBG.updateHitbox();
menuBG.scale.set(0.68, 0.68);
menuBG.scrollFactor.set(0.75, 0.75);

menuBGGroup.add(menuBGTent = new FunkinSprite().loadGraphic(Paths.image(imageFolder + "tent")));
menuBGTent.scale.set(0.67, 0.67);
menuBGTent.updateHitbox();
menuBGTent.scale.set(0.68, 0.68);

var menuBGLerp = 0.1;
var menuBGMouseMovement = 5;
var menuBGOffsets = {
	x:-2,
	y:-2
}

menuBGTweens = [
	FlxTween.tween(menuBGOffsets, {y:2}, 2, {ease: FlxEase.sineInOut, type:4}),
	FlxTween.tween(menuBGOffsets, {x:2}, 1.56, {ease: FlxEase.sineInOut, type:4})
];

function postUpdate(elapsed)
{
	var mousePos = {
		x:FlxG.mouse.x/FlxG.width * 2 - 1,
		y:FlxG.mouse.y/FlxG.height * 2 - 1
	}
	var bgPos = {
		x:menuBGOffsets.x - mousePos.x * menuBGMouseMovement,
		y:menuBGOffsets.y - mousePos.y * menuBGMouseMovement
	}
	for (spr in menuBGGroup.members) spr.setPosition(lerp(spr.x, bgPos.x * spr.scrollFactor.x, menuBGLerp), lerp(spr.y, bgPos.y * spr.scrollFactor.y, menuBGLerp));

	camGame.zoom = lerp(camGame.zoom, defaultCamZoom, 0.025);

	chromIntens = lerp(chromIntens, 0.0015, 0.025);
	chromShader.redOff = [chromIntens, 0];
	chromShader.blueOff = [-chromIntens, 0];
}

function beatHit(curBeat)
{
	if (curBeat%4 == 0)
	{
		camGame.zoom += 0.01;
		chromIntens += 0.001;
	}
}