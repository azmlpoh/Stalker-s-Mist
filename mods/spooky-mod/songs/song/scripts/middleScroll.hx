var swagWidth = 112;

function setStrumlinePos(strumline, pos) for (strum in strumLines.members[strumline]) strum.x = (FlxG.width*pos) + ((strum.ID-1.5) * swagWidth * strumLines.members[strumline].strumScale) - (strum.width/2);

function postCreate() setStrumlinePos(1, 0.5);

function monsterShow() setStrumlinePos(1, 0.75);

function p3Darken()
{
	setStrumlinePos(0, 0.5);
	setStrumlinePos(1, 0.5);
	strumLines.members[1].visible = false;
}

function tvScreams()
{
	setStrumlinePos(0, 0.25);
	setStrumlinePos(1, 0.75);
	strumLines.members[1].visible = true;
}