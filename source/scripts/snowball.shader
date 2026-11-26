snowonwall
{
	polygonOffset
	{
		map textures/decals/snowonwall.tga
		blendfunc blend
		alphagen vertex
		rgbgen vertex
	}
}

//snowball
//{
//	qer_editorimage textures/models/weapons/m2grenade/grenade.tga
//	{
//		map textures/models/weapons/snowball/snowball.tga
//		rgbGen lightingSpherical
//	}
//}

snowball
{
	qer_editorimage textures/decals/snowonwall.tga
	{
		map textures/decals/snowonwall.tga
		rgbGen lightingSpherical
	}
}
Backyard
{
	qer_editorimage textures/mohmenu/dmloading/Backyard.tga
	{
		map textures/mohmenu/dmloading/Backyard.tga
		rgbGen lightingSpherical
	}
}

// 1.42-test: the snowball projectile uses the stock M2FragGrenade shader
// name so players without the mod still see a thrown object. With the mod
// installed this override makes it snow.
M2FragGrenade
{
	qer_editorimage textures/decals/snowonwall.tga
	{
		map textures/decals/snowonwall.tga
		rgbGen lightingSpherical
	}
}
