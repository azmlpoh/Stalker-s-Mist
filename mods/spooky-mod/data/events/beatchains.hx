var beatchains;

function onEvent(e) if (e.event.name == "beatchains")
{
	beatchains = e.event.params[0];
}

function stepHit(curStep) switch(beatchains)
{
	case "half" : if (curStep%4 == 2) for (cam in [camGame, camHUD, camNotes]) cam.zoom += 0.025;
}