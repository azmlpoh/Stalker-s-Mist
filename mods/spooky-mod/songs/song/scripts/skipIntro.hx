function create()
{
	introLength = 1;
}

function postCreate()
{
	Conductor.songPosition = 0;
}

function onCountdown(event:CountdownEvent)
{
	event.cancel();
}

function onStrumCreation(strumEvent)
{
	strumEvent.__doAnimation = false;
}