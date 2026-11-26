textures/cobra_tex/rubble
{
	qer_editorimage textures/cobra_tex/rubble.tga
	qer_keyword grass
	qer_keyword flat
	qer_keyword m1
	surfaceparm grass
	{
		map textures/cobra_tex/rubble.tga
		depthWrite
		rgbGen identity
	}
	{
		map $lightmap
		rgbGen identity
		blendFunc GL_DST_COLOR GL_ZERO
		depthFunc equal
	}
}




textures/cobra_tex/brln_rubble
{
	qer_editorimage textures/cobra_tex/brln_rubble.tga
	qer_keyword grass
	qer_keyword flat
	qer_keyword m1
	surfaceparm grass
	{
		map textures/cobra_tex/brln_rubble.tga
		depthWrite
		rgbGen identity
	}
	{
		map $lightmap
		rgbGen identity
		blendFunc GL_DST_COLOR GL_ZERO
		depthFunc equal
	}
}
