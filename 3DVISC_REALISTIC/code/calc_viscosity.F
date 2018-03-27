C $Header: /u/gcmpack/MITgcm/model/src/calc_viscosity.F,v 1.11 2014/12/24 19:09:33 jmc Exp $
C $Name:  $

#include "PACKAGES_CONFIG.h"
#include "CPP_OPTIONS.h"

CBOP
C     !ROUTINE: CALC_VISCOSITY
C     !INTERFACE:
      SUBROUTINE CALC_VISCOSITY(
     I           bi,bj, iMin,iMax,jMin,jMax,
     O           KappaRU, kappaRV,
     I           myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | SUBROUTINE CALC_VISCOSITY
C     | o Calculate net vertical viscosity
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     == GLobal variables ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "DYNVARS.h"
#include "GRID.h"
#include "PTRACERS_SIZE.h"
#include "PTRACERS_PARAMS.h"
#include "PTRACERS_START.h"
#include "PTRACERS_FIELDS.h"
#include "GAD.h"

C     !INPUT/OUTPUT PARAMETERS:
C     == Routine arguments ==
C     iMin,iMax,jMin,jMax :: Range of points for which calculation
C     bi,bj   :: current tile indices
C     kappaRU :: Total vertical viscosity for zonal flow.
C     kappaRV :: Total vertical viscosity for meridional flow.
C     KappaRk :: vertical diffusion used for one passive tracer
C     myThid  :: my Thread Id number
      INTEGER iMin,iMax,jMin,jMax
      INTEGER bi,bj
      _RL kappaRU(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1)
      _RL kappaRV(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr+1)
      _RL KappaRk(1-OLx:sNx+OLx,1-OLy:sNy+OLy,Nr)
      INTEGER myThid

C     !LOCAL VARIABLES:
C     == Local variables ==
C     i, j, k :: Loop counters
C     GAD_TR :: passive tracer id (GAD_TR1+iTracer-1)
      INTEGER i,j,k
      INTEGER ki
      INTEGER GAD_TR
CEOP

C    I made up this value based on definition and the fact that I only have 1 tracer
      GAD_TR = 1
C ---------- Add call to diffusivity ------------------------------------
C I used itracer = 1 in PTRACERS_useGMREDI and KPP to avoid defining another variable
C----------------------------------------------------------------------------------- 
      CALL CALC_3D_DIFFUSIVITY(
     I         bi, bj, iMin,iMax,jMin,jMax,
     I         GAD_TR,
     I         PTRACERS_useGMRedi(1), PTRACERS_useKPP(1),
     O         kappaRk,
     I         myThid)
C -----------------------------------------------------------------------

 
      DO k = 1,Nr+1
       ki = MIN(k,Nr)

       DO j = 1-OLy, sNy+OLy
        DO i = 1-OLx, sNx+OLx
C --- The original file has the following two lines:
C         kappaRU(i,j,k) = viscArNr(ki)
C         kappaRV(i,j,k) = viscArNr(ki)
C --- I want to make viscAz equal to Kz so that I can have 3D Az - KRM
          kappaRU(i,j,k) = kappaRk(i,j,ki)
          kappaRV(i,j,k) = kappaRk(i,j,ki)
         ENDDO
       ENDDO
       	

#ifdef ALLOW_KPP
       IF ( useKPP .AND. k.LE.Nr ) THEN
         CALL KPP_CALC_VISC(
     I        bi,bj, iMin,iMax,jMin,jMax, k,
     O        kappaRU, kappaRV,
     I        myThid)
       ENDIF
#endif

#ifdef ALLOW_PP81
       IF ( usePP81 .AND. k.LE.Nr ) THEN
         CALL PP81_CALC_VISC(
     I        bi,bj, iMin,iMax,jMin,jMax, k,
     O        kappaRU, kappaRV,
     I        myThid)
       ENDIF
#endif

#ifdef ALLOW_KL10
       IF ( useKL10 .AND. k.LE.Nr ) THEN
         CALL KL10_CALC_VISC(
     I        bi,bj, iMin,iMax,jMin,jMax, k,
     O        kappaRU, kappaRV,
     I        myThid)
       ENDIF
#endif

#ifdef ALLOW_MY82
       IF ( useMY82 .AND. k.LE.Nr ) THEN
         CALL MY82_CALC_VISC(
     I        bi,bj, iMin,iMax,jMin,jMax, k,
     O        kappaRU, kappaRV,
     I        myThid)
       ENDIF
#endif

#ifdef ALLOW_GGL90
       IF ( useGGL90 .AND. k.LE.Nr ) THEN
         CALL GGL90_CALC_VISC(
     I        bi,bj, iMin,iMax,jMin,jMax, k,
     O        kappaRU, kappaRV,
     I        myThid)
       ENDIF
#endif

       IF ( k.EQ.Nr+1 .AND.
     &     ( usePP81 .OR. useKL10 .OR. useMY82 .OR. useGGL90 )
     &    ) THEN
        DO j = 1-OLy, sNy+OLy
         DO i = 1-OLx, sNx+OLx
          kappaRU(i,j,k) = kappaRU(i,j,ki)
          kappaRV(i,j,k) = kappaRV(i,j,ki)
         ENDDO
        ENDDO
       ENDIF

C--   end of k loop
      ENDDO

      RETURN
      END
