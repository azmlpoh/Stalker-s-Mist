public var preLoadedSprites = new FlxSpriteGroup();
preLoadedSprites.scrollFactor.set();
preLoadedSprites.screenCenter();
insert(0, preLoadedSprites);

var preLoadedArr = [];

for (event in PlayState.SONG.events) if (event.name == "Change Character")
	{
	var char = strumLines.members[event.params[0]].characters[event.params[1]];
	var xml = char.getXMLFromCharName(event.params[2]);
	var image = xml.get("sprite");
	if (image == null) image = "bf";
	if (!preLoadedArr.contains(image))
	{
		preLoadedArr.push(image);
		preLoadedSprites.add(new FlxSprite().loadGraphic(Paths.image("characters/" + image)));
	}
	
	xml = char.getXMLFromCharName(char.curCharacter);
	image = xml.get("sprite");
	if (image == null) image = "bf";
	if (!preLoadedArr.contains(image))
	{
		preLoadedArr.push(image);
		preLoadedSprites.add(new FlxSprite().loadGraphic(Paths.image("characters/" + image)));
	}
}
preLoadedSprites.scale.set();

function onEvent(e) if (e.event.name == "Change Character")
{
	var event = e.event;
	var char = strumLines.members[event.params[0]].characters[event.params[1]];
	var xml = char.getXMLFromCharName(event.params[2]);
	char.curCharacter = event.params[2];
	char.buildCharacter(xml);
}