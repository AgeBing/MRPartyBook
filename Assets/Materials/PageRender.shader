Shader "Custom/PageRender" {
    Properties {
        _Color ("Color", Color) = (1,0,0,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" "Queue"="Transparent" }
        LOD 200
        
        CGPROGRAM
        
        //再最后添加alpha参数，就可以实现模型的透明设置
        #pragma surface surf Lambert alpha 

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input {
            float2 uv_MainTex;
        };

        
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutput o) {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

						if(c.b < 0.5 && c.r < 0.5 && c.g < 0.5){
							c = _Color;
							// c.r = 1;
							// c.g = 0;
							// c.b = 0;
							// c.a = 1;
						}else{
							c.a = 0.2;
						}

            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    } 
    FallBack "Diffuse"
}