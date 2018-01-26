#include "matrix.h"
#include "mex.h"

#include <stdio.h>
#include <stdlib.h>

#include <math.h>



/*************************************************************************
 *
 * AUTEUR : Fabien PIERRE.
 * DATE   : 6 novembre 2013.
 *
 *
 * Compilation :
 *
 * % linux
 * clc
 * mex CFLAGS="\$CFLAGS -std=c99" lk.c -output lk_mex
 *
 * % windows
 * clc
 * mex  primal_dual_color10.c -output pdcolor
 *
 * % Version avec calcul des energies et TV classique.
 * % Projection polygone avec respect des teintes.
 *
 ************************************************************************/



void lucas_kanade(float * G, const float * U, int height, int width){
    
    int lin2;
    int col2;
    float a,b,c,h,i, fx, fy, ft, det;
    for(int lin=0; lin < height; lin ++){
        for(int col=0; col<width; col++){
            a=0; b=0; c=0; h=0; i=0;
            for(int l=-2; l< 3; l++){
                for(int j=-2; j< 3; j++){
                    lin2 = lin + l;
                    col2 = col + j;
                    if(lin2 < 0){
                        lin2 = 0;
                    }
                    if(col2 < 0){
                        col2 = 0;
                    }
                    if(lin2 >= height){
                        lin2 = height-1;
                    }
                    if(col2 >= width){
                        col2 = width-1;
                    }
                    
            
                    fx = U[lin2 + col2*height];
                    fy = U[lin2 + col2*height + height*width];
                    ft = U[lin2 + col2*height + 2*height*width];
                    
                    h -= fx*ft;
                    i -= fy*ft;
                    a += fx*fx;
                    b += fy*fy;
                    c += fx*fy;
                    
                }
            }
            
            
            det = 1/ (a*b - c*c);
            if( a*b - c*c < 10e-15){
                G[lin2 + col2*height] =0.0;
                G[lin2 + col2*height + height*width] =   0.0;     
            }
            else {
            G[lin2 + col2*height] = det*(b*h - c*i);
            G[lin2 + col2*height + height*width] = det*(-c*h + a*i);
            }
            
            
            
        }
    }
    
    return;
}

void mexFunction(int nlhs, mxArray *plhs[]       ,
        int nrhs, const mxArray *prhs[]  )
{
    
    /* Verification du nombre d'arguments.*/
    if(nrhs != 1)
    {
        mexErrMsgIdAndTxt("PG_poly_mex:nrhs","1 inputs required.");
    }
    if(nlhs != 1)
    {
        mexErrMsgIdAndTxt("PG_poly_mex:nlhs","1 output required.");
    }
    
    /* Gestion entrees-sorties.*/
    int ndim= mxGetNumberOfDimensions(prhs[0]);
    const size_t * dims= mxGetDimensions(prhs[0]);
    
    int height = (int) dims[0];
    int width = (int) dims[1];
    
    const float* U = (const float*)(mxGetPr(prhs[0]));
    
    const int n_dim_result= 3;
    size_t* dims_result = (size_t *)malloc(sizeof(size_t)*n_dim_result);
    dims_result[0]= (size_t)height;
    dims_result[1]= (size_t)width;
    dims_result[2]= (size_t)2;
    
    plhs[0]= mxCreateNumericArray(n_dim_result, dims_result ,
            mxSINGLE_CLASS, mxREAL     ) ;
    float* G= (float*)mxGetPr(plhs[0]);
    
    lucas_kanade(G,U,height,width);
    
    return;
}
