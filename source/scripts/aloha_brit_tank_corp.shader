aloha_tank_tunic
{
	qer_editorimage textures/aloha_tank_corporal_shirt.tga
	{
		map textures/aloha_tank_corporal_shirt.tga
		rgbGen lightingSpherical
	}
}

aloha_tank_tunic_red
{
	qer_editorimage textures/aloha_tank_corporal_shirt_red.tga
	{
		map textures/aloha_tank_corporal_shirt_red.tga
		rgbGen lightingSpherical
	}
}

aloha_tank_tunic_black
{
	qer_editorimage textures/aloha_tank_corporal_shirt_black.tga
	{
		map textures/aloha_tank_corporal_shirt_black.tga
		rgbGen lightingSpherical
	}
}

aloha_tank_tunic_LOA
{
	qer_editorimage textures/aloha_tank_corporal_shirt_LOA.tga
	{
		map textures/aloha_tank_corporal_shirt_LOA.tga
		rgbGen lightingSpherical
	}
}

aloha_tank_tunic_purple
{
	qer_editorimage textures/aloha_tank_corporal_shirt_purple.tga
	{
		map textures/aloha_tank_corporal_shirt_purple.tga
		rgbGen lightingSpherical
	}
}

aloha_tank_pants
{
	qer_editorimage textures/aloha_tank_corporal_pants.tga
	{
		map textures/aloha_tank_corporal_pants.tga
		rgbGen lightingSpherical
	}
}

aloha_face_us
{
	qer_editorimage textures/us_tourist.tga
	{
		map textures/us_tourist.tga
		rgbGen lightingSpherical
	}
}

aloha_face_uk
{
	qer_editorimage textures/uk_tourist.tga
	{
		map textures/uk_tourist.tga
		rgbGen lightingSpherical
	}
}

aloha_face_russian
{
	qer_editorimage textures/russian_tourist.tga
	{
		map textures/russian_tourist.tga
		rgbGen lightingSpherical
	}
}

aloha_face_german
{
	qer_editorimage textures/wolfgang_tourist.tga
	{
		map textures/wolfgang_tourist.tga
		rgbGen lightingSpherical
	}
}

aloha_face_italian
{
	qer_editorimage textures/italian_tourist.tga
	{
		map textures/italian_tourist.tga
		rgbGen lightingSpherical
	}
}

aloha_hands
{
	qer_editorimage textures/aloha_tank_corporal_hands.tga
	{
		map textures/aloha_tank_corporal_hands.tga
		rgbGen lightingSpherical
	}
}
sunglass
{
	qer_editorimage textures/sunglasses.tga
	cull none
	//{
	//	map textures/sunglasses.tga
	//	tcGen environment
	//}
	{
		map textures/sunglasses.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
	}
	{
		map $lightmap
		rgbGen Identity
		blendFunc GL_DST_COLOR GL_ZERO
	}
}
sunglasses
{
	qer_editorimage textures/sunglasses.tga
	cull none
	{
		map textures/sunglasses.tga
		rgbGen lightingSpherical
	}
}