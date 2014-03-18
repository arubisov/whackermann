/* Include files */

#include <stddef.h>
#include "blas.h"
#include "driver_sfun.h"
#include "c3_driver.h"
#include "mwmathutil.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "driver_sfun_debug_macros.h"
#define _SF_MEX_LISTEN_FOR_CTRL_C(S)   sf_mex_listen_for_ctrl_c(sfGlobalDebugInstanceStruct,S);

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c3_debug_family_names[13] = { "v_lim", "phi_lim", "k_rho",
  "k_alpha", "k_beta", "nargin", "nargout", "rho", "alpha", "beta", "direction",
  "v", "phi" };

/* Function Declarations */
static void initialize_c3_driver(SFc3_driverInstanceStruct *chartInstance);
static void initialize_params_c3_driver(SFc3_driverInstanceStruct *chartInstance);
static void enable_c3_driver(SFc3_driverInstanceStruct *chartInstance);
static void disable_c3_driver(SFc3_driverInstanceStruct *chartInstance);
static void c3_update_debugger_state_c3_driver(SFc3_driverInstanceStruct
  *chartInstance);
static const mxArray *get_sim_state_c3_driver(SFc3_driverInstanceStruct
  *chartInstance);
static void set_sim_state_c3_driver(SFc3_driverInstanceStruct *chartInstance,
  const mxArray *c3_st);
static void finalize_c3_driver(SFc3_driverInstanceStruct *chartInstance);
static void sf_c3_driver(SFc3_driverInstanceStruct *chartInstance);
static void c3_chartstep_c3_driver(SFc3_driverInstanceStruct *chartInstance);
static void initSimStructsc3_driver(SFc3_driverInstanceStruct *chartInstance);
static void registerMessagesc3_driver(SFc3_driverInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c3_machineNumber, uint32_T
  c3_chartNumber);
static const mxArray *c3_sf_marshallOut(void *chartInstanceVoid, void *c3_inData);
static real_T c3_emlrt_marshallIn(SFc3_driverInstanceStruct *chartInstance,
  const mxArray *c3_phi, const char_T *c3_identifier);
static real_T c3_b_emlrt_marshallIn(SFc3_driverInstanceStruct *chartInstance,
  const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId);
static void c3_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData);
static void c3_info_helper(c3_ResolvedFunctionInfo c3_info[21]);
static void c3_check_forloop_overflow_error(SFc3_driverInstanceStruct
  *chartInstance, boolean_T c3_overflow);
static const mxArray *c3_b_sf_marshallOut(void *chartInstanceVoid, void
  *c3_inData);
static int32_T c3_c_emlrt_marshallIn(SFc3_driverInstanceStruct *chartInstance,
  const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId);
static void c3_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData);
static uint8_T c3_d_emlrt_marshallIn(SFc3_driverInstanceStruct *chartInstance,
  const mxArray *c3_b_is_active_c3_driver, const char_T *c3_identifier);
static uint8_T c3_e_emlrt_marshallIn(SFc3_driverInstanceStruct *chartInstance,
  const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId);
static void init_dsm_address_info(SFc3_driverInstanceStruct *chartInstance);

/* Function Definitions */
static void initialize_c3_driver(SFc3_driverInstanceStruct *chartInstance)
{
  chartInstance->c3_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c3_is_active_c3_driver = 0U;
}

static void initialize_params_c3_driver(SFc3_driverInstanceStruct *chartInstance)
{
}

static void enable_c3_driver(SFc3_driverInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c3_driver(SFc3_driverInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c3_update_debugger_state_c3_driver(SFc3_driverInstanceStruct
  *chartInstance)
{
}

static const mxArray *get_sim_state_c3_driver(SFc3_driverInstanceStruct
  *chartInstance)
{
  const mxArray *c3_st;
  const mxArray *c3_y = NULL;
  real_T c3_hoistedGlobal;
  real_T c3_u;
  const mxArray *c3_b_y = NULL;
  real_T c3_b_hoistedGlobal;
  real_T c3_b_u;
  const mxArray *c3_c_y = NULL;
  uint8_T c3_c_hoistedGlobal;
  uint8_T c3_c_u;
  const mxArray *c3_d_y = NULL;
  real_T *c3_phi;
  real_T *c3_v;
  c3_phi = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c3_v = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c3_st = NULL;
  c3_st = NULL;
  c3_y = NULL;
  sf_mex_assign(&c3_y, sf_mex_createcellarray(3), FALSE);
  c3_hoistedGlobal = *c3_phi;
  c3_u = c3_hoistedGlobal;
  c3_b_y = NULL;
  sf_mex_assign(&c3_b_y, sf_mex_create("y", &c3_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c3_y, 0, c3_b_y);
  c3_b_hoistedGlobal = *c3_v;
  c3_b_u = c3_b_hoistedGlobal;
  c3_c_y = NULL;
  sf_mex_assign(&c3_c_y, sf_mex_create("y", &c3_b_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c3_y, 1, c3_c_y);
  c3_c_hoistedGlobal = chartInstance->c3_is_active_c3_driver;
  c3_c_u = c3_c_hoistedGlobal;
  c3_d_y = NULL;
  sf_mex_assign(&c3_d_y, sf_mex_create("y", &c3_c_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c3_y, 2, c3_d_y);
  sf_mex_assign(&c3_st, c3_y, FALSE);
  return c3_st;
}

static void set_sim_state_c3_driver(SFc3_driverInstanceStruct *chartInstance,
  const mxArray *c3_st)
{
  const mxArray *c3_u;
  real_T *c3_phi;
  real_T *c3_v;
  c3_phi = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c3_v = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c3_doneDoubleBufferReInit = TRUE;
  c3_u = sf_mex_dup(c3_st);
  *c3_phi = c3_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c3_u, 0)),
    "phi");
  *c3_v = c3_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c3_u, 1)),
    "v");
  chartInstance->c3_is_active_c3_driver = c3_d_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c3_u, 2)), "is_active_c3_driver");
  sf_mex_destroy(&c3_u);
  c3_update_debugger_state_c3_driver(chartInstance);
  sf_mex_destroy(&c3_st);
}

static void finalize_c3_driver(SFc3_driverInstanceStruct *chartInstance)
{
}

static void sf_c3_driver(SFc3_driverInstanceStruct *chartInstance)
{
  real_T *c3_rho;
  real_T *c3_v;
  real_T *c3_phi;
  real_T *c3_alpha;
  real_T *c3_beta;
  real_T *c3_direction;
  c3_direction = (real_T *)ssGetInputPortSignal(chartInstance->S, 3);
  c3_beta = (real_T *)ssGetInputPortSignal(chartInstance->S, 2);
  c3_alpha = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c3_phi = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c3_v = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c3_rho = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 2U, chartInstance->c3_sfEvent);
  _SFD_DATA_RANGE_CHECK(*c3_rho, 0U);
  _SFD_DATA_RANGE_CHECK(*c3_v, 1U);
  _SFD_DATA_RANGE_CHECK(*c3_phi, 2U);
  _SFD_DATA_RANGE_CHECK(*c3_alpha, 3U);
  _SFD_DATA_RANGE_CHECK(*c3_beta, 4U);
  _SFD_DATA_RANGE_CHECK(*c3_direction, 5U);
  chartInstance->c3_sfEvent = CALL_EVENT;
  c3_chartstep_c3_driver(chartInstance);
  _SFD_CHECK_FOR_STATE_INCONSISTENCY(_driverMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void c3_chartstep_c3_driver(SFc3_driverInstanceStruct *chartInstance)
{
  real_T c3_hoistedGlobal;
  real_T c3_b_hoistedGlobal;
  real_T c3_c_hoistedGlobal;
  real_T c3_d_hoistedGlobal;
  real_T c3_rho;
  real_T c3_alpha;
  real_T c3_beta;
  real_T c3_direction;
  uint32_T c3_debug_family_var_map[13];
  real_T c3_v_lim;
  real_T c3_phi_lim;
  real_T c3_k_rho;
  real_T c3_k_alpha;
  real_T c3_k_beta;
  real_T c3_nargin = 4.0;
  real_T c3_nargout = 2.0;
  real_T c3_v;
  real_T c3_phi;
  real_T c3_a;
  real_T c3_y;
  real_T c3_b_a;
  real_T c3_b;
  real_T c3_b_y;
  real_T c3_varargin_1[2];
  int32_T c3_ixstart;
  real_T c3_mtmp;
  real_T c3_x;
  boolean_T c3_b_b;
  int32_T c3_ix;
  int32_T c3_b_ix;
  real_T c3_b_x;
  boolean_T c3_c_b;
  int32_T c3_c_a;
  int32_T c3_i0;
  boolean_T c3_overflow;
  int32_T c3_c_ix;
  real_T c3_d_a;
  real_T c3_d_b;
  boolean_T c3_p;
  real_T c3_b_mtmp;
  real_T c3_minval;
  int32_T c3_b_ixstart;
  real_T c3_c_mtmp;
  real_T c3_c_x;
  boolean_T c3_e_b;
  int32_T c3_d_ix;
  int32_T c3_e_ix;
  real_T c3_d_x;
  boolean_T c3_f_b;
  int32_T c3_e_a;
  int32_T c3_i1;
  boolean_T c3_b_overflow;
  int32_T c3_f_ix;
  real_T c3_f_a;
  real_T c3_g_b;
  boolean_T c3_b_p;
  real_T c3_d_mtmp;
  real_T c3_h_b;
  real_T c3_c_y;
  real_T c3_i_b;
  real_T c3_d_y;
  real_T c3_g_a;
  real_T c3_j_b;
  real_T c3_e_y;
  real_T c3_e_x;
  real_T c3_f_x;
  real_T c3_f_y;
  real_T c3_A;
  real_T c3_B;
  real_T c3_g_x;
  real_T c3_g_y;
  real_T c3_h_x;
  real_T c3_h_y;
  real_T c3_i_y;
  int32_T c3_c_ixstart;
  real_T c3_e_mtmp;
  real_T c3_i_x;
  boolean_T c3_k_b;
  int32_T c3_g_ix;
  int32_T c3_h_ix;
  real_T c3_j_x;
  boolean_T c3_l_b;
  int32_T c3_h_a;
  int32_T c3_i2;
  boolean_T c3_c_overflow;
  int32_T c3_i_ix;
  real_T c3_i_a;
  real_T c3_m_b;
  boolean_T c3_c_p;
  real_T c3_f_mtmp;
  real_T c3_b_minval;
  int32_T c3_d_ixstart;
  real_T c3_g_mtmp;
  real_T c3_k_x;
  boolean_T c3_n_b;
  int32_T c3_j_ix;
  int32_T c3_k_ix;
  real_T c3_l_x;
  boolean_T c3_o_b;
  int32_T c3_j_a;
  int32_T c3_i3;
  boolean_T c3_d_overflow;
  int32_T c3_l_ix;
  real_T c3_k_a;
  real_T c3_p_b;
  boolean_T c3_d_p;
  real_T c3_h_mtmp;
  real_T *c3_b_rho;
  real_T *c3_b_alpha;
  real_T *c3_b_beta;
  real_T *c3_b_direction;
  real_T *c3_b_v;
  real_T *c3_b_phi;
  boolean_T exitg1;
  boolean_T exitg2;
  boolean_T exitg3;
  boolean_T exitg4;
  c3_b_direction = (real_T *)ssGetInputPortSignal(chartInstance->S, 3);
  c3_b_beta = (real_T *)ssGetInputPortSignal(chartInstance->S, 2);
  c3_b_alpha = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c3_b_phi = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c3_b_v = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c3_b_rho = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 2U, chartInstance->c3_sfEvent);
  c3_hoistedGlobal = *c3_b_rho;
  c3_b_hoistedGlobal = *c3_b_alpha;
  c3_c_hoistedGlobal = *c3_b_beta;
  c3_d_hoistedGlobal = *c3_b_direction;
  c3_rho = c3_hoistedGlobal;
  c3_alpha = c3_b_hoistedGlobal;
  c3_beta = c3_c_hoistedGlobal;
  c3_direction = c3_d_hoistedGlobal;
  _SFD_SYMBOL_SCOPE_PUSH_EML(0U, 13U, 13U, c3_debug_family_names,
    c3_debug_family_var_map);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_v_lim, 0U, c3_sf_marshallOut,
    c3_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_phi_lim, 1U, c3_sf_marshallOut,
    c3_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c3_k_rho, 2U, c3_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c3_k_alpha, 3U, c3_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c3_k_beta, 4U, c3_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_nargin, 5U, c3_sf_marshallOut,
    c3_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_nargout, 6U, c3_sf_marshallOut,
    c3_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c3_rho, 7U, c3_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c3_alpha, 8U, c3_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c3_beta, 9U, c3_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c3_direction, 10U, c3_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_v, 11U, c3_sf_marshallOut,
    c3_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c3_phi, 12U, c3_sf_marshallOut,
    c3_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 3);
  c3_v_lim = 20.0;
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 4);
  c3_phi_lim = 0.5;
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 6);
  c3_k_rho = 3.0;
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 7);
  c3_k_alpha = 8.0;
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 8);
  c3_k_beta = -3.0;
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 10);
  c3_a = c3_direction;
  c3_y = c3_a * 3.0;
  c3_b_a = c3_y;
  c3_b = c3_rho;
  c3_b_y = c3_b_a * c3_b;
  c3_varargin_1[0] = c3_b_y;
  c3_varargin_1[1] = c3_v_lim;
  c3_ixstart = 1;
  c3_mtmp = c3_varargin_1[0];
  c3_x = c3_mtmp;
  c3_b_b = muDoubleScalarIsNaN(c3_x);
  if (c3_b_b) {
    c3_ix = 2;
    exitg4 = FALSE;
    while ((exitg4 == FALSE) && (c3_ix < 3)) {
      c3_b_ix = c3_ix;
      c3_ixstart = c3_b_ix;
      c3_b_x = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
        _SFD_INTEGER_CHECK("", (real_T)c3_b_ix), 1, 2, 1, 0) - 1];
      c3_c_b = muDoubleScalarIsNaN(c3_b_x);
      if (!c3_c_b) {
        c3_mtmp = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c3_b_ix), 1, 2, 1, 0) - 1];
        exitg4 = TRUE;
      } else {
        c3_ix++;
      }
    }
  }

  if (c3_ixstart < 2) {
    c3_c_a = c3_ixstart;
    c3_i0 = c3_c_a;
    c3_overflow = FALSE;
    if (c3_overflow) {
      c3_check_forloop_overflow_error(chartInstance, c3_overflow);
    }

    for (c3_c_ix = c3_i0 + 1; c3_c_ix < 3; c3_c_ix++) {
      c3_b_ix = c3_c_ix;
      c3_d_a = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
        _SFD_INTEGER_CHECK("", (real_T)c3_b_ix), 1, 2, 1, 0) - 1];
      c3_d_b = c3_mtmp;
      c3_p = (c3_d_a < c3_d_b);
      if (c3_p) {
        c3_mtmp = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c3_b_ix), 1, 2, 1, 0) - 1];
      }
    }
  }

  c3_b_mtmp = c3_mtmp;
  c3_minval = c3_b_mtmp;
  c3_varargin_1[0] = c3_minval;
  c3_varargin_1[1] = -c3_v_lim;
  c3_b_ixstart = 1;
  c3_c_mtmp = c3_varargin_1[0];
  c3_c_x = c3_c_mtmp;
  c3_e_b = muDoubleScalarIsNaN(c3_c_x);
  if (c3_e_b) {
    c3_d_ix = 2;
    exitg3 = FALSE;
    while ((exitg3 == FALSE) && (c3_d_ix < 3)) {
      c3_e_ix = c3_d_ix;
      c3_b_ixstart = c3_e_ix;
      c3_d_x = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
        _SFD_INTEGER_CHECK("", (real_T)c3_e_ix), 1, 2, 1, 0) - 1];
      c3_f_b = muDoubleScalarIsNaN(c3_d_x);
      if (!c3_f_b) {
        c3_c_mtmp = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c3_e_ix), 1, 2, 1, 0) - 1];
        exitg3 = TRUE;
      } else {
        c3_d_ix++;
      }
    }
  }

  if (c3_b_ixstart < 2) {
    c3_e_a = c3_b_ixstart;
    c3_i1 = c3_e_a;
    c3_b_overflow = FALSE;
    if (c3_b_overflow) {
      c3_check_forloop_overflow_error(chartInstance, c3_b_overflow);
    }

    for (c3_f_ix = c3_i1 + 1; c3_f_ix < 3; c3_f_ix++) {
      c3_e_ix = c3_f_ix;
      c3_f_a = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
        _SFD_INTEGER_CHECK("", (real_T)c3_e_ix), 1, 2, 1, 0) - 1];
      c3_g_b = c3_c_mtmp;
      c3_b_p = (c3_f_a > c3_g_b);
      if (c3_b_p) {
        c3_c_mtmp = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c3_e_ix), 1, 2, 1, 0) - 1];
      }
    }
  }

  c3_d_mtmp = c3_c_mtmp;
  c3_v = c3_d_mtmp;
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, 13);
  c3_h_b = c3_alpha;
  c3_c_y = 8.0 * c3_h_b;
  c3_i_b = c3_beta;
  c3_d_y = -3.0 * c3_i_b;
  c3_g_a = c3_direction;
  c3_j_b = c3_c_y + c3_d_y;
  c3_e_y = c3_g_a * c3_j_b;
  c3_e_x = c3_v;
  c3_f_x = c3_e_x;
  c3_f_y = muDoubleScalarAbs(c3_f_x);
  c3_A = c3_e_y;
  c3_B = c3_f_y;
  c3_g_x = c3_A;
  c3_g_y = c3_B;
  c3_h_x = c3_g_x;
  c3_h_y = c3_g_y;
  c3_i_y = c3_h_x / c3_h_y;
  c3_varargin_1[0] = c3_i_y;
  c3_varargin_1[1] = c3_phi_lim;
  c3_c_ixstart = 1;
  c3_e_mtmp = c3_varargin_1[0];
  c3_i_x = c3_e_mtmp;
  c3_k_b = muDoubleScalarIsNaN(c3_i_x);
  if (c3_k_b) {
    c3_g_ix = 2;
    exitg2 = FALSE;
    while ((exitg2 == FALSE) && (c3_g_ix < 3)) {
      c3_h_ix = c3_g_ix;
      c3_c_ixstart = c3_h_ix;
      c3_j_x = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
        _SFD_INTEGER_CHECK("", (real_T)c3_h_ix), 1, 2, 1, 0) - 1];
      c3_l_b = muDoubleScalarIsNaN(c3_j_x);
      if (!c3_l_b) {
        c3_e_mtmp = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c3_h_ix), 1, 2, 1, 0) - 1];
        exitg2 = TRUE;
      } else {
        c3_g_ix++;
      }
    }
  }

  if (c3_c_ixstart < 2) {
    c3_h_a = c3_c_ixstart;
    c3_i2 = c3_h_a;
    c3_c_overflow = FALSE;
    if (c3_c_overflow) {
      c3_check_forloop_overflow_error(chartInstance, c3_c_overflow);
    }

    for (c3_i_ix = c3_i2 + 1; c3_i_ix < 3; c3_i_ix++) {
      c3_h_ix = c3_i_ix;
      c3_i_a = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
        _SFD_INTEGER_CHECK("", (real_T)c3_h_ix), 1, 2, 1, 0) - 1];
      c3_m_b = c3_e_mtmp;
      c3_c_p = (c3_i_a < c3_m_b);
      if (c3_c_p) {
        c3_e_mtmp = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c3_h_ix), 1, 2, 1, 0) - 1];
      }
    }
  }

  c3_f_mtmp = c3_e_mtmp;
  c3_b_minval = c3_f_mtmp;
  c3_varargin_1[0] = c3_b_minval;
  c3_varargin_1[1] = -c3_phi_lim;
  c3_d_ixstart = 1;
  c3_g_mtmp = c3_varargin_1[0];
  c3_k_x = c3_g_mtmp;
  c3_n_b = muDoubleScalarIsNaN(c3_k_x);
  if (c3_n_b) {
    c3_j_ix = 2;
    exitg1 = FALSE;
    while ((exitg1 == FALSE) && (c3_j_ix < 3)) {
      c3_k_ix = c3_j_ix;
      c3_d_ixstart = c3_k_ix;
      c3_l_x = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
        _SFD_INTEGER_CHECK("", (real_T)c3_k_ix), 1, 2, 1, 0) - 1];
      c3_o_b = muDoubleScalarIsNaN(c3_l_x);
      if (!c3_o_b) {
        c3_g_mtmp = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c3_k_ix), 1, 2, 1, 0) - 1];
        exitg1 = TRUE;
      } else {
        c3_j_ix++;
      }
    }
  }

  if (c3_d_ixstart < 2) {
    c3_j_a = c3_d_ixstart;
    c3_i3 = c3_j_a;
    c3_d_overflow = FALSE;
    if (c3_d_overflow) {
      c3_check_forloop_overflow_error(chartInstance, c3_d_overflow);
    }

    for (c3_l_ix = c3_i3 + 1; c3_l_ix < 3; c3_l_ix++) {
      c3_k_ix = c3_l_ix;
      c3_k_a = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
        _SFD_INTEGER_CHECK("", (real_T)c3_k_ix), 1, 2, 1, 0) - 1];
      c3_p_b = c3_g_mtmp;
      c3_d_p = (c3_k_a > c3_p_b);
      if (c3_d_p) {
        c3_g_mtmp = c3_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c3_k_ix), 1, 2, 1, 0) - 1];
      }
    }
  }

  c3_h_mtmp = c3_g_mtmp;
  c3_phi = c3_h_mtmp;
  _SFD_EML_CALL(0U, chartInstance->c3_sfEvent, -13);
  _SFD_SYMBOL_SCOPE_POP();
  *c3_b_v = c3_v;
  *c3_b_phi = c3_phi;
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 2U, chartInstance->c3_sfEvent);
}

static void initSimStructsc3_driver(SFc3_driverInstanceStruct *chartInstance)
{
}

static void registerMessagesc3_driver(SFc3_driverInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c3_machineNumber, uint32_T
  c3_chartNumber)
{
}

static const mxArray *c3_sf_marshallOut(void *chartInstanceVoid, void *c3_inData)
{
  const mxArray *c3_mxArrayOutData = NULL;
  real_T c3_u;
  const mxArray *c3_y = NULL;
  SFc3_driverInstanceStruct *chartInstance;
  chartInstance = (SFc3_driverInstanceStruct *)chartInstanceVoid;
  c3_mxArrayOutData = NULL;
  c3_u = *(real_T *)c3_inData;
  c3_y = NULL;
  sf_mex_assign(&c3_y, sf_mex_create("y", &c3_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c3_mxArrayOutData, c3_y, FALSE);
  return c3_mxArrayOutData;
}

static real_T c3_emlrt_marshallIn(SFc3_driverInstanceStruct *chartInstance,
  const mxArray *c3_phi, const char_T *c3_identifier)
{
  real_T c3_y;
  emlrtMsgIdentifier c3_thisId;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_y = c3_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c3_phi), &c3_thisId);
  sf_mex_destroy(&c3_phi);
  return c3_y;
}

static real_T c3_b_emlrt_marshallIn(SFc3_driverInstanceStruct *chartInstance,
  const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId)
{
  real_T c3_y;
  real_T c3_d0;
  sf_mex_import(c3_parentId, sf_mex_dup(c3_u), &c3_d0, 1, 0, 0U, 0, 0U, 0);
  c3_y = c3_d0;
  sf_mex_destroy(&c3_u);
  return c3_y;
}

static void c3_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData)
{
  const mxArray *c3_phi;
  const char_T *c3_identifier;
  emlrtMsgIdentifier c3_thisId;
  real_T c3_y;
  SFc3_driverInstanceStruct *chartInstance;
  chartInstance = (SFc3_driverInstanceStruct *)chartInstanceVoid;
  c3_phi = sf_mex_dup(c3_mxArrayInData);
  c3_identifier = c3_varName;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_y = c3_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c3_phi), &c3_thisId);
  sf_mex_destroy(&c3_phi);
  *(real_T *)c3_outData = c3_y;
  sf_mex_destroy(&c3_mxArrayInData);
}

const mxArray *sf_c3_driver_get_eml_resolved_functions_info(void)
{
  const mxArray *c3_nameCaptureInfo;
  c3_ResolvedFunctionInfo c3_info[21];
  const mxArray *c3_m0 = NULL;
  int32_T c3_i4;
  c3_ResolvedFunctionInfo *c3_r0;
  c3_nameCaptureInfo = NULL;
  c3_nameCaptureInfo = NULL;
  c3_info_helper(c3_info);
  sf_mex_assign(&c3_m0, sf_mex_createstruct("nameCaptureInfo", 1, 21), FALSE);
  for (c3_i4 = 0; c3_i4 < 21; c3_i4++) {
    c3_r0 = &c3_info[c3_i4];
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", c3_r0->context, 15,
      0U, 0U, 0U, 2, 1, strlen(c3_r0->context)), "context", "nameCaptureInfo",
                    c3_i4);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", c3_r0->name, 15, 0U,
      0U, 0U, 2, 1, strlen(c3_r0->name)), "name", "nameCaptureInfo", c3_i4);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", c3_r0->dominantType,
      15, 0U, 0U, 0U, 2, 1, strlen(c3_r0->dominantType)), "dominantType",
                    "nameCaptureInfo", c3_i4);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", c3_r0->resolved, 15,
      0U, 0U, 0U, 2, 1, strlen(c3_r0->resolved)), "resolved", "nameCaptureInfo",
                    c3_i4);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", &c3_r0->fileTimeLo,
      7, 0U, 0U, 0U, 0), "fileTimeLo", "nameCaptureInfo", c3_i4);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", &c3_r0->fileTimeHi,
      7, 0U, 0U, 0U, 0), "fileTimeHi", "nameCaptureInfo", c3_i4);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", &c3_r0->mFileTimeLo,
      7, 0U, 0U, 0U, 0), "mFileTimeLo", "nameCaptureInfo", c3_i4);
    sf_mex_addfield(c3_m0, sf_mex_create("nameCaptureInfo", &c3_r0->mFileTimeHi,
      7, 0U, 0U, 0U, 0), "mFileTimeHi", "nameCaptureInfo", c3_i4);
  }

  sf_mex_assign(&c3_nameCaptureInfo, c3_m0, FALSE);
  sf_mex_emlrtNameCapturePostProcessR2012a(&c3_nameCaptureInfo);
  return c3_nameCaptureInfo;
}

static void c3_info_helper(c3_ResolvedFunctionInfo c3_info[21])
{
  c3_info[0].context = "";
  c3_info[0].name = "mtimes";
  c3_info[0].dominantType = "double";
  c3_info[0].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c3_info[0].fileTimeLo = 1289516092U;
  c3_info[0].fileTimeHi = 0U;
  c3_info[0].mFileTimeLo = 0U;
  c3_info[0].mFileTimeHi = 0U;
  c3_info[1].context = "";
  c3_info[1].name = "min";
  c3_info[1].dominantType = "double";
  c3_info[1].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/min.m";
  c3_info[1].fileTimeLo = 1311251718U;
  c3_info[1].fileTimeHi = 0U;
  c3_info[1].mFileTimeLo = 0U;
  c3_info[1].mFileTimeHi = 0U;
  c3_info[2].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/min.m";
  c3_info[2].name = "eml_min_or_max";
  c3_info[2].dominantType = "char";
  c3_info[2].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m";
  c3_info[2].fileTimeLo = 1334067890U;
  c3_info[2].fileTimeHi = 0U;
  c3_info[2].mFileTimeLo = 0U;
  c3_info[2].mFileTimeHi = 0U;
  c3_info[3].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum";
  c3_info[3].name = "eml_const_nonsingleton_dim";
  c3_info[3].dominantType = "double";
  c3_info[3].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_const_nonsingleton_dim.m";
  c3_info[3].fileTimeLo = 1286818696U;
  c3_info[3].fileTimeHi = 0U;
  c3_info[3].mFileTimeLo = 0U;
  c3_info[3].mFileTimeHi = 0U;
  c3_info[4].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum";
  c3_info[4].name = "eml_scalar_eg";
  c3_info[4].dominantType = "double";
  c3_info[4].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c3_info[4].fileTimeLo = 1286818796U;
  c3_info[4].fileTimeHi = 0U;
  c3_info[4].mFileTimeLo = 0U;
  c3_info[4].mFileTimeHi = 0U;
  c3_info[5].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum";
  c3_info[5].name = "eml_index_class";
  c3_info[5].dominantType = "";
  c3_info[5].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c3_info[5].fileTimeLo = 1323166978U;
  c3_info[5].fileTimeHi = 0U;
  c3_info[5].mFileTimeLo = 0U;
  c3_info[5].mFileTimeHi = 0U;
  c3_info[6].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum_sub";
  c3_info[6].name = "eml_index_class";
  c3_info[6].dominantType = "";
  c3_info[6].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c3_info[6].fileTimeLo = 1323166978U;
  c3_info[6].fileTimeHi = 0U;
  c3_info[6].mFileTimeLo = 0U;
  c3_info[6].mFileTimeHi = 0U;
  c3_info[7].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum_sub";
  c3_info[7].name = "isnan";
  c3_info[7].dominantType = "double";
  c3_info[7].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isnan.m";
  c3_info[7].fileTimeLo = 1286818760U;
  c3_info[7].fileTimeHi = 0U;
  c3_info[7].mFileTimeLo = 0U;
  c3_info[7].mFileTimeHi = 0U;
  c3_info[8].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum_sub";
  c3_info[8].name = "eml_index_plus";
  c3_info[8].dominantType = "coder.internal.indexInt";
  c3_info[8].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  c3_info[8].fileTimeLo = 1286818778U;
  c3_info[8].fileTimeHi = 0U;
  c3_info[8].mFileTimeLo = 0U;
  c3_info[8].mFileTimeHi = 0U;
  c3_info[9].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  c3_info[9].name = "eml_index_class";
  c3_info[9].dominantType = "";
  c3_info[9].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c3_info[9].fileTimeLo = 1323166978U;
  c3_info[9].fileTimeHi = 0U;
  c3_info[9].mFileTimeLo = 0U;
  c3_info[9].mFileTimeHi = 0U;
  c3_info[10].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum_sub";
  c3_info[10].name = "eml_int_forloop_overflow_check";
  c3_info[10].dominantType = "";
  c3_info[10].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m";
  c3_info[10].fileTimeLo = 1346506740U;
  c3_info[10].fileTimeHi = 0U;
  c3_info[10].mFileTimeLo = 0U;
  c3_info[10].mFileTimeHi = 0U;
  c3_info[11].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m!eml_int_forloop_overflow_check_helper";
  c3_info[11].name = "intmax";
  c3_info[11].dominantType = "char";
  c3_info[11].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmax.m";
  c3_info[11].fileTimeLo = 1311251716U;
  c3_info[11].fileTimeHi = 0U;
  c3_info[11].mFileTimeLo = 0U;
  c3_info[11].mFileTimeHi = 0U;
  c3_info[12].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum_sub";
  c3_info[12].name = "eml_relop";
  c3_info[12].dominantType = "function_handle";
  c3_info[12].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_relop.m";
  c3_info[12].fileTimeLo = 1342447582U;
  c3_info[12].fileTimeHi = 0U;
  c3_info[12].mFileTimeLo = 0U;
  c3_info[12].mFileTimeHi = 0U;
  c3_info[13].context = "";
  c3_info[13].name = "max";
  c3_info[13].dominantType = "double";
  c3_info[13].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/max.m";
  c3_info[13].fileTimeLo = 1311251716U;
  c3_info[13].fileTimeHi = 0U;
  c3_info[13].mFileTimeLo = 0U;
  c3_info[13].mFileTimeHi = 0U;
  c3_info[14].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/max.m";
  c3_info[14].name = "eml_min_or_max";
  c3_info[14].dominantType = "char";
  c3_info[14].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m";
  c3_info[14].fileTimeLo = 1334067890U;
  c3_info[14].fileTimeHi = 0U;
  c3_info[14].mFileTimeLo = 0U;
  c3_info[14].mFileTimeHi = 0U;
  c3_info[15].context = "";
  c3_info[15].name = "abs";
  c3_info[15].dominantType = "double";
  c3_info[15].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c3_info[15].fileTimeLo = 1343826766U;
  c3_info[15].fileTimeHi = 0U;
  c3_info[15].mFileTimeLo = 0U;
  c3_info[15].mFileTimeHi = 0U;
  c3_info[16].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c3_info[16].name = "eml_scalar_abs";
  c3_info[16].dominantType = "double";
  c3_info[16].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_abs.m";
  c3_info[16].fileTimeLo = 1286818712U;
  c3_info[16].fileTimeHi = 0U;
  c3_info[16].mFileTimeLo = 0U;
  c3_info[16].mFileTimeHi = 0U;
  c3_info[17].context = "";
  c3_info[17].name = "mrdivide";
  c3_info[17].dominantType = "double";
  c3_info[17].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c3_info[17].fileTimeLo = 1357947948U;
  c3_info[17].fileTimeHi = 0U;
  c3_info[17].mFileTimeLo = 1319729966U;
  c3_info[17].mFileTimeHi = 0U;
  c3_info[18].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c3_info[18].name = "rdivide";
  c3_info[18].dominantType = "double";
  c3_info[18].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c3_info[18].fileTimeLo = 1346506788U;
  c3_info[18].fileTimeHi = 0U;
  c3_info[18].mFileTimeLo = 0U;
  c3_info[18].mFileTimeHi = 0U;
  c3_info[19].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c3_info[19].name = "eml_scalexp_compatible";
  c3_info[19].dominantType = "double";
  c3_info[19].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_compatible.m";
  c3_info[19].fileTimeLo = 1286818796U;
  c3_info[19].fileTimeHi = 0U;
  c3_info[19].mFileTimeLo = 0U;
  c3_info[19].mFileTimeHi = 0U;
  c3_info[20].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c3_info[20].name = "eml_div";
  c3_info[20].dominantType = "double";
  c3_info[20].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m";
  c3_info[20].fileTimeLo = 1313344210U;
  c3_info[20].fileTimeHi = 0U;
  c3_info[20].mFileTimeLo = 0U;
  c3_info[20].mFileTimeHi = 0U;
}

static void c3_check_forloop_overflow_error(SFc3_driverInstanceStruct
  *chartInstance, boolean_T c3_overflow)
{
  int32_T c3_i5;
  static char_T c3_cv0[34] = { 'C', 'o', 'd', 'e', 'r', ':', 't', 'o', 'o', 'l',
    'b', 'o', 'x', ':', 'i', 'n', 't', '_', 'f', 'o', 'r', 'l', 'o', 'o', 'p',
    '_', 'o', 'v', 'e', 'r', 'f', 'l', 'o', 'w' };

  char_T c3_u[34];
  const mxArray *c3_y = NULL;
  int32_T c3_i6;
  static char_T c3_cv1[23] = { 'c', 'o', 'd', 'e', 'r', '.', 'i', 'n', 't', 'e',
    'r', 'n', 'a', 'l', '.', 'i', 'n', 'd', 'e', 'x', 'I', 'n', 't' };

  char_T c3_b_u[23];
  const mxArray *c3_b_y = NULL;
  if (!c3_overflow) {
  } else {
    for (c3_i5 = 0; c3_i5 < 34; c3_i5++) {
      c3_u[c3_i5] = c3_cv0[c3_i5];
    }

    c3_y = NULL;
    sf_mex_assign(&c3_y, sf_mex_create("y", c3_u, 10, 0U, 1U, 0U, 2, 1, 34),
                  FALSE);
    for (c3_i6 = 0; c3_i6 < 23; c3_i6++) {
      c3_b_u[c3_i6] = c3_cv1[c3_i6];
    }

    c3_b_y = NULL;
    sf_mex_assign(&c3_b_y, sf_mex_create("y", c3_b_u, 10, 0U, 1U, 0U, 2, 1, 23),
                  FALSE);
    sf_mex_call_debug("error", 0U, 1U, 14, sf_mex_call_debug("message", 1U, 2U,
      14, c3_y, 14, c3_b_y));
  }
}

static const mxArray *c3_b_sf_marshallOut(void *chartInstanceVoid, void
  *c3_inData)
{
  const mxArray *c3_mxArrayOutData = NULL;
  int32_T c3_u;
  const mxArray *c3_y = NULL;
  SFc3_driverInstanceStruct *chartInstance;
  chartInstance = (SFc3_driverInstanceStruct *)chartInstanceVoid;
  c3_mxArrayOutData = NULL;
  c3_u = *(int32_T *)c3_inData;
  c3_y = NULL;
  sf_mex_assign(&c3_y, sf_mex_create("y", &c3_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c3_mxArrayOutData, c3_y, FALSE);
  return c3_mxArrayOutData;
}

static int32_T c3_c_emlrt_marshallIn(SFc3_driverInstanceStruct *chartInstance,
  const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId)
{
  int32_T c3_y;
  int32_T c3_i7;
  sf_mex_import(c3_parentId, sf_mex_dup(c3_u), &c3_i7, 1, 6, 0U, 0, 0U, 0);
  c3_y = c3_i7;
  sf_mex_destroy(&c3_u);
  return c3_y;
}

static void c3_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c3_mxArrayInData, const char_T *c3_varName, void *c3_outData)
{
  const mxArray *c3_b_sfEvent;
  const char_T *c3_identifier;
  emlrtMsgIdentifier c3_thisId;
  int32_T c3_y;
  SFc3_driverInstanceStruct *chartInstance;
  chartInstance = (SFc3_driverInstanceStruct *)chartInstanceVoid;
  c3_b_sfEvent = sf_mex_dup(c3_mxArrayInData);
  c3_identifier = c3_varName;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_y = c3_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c3_b_sfEvent),
    &c3_thisId);
  sf_mex_destroy(&c3_b_sfEvent);
  *(int32_T *)c3_outData = c3_y;
  sf_mex_destroy(&c3_mxArrayInData);
}

static uint8_T c3_d_emlrt_marshallIn(SFc3_driverInstanceStruct *chartInstance,
  const mxArray *c3_b_is_active_c3_driver, const char_T *c3_identifier)
{
  uint8_T c3_y;
  emlrtMsgIdentifier c3_thisId;
  c3_thisId.fIdentifier = c3_identifier;
  c3_thisId.fParent = NULL;
  c3_y = c3_e_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c3_b_is_active_c3_driver), &c3_thisId);
  sf_mex_destroy(&c3_b_is_active_c3_driver);
  return c3_y;
}

static uint8_T c3_e_emlrt_marshallIn(SFc3_driverInstanceStruct *chartInstance,
  const mxArray *c3_u, const emlrtMsgIdentifier *c3_parentId)
{
  uint8_T c3_y;
  uint8_T c3_u0;
  sf_mex_import(c3_parentId, sf_mex_dup(c3_u), &c3_u0, 1, 3, 0U, 0, 0U, 0);
  c3_y = c3_u0;
  sf_mex_destroy(&c3_u);
  return c3_y;
}

static void init_dsm_address_info(SFc3_driverInstanceStruct *chartInstance)
{
}

/* SFunction Glue Code */
#ifdef utFree
#undef utFree
#endif

#ifdef utMalloc
#undef utMalloc
#endif

#ifdef __cplusplus

extern "C" void *utMalloc(size_t size);
extern "C" void utFree(void*);

#else

extern void *utMalloc(size_t size);
extern void utFree(void*);

#endif

void sf_c3_driver_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3649427453U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(2925245692U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(723935625U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1249248568U);
}

mxArray *sf_c3_driver_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("WCazYw03SqsvXe8R9imtzE");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,4,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,2,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,2,"type",mxType);
    }

    mxSetField(mxData,2,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,3,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,3,"type",mxType);
    }

    mxSetField(mxData,3,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxCreateDoubleMatrix(0,0,
                mxREAL));
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,2,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

mxArray *sf_c3_driver_third_party_uses_info(void)
{
  mxArray * mxcell3p = mxCreateCellMatrix(1,0);
  return(mxcell3p);
}

static const mxArray *sf_get_sim_state_info_c3_driver(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x3'type','srcId','name','auxInfo'{{M[1],M[6],T\"phi\",},{M[1],M[5],T\"v\",},{M[8],M[0],T\"is_active_c3_driver\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 3, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c3_driver_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc3_driverInstanceStruct *chartInstance;
    chartInstance = (SFc3_driverInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (sfGlobalDebugInstanceStruct,
           _driverMachineNumber_,
           3,
           1,
           1,
           6,
           0,
           0,
           0,
           0,
           0,
           &(chartInstance->chartNumber),
           &(chartInstance->instanceNumber),
           ssGetPath(S),
           (void *)S);
        if (chartAlreadyPresent==0) {
          /* this is the first instance */
          init_script_number_translation(_driverMachineNumber_,
            chartInstance->chartNumber);
          sf_debug_set_chart_disable_implicit_casting
            (sfGlobalDebugInstanceStruct,_driverMachineNumber_,
             chartInstance->chartNumber,1);
          sf_debug_set_chart_event_thresholds(sfGlobalDebugInstanceStruct,
            _driverMachineNumber_,
            chartInstance->chartNumber,
            0,
            0,
            0);
          _SFD_SET_DATA_PROPS(0,1,1,0,"rho");
          _SFD_SET_DATA_PROPS(1,2,0,1,"v");
          _SFD_SET_DATA_PROPS(2,2,0,1,"phi");
          _SFD_SET_DATA_PROPS(3,1,1,0,"alpha");
          _SFD_SET_DATA_PROPS(4,1,1,0,"beta");
          _SFD_SET_DATA_PROPS(5,1,1,0,"direction");
          _SFD_STATE_INFO(0,0,2);
          _SFD_CH_SUBSTATE_COUNT(0);
          _SFD_CH_SUBSTATE_DECOMP(0);
        }

        _SFD_CV_INIT_CHART(0,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,0,0,0,0,0,NULL,NULL);
        }

        _SFD_CV_INIT_TRANS(0,0,NULL,NULL,0,NULL);

        /* Initialization of MATLAB Function Model Coverage */
        _SFD_CV_INIT_EML(0,1,1,0,0,0,0,0,0,0,0);
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,369);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)c3_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)c3_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(3,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(4,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(5,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c3_sf_marshallOut,(MexInFcnForType)NULL);

        {
          real_T *c3_rho;
          real_T *c3_v;
          real_T *c3_phi;
          real_T *c3_alpha;
          real_T *c3_beta;
          real_T *c3_direction;
          c3_direction = (real_T *)ssGetInputPortSignal(chartInstance->S, 3);
          c3_beta = (real_T *)ssGetInputPortSignal(chartInstance->S, 2);
          c3_alpha = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
          c3_phi = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
          c3_v = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
          c3_rho = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c3_rho);
          _SFD_SET_DATA_VALUE_PTR(1U, c3_v);
          _SFD_SET_DATA_VALUE_PTR(2U, c3_phi);
          _SFD_SET_DATA_VALUE_PTR(3U, c3_alpha);
          _SFD_SET_DATA_VALUE_PTR(4U, c3_beta);
          _SFD_SET_DATA_VALUE_PTR(5U, c3_direction);
        }
      }
    } else {
      sf_debug_reset_current_state_configuration(sfGlobalDebugInstanceStruct,
        _driverMachineNumber_,chartInstance->chartNumber,
        chartInstance->instanceNumber);
    }
  }
}

static const char* sf_get_instance_specialization(void)
{
  return "alcIEnQSP0FVxne6ZuGo7E";
}

static void sf_opaque_initialize_c3_driver(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc3_driverInstanceStruct*) chartInstanceVar)->S,
    0);
  initialize_params_c3_driver((SFc3_driverInstanceStruct*) chartInstanceVar);
  initialize_c3_driver((SFc3_driverInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_enable_c3_driver(void *chartInstanceVar)
{
  enable_c3_driver((SFc3_driverInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_disable_c3_driver(void *chartInstanceVar)
{
  disable_c3_driver((SFc3_driverInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_gateway_c3_driver(void *chartInstanceVar)
{
  sf_c3_driver((SFc3_driverInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c3_driver(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c3_driver((SFc3_driverInstanceStruct*)
    chartInfo->chartInstance);         /* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c3_driver();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_raw2high'.\n");
  }

  return plhs[0];
}

extern void sf_internal_set_sim_state_c3_driver(SimStruct* S, const mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c3_driver();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c3_driver((SFc3_driverInstanceStruct*)chartInfo->chartInstance,
    mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c3_driver(SimStruct* S)
{
  return sf_internal_get_sim_state_c3_driver(S);
}

static void sf_opaque_set_sim_state_c3_driver(SimStruct* S, const mxArray *st)
{
  sf_internal_set_sim_state_c3_driver(S, st);
}

static void sf_opaque_terminate_c3_driver(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc3_driverInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
      unload_driver_optimization_info();
    }

    finalize_c3_driver((SFc3_driverInstanceStruct*) chartInstanceVar);
    utFree((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc3_driver((SFc3_driverInstanceStruct*) chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c3_driver(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c3_driver((SFc3_driverInstanceStruct*)(((ChartInfoStruct *)
      ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c3_driver(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_driver_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      3);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,3,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,3,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_update_buildInfo(S,sf_get_instance_specialization(),infoStruct,3);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 2, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 3, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,3,4);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,3,2);
    }

    {
      unsigned int outPortIdx;
      for (outPortIdx=1; outPortIdx<=2; ++outPortIdx) {
        ssSetOutputPortOptimizeInIR(S, outPortIdx, 1U);
      }
    }

    {
      unsigned int inPortIdx;
      for (inPortIdx=0; inPortIdx < 4; ++inPortIdx) {
        ssSetInputPortOptimizeInIR(S, inPortIdx, 1U);
      }
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,3);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(1773436907U));
  ssSetChecksum1(S,(2431992201U));
  ssSetChecksum2(S,(3279921658U));
  ssSetChecksum3(S,(1339064878U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSupportsMultipleExecInstances(S,1);
}

static void mdlRTW_c3_driver(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c3_driver(SimStruct *S)
{
  SFc3_driverInstanceStruct *chartInstance;
  chartInstance = (SFc3_driverInstanceStruct *)utMalloc(sizeof
    (SFc3_driverInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc3_driverInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway = sf_opaque_gateway_c3_driver;
  chartInstance->chartInfo.initializeChart = sf_opaque_initialize_c3_driver;
  chartInstance->chartInfo.terminateChart = sf_opaque_terminate_c3_driver;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c3_driver;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c3_driver;
  chartInstance->chartInfo.getSimState = sf_opaque_get_sim_state_c3_driver;
  chartInstance->chartInfo.setSimState = sf_opaque_set_sim_state_c3_driver;
  chartInstance->chartInfo.getSimStateInfo = sf_get_sim_state_info_c3_driver;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c3_driver;
  chartInstance->chartInfo.mdlStart = mdlStart_c3_driver;
  chartInstance->chartInfo.mdlSetWorkWidths = mdlSetWorkWidths_c3_driver;
  chartInstance->chartInfo.extModeExec = NULL;
  chartInstance->chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.storeCurrentConfiguration = NULL;
  chartInstance->S = S;
  ssSetUserData(S,(void *)(&(chartInstance->chartInfo)));/* register the chart instance with simstruct */
  init_dsm_address_info(chartInstance);
  if (!sim_mode_is_rtw_gen(S)) {
  }

  sf_opaque_init_subchart_simstructs(chartInstance->chartInfo.chartInstance);
  chart_debug_initialization(S,1);
}

void c3_driver_method_dispatcher(SimStruct *S, int_T method, void *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c3_driver(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c3_driver(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c3_driver(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c3_driver_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
