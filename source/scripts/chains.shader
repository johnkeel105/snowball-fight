textures/cobra_tex2/chains
{
	qer_keyword masked
	qer_keyword rusted
	qer_keyword metal
	surfaceparm grill
	surfaceparm monsterclip
	surfaceparm playerclip
	surfaceparm fence
    qer_editorimage textures/cobra_tex2/chains.tga 
//	surfaceparm alphashadow
	cull none
	nopicmip
	{
		map textures/cobra_tex2/chains.tga 
		depthWrite
		alphaFunc GE128
	nextbundle
		map $lightmap
	}
}