﻿Shader "NarshaGames/Shader/Mask/Unlit/MaskUnlitGlowFlowZoff" {
	 Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
		_MainColor("Main Color", Color) = (1,1,1,1)
		_MaskTex ("Mask Texture", 2D) = "white" {}
		_MaskAlpha("Mask Alpha", Float) = 0.5
		
		_UVAniX("UV X Speed", Float) = 0
		_UVAniY("UV Y Speed", Float) = 0
    }
    SubShader {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		
		ZWrite off
		Blend SrcAlpha OneMinusSrcAlpha
       
        CGPROGRAM
        #pragma surface surf UnlitSimple  alphatest:Zero noforwardadd noambient

		inline fixed4 LightingUnlitSimple(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			return fixed4(s.Albedo, s.Alpha);
		}
		
        sampler2D _MainTex;
		fixed4 _MainColor;
		sampler2D _MaskTex;
		fixed _MaskAlpha;
		fixed _UVAniX;
		fixed _UVAniY;
		
		
        struct Input {
            fixed2 uv_MainTex;
			fixed2 uv_MaskTex;
        };
 
       
         void surf (Input IN, inout SurfaceOutput o) 
		{  
			fixed2 uvani = _Time.x * fixed2(_UVAniX, _UVAniY);
            half4 diff = tex2D (_MainTex, IN.uv_MainTex);
			half4 mask = tex2D (_MaskTex, IN.uv_MaskTex+uvani);
			
			o.Albedo = 2 * diff * _MainColor;
			o.Alpha = diff.a * mask.r * _MaskAlpha;
			if( o.Alpha <= 0)
				o.Alpha = -1;
		}
        ENDCG
    }
    FallBack "Mobile/Particles/Alpha Blended"
}
