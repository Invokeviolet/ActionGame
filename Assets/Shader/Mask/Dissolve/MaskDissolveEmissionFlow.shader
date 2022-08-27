﻿Shader "NarshaGames/Shader/Mask/Dissolve/MaskDissolveEmissionFlow" {
	 Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
		_MainColor("Main Color", Color) = (1,1,1,1)
		_MaskTex ("Mask Texture", 2D) = "white" {}
		
		
	    _UVAniX("UV X Speed", Float) = 0
		_UVAniY("UV Y Speed", Float) = 0
		

		_DissolvePower ("Dissolve Power", Range(0.65, -0.5)) = 0.2
		_DissolveEmissionColor ("Dissolve Emission Color", Color) = (1,1,1)
		_DissolveTex ("Dissolve Texture", 2D) = "white"{}    
    }
    SubShader {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		
		Blend SrcAlpha OneMinusSrcAlpha
				
	
        CGPROGRAM
        #pragma surface surf Lambert  alphatest:Zero noforwardadd noambient	

        sampler2D _MainTex;
		fixed4 _MainColor;
		sampler2D _MaskTex;
	    float _UVAniX;
		float _UVAniY;
		
   

		sampler2D _DissolveTex;
		float3 _DissolveEmissionColor;
		fixed _DissolvePower;

         
 
        struct Input {
            float2 uv_MainTex;
			float2 uv_MaskTex;
			float2 uv_DissolveTex;
        };
 
        void surf (Input IN, inout SurfaceOutput o) 
		{  
            float4 uvani = float4(_Time.x * _UVAniX, _Time.x * _UVAniY, 0,0);
            half4 diff = tex2D (_MainTex, IN.uv_MainTex+uvani);
			half4 mask = tex2D (_MaskTex, IN.uv_MaskTex);
			half4 dissolve = tex2D(_DissolveTex, IN.uv_DissolveTex);



            //o.Albedo = diff.rgb * _MainColor.rgb * 2; // (발광 곱하기 2)
            o.Albedo = diff.rgb * _MainColor.rgb;
			fixed alpha = _DissolvePower - dissolve.r;
			if( alpha > 0)
				o.Alpha = diff.a * mask.r;
			else
			{
				o.Alpha = -1;
				// 번지는 부분들의 경계의 두께 만큼 dissolve color 로 설정
				if (-0.03 < alpha && alpha < 0.0)
				{
					o.Alpha = mask.r;					
					o.Albedo = _DissolveEmissionColor;
				}
			}
			if( o.Alpha <= 0 )
				o.Alpha = -1;
            
        }
        ENDCG
    }
    FallBack "Mobile/Particles/Alpha Blended"
}
