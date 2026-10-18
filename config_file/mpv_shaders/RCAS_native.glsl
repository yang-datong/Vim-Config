// Copyright (c) 2021 Advanced Micro Devices, Inc. All rights reserved.
// FidelityFX FSR v1.0.2 (RCAS pass for non-upscaled / native resolution)
// Triggers automatically when OUTPUT <= LUMA (when FSR EASU+RCAS is inactive)

//!HOOK LUMA
//!BIND HOOKED
//!DESC FidelityFX RCAS v1.0.2 (Native Sharpening)
//!WHEN OUTPUT.w OUTPUT.h * 921600 > ! LUMA.w 2560 < ! +
//!COMPONENTS 1

// User variables - RCAS
#define SHARPNESS 0.15 // 0.0 := maximum sharpness, higher = less sharp (0.0 to 2.0)
#define FSR_RCAS_DENOISE 1 // 1 = lessen sharpening on noisy areas (recommended for live streams)

#define FSR_RCAS_LIMIT (0.25 - (1.0 / 16.0))

float APrxMedRcpF1(float a) {
	float b = uintBitsToFloat(uint(0x7ef19fff) - floatBitsToUint(a));
	return b * (-b * a + 2.0);
}

float AMax3F1(float x, float y, float z) {
	return max(x, max(y, z));
}

float AMin3F1(float x, float y, float z) {
	return min(x, min(y, z));
}

vec4 hook() {
#if (defined(HOOKED_gather) && (__VERSION__ >= 400 || (GL_ES && __VERSION__ >= 310)))
	vec3 bde = HOOKED_gather(HOOKED_pos + HOOKED_pt * vec2(-0.5), 0).xyz;
	float b = bde.z;
	float d = bde.x;
	float e = bde.y;

	vec2 fh = HOOKED_gather(HOOKED_pos + HOOKED_pt * vec2(0.5), 0).zx;
	float f = fh.x;
	float h = fh.y;
#else
	float b = HOOKED_texOff(vec2( 0.0, -1.0)).r;
	float d = HOOKED_texOff(vec2(-1.0,  0.0)).r;
	float e = HOOKED_tex(HOOKED_pos).r;
	float f = HOOKED_texOff(vec2( 1.0,  0.0)).r;
	float h = HOOKED_texOff(vec2( 0.0,  1.0)).r;
#endif

	float mn1L = min(AMin3F1(b, d, f), h);
	float mx1L = max(AMax3F1(b, d, f), h);

	vec2 peakC = vec2(1.0, -1.0 * 4.0);

	float hitMinL = min(mn1L, e) / (4.0 * mx1L);
	float hitMaxL = (peakC.x - max(mx1L, e)) / (4.0 * mn1L + peakC.y);
	float lobeL = max(-hitMinL, hitMaxL);
	float lobe = max(float(-FSR_RCAS_LIMIT), min(lobeL, 0.0)) * exp2(-clamp(float(SHARPNESS), 0.0, 2.0));

#if (FSR_RCAS_DENOISE == 1)
	float nz = 0.25 * b + 0.25 * d + 0.25 * f + 0.25 * h - e;
	nz = clamp(abs(nz) * APrxMedRcpF1(AMax3F1(AMax3F1(b, d, e), f, h) - AMin3F1(AMin3F1(b, d, e), f, h)), 0.0, 1.0);
	nz = -0.5 * nz + 1.0;
	lobe *= nz;
#endif

	float rcpL = APrxMedRcpF1(4.0 * lobe + 1.0);
	vec4 pix = vec4(0.0, 0.0, 0.0, 1.0);
	pix.r = float((lobe * b + lobe * d + lobe * h + lobe * f + e) * rcpL);

	return pix;
}
