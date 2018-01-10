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
  clc
  mex CFLAGS="\$CFLAGS -std=c99" divergence.c -output divergence_mex
 *
 * % windows
 * clc
 * mex  primal_dual_color10.c -output pdcolor
 *
 * % Version avec calcul des energies et TV classique.
 * % Projection polygone avec respect des teintes.
 *
 ************************************************************************/



void gradient(float *Wl,const float * Wr, int height, int width, int nb_color)
{
    
    int length_image = height*width;
    int l_w = width-1;
    int l_h = height-1;
    int posr = 0;
    int posl1 = 0;
    int posl2 = length_image;
    
    for(int c=0; c < nb_color; c++){
        
        for(int col=0; col<l_w; col++)
        {
            for(int lin=0; lin<l_h; lin++)
            {
                Wl[posl2] = Wr[posr+1] - Wr[posr];
                Wl[posl1] = Wr[posr+height] - Wr[posr];
                posr++;
                posl1 ++;
                posl2 ++;
            }
            Wl[posl2] = 0;
            Wl[posl1] = Wr[posr+height] - Wr[posr];
            posr ++;
            posl1 ++;
            posl2 ++;
            
        }
        for(int lin=0; lin<l_h; lin++)
        {
            Wl[posl2] = Wr[posr+1] - Wr[posr];
            Wl[posl1] = 0;
            posr++;
            posl1 ++;
            posl2 ++;
        }
     
            Wl[posl2] =0;
            Wl[posl1] = 0;
            posr++;
            posl1 ++;
            posl2 ++;
            
        posl1 +=  length_image;
        posl2 +=  length_image;
        
        
    }
    return;

}



void divergence(                float * Wl     ,
        const float * Wr     ,
        int      height ,
        int      width  ,
        int      nb_color  )
{
    
    
    int length_image = height*width;
    int l_w = width-1;
    int l_h = height-1;
    int posl = 0;
    int posr2 = 0;
    int posr1 = length_image;
    float x_1;
    float x_2;
    
    for(int c=0; c < nb_color; c++){
        
        x_1 = Wr[posr1];
        x_2 = Wr[posr2];
        Wl[posl] = x_1 + x_2;
        posl++;
        posr1 ++;
        posr2 ++;
        
        for(int lin=1; lin<l_h; lin++)
        {
            x_1 = Wr[posr1] - Wr[posr1- 1];
            x_2 = Wr[posr2];
            Wl[posl] = x_1 + x_2;
            posl++;
            posr1 ++;
            posr2 ++;
        }
        
        x_1 = -Wr[posr1- 1];
        x_2 =  Wr[posr2];
        Wl[posl] = x_1 + x_2;
        posl++;
        posr1 ++;
        posr2 ++;
        
        for(int col=1; col<l_w; col++)
        {
            x_1 = Wr[posr1] ;
            x_2 = Wr[posr2] - Wr[posr2- height];
            Wl[posl] = x_1 + x_2;
            posl++;
            posr1 ++;
            posr2 ++;
            for(int lin=1; lin<l_h; lin++)
            {
                x_1 = Wr[posr1] - Wr[posr1- 1];
                x_2 = Wr[posr2] - Wr[posr2-height];
               Wl[posl] = x_1 + x_2;
                posl++;
                posr1 ++;
                posr2 ++;
            }
            x_1 = -Wr[posr1-1];
            x_2 = Wr[posr2] - Wr[posr2-height];
            Wl[posl] = x_1 + x_2;
            posl++;
            posr1 ++;
            posr2 ++;
            
        }
        
        x_1 = Wr[posr1];
        x_2 = -Wr[posr2-height];
        Wl[posl] = x_1 + x_2;
        posl++;
        posr1 ++;
        posr2 ++;
        
        for(int lin=1; lin<l_h; lin++)
        {
            x_1 = Wr[posr1] - Wr[posr1- 1];
            x_2 = -Wr[posr2-height];
            Wl[posl] = x_1 + x_2;
            posl++;
            posr1 ++;
            posr2 ++;
        }
        
        x_1 = -Wr[posr1-1];
        x_2 = -Wr[posr2-height];
        Wl[posl] = x_1 + x_2;
        posl++;
        posr1 ++;
        posr2 ++;
        
        posr1 +=  length_image;
        posr2 +=  length_image;
        
        
    }
    return;
    
}/*
{
    float x_1;
    float x_2;
    int length_image = height*width;
    
    for(int c=0; c < nb_color; c++){
        
        for(int lin=0; lin<height; lin++)
        {
            for(int col=0; col<width; col++)
            {
                if(lin==0)
                {
                    x_1=Wr[lin+height*col + (2*c+1)*length_image];
                }
                else if (lin==(height-1))
                {
                    x_1=-Wr[lin+height*col-1+ (2*c+1)*length_image ];
                }
                else
                {
                    x_1=Wr[lin+height*col+ (2*c+1)*length_image]
                            -Wr[lin+height*col-1+ (2*c+1)*length_image];
                }
                
                if (col==0)
                {
                    x_2=Wr[lin+height*col+ (2*c)*length_image];
                }
                else if (col==(width-1))
                {
                    x_2=-Wr[lin+height*(col-1)+ (2*c)*length_image];
                }
                else
                {
                    x_2=Wr[lin+height*col+ (2*c)*length_image]
                            -Wr[lin+height*(col-1)+ (2*c)*length_image];
                }
                Wl[lin+height*col + (c)*length_image]= x_1+x_2;
            }
        }
    }
    
    return;
}*/



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
    const int * dims= mxGetDimensions(prhs[0]);
    
    int height = dims[0];
    int width = dims[1];
    int nb_color = dims[2]/2;
    
    const float* G = (const float*)(mxGetPr(prhs[0]));
    
    const int n_dim_result= 3;
    int* dims_result = (int *)malloc(sizeof(int)*n_dim_result);
    dims_result[0]= height;
    dims_result[1]= width;
    dims_result[2]= nb_color;
    
    plhs[0]= mxCreateNumericArray(n_dim_result, dims_result ,
            mxSINGLE_CLASS, mxREAL     ) ;
    float* U= (float*)mxGetPr(plhs[0]);
    
    divergence(U,G,height,width,  nb_color);
    
    return;
}
