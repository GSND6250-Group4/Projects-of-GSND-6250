// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HQWesternSaloon/HQWesternSaloon_Cloth_Opaque"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,0)
		_MainTex("Albedo", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.65
		_SpecularRGBGlossA("Specular (RGB) Gloss (A)", 2D) = "white" {}
		_NormalMap("Normal Map", 2D) = "bump" {}
		_AmbientOcclusion("Ambient Occlusion", 2D) = "white" {}
		_AOPower("AO Power", Range( 0 , 3)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			half ASEVFace : VFACE;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color;
		uniform sampler2D _SpecularRGBGlossA;
		uniform float4 _SpecularRGBGlossA_ST;
		uniform sampler2D _AmbientOcclusion;
		uniform float4 _AmbientOcclusion_ST;
		uniform float _AOPower;
		uniform float _Cutoff = 0.65;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 tex2DNode5 = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float3 appendResult13 = (float3(tex2DNode5.r , tex2DNode5.g , ( tex2DNode5.b * -1.0 )));
			float3 switchResult14 = (((i.ASEVFace>0)?(tex2DNode5):(appendResult13)));
			o.Normal = switchResult14;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			o.Albedo = ( tex2DNode1 * _Color ).rgb;
			float2 uv_SpecularRGBGlossA = i.uv_texcoord * _SpecularRGBGlossA_ST.xy + _SpecularRGBGlossA_ST.zw;
			float4 tex2DNode4 = tex2D( _SpecularRGBGlossA, uv_SpecularRGBGlossA );
			o.Specular = tex2DNode4.rgb;
			o.Smoothness = tex2DNode4.a;
			float2 uv_AmbientOcclusion = i.uv_texcoord * _AmbientOcclusion_ST.xy + _AmbientOcclusion_ST.zw;
			float temp_output_9_0 = pow( tex2D( _AmbientOcclusion, uv_AmbientOcclusion ).g , _AOPower );
			float switchResult15 = (((i.ASEVFace>0)?(temp_output_9_0):(( 1.0 - temp_output_9_0 ))));
			o.Occlusion = switchResult15;
			o.Alpha = 1;
			clip( tex2DNode1.a - _Cutoff );
		}

		ENDCG
	}
	Fallback "Standard (Specular setup)"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
104;71;1920;970;1538.731;106.0188;1.76075;True;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-899.1227,585.1844;Half;False;Constant;_Float1;Float 0;5;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1027.968,284.0486;Inherit;True;Property;_NormalMap;Normal Map;4;0;Create;True;0;0;0;False;0;False;-1;None;5398e8e0d033fb140802632b66d69086;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-594,1037.5;Inherit;True;Property;_AmbientOcclusion;Ambient Occlusion;5;0;Create;True;0;0;0;False;0;False;-1;None;9e98878d87f97aa4ea466f25ef9a99b2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-578,1307.5;Inherit;False;Property;_AOPower;AO Power;6;0;Create;True;0;0;0;False;0;False;1;3;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-682.4197,467.2011;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;9;-236.1088,1087.972;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-619.8602,-188.7258;Inherit;True;Property;_MainTex;Albedo;1;0;Create;False;0;0;0;False;0;False;-1;None;6b16c44e0c3de89479e6be97b3330729;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;2;-533.043,29.52153;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;13;-492.9868,350.9841;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;17;-52.4281,1175.051;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-600.6557,821.4571;Inherit;True;Property;_SpecularRGBGlossA;Specular (RGB) Gloss (A);3;0;Create;True;0;0;0;False;0;False;-1;None;ce7eefba3029ce24a99f4d66c840d92d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-107.5345,-159.4597;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwitchByFaceNode;14;-323.8949,219.4513;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SwitchByFaceNode;15;146.6847,1076.159;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;374.2568,26.35605;Float;False;True;-1;2;ASEMaterialInspector;0;0;StandardSpecular;HQWesternSaloon/HQWesternSaloon_Cloth_Opaque;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.65;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;Standard (Specular setup);2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;5;3
WireConnection;12;1;11;0
WireConnection;9;0;6;2
WireConnection;9;1;7;0
WireConnection;13;0;5;1
WireConnection;13;1;5;2
WireConnection;13;2;12;0
WireConnection;17;0;9;0
WireConnection;8;0;1;0
WireConnection;8;1;2;0
WireConnection;14;0;5;0
WireConnection;14;1;13;0
WireConnection;15;0;9;0
WireConnection;15;1;17;0
WireConnection;0;0;8;0
WireConnection;0;1;14;0
WireConnection;0;3;4;0
WireConnection;0;4;4;4
WireConnection;0;5;15;0
WireConnection;0;10;1;4
ASEEND*/
//CHKSM=F7366552D9D96B36796A79B790AF28BEAB9A1FA6