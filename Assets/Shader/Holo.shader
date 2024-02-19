Shader "Custom/Holo"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        //https://docs.unity3d.com/kr/530/Manual/SL-Pass.html
        Pass{
            ColorMask 0
        }

        CGPROGRAM        
        #pragma surface surf Lambert noambient alpha:fade

        sampler2D _MainTex;
        float4 _Color;
        
        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            //o.Albedo = 0;//c.rgb;
            float ndotv = saturate(dot(o.Normal, IN.viewDir));
            o.Emission = _Color.rgb;
            float rim = pow(1 - ndotv, 3) +  pow(frac(IN.worldPos.g * 10 - _Time.y * 2), 3);// float3(0,1,0);    1.1 -> 0.1, 1.9->0.9   0 ~ 0.9
            o.Alpha = rim;
        }
        ENDCG
    }
    FallBack "Diffuse"
}