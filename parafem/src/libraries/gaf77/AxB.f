c  **********************************************************************
c  *                                                                    *
c  *                            Subroutine AxB                          *
c  *                                                                    *
c  **********************************************************************
c  Single Precision Version 1.01
c  Written by Gordon A. Fenton, TUNS, 1991
c  Latest Update: Jun 9, 1999
c
c  PURPOSE   to compute the matrix multiplication [A][B] = [C]
c
c  This routine takes the three matrices [A] of size n x m, [B] of size m x p,
c  and produces the inner product matrix [C] = [A][B] of size n x p.
c  Arguments to the routine are as follows;
c
c    A    real array of size at least n x m which contains the elements of
c         the matrix [A]. (input)
c
c   ia    leading dimension of the array A exactly as specified by the
c         dimension statement in the calling routine. (input)
c
c    B    real array of size at least m x p which contains the elements of
c         the matrix [B]. (input)
c
c   ib    leading dimension of the array B exactly as specified by the
c         dimension statement in the calling routine. (input)
c
c    C    real array of size at least n x p which will contain the elements of
c         the matrix product [A][B]. (output)
c
c   ic    leading dimension of the array C exactly as specified by the
c         dimension statement in the calling routine. (input)
c
c    n    column dimension of the matrix [A]. (input)
c
c    m    row dimension of the matrix [A] and column dimension of the matrix
c         [B]. (input)
c
c    p    row dimension of the matrix [B]. (input)
c
c  REVISION HISTORY:
c  1.01	replaced dummy dimensions with a (*) for GNU's compiler (Jun 9/99)
c----------------------------------------------------------------------------
      subroutine AxB( A, ia, B, ib, C, ic, n, m, p )
      dimension A(ia,*), B(ib,*), C(ic,*)
      integer n, m, p
      data zero/0.0/

      do 20 j = 1, p
      do 20 i = 1, n
         s = zero
         do 10 k = 1, m
            s = s + A(i,k)*B(k,j)
  10     continue
         C(i,j) = s
  20  continue

      return
      end
