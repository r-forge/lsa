/********************************************************************

                        Singular Value Decomposition

                        (C) Copyright 1999, 2000, 2001, 2005, 2006, 2007

                        Haibin Tang
                        Justin Giles
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
                      203 Claxton Complex
                      University of Tennessee
                      Knoxville, TN 37996-3450

********************************************************************/

#include <iostream>
#include <fstream>
#include <cstring>
#include <cstdlib>
#include "las2.h"

using namespace std;

extern general gen; 
extern com_routines com_r; 
extern matrix_comp comp; 
extern options opts; 



las2::las2() {
  in2 = "matrix.hb";
  out1 = "lao2";
  out2 = "lalv2";
  out3 = "larv2"; 
  out4 = "output";
}



void las2::init_files() {
  int out_of_core = opts.mem_mgt & OUT_CORE;

  // open files for input/output 
  if(!(fp_in2 = fopen(in2, "r"))) {
    printf("cannot open file %s for reading\n", in2);
    exit(1);
  }
  if(!(gen.fp_out1 = fopen(out1, "w"))) {
    printf("cannot open output file %s \n", out1);
    exit(1);
  }

  /* read data */
  fscanf(fp_in2, "%12c%*s%*s%*s%ld%ld%ld%*d", title, &gen.nrow, &gen.ncol, &nnzero);
  title[13] = '\0';

  if(opts.mem_mgt & A_OUT_CORE)
    if(((gen.fp_a = creat("a_temp", PERMS)) == -1) ||
       ((gen.fp_a = open("a_temp", O_RDWR, 0)) == -1)) {
         printf("cannot create/open temporary working file\n");
         exit(-1);
    }

  strcpy(name,opts.name); 
  lanmax = opts.lanmax; 
  maxprs = opts.maxprs; 
  endl = opts.endl; 
  endr = opts.endr; 
  strcpy(v, "TRUE"); 
  kappa = opts.kappa;   
    
  //create lalv2 & larv2 files only if output file is not generated
  //and all vectors are to be stored in core
  vectors = 0; 
  if(!(strcmp(v, "TRUE"))) {
    vectors = 1;
    if(!opts.createout || out_of_core) {
      if(((gen.fp_out2 = creat(out2, 0644)) == -1) ||
         ((gen.fp_out3 = creat(out3, 0644)) == -1)) {
        printf("cannot creat s-vector output file(s)\n");
        exit(1);
      }
    }
  }
    
  if(gen.nrow >= gen.ncol) {
    gen.transpose = 0; 
    n = gen.ncol; 
  }
  else {
    gen.transpose = 1; 
    n = gen.nrow; 
  } 
   
  if(lanmax > n) lanmax = opts.lanmax = n; 
  if(maxprs > n) maxprs = opts.maxprs = n;     
  if(opts.maxfact > n) opts.maxfact = n;
}



//write header of output file
void las2::write_data()  {
  if(gen.transpose) fprintf(gen.fp_out1, "transposed\n"); 
  else fprintf(gen.fp_out1,"not transposed\n"); 

  if(opts.mem_mgt & OUT_CORE)
    fprintf(gen.fp_out1, " ... SINGULAR VECTORS STORED OUT OF CORE\n");
  else
    fprintf(gen.fp_out1, " ... SINGULAR VECTORS STORED IN CORE\n");
  if(opts.mem_mgt & A_OUT_CORE)
    fprintf(gen.fp_out1, " ... LANCZOS VECTORS STORED OUT OF CORE\n");
  else
    fprintf(gen.fp_out1, " ... LANCZOS VECTORS STORED IN CORE\n");

  fprintf(gen.fp_out1, " ... \n");
  fprintf(gen.fp_out1, " ... SOLVE THE [A^TA]   EIGENPROBLEM\n");
  fprintf(gen.fp_out1, " ... NO. OF EQUATIONS          =%5ld\n", n);
  fprintf(gen.fp_out1, " ... MAX. NO. OF LANCZOS STEPS =%5ld\n", lanmax);
  fprintf(gen.fp_out1, " ... MAX. NO. OF EIGENPAIRS    =%5ld\n", maxprs);
  fprintf(gen.fp_out1, " ... LEFT  END OF THE INTERVAL =%10.2E\n", endl);
  fprintf(gen.fp_out1, " ... RIGHT END OF THE INTERVAL =%10.2E\n", endr);

  if(vectors)
    fprintf(gen.fp_out1, " ... WANT S-VECTORS?   [T/F]   =   T\n");
  else
    fprintf(gen.fp_out1, " ... WANT S-VECTORS?   [T/F]   =   F\n");

  fprintf(gen.fp_out1, " ... KAPPA                     =%10.2E\n", kappa);
  fprintf(gen.fp_out1, " %s\n", title);
  fprintf(gen.fp_out1, "           %s\n", name);
 
  if(gen.transpose) {
    fprintf(gen.fp_out1, " ... NO. OF TERMS     (COLS)   = %8ld\n", gen.ncol); 
    fprintf(gen.fp_out1, " ... NO. OF DOCUMENTS (ROWS)   = %8ld\n", gen.nrow); 
  }
  else {
    fprintf(gen.fp_out1, " ... NO. OF TERMS     (ROWS)   = %8ld\n", gen.nrow);
    fprintf(gen.fp_out1, " ... NO. OF DOCUMENTS (COLS)   = %8ld\n", gen.ncol);
  }

  fprintf(gen.fp_out1, " ... ORDER OF MATRIX A         = %8ld\n", n);
  fprintf(gen.fp_out1, " ... \n");
  return;
}



void las2::check() {
  int out_of_core = opts.mem_mgt & OUT_CORE;

  if(com_r.check_parameters(maxprs,lanmax,n,endl,endr,vectors,nnzero)) {
    if(fp_in2) fclose(fp_in2); 
    fp_in2 = NULL;
    fclose(gen.fp_out1); 
    if(vectors && (!opts.createout || out_of_core)) {
      close(gen.fp_out2); 
      close(gen.fp_out3); 
    }
    exit(1); 
  }
}



/*******************************************************************
 * allocate memory                                                 *
 * pointr - column start array of harwell-boeing sparse matrix     *
 *          format                                       (ncol+1)  *
 * rowind - row indices array of harwell-boeing format   (nnzero)  *
 * value  - nonzero values array of harwell-boeing sparse matrix   *
 *          format                                       (nnzero)  *
 * r      - work array                                        (n)  *
 * ritz   - array of ritz values                              (n)  *
 * bnd    - array of error bounds                             (n)  *
 * d      - array of approximate singular values of matrix A  (n)  *
 * ztemp  - work array for user function opb               (nrow)  *
 * a      - storage area for Lanczos vectors     (n * (lanmax+2))  *
 *******************************************************************/
void las2::allocate_mem() {
  gen.mxvcount = 0; 
  if(opts.mem_mgt & A_OUT_CORE) sizea = 0;
  else sizea = n*(lanmax+2); 

  if(gen.transpose)
    size1 = sizeof(double)*(4*n+gen.ncol+nnzero+sizea);
  else
    size1 = sizeof(double)*(4*n+gen.nrow+nnzero+sizea); 
 
  size2 = sizeof(long)*(gen.ncol+1+nnzero);

  if(!(gen.pointr = new long[size2/sizeof(long)]) || 
     !(gen.value  = new double[size1/sizeof(double)])) {
    perror("NEW FAILED");
    exit(errno);
  }
  tptr1 = gen.value;

  /* allocated memory including work array used in landr */
  memory = size1 + size2 + sizeof(double) * (5 * n + lanmax * 4 + 1);

  gen.rowind = gen.pointr + gen.ncol + 1;
  tptr1 += nnzero;
  r = tptr1;
  tptr1 += n;
  ritz = tptr1;
  tptr1 += n;
  bnd = tptr1;
  tptr1 += n;
  d = tptr1;
  tptr1 += n;

  gen.ztemp = tptr1;

  if(!(opts.mem_mgt & A_OUT_CORE)) {
    if(gen.transpose) tptr1 += gen.ncol; 
    else tptr1 += gen.nrow; 
    gen.a = tptr1;
  }
}



void las2::read_data() {
  /* skip data format line */
  fscanf(fp_in2, "%*s %*s %*s %*s");

  /* read data */
  for(i = 0; i <= gen.ncol; i++) fscanf(fp_in2, "%ld", &gen.pointr[i]);
  for(i = 0; i <= gen.ncol; i++) gen.pointr[i] -= 1;

  /* define last element of pointr in case it is not */
  gen.pointr[i] = nnzero;

  for(i = 0; i < nnzero; i++) fscanf(fp_in2, "%10ld", &gen.rowind[i]);
  for(i = 0; i < nnzero; i++) gen.rowind[i] -= 1;
  for(i = 0; i < nnzero; i++) fscanf(fp_in2, "%lf", &gen.value[i]);

  /* to get a random starting vector, the first n cells must be
     initialize to zero */
  for(i = 0; i < n; i++) r[i] = 0.;

  if(fp_in2) fclose(fp_in2); 
  fp_in2 = NULL;
}



/***********************************************************************
 *                                                                     *
 *                              landr()                                *
 *        Lanczos algorithm with selective orthogonalization           *
 *                    Using Simon's Recurrence                         *
 *                       (double precision)                            *
 *                                                                     *
 ***********************************************************************/
/***********************************************************************

   Description
   -----------

   landr() is the LAS2 driver routine that, upon entry,
     (1)  checks for the validity of input parameters of the
          B-eigenproblem
     (2)  determines several machine constants
     (3)  makes a Lanczos run
     (4)  calculates B-eigenvectors (singular vectors of A) if requested
          by user


   arguments
   ---------

   (input)
   n        dimension of the eigenproblem for A'A
   lanmax   upper limit of desired number of Lanczos steps
   maxprs   upper limit of desired number of eigenpairs
   nnzero   number of nonzeros in matrix A
   endl     left end of interval containing unwanted eigenvalues of B
   endr     right end of interval containing unwanted eigenvalues of B
   vectors  1 indicates both eigenvalues and eigenvectors are wanted
              and they can be found in output file lav2;
            0 indicates only eigenvalues are wanted
   kappa    relative accuracy of ritz values acceptable as eigenvalues
              of B (singular values of A)
   r        work array

   (output)
   j        number of Lanczos steps actually taken
   neig     number of ritz values stabilized
   ritz     array to hold the ritz values
   bnd      array to hold the error bounds


   External parameters
   -------------------

   Defined and documented in las2.h


   local parameters
   -------------------

   ibeta    radix for the floating-point representation
   it       number of base ibeta digits in the floating-point significand
   irnd     floating-point addition rounded or chopped
   machep   machine relative precision or round-off error
   negeps   largest negative integer
   wptr     array of pointers each pointing to a work space


   Functions used
   --------------

   MISC         dmax, machar, check_parameters
   LAS2         ritvec, lanso

 ***********************************************************************/
long las2::landr(long n,long lanmax,long maxprs,long nnzero,double endl,
	         double endr, long vectors, double kappa, double *ritz,
		 double *bnd, double *r) 
{ 
  long i, size, ibeta, it, irnd, machep, negep;
  double *wptr[10], *tptr, *tptr2;

  /* data validation */
  if(com_r.check_parameters(maxprs, lanmax, n, endl, endr, vectors, nnzero))
    return(-1);

  /* Compute machine precision */
  com_r.machar(&ibeta, &it, &irnd, &machep, &negep);

  gen.eps1 = gen.eps * sqrt((double)n);
  gen.reps = sqrt(gen.eps);
  gen.eps34 = gen.reps * sqrt(gen.reps);

  /* allocate work area and initialize pointers         *
   * ptr             symbolic name         size         *
   * wptr[0]             r                  n           *
   * wptr[1]             q                  n           *
   * wptr[2]             q_previous         n           *
   * wptr[3]             p                  n           *
   * wptr[4]             p_previous         n           *
   * wptr[5]             wrk                n           *
   * wptr[6]             alf              lanmax        *
   * wptr[7]             eta              lanmax        *
   * wptr[8]             oldeta           lanmax        *
   * wptr[9]             bet              lanmax+1      */

  size = 5 * n + (lanmax * 4 + 1);
  tptr = NULL;
  if(!(tptr = new double[size])) {
    perror("FIRST MALLOC FAILED in LANDR()");
    exit(errno);
  }
  tptr2 = tptr;
  wptr[0] = r;
  for(i = 1; i <= 5; i++) {
    wptr[i] = tptr;
    tptr += n;
  }
  for(i = 6; i <= 9; i++) {
    wptr[i] = tptr;
    tptr += lanmax;
  }

  lan.lanso(n, lanmax, maxprs, endl, endr, ritz, bnd, wptr);

  if(opts.mem_mgt & OUT_CORE) nvectors = 1;
  else nvectors = gen.j + 1; 
  if(gen.transpose) nother = gen.ncol; 
  else nother = gen.nrow; 

  /* compute eigenvectors */
  if(vectors) {
    if(!(gen.xv1 = new double[n*nvectors]) || !(gen.xv2 = new double[nother])) {
      perror("SECOND MALLOC FAILED in LANDR()");
      exit(errno);
    }
    kappa = com_r.dmax(fabs(kappa), gen.eps34);
    lan.ritvec(n, kappa, ritz, bnd, wptr[6], wptr[9], wptr[4], wptr[5]);
  }

  delete [] tptr2;
  return(0);
}



void las2::run_landr() {
  int out_of_core = opts.mem_mgt & OUT_CORE;
  exetime = com_r.timer(); 

  if(landr(n,lanmax,maxprs,nnzero,endl,endr,vectors,kappa,ritz,bnd,r)) {
    delete [] gen.value; 
    delete [] gen.pointr; 
    if(fp_in2) fclose(fp_in2); 
    fp_in2 = NULL;
    fclose(gen.fp_out1); 
    if(vectors && (!opts.createout || out_of_core)) {
      close(gen.fp_out2);
      close(gen.fp_out3);  
      delete [] gen.xv1; 
      delete [] gen.xv2; 
    }
    if(opts.mem_mgt & A_OUT_CORE) {
      close(gen.fp_a);
      unlink("a_temp");
    }
    exit(-1); 
  }

  /* delete working file to make room for singular vectors file */
  if(opts.mem_mgt & A_OUT_CORE) {
    close(gen.fp_a);
    unlink("a_temp");
  }

  exetime = com_r.timer() - exetime; 
}



void las2::output() {
  char commentbuf[256] = "Creating output file";
  int out_of_core = opts.mem_mgt & OUT_CORE;
  double val_ptr[1];
  int sizelong = sizeof(long);
  int start;
  float val;

  start = gen.nsig - opts.maxfact;
  if(start < 0 || opts.maxfact <= 0) start = 0;

  if(vectors && (!opts.createout || out_of_core)) {
//	  lseek(gen.fp_out3, 0L, 0);
    close(gen.fp_out3);
    gen.fp_out3 = open(out3, O_RDONLY, "rb");
  }

  /* memory allocated for xv1, xv2 and s in landr() */
  if(vectors) 
    memory += sizeof(double) * (n * nvectors + nother + (gen.j+1) * (gen.j+1));

  /* print error code if not zero */
  if(gen.ierr)
    fprintf(gen.fp_out1, " ... RETURN FLAG = %9ld ...\n", gen.ierr);

  /* print ritz values and error bounds */
  fprintf(gen.fp_out1, "\n");
  fprintf(gen.fp_out1, " ...... ALLOCATED MEMORY (BYTES)= %10.2E\n", (float)memory); 
  fprintf(gen.fp_out1, " ...... LANSO EXECUTION TIME=%10.2E\n", exetime);
  fprintf(gen.fp_out1, " ...... \n");
  fprintf(gen.fp_out1, " ...... NUMBER OF LANCZOS STEPS = %3ld       NEIG = %3ld\n", gen.j+1, gen.neig);
  fprintf(gen.fp_out1, " ...... \n");
  fprintf(gen.fp_out1, " ......         COMPUTED RITZ VALUES  (ERROR BNDS)\n"); 
  fprintf(gen.fp_out1, " ...... \n");

  for(i = 0; i <= gen.j; i++)
    fprintf(gen.fp_out1, " ...... %3ld   %22.14E  (%11.2E)\n", i + 1, ritz[i], bnd[i]);

  /* compute residual error when singular values and vectors are
   * computed.  This is done only for singular values that are
   * within the relative accuracy (kappa) */
  if(vectors) {
    if(!opts.createout) {
      size2 = sizeof(double) * n; 
      size1 = sizeof(double) * nother;

      if(out_of_core) lseek(gen.fp_out3, 0L, 0);

      t0 = com_r.timer();
      id = 0;

      for(i = 0; i < gen.nsig; i++) {
        if(out_of_core) read(gen.fp_out3, (char *)gen.xv1, size2);

        /* multiply by matrix B first */
        comp.opb(n, &gen.xv1[id], gen.xv2);
        tmp0 = comp.ddot(n, &gen.xv1[id], 1, gen.xv2, 1);
        comp.daxpy(n, -tmp0, &gen.xv1[id], 1, gen.xv2, 1);
        tmp0 = sqrt(tmp0);
        xnorm = sqrt(comp.ddot(n, gen.xv2, 1, gen.xv2, 1));

        /* multiply by matrix A to get (scaled) left s-vector */
        comp.opa(&gen.xv1[id], gen.xv2);
        tmp1 = 1.0 / tmp0;
        comp.dscal(nother, tmp1, gen.xv2, 1);
        xnorm *= tmp1;
        bnd[i] = xnorm;
        d[i] = tmp0;

        if(gen.transpose) {
          /* write left s-vector to output file */
          write(gen.fp_out2, (char *)gen.xv2, size1);
        }
        else {
          /* write right s-vector to output file */
          write(gen.fp_out2, (char *)&gen.xv1[id], size2); 
        }
        if(!out_of_core) id += n;
      }
    }
    else {                //-O flag is on, create output file
      size2 = sizeof(double) * n; 
      size1 = sizeof(double) * nother;

      if((gen.fp_out4 = creat(out4, 0644)) == -1)
      { printf("Cannot create/open out file\n"); exit(1); }

      if(!(gen.xv3 = new double [gen.nsig * nother]))
      { perror("New failed for xv3 in output()"); exit(errno); }

      t0 = com_r.timer();
      id = 0;
      for(i = 0; i < gen.nsig; i++) {
        if(out_of_core) read(gen.fp_out3, (char *)gen.xv1, size2);

        /* multiply by matrix B first */
        comp.opb(n, &gen.xv1[id], gen.xv2);
        tmp0 = comp.ddot(n, &gen.xv1[id], 1, gen.xv2, 1);
        comp.daxpy(n, -tmp0, &gen.xv1[id], 1, gen.xv2, 1);
        tmp0 = sqrt(tmp0);
        xnorm = sqrt(comp.ddot(n, gen.xv2, 1, gen.xv2, 1));

        /* multiply by matrix A to get (scaled) left s-vector */
        comp.opa(&gen.xv1[id], gen.xv2);
        tmp1 = 1.0 / tmp0;
        comp.dscal(nother, tmp1, gen.xv2, 1);
        xnorm *= tmp1;
        bnd[i] = xnorm;
        d[i] = tmp0;

        for(h = 0; h < nother; h++)
        gen.xv3[(i * nother) + h] = gen.xv2[h];

        if(!out_of_core) id += n;
      }

      header.imagic = IMAGIC;
      header.fmagic = FMAGIC;
      header.size[TERM] = gen.ncol;
      header.size[DOCUMENT] = gen.nrow;
      header.size[FACTOR] = gen.nsig;
      if(opts.maxfact < gen.nsig && opts.maxfact > 0)
        header.size[FACTOR] = opts.maxfact;
      header.size[COMMENT] = strlen(commentbuf);
      header.folded[TERM] = 0;
      header.folded[DOCUMENT] = 0;
      write(gen.fp_out4, (char *) &header, sizeof(struct svd_st));
      write(gen.fp_out4, commentbuf, header.size[COMMENT]);

      //start = gen.nsig - opts.maxfact;
      //if(start < 0 || opts.maxfact <= 0) start = 0;
      if(gen.transpose) {
        /* Print terms to out file */
        for(i = 0; i < nother; i++) {
          for(h = 0; h < gen.nsig - start; h++) {
            val = (float) gen.xv3[((gen.nsig - h - 1) * nother) + i];
            write(gen.fp_out4, (char *) &val, sizeof(float));
          }
        }
           
        /* Print documents to out file */
        if(out_of_core) {
          if(gen.fp_out3) close(gen.fp_out3);
          gen.fp_out3 = open(out3, O_RDONLY, "rb");
          delete [] gen.xv1;
          delete [] gen.xv2;
          if(!(gen.xv1 = new double[size2]))
          { perror("MALLOC FAILED IN OUTPUT()"); exit(errno); }
          if(!(gen.xv2 = new double[size1]))
          { perror("MALLOC FAILED IN OUTPUT()"); exit(errno); }
        }
        for(i = 0; i < n; i++) {
          if(out_of_core) {
	    if(gen.fp_out3) lseek(gen.fp_out3, 0L, 0);
	    else gen.fp_out3 = open(out3, O_RDONLY, "rb");
          }
          for(h = 0; h < gen.nsig; h++) {
            if(out_of_core) {
              read(gen.fp_out3, (char *)gen.xv1, size2);
              gen.xv2[h] = gen.xv1[i];
            }
            else {
              val = (float) gen.xv1[((gen.nsig - h - 1) * n) + i];
              write(gen.fp_out4, (char *) &val, sizeof(float));
            }
          }
          if(out_of_core) { 
            for(h = gen.nsig - 1; h >= start; h--) {
              val = (float) gen.xv2[h];
              write(gen.fp_out4, (char *) &val, sizeof(float));
            }
          }
        }
      }
      else {  //!gen.transpose--This case brings all singular vectors into
              //memory even if out of core is requested
        /* Print terms to out file */
        if(out_of_core) {
          cout << "Out of core requested, not performed.\n";
          //if(gen.fp_out3) close(gen.fp_out3);
	  if(gen.fp_out3) lseek(gen.fp_out3, 0L, 0);
	  else gen.fp_out3 = open(out3, O_RDONLY, "rb");
          delete [] gen.xv1;
          if(!(gen.xv1 = new double[gen.nsig * size2]))
          { perror("MALLOC FAILED IN OUTPUT()"); exit(errno); }
        }
        for(i = 0; i < n; i++) {
          if(out_of_core) read(gen.fp_out3, (char *)gen.xv1, size2);
          for(h = 0; h < gen.nsig - start; h++) {
            val = (float) gen.xv1[((gen.nsig - h - 1) * n) + i];
            write(gen.fp_out4, (char *) &val, sizeof(float));
          }
        }

        /* Print documents to out file */
        for(i = 0; i < nother; i++) {
          for(h = 0; h < gen.nsig - start; h++) {
            val = (float) gen.xv3[((gen.nsig - h - 1) * nother) + i];
            write(gen.fp_out4, (char *) &val, sizeof(float));
          }
        }
      }

      /* Print singular values to out file */
      for(i = gen.nsig-1; i >= 0 && i >= start; i--) {
        val = (float) d[i];
        write(gen.fp_out4, (char *) &val, sizeof(float));
      }
        
      close(gen.fp_out4);
      delete [] gen.xv3; 
    }
    exetime += (com_r.timer() - t0);
    count1=(gen.mxvcount-gen.nsig)/2 + gen.nsig;
    count2=(gen.mxvcount-gen.nsig)/2;
    fprintf(gen.fp_out1, " ...... \n");
    fprintf(gen.fp_out1, " ...... NO. MULTIPLICATIONS BY A  =%10ld\n", count1);
    fprintf(gen.fp_out1, " ...... NO. MULT. BY TRANSPOSE(A) =%10ld\n", count2);
    fprintf(gen.fp_out1, "\n");
    fprintf(gen.fp_out1, " ...... LASVD EXECUTION TIME=%10.2E\n", exetime);
    fprintf(gen.fp_out1, " ...... \n");
    if(opts.maxfact < gen.nsig && opts.maxfact > 0)
      fprintf(gen.fp_out1, " ......        NSIG = %4ld\n", opts.maxfact);
    else fprintf(gen.fp_out1, " ......        NSIG = %4ld\n", gen.nsig);
    fprintf(gen.fp_out1, " ...... \n");
    fprintf(gen.fp_out1, " ......         COMPUTED S-VALUES     (RES. NORMS)\n");
    fprintf(gen.fp_out1, " ...... \n");
    for(i = start; i < gen.nsig; i++)
      fprintf(gen.fp_out1, " ...... %3ld   %22.14E  (%11.2E)\n", i + 1 - start, d[i], bnd[i]);
  }
  else {
    for(i = gen.j; i >= 0; i--)
      if(bnd[i] > kappa * fabs(ritz[i])) break;
    gen.nsig = gen.j - i;

    count1=(gen.mxvcount-gen.nsig)/2 + gen.nsig;
    count2=(gen.mxvcount-gen.nsig)/2;
    fprintf(gen.fp_out1," ...... \n");
    fprintf(gen.fp_out1," ...... NO. MULTIPLICATIONS BY A  =%10ld\n", count1);
    fprintf(gen.fp_out1," ...... NO. MULT. BY TRANSPOSE(A) =%10ld\n", count2);
    fprintf(gen.fp_out1, "\n");
    fprintf(gen.fp_out1," ...... LASVD EXECUTION TIME = %10.2E\n", exetime);
    fprintf(gen.fp_out1," ...... \n");
    if(opts.maxfact < gen.nsig && opts.maxfact > 0)
      fprintf(gen.fp_out1," ......         NSIG = %4ld\n" , opts.maxfact);
    else fprintf(gen.fp_out1," ......         NSIG = %4ld\n" , gen.nsig);
    fprintf(gen.fp_out1," ...... \n");
    fprintf(gen.fp_out1," ......         COMPUTED S-VALUES   (ERROR BNDS)\n");
    fprintf(gen.fp_out1," ...... \n");

    k = gen.j + 1 - gen.nsig;
    for(i = start + 1 ; i <= gen.nsig; i++) {
      fprintf(gen.fp_out1," ...... %3ld   %22.14E  (%11.2E)\n", i - start, sqrt(ritz[k]), bnd[k]);
      k++;
    }
  }
  delete [] gen.value;
  delete [] gen.pointr;
  if(fp_in2) fclose(fp_in2);
  fp_in2 = NULL;
  fclose(gen.fp_out1);
  if(vectors) {
    delete [] gen.xv1;
    delete [] gen.xv2;
    if(!opts.createout || out_of_core) {
      close(gen.fp_out2);
      close(gen.fp_out3); 
    }
  }
  if(vectors && opts.createout && out_of_core) {
    if(unlink(out2) != 0)
      cerr << "GTP: error, " << out2 << " not removed.\n";
    if(unlink(out3) != 0)
      cerr << "GTP: error, " << out3 << " not removed.\n";
  }
}
