// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "(UI)Fx_ShockWave"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin]_Main_Texture("Main_Texture", 2D) = "white" {}
		_UVNoise("UV Noise", Range(0 , 1)) = 0.4821447
		_UPanner("UPanner", Float) = 0
		_VPanner("VPanner", Float) = 0
		_Noise_VPanner("Noise_VPanner", Float) = 0
		_Noise_UPanner("Noise_UPanner", Float) = 0.25
		_Noise_Texture("Noise_Texture", 2D) = "white" {}
		_Power("Power", Range(0.01 , 5)) = 1.889804
		_Ins("Ins", Range(0 , 10)) = 2.530838
		[HDR]_Tint_Color("Tint_Color", Color) = (1,1,1,0)
		_Float5("Float 5", Float) = 1
		_Float6("Float 6", Float) = 1
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_MaskPow("Mask Pow", Range(0 , 5)) = 1.277498
		_Opacity("Opacity", Range(0 , 10)) = 1.276182
		[Toggle(_KEYWORD0_ON)] _Keyword0("Keyword 0", Float) = 0
		[ASEEnd]_Dissolve("Dissolve", Range(-1 , 1)) = 0.6521611
		[HideInInspector] _texcoord("", 2D) = "white" {}

		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		_StencilComp("Stencil Comparison", Float) = 8
		_Stencil("Stencil ID", Float) = 0
		_StencilOp("Stencil Operation", Float) = 0
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		_StencilReadMask("Stencil Read Mask", Float) = 255
		_ColorMask("Color Mask", Float) = 15
	}

		SubShader
	{
		LOD 0


		Tags { "RenderPipeline" = "UniversalPipeline" "RenderType" = "Transparent" "Queue" = "Transparent" }

		Cull Off
		ZTest[unity_GUIZTestMode]
		AlphaToMask Off

		Stencil
		{
		 Ref[_Stencil]
		 Comp[_StencilComp]
		 Pass[_StencilOp]
		 ReadMask[_StencilReadMask]
		 WriteMask[_StencilWriteMask]
		}
		ColorMask[_ColorMask]

		HLSLINCLUDE
		#pragma target 2.0

		#pragma prefer_hlslcc gles
		#pragma exclude_renderers d3d11_9x 

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess(float tessValue)
		{
			return tessValue;
		}

		float CalcDistanceTessFactor(float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos)
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance(wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors(float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor(float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams)
		{
			float dist = distance(0.5 * (wpos0 + wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane(float3 pos, float4 plane)
		{
			float d = dot(float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull(float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6])
		{
			float4 planeTest;
			planeTest.x = ((DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f) +
						  ((DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f) +
						  ((DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f);
			planeTest.y = ((DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f) +
						  ((DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f) +
						  ((DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f);
			planeTest.z = ((DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f) +
						  ((DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f) +
						  ((DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f);
			planeTest.w = ((DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f) +
						  ((DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f) +
						  ((DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f);
			return !all(planeTest);
		}

		float4 DistanceBasedTess(float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos)
		{
			float3 f;
			f.x = CalcDistanceTessFactor(v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor(v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor(v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors(f);
		}

		float4 EdgeLengthBasedTess(float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams)
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor(pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor(pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor(pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull(float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6])
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor(pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor(pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor(pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS

		ENDHLSL


		Pass
		{

			Name "Forward"
			Tags { "LightMode" = "UniversalForward" }

			Blend One One, One OneMinusSrcAlpha
			ZWrite Off
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM

			#define _RECEIVE_SHADOWS_OFF 1
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION 110000


			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _KEYWORD0_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef ASE_FOG
				float fogFactor : TEXCOORD2;
				#endif
				float4 ase_color : COLOR;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Tint_Color;
			float4 _Main_Texture_ST;
			float4 _Noise_Texture_ST;
			float4 _TextureSample0_ST;
			float _UPanner;
			float _VPanner;
			float _Noise_UPanner;
			float _Noise_VPanner;
			float _UVNoise;
			float _Power;
			float _Ins;
			float _Opacity;
			float _Float5;
			float _Float6;
			float _MaskPow;
			float _Dissolve;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Main_Texture;
			sampler2D _Noise_Texture;
			sampler2D _TextureSample0;



			VertexOutput VertexFunction(VertexInput v)
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_color = v.ase_color;
				o.ase_texcoord3 = v.ase_texcoord;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
				float4 positionCS = TransformWorldToHClip(positionWS);

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord(vertexInput);
				#endif
				#ifdef ASE_FOG
				o.fogFactor = ComputeFogFactor(positionCS.z);
				#endif
				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_color : COLOR;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert(VertexInput v)
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_color = v.ase_color;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction(InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess(tessValue);
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos);
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams);
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes);
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput)0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0] * bary.x + pp[1] * bary.y + pp[2] * bary.z) + (1.0f - phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert(VertexInput v)
			{
				return VertexFunction(v);
			}
			#endif

			half4 frag(VertexOutput IN) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4(0, 0, 0, 0);

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord(WorldPosition);
					#endif
				#endif
				float2 appendResult27 = (float2(_UPanner , _VPanner));
				float2 uv_Main_Texture = IN.ase_texcoord3.xy * _Main_Texture_ST.xy + _Main_Texture_ST.zw;
				float2 appendResult17 = (float2(_Noise_UPanner , _Noise_VPanner));
				float2 uv_Noise_Texture = IN.ase_texcoord3.xy * _Noise_Texture_ST.xy + _Noise_Texture_ST.zw;
				float2 panner16 = (1.0 * _Time.y * appendResult17 + uv_Noise_Texture);
				float2 panner26 = (1.0 * _Time.y * appendResult27 + (uv_Main_Texture + (tex2D(_Noise_Texture, panner16).r * _UVNoise)));
				float4 tex2DNode31 = tex2D(_Main_Texture, panner26);
				float4 temp_cast_0 = (_Power).xxxx;
				float2 uv_TextureSample0 = IN.ase_texcoord3.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float4 tex2DNode75 = tex2D(_TextureSample0, uv_TextureSample0);
				float temp_output_58_0 = saturate(pow(((saturate((pow(tex2DNode31.r , _Float5) * _Float6)) + tex2DNode75.r) * tex2DNode75.r) , _MaskPow));
				#ifdef _KEYWORD0_ON
				float staticSwitch67 = IN.ase_texcoord3.z;
				#else
				float staticSwitch67 = _Dissolve;
				#endif

				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = (((_Tint_Color * IN.ase_color) * (IN.ase_color * (_Tint_Color * (pow(tex2DNode31 , temp_cast_0) * _Ins)))) * (IN.ase_color.a * (saturate((((tex2DNode31.r * _Opacity) + temp_output_58_0) * temp_output_58_0)) * (tex2DNode31.r + staticSwitch67)))).rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition(IN.clipPos.xyz, unity_LODFade.x);
				#endif

				#ifdef ASE_FOG
					Color = MixFog(Color, IN.fogFactor);
				#endif

				return half4(Color, Alpha);
			}

			ENDHLSL
		}


		Pass
		{

			Name "DepthOnly"
			Tags { "LightMode" = "DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM

			#define _RECEIVE_SHADOWS_OFF 1
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION 110000


			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"



			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif

				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Tint_Color;
			float4 _Main_Texture_ST;
			float4 _Noise_Texture_ST;
			float4 _TextureSample0_ST;
			float _UPanner;
			float _VPanner;
			float _Noise_UPanner;
			float _Noise_VPanner;
			float _UVNoise;
			float _Power;
			float _Ins;
			float _Opacity;
			float _Float5;
			float _Float6;
			float _MaskPow;
			float _Dissolve;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END



			VertexOutput VertexFunction(VertexInput v)
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);


				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld(v.vertex.xyz);

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.clipPos = TransformWorldToHClip(positionWS);
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord(vertexInput);
				#endif
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert(VertexInput v)
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;

				return o;
			}

			TessellationFactors TessellationFunction(InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess(tessValue);
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos);
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams);
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes);
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput)0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;

				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0] * bary.x + pp[1] * bary.y + pp[2] * bary.z) + (1.0f - phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert(VertexInput v)
			{
				return VertexFunction(v);
			}
			#endif

			half4 frag(VertexOutput IN) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4(0, 0, 0, 0);

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord(WorldPosition);
					#endif
				#endif


				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition(IN.clipPos.xyz, unity_LODFade.x);
				#endif
				return 0;
			}
			ENDHLSL
		}


	}
		CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
				Fallback "Hidden/InternalErrorShader"

}