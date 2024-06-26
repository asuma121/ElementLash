#include "ObjHeader.hlsli"

Texture2D<float4>tex : register(t0);	//0番スロットに設定されたテクスチャ
SamplerState smp : register(s0);		//0番スロットに設定されたサンプラー

float4 main(VSOutput input) : SV_TARGET
{
    length(input.normal);
	float4 texcolor = tex.Sample(smp, input.uv);
    return float4(texcolor.x, texcolor.y, texcolor.z,input.alpha);
}