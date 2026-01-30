import funkin.menus.ModSwitchMenu;

importScript("data/scripts/touchingMouse");
importScript("data/scripts/menuBG");

var creditsData = CoolUtil.parseJson("data/config/credits.json");

var creditsFolder = creditsData.iconFolder;

var creditPeople = creditsData.credits;

add(creditsGroup = new FlxSpriteGroup(50, 50));

var creditsScale = creditsData.scale;

var creditSpacing = creditsData.spacing;

var altChance = 5;
for (i=>person in creditPeople)
{
	var name = "Name";
	if (person.name != null) name = person.name;

	var nameText = "Name";
	if (person.name != null) nameText = person.name;

	var iconImage = creditsFolder + "icons/face";
	if (person.icon != null) iconImage = creditsFolder + "icons/" + person.icon;
	if (person.altIcon != null) if (FlxG.random.int(1, altChance) == 1) iconImage = creditsFolder + "icons/" + person.altIcon;

	creditsGroup.add(curGroup = new FlxSpriteGroup(0, creditSpacing*i*creditsScale));

	curGroup.add(icon = new FunkinSprite().loadGraphic(Paths.image(iconImage)));

	curGroup.add(nameTxt = new FunkinText(100*creditsScale, 25, 0, nameText, 25));
	nameTxt.font = Paths.font("Endless Scarry.ttf");
}

creditsGroup.scale.set(creditsScale, creditsScale);

var descTxtWidth = 500;
add(descTxt = new FunkinText(FlxG.width/1.5 - descTxtWidth/2, 0, descTxtWidth, "Description", 50));
descTxt.font = Paths.font("Endless Scarry.ttf");
descTxt.alignment = "center";
descTxt.screenCenter(FlxAxes.Y);

add(rolesTxt = new FunkinText(0, 0, FlxG.width, "Roles", 30));
rolesTxt.font = Paths.font("Endless Scarry.ttf");
rolesTxt.alignment = "center";

add(linkMenu = new FlxSpriteGroup(0, 0));

linkMenu.add(linkMenuBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK));
linkMenuBG.alpha = 0.5;

linkMenu.add(linkMenuTxt = new FunkinText(0, 50, FlxG.width/1.5, "Links", 50));
linkMenuTxt.font = Paths.font("Endless Scarry.ttf");
linkMenuTxt.alignment = "center";

linkMenu.add(linkTextGroup = new FlxSpriteGroup(0, 0));

var linkMenuOpened = false;
var linkSpacing = creditsData.linkSpacing;

function openLinkMenu(links) if (links != null && links.length > 0)
{
	if (links.length > 1)
	{
		closeLinkMenu();
		linkMenuOpened = true;
		linkMenu.visible = true;
	
		linkCurSelected = 0;
		linkOldSelected = null;
	
		for (i=>link in links)
		{
			linkTextGroup.add(text = new FunkinText(0, linkSpacing*i, FlxG.width/1.5, link.name, 50));
			text.font = Paths.font("Endless Scarry.ttf");
			text.alignment = "center";
			text.alpha = 0.5;
		}
		linkTextGroup.screenCenter(FlxAxes.Y);
		linkUpdateCurSelectedItem();
	
		menuBGGroup.color = 0x3D3D3D;
	}
	else openLink(creditPeople[curSelected].links[0].site);
}

function closeLinkMenu()
{
	linkMenuOpened = false;
	linkMenu.visible = false;
	for (link in linkTextGroup) linkTextGroup.members.remove(link);

	menuBGGroup.color = 0xC4C4C4;
}

function linkUpdateCurSelectedItem()
{
	var text;

	if (linkOldSelected != null && linkTextGroup.members.length > 1)
	{
		text = linkTextGroup.members[linkOldSelected];
	
		text.alpha = 0.5;
	}

	text = linkTextGroup.members[linkCurSelected];
	text.alpha = 1;
}

var linkCurSelected = 0;
var linkOldSelected;
function linkChangeSelected(amount:Int = 0)
{
	if (amount != 0) linkOldSelected = linkCurSelected;
	linkCurSelected += amount;
	if (linkCurSelected > linkTextGroup.members.length-1) linkCurSelected = 0;
	if (linkCurSelected < 0) linkCurSelected = linkTextGroup.members.length-1;
	CoolUtil.playMenuSFX(0);
	linkUpdateCurSelectedItem();
}

closeLinkMenu();

function openLink(site:String)
{
	if (site != null)
	{
		CoolUtil.openURL(site);
	}
}

var curSelected = 0;
var oldSelected;
function changeSelected(amount:Int = 0)
{
	if (amount != 0) oldSelected = curSelected;
	curSelected += amount;
	if (curSelected > creditsGroup.members.length-1) curSelected = 0;
	if (curSelected < 0) curSelected = creditsGroup.members.length-1;
	updateCurSelectedItem();
	CoolUtil.playMenuSFX(0);
}

function updateCurSelectedItem()
{
	descTxt.text = "Desc";
	rolesTxt.text = "Roles";
	if (creditPeople[curSelected].desc != null) descTxt.text = creditPeople[curSelected].desc;
	if (creditPeople[curSelected].roles != null)
	{
		rolesTxt.text = "";
		for (role in creditPeople[curSelected].roles) rolesTxt.text += "-" + role + "-
";
	}
	descTxt.scale.set(1.1, 1.1);
	descTxt.screenCenter(FlxAxes.Y);
	descTxt.angle = FlxG.random.int(-5, 5);
}

updateCurSelectedItem();

var selectLerp = 0.1;
var selectStrength = 50;
function updateCreditPos(credit)
{
	var xPos = 0;
	var angle = 0;
	if (creditsGroup.members.indexOf(credit) == curSelected)
	{
		xPos = selectStrength;
		angle = 10;
	}
	credit.x = lerp(credit.x, xPos + creditsGroup.x, selectLerp);
	credit.angle = lerp(credit.angle, angle, selectLerp);
}

function update()
{
	if (linkMenuOpened)
	{
		if (controls.BACK) closeLinkMenu();
		if (controls.UP_P || FlxG.mouse.wheel) linkChangeSelected(-1);
		if (controls.DOWN_P || -FlxG.mouse.wheel) linkChangeSelected(1);
		if (controls.ACCEPT) openLink(creditPeople[curSelected].links[linkCurSelected].site);
	}
	else
	{
		if (controls.BACK) FlxG.switchState(new MainMenuState());
		if (controls.UP_P || FlxG.mouse.wheel) changeSelected(-1);
		if (controls.DOWN_P || -FlxG.mouse.wheel) changeSelected(1);
		if (controls.ACCEPT) openLinkMenu(creditPeople[curSelected].links);
	}
	for (credit in creditsGroup.members) updateCreditPos(credit);
	descTxt.scale.set(lerp(descTxt.scale.x, 1, selectLerp), lerp(descTxt.scale.y, 1, selectLerp));
	descTxt.angle = lerp(descTxt.angle, 0, 0.1);
}

add(exitTxt = new FunkinText(20, FlxG.height - 50, 0, "Tap to Exit", 30));
exitTxt.font = Paths.font("Endless Scarry.ttf");

function postUpdate()
{
	var mousePressed = FlxG.mouse.justReleased;
	
	if (mousePressed && touchingMouse(exitTxt, false))
	{
		FlxG.switchState(new MainMenuState());
		return;
	}
	
	if (linkMenuOpened)
	{
		var clickedOnLink = false;
		
		for (i in 0...linkTextGroup.members.length)
		{
			var object = linkTextGroup.members[i];
			if (touchingMouse(object, false))
			{
				clickedOnLink = true;
				
				if (object != linkTextGroup.members[linkCurSelected])
				{
					linkOldSelected = linkCurSelected;
					linkCurSelected = i;
					linkUpdateCurSelectedItem();
					CoolUtil.playMenuSFX(0);
				}
				
				if (mousePressed)
				{
					openLink(creditPeople[curSelected].links[linkCurSelected].site);
				}
				return;
			}
		}
		
		if (mousePressed && !clickedOnLink)
		{
			closeLinkMenu();
			return;
		}
	}
	else
	{
		for (i in 0...creditsGroup.members.length)
		{
			var object = creditsGroup.members[i];
			if (touchingMouse(object, false))
			{
				if (object != creditsGroup.members[curSelected])
				{
					oldSelected = curSelected;
					curSelected = i;
					updateCurSelectedItem();
					CoolUtil.playMenuSFX(0);
				}
				
				if (mousePressed)
				{
					openLinkMenu(creditPeople[curSelected].links);
				}
				return;
			}
		}
	}
}