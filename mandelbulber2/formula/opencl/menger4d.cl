/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * from Syntopia & Darkbeam's Menger4 code from M3D
 * @reference
 * http://www.fractalforums.com/mandelbulb-3d/custom-formulas-and-transforms-release-t17106/
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

REAL4 Menger4dIteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	if (aux->i >= fractal->transformCommon.startIterationsC
			&& aux->i < fractal->transformCommon.stopIterationsC)
	{
		z += fractal->transformCommon.additionConstant0000; // offset
	}

	z = fabs(z);
	if (z.x - z.y < 0.0f)
	{
		REAL temp = z.y;
		z.y = z.x;
		z.x = temp;
	}
	if (z.x - z.z < 0.0f)
	{
		REAL temp = z.z;
		z.z = z.x;
		z.x = temp;
	}
	if (z.y - z.z < 0.0f)
	{
		REAL temp = z.z;
		z.z = z.y;
		z.y = temp;
	}
	if (z.x - z.w < 0.0f)
	{
		REAL temp = z.w;
		z.w = z.x;
		z.x = temp;
	}
	if (z.y - z.w < 0.0f)
	{
		REAL temp = z.w;
		z.w = z.y;
		z.y = temp;
	}
	if (z.z - z.w < 0.0f)
	{
		REAL temp = z.w;
		z.w = z.z;
		z.z = temp;
	}

	// 6 plane rotation
	if (fractal->transformCommon.functionEnabledRFalse
			&& aux->i >= fractal->transformCommon.startIterationsR
			&& aux->i < fractal->transformCommon.stopIterationsR)
	{
		REAL4 tp;
		if (fractal->transformCommon.rotation44a.x != 0)
		{
			tp = z;
			REAL alpha = fractal->transformCommon.rotation44a.x * M_PI_180;
			z.x = mad(tp.x, native_cos(alpha), tp.y * native_sin(alpha));
			z.y = tp.x * -native_sin(alpha) + tp.y * native_cos(alpha);
		}
		if (fractal->transformCommon.rotation44a.y != 0)
		{
			tp = z;
			REAL beta = fractal->transformCommon.rotation44a.y * M_PI_180;
			z.y = mad(tp.y, native_cos(beta), tp.z * native_sin(beta));
			z.z = tp.y * -native_sin(beta) + tp.z * native_cos(beta);
		}
		if (fractal->transformCommon.rotation44a.z != 0)
		{
			tp = z;
			REAL gamma = fractal->transformCommon.rotation44a.z * M_PI_180;
			z.x = mad(tp.x, native_cos(gamma), tp.z * native_sin(gamma));
			z.z = tp.x * -native_sin(gamma) + tp.z * native_cos(gamma);
		}
		if (fractal->transformCommon.rotation44b.x != 0)
		{
			tp = z;
			REAL delta = fractal->transformCommon.rotation44b.x * M_PI_180;
			z.x = mad(tp.x, native_cos(delta), tp.w * native_sin(delta));
			z.w = tp.x * -native_sin(delta) + tp.w * native_cos(delta);
		}
		if (fractal->transformCommon.rotation44b.y != 0)
		{
			tp = z;
			REAL epsilon = fractal->transformCommon.rotation44b.y * M_PI_180;
			z.y = mad(tp.y, native_cos(epsilon), tp.w * native_sin(epsilon));
			z.w = tp.y * -native_sin(epsilon) + tp.w * native_cos(epsilon);
		}
		if (fractal->transformCommon.rotation44b.z != 0)
		{
			tp = z;
			REAL zeta = fractal->transformCommon.rotation44b.z * M_PI_180;
			z.z = mad(tp.z, native_cos(zeta), tp.w * native_sin(zeta));
			z.w = tp.z * -native_sin(zeta) + tp.w * native_cos(zeta);
		}
	}

	REAL scaleM = fractal->transformCommon.scale3;
	REAL4 offsetM = fractal->transformCommon.additionConstant111d5;
	z.x = mad(scaleM, z.x, -offsetM.x);
	z.y = mad(scaleM, z.y, -offsetM.y);
	z.w = mad(scaleM, z.w, -offsetM.w);
	z.z -= 0.5f * native_divide(offsetM.z, scaleM);
	z.z = -fabs(-z.z);
	z.z += 0.5f * native_divide(offsetM.z, scaleM);
	z.z *= scaleM;
	aux->DE *= scaleM;

	if (fractal->transformCommon.functionEnabledSFalse
			&& aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
	{
		REAL r2 = dot(z, z);
		// if (r2 < 1e-21f && r2 > -1e-21f) r2 = (r2 > 0) ? 1e-21f : -1e-21f;

		if (r2 < fractal->transformCommon.minR2p25)
		{
			z *= fractal->transformCommon.maxMinR2factor;
			aux->DE *= fractal->transformCommon.maxMinR2factor;
			aux->color += fractal->mandelbox.color.factorSp1;
		}
		else if (r2 < fractal->transformCommon.maxR2d1)
		{
			REAL tglad_factor2 = native_divide(fractal->transformCommon.maxR2d1, r2);
			z *= tglad_factor2;
			aux->DE *= tglad_factor2;
			aux->color += fractal->mandelbox.color.factorSp2;
		}
	}

	if (fractal->transformCommon.functionEnabledFalse)
	{
		REAL4 zA4 = (aux->i == fractal->transformCommon.intA) ? z : (REAL4){};
		REAL4 zB4 = (aux->i == fractal->transformCommon.intB) ? z : (REAL4){};

		z = (z * fractal->transformCommon.scale) + (zA4 * fractal->transformCommon.offset)
				+ (zB4 * fractal->transformCommon.offset0);
		aux->DE *= fractal->transformCommon.scale;
		aux->r_dz *= fractal->transformCommon.scale;
	}

	aux->DE *= fractal->analyticDE.scale1;
	return z;
}