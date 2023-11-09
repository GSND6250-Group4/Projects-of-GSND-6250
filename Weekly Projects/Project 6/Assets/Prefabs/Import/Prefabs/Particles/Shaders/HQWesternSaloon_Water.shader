// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HQWesternSaloon/HQWesternSaloon_Water"
{
	Properties
	{
		_DirtMask("DirtMask", 2D) = "white" {}
		_NormalMapRefraction("NormalMap (Refraction)", 2D) = "bump" {}
		_WaterColor("WaterColor", Color) = (0.1226415,0.1103235,0.1058651,0.627451)
		_DirtColor("DirtColor", Color) = (0.4622642,0.4050263,0.385947,1)
		_Specular("Specular", Range( 0 , 1)) = 0.23
		_Gloss("Gloss", Range( 0 , 1)) = 0.95
		_RefractionIntensity("Refraction Intensity", Range( 0 , 1)) = 0.01
		_DepthBlend("Depth Blend", Range( 0 , 2)) = 0.3
		_RefractionDistance("Refraction Distance", Float) = 1
		_RefractionDistanceFalloff("Refraction Distance Falloff", Range( 0 , 5)) = 1
		_SpeedX("Speed X", Float) = 0
		_Speed("Speed Y", Float) = 1
		_DirtDirection("Dirt Direction and Speed", Range( -1 , 1)) = -1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.5
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float eyeDepth;
		};

		uniform sampler2D _NormalMapRefraction;
		uniform float _SpeedX;
		uniform float _Speed;
		uniform float4 _NormalMapRefraction_ST;
		uniform float4 _WaterColor;
		uniform float4 _DirtColor;
		uniform sampler2D _DirtMask;
		uniform float _DirtDirection;
		uniform float4 _DirtMask_ST;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _RefractionIntensity;
		uniform float _RefractionDistanceFalloff;
		uniform float _RefractionDistance;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthBlend;
		uniform float _Specular;
		uniform float _Gloss;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			o.eyeDepth = -UnityObjectToViewPos( v.vertex.xyz ).z;
		}

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 appendResult68 = (float2(_SpeedX , _Speed));
			float2 temp_output_70_0 = ( appendResult68 * 0.05 );
			float2 uv_NormalMapRefraction = i.uv_texcoord * _NormalMapRefraction_ST.xy + _NormalMapRefraction_ST.zw;
			float2 panner65 = ( 1.0 * _Time.y * temp_output_70_0 + uv_NormalMapRefraction);
			float3 tex2DNode2 = UnpackScaleNormal( tex2D( _NormalMapRefraction, panner65 ), 0.05 );
			o.Normal = tex2DNode2;
			float2 uv_DirtMask = i.uv_texcoord * _DirtMask_ST.xy + _DirtMask_ST.zw;
			float2 panner72 = ( 1.0 * _Time.y * ( temp_output_70_0 * _DirtDirection ) + uv_DirtMask);
			float4 tex2DNode1 = tex2D( _DirtMask, panner72 );
			float4 lerpResult6 = lerp( _WaterColor , _DirtColor , tex2DNode1.a);
			o.Albedo = lerpResult6.rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float cameraDepthFade32 = (( i.eyeDepth -_ProjectionParams.y - _RefractionDistance ) / _RefractionDistanceFalloff);
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth23 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth23 = saturate( ( screenDepth23 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthBlend ) );
			float4 screenColor21 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( (ase_grabScreenPosNorm).xy + (( ( ( _RefractionIntensity * saturate( ( 1.0 - cameraDepthFade32 ) ) ) * distanceDepth23 ) * tex2DNode2 )).xy ));
			o.Emission = screenColor21.rgb;
			float3 temp_cast_2 = (_Specular).xxx;
			o.Specular = temp_cast_2;
			o.Smoothness = _Gloss;
			float lerpResult10 = lerp( _WaterColor.a , _DirtColor.a , tex2DNode1.a);
			o.Alpha = ( lerpResult10 * distanceDepth23 );
		}

		ENDCG
		CGPROGRAM
		#pragma exclude_renderers d3d9 
		#pragma surface surf StandardSpecular alpha:fade keepalpha fullforwardshadows nodynlightmap vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.5
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float4 tSpace0 : TEXCOORD4;
				float4 tSpace1 : TEXCOORD5;
				float4 tSpace2 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.z = customInputData.eyeDepth;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.eyeDepth = IN.customPack1.z;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
0;73;1920;1047;2621.554;-529.6979;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;31;-2453.128,599.5637;Inherit;False;Property;_RefractionDistance;Refraction Distance;8;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2481.212,471.2527;Inherit;False;Property;_RefractionDistanceFalloff;Refraction Distance Falloff;9;0;Create;True;0;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;32;-2138.146,438.2777;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-2446,1332.27;Inherit;False;Property;_Speed;Speed Y;11;0;Create;False;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-2448.068,1212.553;Inherit;False;Property;_SpeedX;Speed X;10;0;Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;35;-1852.261,449.1138;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-2290.624,1428.715;Inherit;False;Constant;_Float0;Float 0;12;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;68;-2252.745,1223.332;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1925.307,246.187;Inherit;False;Property;_RefractionIntensity;Refraction Intensity;6;0;Create;True;0;0;0;False;0;False;0.01;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-2057.624,1242.715;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2148.67,824.1188;Inherit;False;Property;_DepthBlend;Depth Blend;7;0;Create;True;0;0;0;False;0;False;0.3;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-2207.086,1037.759;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;36;-1665.041,445.6096;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;23;-1808.293,779.0436;Inherit;False;True;True;False;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1482.34,416.25;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-1860.655,970.8474;Inherit;False;Property;_DirtDirection;Dirt Direction and Speed;12;0;Create;False;0;0;0;False;0;False;-1;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;65;-1776.422,1192.68;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1816.337,1341.142;Inherit;False;Constant;_NormalScale;Normal Scale;10;0;Create;True;0;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-1602.732,949.3568;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1235.405,559.0174;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1516.947,1173.858;Inherit;True;Property;_NormalMapRefraction;NormalMap (Refraction);1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;73;-1307.902,164.1537;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;72;-966.9127,261.3355;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-952.4641,820.2588;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GrabScreenPosition;22;-976.4379,564.0655;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-545.8365,-337.3113;Inherit;False;Property;_WaterColor;WaterColor;2;0;Create;True;0;0;0;False;0;False;0.1226415,0.1103235,0.1058651,0.627451;0.1226415,0.1103235,0.1058651,0.627451;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-582.4238,225.722;Inherit;True;Property;_DirtMask;DirtMask;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;19;-761.9578,798.5717;Inherit;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;5;-543.9086,-129.7677;Inherit;False;Property;_DirtColor;DirtColor;3;0;Create;True;0;0;0;False;0;False;0.4622642,0.4050263,0.385947,1;0.1226415,0.1103235,0.1058651,0.627451;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;18;-720.7578,579.9723;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;10;95.7625,336.6422;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-492.3521,652.0729;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-226.1375,178.6422;Inherit;False;Property;_Gloss;Gloss;5;0;Create;True;0;0;0;False;0;False;0.95;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;6;-166.2375,-201.3578;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;364.2035,431.2255;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;21;-304.9767,569.673;Float;False;Global;_ScreenGrab0;Screen Grab 0;-1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-251.2375,61.64221;Inherit;False;Property;_Specular;Specular;4;0;Create;True;0;0;0;False;0;False;0.23;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;723.5999,148.7;Float;False;True;-1;3;ASEMaterialInspector;0;0;StandardSpecular;HQWesternSaloon/HQWesternSaloon_Water;False;False;False;False;False;False;False;True;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;True;Transparent;;Transparent;All;13;d3d11_9x;d3d11;glcore;gles;gles3;metal;vulkan;xbox360;xboxone;ps4;psp2;n3ds;wiiu;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;2;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;37;0
WireConnection;32;1;31;0
WireConnection;35;0;32;0
WireConnection;68;0;64;0
WireConnection;68;1;69;0
WireConnection;70;0;68;0
WireConnection;70;1;71;0
WireConnection;36;0;35;0
WireConnection;23;0;24;0
WireConnection;33;0;7;0
WireConnection;33;1;36;0
WireConnection;65;0;66;0
WireConnection;65;2;70;0
WireConnection;75;0;70;0
WireConnection;75;1;74;0
WireConnection;27;0;33;0
WireConnection;27;1;23;0
WireConnection;2;1;65;0
WireConnection;2;5;61;0
WireConnection;72;0;73;0
WireConnection;72;2;75;0
WireConnection;17;0;27;0
WireConnection;17;1;2;0
WireConnection;1;1;72;0
WireConnection;19;0;17;0
WireConnection;18;0;22;0
WireConnection;10;0;4;4
WireConnection;10;1;5;4
WireConnection;10;2;1;4
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;6;0;4;0
WireConnection;6;1;5;0
WireConnection;6;2;1;4
WireConnection;25;0;10;0
WireConnection;25;1;23;0
WireConnection;21;0;20;0
WireConnection;0;0;6;0
WireConnection;0;1;2;0
WireConnection;0;2;21;0
WireConnection;0;3;8;0
WireConnection;0;4;9;0
WireConnection;0;9;25;0
ASEEND*/
//CHKSM=3CF4BA589DBB7F2CAF8291E2C91F8E27C8B1151C