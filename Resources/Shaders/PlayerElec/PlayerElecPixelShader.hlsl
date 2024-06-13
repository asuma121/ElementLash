#include "PlayerElecHeader.hlsli"

//0�ԃX���b�g�ɐݒ肳�ꂽ�e�N�X�`��
Texture2D<float4> tex : register(t0);	//�e�N�X�`��1����
Texture2D<float> tex1 : register(t1);	//�J��������̐[�x
Texture2D<float> tex2 : register(t2);	//���C�g����̐[�x
Texture2D<float4> tex3 : register(t3);	//�e�N�X�`��2����
//0�ԃX���b�g�ɐݒ肳�ꂽ�T���v���[
SamplerState smp : register(s0);

struct PSOutput 
{
	float4 target0 : SV_TARGET0;
	float4 target1 : SV_TARGET1;
};

PSOutput main(VSOutput input) : SV_TARGET
{
	PSOutput output;
	
	//�e�N�X�`���}�b�s���O
	//��1
    float4 texcoord1 = tex3.Sample(smp, input.uv);
	//Lambert����
	float3 light = normalize(float3(1,-1,1));	//�E���� �����̃��C�g
	float diffuse = saturate(dot(-light, input.normal));
	float brightness = diffuse + 0.3f;
	float4 shadecolor = float4(brightness, brightness, brightness, 1.0f);
	//���C�g���猩��UV�l
	float3 posFromLightVP = input.tpos.xyz / input.tpos.w;
	float2 shadowUV = (posFromLightVP + float2(1, -1)) * float2(0.5, -0.5);
	//�e�e�N�X�`��
	float depthFromLight = tex2.Sample(smp, shadowUV);
	float shadowWeight = 1.0f;
	if (depthFromLight < posFromLightVP.z - 0.005)
	{
		shadowWeight = 0.2f;
	}
	
    output.target0 = shadecolor * texcoord1;
	//�e������
	output.target0.x *= shadowWeight;
	output.target0.y *= shadowWeight;
	output.target0.z *= shadowWeight;
	output.target1 = float4(1,1,1,1);
	return output;
}