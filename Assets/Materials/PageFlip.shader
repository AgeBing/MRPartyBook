Shader "Custom/PageFlip"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SecondTex("second tex",2D) = "white"{}
		_Angle ("Rotate angle",Range(0,180)) = 0
	}
	SubShader
	{
		Pass
		{
			Cull Back
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Angle;
			
			v2f vert (appdata v)
			{
				float sins;
				float coss;
				float rad = (_Angle * 3.1415926) / 180;	//角度转弧度
				// rad = radians(_Angle)
				sincos(rad, sins, coss);
				// 创建旋转矩阵
				// float4x4 rotateMatrix =  
				// {
				// 	coss,sins,0,0,
				// 	-sins,coss,0,0,
				// 	0,0,1,0,
				// 	0,0,0,1,
				// };
				float4x4 rotateMatrix =  
				{
					coss,0,sins,0,
					0,1,0,0,
					-sins,0,coss,0,
					0,0,0,1,
				};
				
				v2f o;
				v.vertex += float4(0.5, 0, 0, 0);					//将中心点偏移到最左边（让书绕最左边进行旋转）
				v.vertex.y += sin(v.vertex.x * 0.4) * sins;	//对顶点Y进行偏移，添加 sin 函数使其平滑
				v.vertex = mul(rotateMatrix, v.vertex);			//使用旋转矩阵对顶点进行旋转
				v.vertex -= float4(0.5, 0, 0, 0);  
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}

		Pass
		{
			Cull front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			sampler2D _SecondTex;
			float4 _SecondTex_ST;
			float _Angle;
			
			v2f vert(appdata v)
			{
				float sins;
				float coss;
				float rad = (_Angle * 3.1415926) / 180;
				sincos(rad, sins, coss);
				//sincos(radians(_Angle), sins, coss);
				// float4x4 rotateMatrix =
				// {
				// 	coss,sins,0,0,
				// 	-sins,coss,0,0,
				// 	0,0,1,0,
				// 	0,0,0,1,
				// };
				float4x4 rotateMatrix =  
				{
					coss,0,sins,0,
					0,1,0,0,
					-sins,0,coss,0,
					0,0,0,1,
				};
				v2f o;
				v.vertex += float4(0.5, 0, 0, 0);
				v.vertex.y += sin(v.vertex.x * 0.4) * sins;
				v.vertex = mul(rotateMatrix, v.vertex);
				v.vertex -= float4(0.5, 0, 0, 0);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _SecondTex);
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_SecondTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}