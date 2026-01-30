var FUCKFUCKFUCK = new FlxCamera();

var oldMousePos = {
	x:FlxG.mouse.x,
	y:FlxG.mouse.y
};

public function touchingMouse(object, moving)
{
	if (!moving || oldMousePos.x != FlxG.mouse.getScreenPosition(FUCKFUCKFUCK).x || oldMousePos.y != FlxG.mouse.getScreenPosition(FUCKFUCKFUCK).y) if (FlxG.mouse.x <= object.x + object.width && FlxG.mouse.x >= object.x && FlxG.mouse.y <= object.y + object.height && FlxG.mouse.y >= object.y) return true;
	return false;
}

function postUpdate(elapsed)
{
	oldMousePos = FlxG.mouse.getScreenPosition(FUCKFUCKFUCK);
}