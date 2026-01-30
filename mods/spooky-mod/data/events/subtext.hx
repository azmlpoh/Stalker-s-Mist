import flixel.text.FlxText.FlxTextFormat;

var subtext = new FunkinText(0, FlxG.height/1.25, FlxG.width, "", 25);
subtext.alignment = "center";

var subtextFormat:FlxTextFormat = new FlxTextFormat(0xFF0000, true, false, 0x4E0000, false);
subtext.addFormat(subtextFormat, 0, 0);

function create() add(subtext);

function onEvent(e) if (e.event.name == "subtext")
{
	var params = e.event.params;
	subtext.text = "";
	subtext.text = params[0];
	subtext._formatRanges[0].range.start = params[1];
	subtext._formatRanges[0].range.end = params[2];	
}

function postCreate()
{
	subtext.cameras = [camVideo];
}