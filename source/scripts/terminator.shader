tttop
{
	qer_editorimage textures/tttop.tga
	{
		map textures/tttop.tga
		rgbGen lightingSpherical
	}
}
ttpants
{
	qer_editorimage textures/ttpants.tga
	{
		map textures/ttpants.tga
		rgbGen lightingSpherical
	}
}
cull_tt_pants
{
	qer_editorimage textures/ttpants.tga
	cull none
	{
		map textures/ttpants.tga
		rgbGen lightingSpherical
	}
}

ttface
{
	qer_editorimage textures/ttface.jpg
	{
		map textures/ttface.jpg
		rgbGen lightingSpherical
	}
}
dude_glass
{
	qer_editorimage textures/glasses.tga
	cull none
	{
		map textures/glasses.tga
		tcGen environment
}
	{
		map textures/glasses.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
	}
	{
		map $lightmap
		rgbGen Identity
		blendFunc GL_DST_COLOR GL_ZERO
	}
}	

dude_glass_frames
{
	qer_editorimage textures/glasses.tga
	cull none
	{
		map textures/glasses.tga
		rgbGen lightingSpherical
	}
}


