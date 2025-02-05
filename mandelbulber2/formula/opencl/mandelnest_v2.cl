/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2021 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Mandelnest by Jeannoc
 * https://fractalforums.org/share-a-fractal/22/mandelbrot-3d-mandelnest/4028/

 * This file has been autogenerated by tools/populateUiInformation.php
 * from the file "fractal_mandelnest_v2.cpp" in the folder formula/definition
 * D O    N O T    E D I T    T H I S    F I L E !
 */

REAL4 MandelnestV2Iteration(REAL4 z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	REAL Power = fractal->bulb.power;
	REAL4 shift = fractal->transformCommon.offset000 * M_PI_F;
	REAL4 dual = fractal->transformCommon.scale3D111;

	z = z + fabs(z - fractal->transformCommon.offsetA000)
			- fabs(z + fractal->transformCommon.offsetA000);

	REAL r = length(z);
	REAL rN = fractal->transformCommon.scale1 / r;
	aux->DE *= fabs(rN);

	if (fractal->transformCommon.functionEnabledFalse)
	{
		if (fractal->transformCommon.functionEnabledAxFalse) z.x = fabs(z.x);
		if (fractal->transformCommon.functionEnabledAyFalse) z.y = fabs(z.y);
		if (fractal->transformCommon.functionEnabledAzFalse) z.z = fabs(z.z);
	}

	REAL4 temp = z * rN;
	if (!fractal->transformCommon.functionEnabledBxFalse)
		temp.x = asin(temp.x);
	else
		temp.x = acos(temp.x);
	if (!fractal->transformCommon.functionEnabledByFalse)
		temp.y = asin(temp.y);
	else
		temp.y = acos(temp.y);
	if (!fractal->transformCommon.functionEnabledBzFalse)
		temp.z = asin(temp.z);
	else
		temp.z = acos(temp.z);

	temp = shift + Power * dual * temp;

	if (!fractal->transformCommon.functionEnabledCxFalse)
		z.x = native_sin(temp.x);
	else
		z.x = native_cos(temp.x);
	if (!fractal->transformCommon.functionEnabledCyFalse)
		z.y = native_sin(temp.y);
	else
		z.y = native_cos(temp.y);
	if (!fractal->transformCommon.functionEnabledCzFalse)
		z.z = native_sin(temp.z);
	else
		z.z = native_cos(temp.z);

	if (!fractal->transformCommon.functionEnabledAFalse)
	{
		rN = 1.0f / length(z);
		z *= rN;
		aux->DE *= rN;
	}

	z *= native_powr(r, Power - fractal->transformCommon.offset1);

	if (aux->i >= fractal->transformCommon.startIterationsS
			&& aux->i < fractal->transformCommon.stopIterationsS)
		z += fractal->transformCommon.offsetF000;

	r = length(z);

	aux->DE = aux->DE * Power * r + 1.0f;
	if (fractal->analyticDE.enabledFalse)
	{
		aux->DE = aux->DE * fractal->analyticDE.scale1 + fractal->analyticDE.offset0;

		// aux->dist
		if (fractal->transformCommon.functionEnabledDFalse)
		{
			aux->DE0 = 0.5f * log(r) * r / aux->DE;

			if (aux->i <= fractal->transformCommon.startIterationsE)
				aux->dist = min(aux->DE0, fractal->analyticDE.offset1);
			else
				aux->dist = min(aux->dist, aux->DE0); // hybrid
		}
	}
	return z;
}