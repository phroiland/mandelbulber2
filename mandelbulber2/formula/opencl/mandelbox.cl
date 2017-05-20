/**
 * Mandelbulber v2, a 3D fractal generator  _%}}i*<.        ____                _______
 * Copyright (C) 2017 Mandelbulber Team   _>]|=||i=i<,     / __ \___  ___ ___  / ___/ /
 *                                        \><||i|=>>%)    / /_/ / _ \/ -_) _ \/ /__/ /__
 * This file is part of Mandelbulber.     )<=i=]=|=i<>    \____/ .__/\__/_//_/\___/____/
 * The project is licensed under GPLv3,   -<>>=|><|||`        /_/
 * see also COPYING file in this folder.    ~+{i%+++
 *
 * Mandelbox fractal known as AmazingBox or ABox, invented by Tom Lowe in 2010
 * @reference
 * http://www.fractalforums.com/ifs-iterated-function-systems/amazing-fractal/msg12467/#msg12467
 */

/* ### This file has been autogenerated. Remove this line, to prevent override. ### */

#ifndef DOUBLE_PRECISION
void MandelboxIteration(float4 *z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	if (fractal->mandelbox.rotationsEnabled)
	{
		float4 zRot;
		// cast vector to array pointer for address taking of components in opencl
		float *zRotP = (float *)&zRot;
		__constant float *colP = (__constant float *)&fractal->mandelbox.color.factor;
		for (int dim = 0; dim < 3; dim++)
		{
			// handle each dimension x, y and *z sequentially in pointer var dim
			float *rotDim = (dim == 0) ? &zRotP[0] : ((dim == 1) ? &zRotP[1] : &zRotP[2]);
			__constant float *colorFactor = (dim == 0) ? &colP[0] : ((dim == 1) ? &colP[1] : &colP[2]);

			zRot = Matrix33MulFloat4(fractal->mandelbox.rot[0][dim], *z);
			if (*rotDim > fractal->mandelbox.foldingLimit)
			{
				*rotDim = fractal->mandelbox.foldingValue - *rotDim;
				*z = Matrix33MulFloat4(fractal->mandelbox.rotinv[0][dim], zRot);
				aux->color += *colorFactor;
			}
			else
			{
				zRot = Matrix33MulFloat4(fractal->mandelbox.rot[1][dim], *z);
				if (*rotDim < -fractal->mandelbox.foldingLimit)
				{
					*rotDim = -fractal->mandelbox.foldingValue - *rotDim;
					*z = Matrix33MulFloat4(fractal->mandelbox.rotinv[1][dim], zRot);
					aux->color += *colorFactor;
				}
			}
		}
	}
	else
	{
		if (fabs(z->x) > fractal->mandelbox.foldingLimit)
		{
			z->x = copysign(fractal->mandelbox.foldingValue, z->x) - z->x;
			aux->color += fractal->mandelbox.color.factor.x;
		}
		if (fabs(z->y) > fractal->mandelbox.foldingLimit)
		{
			z->y = copysign(fractal->mandelbox.foldingValue, z->y) - z->y;
			aux->color += fractal->mandelbox.color.factor.y;
		}
		if (fabs(z->z) > fractal->mandelbox.foldingLimit)
		{
			z->z = copysign(fractal->mandelbox.foldingValue, z->z) - z->z;
			aux->color += fractal->mandelbox.color.factor.z;
		}
	}

	float r2 = dot(*z, *z);

	*z += fractal->mandelbox.offset;

	if (r2 < fractal->mandelbox.mR2)
	{
		*z *= fractal->mandelbox.mboxFactor1;
		aux->DE *= fractal->mandelbox.mboxFactor1;
		aux->color += fractal->mandelbox.color.factorSp1;
	}
	else if (r2 < fractal->mandelbox.fR2)
	{
		float tglad_factor2 = native_divide(fractal->mandelbox.fR2, r2);
		*z *= tglad_factor2;
		aux->DE *= tglad_factor2;
		aux->color += fractal->mandelbox.color.factorSp2;
	}

	*z -= fractal->mandelbox.offset;

	if (fractal->mandelbox.mainRotationEnabled)
		*z = Matrix33MulFloat4(fractal->mandelbox.mainRot, *z);

	*z = *z * fractal->mandelbox.scale;
	aux->DE = mad(aux->DE, fabs(fractal->mandelbox.scale), 1.0f);
}
#else
void MandelboxIteration(double4 *z, __constant sFractalCl *fractal, sExtendedAuxCl *aux)
{
	if (fractal->mandelbox.rotationsEnabled)
	{
		double4 zRot;
		// cast vector to array pointer for address taking of components in opencl
		double *zRotP = (double *)&zRot;
		__constant double *colP = (__constant double *)&fractal->mandelbox.color.factor;
		for (int dim = 0; dim < 3; dim++)
		{
			// handle each dimension x, y and *z sequentially in pointer var dim
			double *rotDim = (dim == 0) ? &zRotP[0] : ((dim == 1) ? &zRotP[1] : &zRotP[2]);
			__constant double *colorFactor = (dim == 0) ? &colP[0] : ((dim == 1) ? &colP[1] : &colP[2]);

			zRot = Matrix33MulFloat4(fractal->mandelbox.rot[0][dim], *z);
			if (*rotDim > fractal->mandelbox.foldingLimit)
			{
				*rotDim = fractal->mandelbox.foldingValue - *rotDim;
				*z = Matrix33MulFloat4(fractal->mandelbox.rotinv[0][dim], zRot);
				aux->color += *colorFactor;
			}
			else
			{
				zRot = Matrix33MulFloat4(fractal->mandelbox.rot[1][dim], *z);
				if (*rotDim < -fractal->mandelbox.foldingLimit)
				{
					*rotDim = -fractal->mandelbox.foldingValue - *rotDim;
					*z = Matrix33MulFloat4(fractal->mandelbox.rotinv[1][dim], zRot);
					aux->color += *colorFactor;
				}
			}
		}
	}
	else
	{
		if (fabs(z->x) > fractal->mandelbox.foldingLimit)
		{
			z->x = copysign(fractal->mandelbox.foldingValue, z->x) - z->x;
			aux->color += fractal->mandelbox.color.factor.x;
		}
		if (fabs(z->y) > fractal->mandelbox.foldingLimit)
		{
			z->y = copysign(fractal->mandelbox.foldingValue, z->y) - z->y;
			aux->color += fractal->mandelbox.color.factor.y;
		}
		if (fabs(z->z) > fractal->mandelbox.foldingLimit)
		{
			z->z = copysign(fractal->mandelbox.foldingValue, z->z) - z->z;
			aux->color += fractal->mandelbox.color.factor.z;
		}
	}

	double r2 = dot(*z, *z);

	*z += fractal->mandelbox.offset;

	if (r2 < fractal->mandelbox.mR2)
	{
		*z *= fractal->mandelbox.mboxFactor1;
		aux->DE *= fractal->mandelbox.mboxFactor1;
		aux->color += fractal->mandelbox.color.factorSp1;
	}
	else if (r2 < fractal->mandelbox.fR2)
	{
		double tglad_factor2 = native_divide(fractal->mandelbox.fR2, r2);
		*z *= tglad_factor2;
		aux->DE *= tglad_factor2;
		aux->color += fractal->mandelbox.color.factorSp2;
	}

	*z -= fractal->mandelbox.offset;

	if (fractal->mandelbox.mainRotationEnabled)
		*z = Matrix33MulFloat4(fractal->mandelbox.mainRot, *z);

	*z = *z * fractal->mandelbox.scale;
	aux->DE = aux->DE * fabs(fractal->mandelbox.scale) + 1.0;
}
#endif
