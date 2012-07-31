/********************************************************************

                        Singular Value Decomposition

                        (C) Copyright 1999, 2000, 2005

                        Haibin Tang
                        Dian Martin
                        Kevin Heinrich
                        Michael W. Berry

                        All Rights Reserved

            Permission to copy all or part of any of this
            software is only granted upon approval from the
            authors listed above.  Interested parties may
            send electronic mail to berry@cs.utk.edu for
            more information.  Written requests for software
            distribution or use may be sent to:

                      Michael W. Berry
                      Department of Computer Science
                      University of Tennessee
                      Knoxville, TN 37996-1301

********************************************************************/

#include <fstream>
#include <cstdio>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <cerrno>
#include <unistd.h>
#include "general.h"
#include "com_routines.h"
#include "matrix_comp.h"
#include "lans.h"
#include "options.h"

using std::fstream;

#define FMAGIC 312.70
#define IMAGIC 26948
#define TERM 0
#define DOCUMENT 1
#define FACTOR 2
#define COMMENT 3

class las2
{
 protected:
   double t0,exetime;
   double endl, endr, kappa, tmp0, tmp1, xnorm;
   double *r, *ritz, *bnd, *d, *tptr1;
   long nn, k, i, id, ida, n, nother, lanmax, maxprs, nnzero, h;
   long memory, vectors, size1, size2, sizea, count1, count2;
   char title[73], name[41], v[5];
   char *in1, *in2, *out1, *out2, *out3, *out4;
   FILE *fp_in1, *fp_in2;
   lans lan;
   long nvectors;  

   struct svd_st
   {
      int imagic;
      float fmagic;
      int size[4];
      int folded[2];
   };
   struct svd_st header;

 public:
   las2(); 
   ~las2() { }
   void init_files(); 
   void write_data();  
   void check(); 
   void allocate_mem(); 
   void read_data(); 
   void run_landr(); 
   long landr(long,long,long,long,double,double,long,double,double *,double *,double *); 
   void output(); 
 
}; 



