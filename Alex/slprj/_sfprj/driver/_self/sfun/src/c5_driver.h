#ifndef __c5_driver_h__
#define __c5_driver_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"

/* Type Definitions */
#ifndef typedef_SFc5_driverInstanceStruct
#define typedef_SFc5_driverInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c5_sfEvent;
  boolean_T c5_isStable;
  boolean_T c5_doneDoubleBufferReInit;
  uint8_T c5_is_active_c5_driver;
} SFc5_driverInstanceStruct;

#endif                                 /*typedef_SFc5_driverInstanceStruct*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c5_driver_get_eml_resolved_functions_info(void);

/* Function Definitions */
extern void sf_c5_driver_get_check_sum(mxArray *plhs[]);
extern void c5_driver_method_dispatcher(SimStruct *S, int_T method, void *data);

#endif
