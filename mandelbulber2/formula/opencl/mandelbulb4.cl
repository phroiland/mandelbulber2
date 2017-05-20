/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Fractal formula created by Buddhi
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#ifndef DOUBLE_PRECISION
void Mandelbulb4Iteration(float4 *z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	float rp = native_powr(aux->r, fractal->bulb.power - 1.0f);
	aux->r_dz = mad(rp * aux->r_dz, fractal->bulb.power, 1.0f);

	float angZ = atan2(z->y, z->x) + fractal->bulb.alphaAngleOffset;
	float angY = atan2(z->z, z->x) + fractal->bulb.betaAngleOffset;
	float angX = atan2(z->z, z->y) + fractal->bulb.gammaAngleOffset;

	matrix33 rotM;
	rotM = RotateX(rotM, angX * (fractal->bulb.power - 1.0f));
	rotM = RotateY(rotM, angY * (fractal->bulb.power - 1.0f));
	rotM = RotateZ(rotM, angZ * (fractal->bulb.power - 1.0f));

	*z = Matrix33MulFloat4(rotM, *z) * rp;
}
#else
void Mandelbulb4Iteration(double4 *z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	double rp = native_powr(aux->r, fractal->bulb.power - 1.0);
	aux->r_dz = rp * aux->r_dz * fractal->bulb.power + 1.0;

	double angZ = atan2(z->y, z->x) + fractal->bulb.alphaAngleOffset;
	double angY = atan2(z->z, z->x) + fractal->bulb.betaAngleOffset;
	double angX = atan2(z->z, z->y) + fractal->bulb.gammaAngleOffset;

	matrix33 rotM;
	rotM = RotateX(rotM, angX * (fractal->bulb.power - 1.0));
	rotM = RotateY(rotM, angY * (fractal->bulb.power - 1.0));
	rotM = RotateZ(rotM, angZ * (fractal->bulb.power - 1.0));

	*z = Matrix33MulFloat4(rotM, *z) * rp;
}
#endif
