MODULE PARTITION

  !/****h* /partition
  !*  NAME
  !*    MODULE: partition
  !*  SYNOPSIS
  !*    Usage:      USE partition
  !*  FUNCTION
  !*    Contains subroutines required for subdividing a finite element problem
  !*    over multiple processors.
  !*    
  !*    Subroutine             Purpose
  !*    
  !*    CALC_NODES_PP          Subdivide the nodes across processors
  !*  AUTHOR
  !*    F. Calvo
  !*    L. Margetts
  !*  COPYRIGHT
  !*    2004-2010 University of Manchester
  !******
  !*  Place remarks that should not be included in the documentation here.
  !*
  !*/
  
  USE precision

  CONTAINS

!---------------------------------------------------------------------------
!---------------------------------------------------------------------------
!---------------------------------------------------------------------------

  SUBROUTINE CALC_NODES_PP(nn,npes,numpe,node_end,node_start,nodes_pp)

    !/****f* partition/calc_nodes_pp
    !*  NAME
    !*    SUBROUTINE: calc_nodes_pp
    !*  SYNOPSIS
    !*    Usage:      CALL calc_nodes_pp(node_end,node_start,nn,npes,numpe, &
    !*                                   nodes_pp)
    !*  FUNCTION
    !*    Subdivide the nodes across the processors. Strategy similar to that
    !*    found in CALC_NELS_PP and CALC_NEQ_PP.
    !*  INPUTS
    !*    The following arguments have the INTENT(IN) attribute:
    !*
    !*    nn                    : Integer
    !*                          : Total number of nodes
    !*
    !*    npes                  : Integer
    !*                          : Number of processes
    !*
    !*    numpe                 : Integer
    !*                          : Processor number
    !*
    !*    The following arguments have the INTENT(OUT) attribute:
    !*
    !*    node_end              : Integer
    !*                          : Last node stored in the process
    !*
    !*    node_start            : Integer
    !*                          : First node stored in the process
    !*
    !*    nodes_pp              : Integer
    !*                          : Number of nodes assigned to the process
    !*  AUTHOR
    !*    F. Calvo
    !*  COPYRIGHT
    !*    (c) University of Manchester 2007-2010
    !******
    !*  Place remarks that should not be included in the documentation here.
    !*
    !*  nodes_pp is different from nn_pp
    !*
    !*  Example to understand this subroutine:
    !* If we have:   nn = 103  (number of nodes)
    !*               npes = 5  (number of processors)
    !* The output will be:
    !* nodes_pp2 = 20 (103/5=20, so 20 nodes for each processor and the 3 nodes
    !*           remaining will be assignated (because we want to) to the first
    !*                3 processors)
    !* num_nodes_pp1 = 3  (103 - 20*5 = 3, these are the 3 nodes remaining)
    !* nodes_pp2 = 21 (number of nodes assignated to the first 3 processors)
    !* So the assignation is:
    !* 21 nodes (nodes_pp1) to processors 1, 2 and 3
    !* 20 nodes (nodes_pp2) to processors 4 and 5
    !* That is:
    !* numpe = 1 ----->   nodes_pp=21    node_start=1
    !* numpe = 2 ----->   nodes_pp=21    node_start=22
    !* numpe = 3 ----->   nodes_pp=21    node_start=43
    !* numpe = 4 ----->   nodes_pp=20    node_start=64
    !* numpe = 5 ----->   nodes_pp=20    node_start=84
    !*
    !*/

    IMPLICIT NONE

    INTEGER, INTENT(IN)  :: nn, npes, numpe
    INTEGER, INTENT(OUT) :: node_end, node_start, nodes_pp
    INTEGER              :: nodes_pp1, nodes_pp2, num_nodes_pp1 


    IF (npes == 1) THEN
      nodes_pp1  = 0
      nodes_pp2  = nn
      nodes_pp   = nodes_pp2
      node_start = 1
      node_end   = nn
    ELSE
      nodes_pp2 = nn/npes
      num_nodes_pp1 = nn - nodes_pp2*npes
      IF (num_nodes_pp1 == 0) THEN
        nodes_pp1 = nodes_pp2
      ELSE
        nodes_pp1 = nodes_pp2 + 1
      ENDIF
      IF (numpe <= num_nodes_pp1 .OR. num_nodes_pp1 == 0) THEN
        nodes_pp = nodes_pp1
        node_start = (numpe - 1)*nodes_pp1 + 1
      ELSE
        nodes_pp = nodes_pp2
        node_start = num_nodes_pp1*nodes_pp1 +                         &
                     (numpe - num_nodes_pp1 - 1)*(nodes_pp1- 1) + 1
      ENDIF
      node_end = node_start + nodes_pp - 1
    ENDIF

  END SUBROUTINE CALC_NODES_PP

!---------------------------------------------------------------------------
!---------------------------------------------------------------------------
!---------------------------------------------------------------------------
 
END MODULE PARTITION