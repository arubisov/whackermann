/* Include files */

#include <stddef.h>
#include "blas.h"
#include "driver_sfun.h"
#include "c7_driver.h"
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
static const char * c7_debug_family_names[18] = { "x", "y", "theta", "rho",
  "beta", "alpha", "direction", "v_lim", "phi_lim", "k_rho", "k_alpha", "k_beta",
  "nargin", "nargout", "pose", "exec_path", "steering", "speed" };

/* Function Declarations */
static void initialize_c7_driver(SFc7_driverInstanceStruct *chartInstance);
static void initialize_params_c7_driver(SFc7_driverInstanceStruct *chartInstance);
static void enable_c7_driver(SFc7_driverInstanceStruct *chartInstance);
static void disable_c7_driver(SFc7_driverInstanceStruct *chartInstance);
static void c7_update_debugger_state_c7_driver(SFc7_driverInstanceStruct
  *chartInstance);
static const mxArray *get_sim_state_c7_driver(SFc7_driverInstanceStruct
  *chartInstance);
static void set_sim_state_c7_driver(SFc7_driverInstanceStruct *chartInstance,
  const mxArray *c7_st);
static void finalize_c7_driver(SFc7_driverInstanceStruct *chartInstance);
static void sf_c7_driver(SFc7_driverInstanceStruct *chartInstance);
static void c7_chartstep_c7_driver(SFc7_driverInstanceStruct *chartInstance);
static void initSimStructsc7_driver(SFc7_driverInstanceStruct *chartInstance);
static void registerMessagesc7_driver(SFc7_driverInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c7_machineNumber, uint32_T
  c7_chartNumber);
static const mxArray *c7_sf_marshallOut(void *chartInstanceVoid, void *c7_inData);
static real_T c7_emlrt_marshallIn(SFc7_driverInstanceStruct *chartInstance,
  const mxArray *c7_speed, const char_T *c7_identifier);
static real_T c7_b_emlrt_marshallIn(SFc7_driverInstanceStruct *chartInstance,
  const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId);
static void c7_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c7_mxArrayInData, const char_T *c7_varName, void *c7_outData);
static const mxArray *c7_b_sf_marshallOut(void *chartInstanceVoid, void
  *c7_inData);
static void c7_info_helper(c7_ResolvedFunctionInfo c7_info[36]);
static real_T c7_mpower(SFc7_driverInstanceStruct *chartInstance, real_T c7_a);
static void c7_eml_scalar_eg(SFc7_driverInstanceStruct *chartInstance);
static real_T c7_sqrt(SFc7_driverInstanceStruct *chartInstance, real_T c7_x);
static void c7_eml_error(SFc7_driverInstanceStruct *chartInstance);
static real_T c7_atan2(SFc7_driverInstanceStruct *chartInstance, real_T c7_y,
  real_T c7_x);
static void c7_check_forloop_overflow_error(SFc7_driverInstanceStruct
  *chartInstance, boolean_T c7_overflow);
static real_T c7_abs(SFc7_driverInstanceStruct *chartInstance, real_T c7_x);
static const mxArray *c7_c_sf_marshallOut(void *chartInstanceVoid, void
  *c7_inData);
static int32_T c7_c_emlrt_marshallIn(SFc7_driverInstanceStruct *chartInstance,
  const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId);
static void c7_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c7_mxArrayInData, const char_T *c7_varName, void *c7_outData);
static uint8_T c7_d_emlrt_marshallIn(SFc7_driverInstanceStruct *chartInstance,
  const mxArray *c7_b_is_active_c7_driver, const char_T *c7_identifier);
static uint8_T c7_e_emlrt_marshallIn(SFc7_driverInstanceStruct *chartInstance,
  const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId);
static void c7_b_sqrt(SFc7_driverInstanceStruct *chartInstance, real_T *c7_x);
static void init_dsm_address_info(SFc7_driverInstanceStruct *chartInstance);

/* Function Definitions */
static void initialize_c7_driver(SFc7_driverInstanceStruct *chartInstance)
{
  chartInstance->c7_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c7_is_active_c7_driver = 0U;
}

static void initialize_params_c7_driver(SFc7_driverInstanceStruct *chartInstance)
{
}

static void enable_c7_driver(SFc7_driverInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c7_driver(SFc7_driverInstanceStruct *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c7_update_debugger_state_c7_driver(SFc7_driverInstanceStruct
  *chartInstance)
{
}

static const mxArray *get_sim_state_c7_driver(SFc7_driverInstanceStruct
  *chartInstance)
{
  const mxArray *c7_st;
  const mxArray *c7_y = NULL;
  real_T c7_hoistedGlobal;
  real_T c7_u;
  const mxArray *c7_b_y = NULL;
  real_T c7_b_hoistedGlobal;
  real_T c7_b_u;
  const mxArray *c7_c_y = NULL;
  uint8_T c7_c_hoistedGlobal;
  uint8_T c7_c_u;
  const mxArray *c7_d_y = NULL;
  real_T *c7_speed;
  real_T *c7_steering;
  c7_speed = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c7_steering = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c7_st = NULL;
  c7_st = NULL;
  c7_y = NULL;
  sf_mex_assign(&c7_y, sf_mex_createcellarray(3), FALSE);
  c7_hoistedGlobal = *c7_speed;
  c7_u = c7_hoistedGlobal;
  c7_b_y = NULL;
  sf_mex_assign(&c7_b_y, sf_mex_create("y", &c7_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c7_y, 0, c7_b_y);
  c7_b_hoistedGlobal = *c7_steering;
  c7_b_u = c7_b_hoistedGlobal;
  c7_c_y = NULL;
  sf_mex_assign(&c7_c_y, sf_mex_create("y", &c7_b_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c7_y, 1, c7_c_y);
  c7_c_hoistedGlobal = chartInstance->c7_is_active_c7_driver;
  c7_c_u = c7_c_hoistedGlobal;
  c7_d_y = NULL;
  sf_mex_assign(&c7_d_y, sf_mex_create("y", &c7_c_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c7_y, 2, c7_d_y);
  sf_mex_assign(&c7_st, c7_y, FALSE);
  return c7_st;
}

static void set_sim_state_c7_driver(SFc7_driverInstanceStruct *chartInstance,
  const mxArray *c7_st)
{
  const mxArray *c7_u;
  real_T *c7_speed;
  real_T *c7_steering;
  c7_speed = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c7_steering = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c7_doneDoubleBufferReInit = TRUE;
  c7_u = sf_mex_dup(c7_st);
  *c7_speed = c7_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c7_u,
    0)), "speed");
  *c7_steering = c7_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell
    (c7_u, 1)), "steering");
  chartInstance->c7_is_active_c7_driver = c7_d_emlrt_marshallIn(chartInstance,
    sf_mex_dup(sf_mex_getcell(c7_u, 2)), "is_active_c7_driver");
  sf_mex_destroy(&c7_u);
  c7_update_debugger_state_c7_driver(chartInstance);
  sf_mex_destroy(&c7_st);
}

static void finalize_c7_driver(SFc7_driverInstanceStruct *chartInstance)
{
}

static void sf_c7_driver(SFc7_driverInstanceStruct *chartInstance)
{
  int32_T c7_i0;
  real_T *c7_steering;
  real_T *c7_speed;
  real_T *c7_exec_path;
  real_T (*c7_pose)[4];
  c7_exec_path = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c7_speed = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c7_pose = (real_T (*)[4])ssGetInputPortSignal(chartInstance->S, 0);
  c7_steering = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 2U, chartInstance->c7_sfEvent);
  _SFD_DATA_RANGE_CHECK(*c7_steering, 0U);
  for (c7_i0 = 0; c7_i0 < 4; c7_i0++) {
    _SFD_DATA_RANGE_CHECK((*c7_pose)[c7_i0], 1U);
  }

  _SFD_DATA_RANGE_CHECK(*c7_speed, 2U);
  _SFD_DATA_RANGE_CHECK(*c7_exec_path, 3U);
  chartInstance->c7_sfEvent = CALL_EVENT;
  c7_chartstep_c7_driver(chartInstance);
  _SFD_CHECK_FOR_STATE_INCONSISTENCY(_driverMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void c7_chartstep_c7_driver(SFc7_driverInstanceStruct *chartInstance)
{
  real_T c7_hoistedGlobal;
  int32_T c7_i1;
  real_T c7_pose[4];
  real_T c7_exec_path;
  uint32_T c7_debug_family_var_map[18];
  real_T c7_x;
  real_T c7_y;
  real_T c7_theta;
  real_T c7_rho;
  real_T c7_beta;
  real_T c7_alpha;
  real_T c7_direction;
  real_T c7_v_lim;
  real_T c7_phi_lim;
  real_T c7_k_rho;
  real_T c7_k_alpha;
  real_T c7_k_beta;
  real_T c7_nargin = 2.0;
  real_T c7_nargout = 2.0;
  real_T c7_steering;
  real_T c7_speed;
  real_T c7_b;
  real_T c7_b_y;
  real_T c7_varargin_1[2];
  int32_T c7_ixstart;
  real_T c7_mtmp;
  real_T c7_b_x;
  boolean_T c7_b_b;
  int32_T c7_ix;
  int32_T c7_b_ix;
  real_T c7_c_x;
  boolean_T c7_c_b;
  int32_T c7_a;
  int32_T c7_i2;
  boolean_T c7_overflow;
  int32_T c7_c_ix;
  real_T c7_b_a;
  real_T c7_d_b;
  boolean_T c7_p;
  real_T c7_b_mtmp;
  real_T c7_minval;
  int32_T c7_b_ixstart;
  real_T c7_c_mtmp;
  real_T c7_d_x;
  boolean_T c7_e_b;
  int32_T c7_d_ix;
  int32_T c7_e_ix;
  real_T c7_e_x;
  boolean_T c7_f_b;
  int32_T c7_c_a;
  int32_T c7_i3;
  boolean_T c7_b_overflow;
  int32_T c7_f_ix;
  real_T c7_d_a;
  real_T c7_g_b;
  boolean_T c7_b_p;
  real_T c7_d_mtmp;
  real_T c7_h_b;
  real_T c7_c_y;
  real_T c7_i_b;
  real_T c7_d_y;
  real_T c7_j_b;
  real_T c7_e_y;
  real_T c7_A;
  real_T c7_B;
  real_T c7_f_x;
  real_T c7_f_y;
  real_T c7_g_x;
  real_T c7_g_y;
  real_T c7_h_y;
  int32_T c7_c_ixstart;
  real_T c7_e_mtmp;
  real_T c7_h_x;
  boolean_T c7_k_b;
  int32_T c7_g_ix;
  int32_T c7_h_ix;
  real_T c7_i_x;
  boolean_T c7_l_b;
  int32_T c7_e_a;
  int32_T c7_i4;
  boolean_T c7_c_overflow;
  int32_T c7_i_ix;
  real_T c7_f_a;
  real_T c7_m_b;
  boolean_T c7_c_p;
  real_T c7_f_mtmp;
  real_T c7_b_minval;
  int32_T c7_d_ixstart;
  real_T c7_g_mtmp;
  real_T c7_j_x;
  boolean_T c7_n_b;
  int32_T c7_j_ix;
  int32_T c7_k_ix;
  real_T c7_k_x;
  boolean_T c7_o_b;
  int32_T c7_g_a;
  int32_T c7_i5;
  boolean_T c7_d_overflow;
  int32_T c7_l_ix;
  real_T c7_h_a;
  real_T c7_p_b;
  boolean_T c7_d_p;
  real_T c7_h_mtmp;
  real_T *c7_b_exec_path;
  real_T *c7_b_steering;
  real_T *c7_b_speed;
  real_T (*c7_b_pose)[4];
  boolean_T exitg1;
  boolean_T exitg2;
  boolean_T exitg3;
  boolean_T exitg4;
  c7_b_exec_path = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c7_b_speed = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c7_b_pose = (real_T (*)[4])ssGetInputPortSignal(chartInstance->S, 0);
  c7_b_steering = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 2U, chartInstance->c7_sfEvent);
  c7_hoistedGlobal = *c7_b_exec_path;
  for (c7_i1 = 0; c7_i1 < 4; c7_i1++) {
    c7_pose[c7_i1] = (*c7_b_pose)[c7_i1];
  }

  c7_exec_path = c7_hoistedGlobal;
  _SFD_SYMBOL_SCOPE_PUSH_EML(0U, 18U, 18U, c7_debug_family_names,
    c7_debug_family_var_map);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c7_x, 0U, c7_sf_marshallOut,
    c7_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c7_y, 1U, c7_sf_marshallOut,
    c7_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c7_theta, 2U, c7_sf_marshallOut,
    c7_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c7_rho, 3U, c7_sf_marshallOut,
    c7_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c7_beta, 4U, c7_sf_marshallOut,
    c7_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c7_alpha, 5U, c7_sf_marshallOut,
    c7_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c7_direction, 6U, c7_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c7_v_lim, 7U, c7_sf_marshallOut,
    c7_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c7_phi_lim, 8U, c7_sf_marshallOut,
    c7_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c7_k_rho, 9U, c7_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c7_k_alpha, 10U, c7_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c7_k_beta, 11U, c7_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c7_nargin, 12U, c7_sf_marshallOut,
    c7_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c7_nargout, 13U, c7_sf_marshallOut,
    c7_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(c7_pose, 14U, c7_b_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c7_exec_path, 15U, c7_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c7_steering, 16U, c7_sf_marshallOut,
    c7_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c7_speed, 17U, c7_sf_marshallOut,
    c7_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 3);
  if (CV_EML_IF(0, 1, 0, CV_EML_MCDC(0, 1, 0, !(CV_EML_COND(0, 1, 0,
          c7_exec_path != 0.0) != 0.0)))) {
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 4);
    c7_speed = 0.0;
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 5);
    c7_steering = 0.0;
  } else {
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 9);
    c7_x = c7_pose[0];
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 9);
    c7_y = c7_pose[1];
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 9);
    c7_theta = c7_pose[2];
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 11);
    c7_rho = c7_mpower(chartInstance, c7_x) + c7_mpower(chartInstance, c7_y);
    c7_b_sqrt(chartInstance, &c7_rho);
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 12);
    c7_beta = -c7_atan2(chartInstance, -c7_y, -c7_x);
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 13);
    c7_alpha = -c7_theta - c7_beta;
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 14);
    c7_direction = 1.0;
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 17);
    c7_v_lim = 20.0;
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 18);
    c7_phi_lim = 0.5;
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 20);
    c7_k_rho = 3.0;
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 21);
    c7_k_alpha = 8.0;
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 22);
    c7_k_beta = -3.0;
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 24);
    c7_b = c7_rho;
    c7_b_y = 3.0 * c7_b;
    c7_varargin_1[0] = c7_b_y;
    c7_varargin_1[1] = c7_v_lim;
    c7_ixstart = 1;
    c7_mtmp = c7_varargin_1[0];
    c7_b_x = c7_mtmp;
    c7_b_b = muDoubleScalarIsNaN(c7_b_x);
    if (c7_b_b) {
      c7_ix = 2;
      exitg4 = FALSE;
      while ((exitg4 == FALSE) && (c7_ix < 3)) {
        c7_b_ix = c7_ix;
        c7_ixstart = c7_b_ix;
        c7_c_x = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c7_b_ix), 1, 2, 1, 0) - 1];
        c7_c_b = muDoubleScalarIsNaN(c7_c_x);
        if (!c7_c_b) {
          c7_mtmp = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
            _SFD_INTEGER_CHECK("", (real_T)c7_b_ix), 1, 2, 1, 0) - 1];
          exitg4 = TRUE;
        } else {
          c7_ix++;
        }
      }
    }

    if (c7_ixstart < 2) {
      c7_a = c7_ixstart;
      c7_i2 = c7_a;
      c7_overflow = FALSE;
      if (c7_overflow) {
        c7_check_forloop_overflow_error(chartInstance, c7_overflow);
      }

      for (c7_c_ix = c7_i2 + 1; c7_c_ix < 3; c7_c_ix++) {
        c7_b_ix = c7_c_ix;
        c7_b_a = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c7_b_ix), 1, 2, 1, 0) - 1];
        c7_d_b = c7_mtmp;
        c7_p = (c7_b_a < c7_d_b);
        if (c7_p) {
          c7_mtmp = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
            _SFD_INTEGER_CHECK("", (real_T)c7_b_ix), 1, 2, 1, 0) - 1];
        }
      }
    }

    c7_b_mtmp = c7_mtmp;
    c7_minval = c7_b_mtmp;
    c7_varargin_1[0] = c7_minval;
    c7_varargin_1[1] = -c7_v_lim;
    c7_b_ixstart = 1;
    c7_c_mtmp = c7_varargin_1[0];
    c7_d_x = c7_c_mtmp;
    c7_e_b = muDoubleScalarIsNaN(c7_d_x);
    if (c7_e_b) {
      c7_d_ix = 2;
      exitg3 = FALSE;
      while ((exitg3 == FALSE) && (c7_d_ix < 3)) {
        c7_e_ix = c7_d_ix;
        c7_b_ixstart = c7_e_ix;
        c7_e_x = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c7_e_ix), 1, 2, 1, 0) - 1];
        c7_f_b = muDoubleScalarIsNaN(c7_e_x);
        if (!c7_f_b) {
          c7_c_mtmp = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
            _SFD_INTEGER_CHECK("", (real_T)c7_e_ix), 1, 2, 1, 0) - 1];
          exitg3 = TRUE;
        } else {
          c7_d_ix++;
        }
      }
    }

    if (c7_b_ixstart < 2) {
      c7_c_a = c7_b_ixstart;
      c7_i3 = c7_c_a;
      c7_b_overflow = FALSE;
      if (c7_b_overflow) {
        c7_check_forloop_overflow_error(chartInstance, c7_b_overflow);
      }

      for (c7_f_ix = c7_i3 + 1; c7_f_ix < 3; c7_f_ix++) {
        c7_e_ix = c7_f_ix;
        c7_d_a = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c7_e_ix), 1, 2, 1, 0) - 1];
        c7_g_b = c7_c_mtmp;
        c7_b_p = (c7_d_a > c7_g_b);
        if (c7_b_p) {
          c7_c_mtmp = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
            _SFD_INTEGER_CHECK("", (real_T)c7_e_ix), 1, 2, 1, 0) - 1];
        }
      }
    }

    c7_d_mtmp = c7_c_mtmp;
    c7_speed = c7_d_mtmp;
    _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, 27);
    c7_h_b = c7_alpha;
    c7_c_y = 8.0 * c7_h_b;
    c7_i_b = c7_beta;
    c7_d_y = -3.0 * c7_i_b;
    c7_j_b = c7_c_y + c7_d_y;
    c7_e_y = c7_j_b;
    c7_A = c7_e_y;
    c7_B = c7_abs(chartInstance, c7_speed);
    c7_f_x = c7_A;
    c7_f_y = c7_B;
    c7_g_x = c7_f_x;
    c7_g_y = c7_f_y;
    c7_h_y = c7_g_x / c7_g_y;
    c7_varargin_1[0] = c7_h_y;
    c7_varargin_1[1] = c7_phi_lim;
    c7_c_ixstart = 1;
    c7_e_mtmp = c7_varargin_1[0];
    c7_h_x = c7_e_mtmp;
    c7_k_b = muDoubleScalarIsNaN(c7_h_x);
    if (c7_k_b) {
      c7_g_ix = 2;
      exitg2 = FALSE;
      while ((exitg2 == FALSE) && (c7_g_ix < 3)) {
        c7_h_ix = c7_g_ix;
        c7_c_ixstart = c7_h_ix;
        c7_i_x = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c7_h_ix), 1, 2, 1, 0) - 1];
        c7_l_b = muDoubleScalarIsNaN(c7_i_x);
        if (!c7_l_b) {
          c7_e_mtmp = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
            _SFD_INTEGER_CHECK("", (real_T)c7_h_ix), 1, 2, 1, 0) - 1];
          exitg2 = TRUE;
        } else {
          c7_g_ix++;
        }
      }
    }

    if (c7_c_ixstart < 2) {
      c7_e_a = c7_c_ixstart;
      c7_i4 = c7_e_a;
      c7_c_overflow = FALSE;
      if (c7_c_overflow) {
        c7_check_forloop_overflow_error(chartInstance, c7_c_overflow);
      }

      for (c7_i_ix = c7_i4 + 1; c7_i_ix < 3; c7_i_ix++) {
        c7_h_ix = c7_i_ix;
        c7_f_a = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c7_h_ix), 1, 2, 1, 0) - 1];
        c7_m_b = c7_e_mtmp;
        c7_c_p = (c7_f_a < c7_m_b);
        if (c7_c_p) {
          c7_e_mtmp = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
            _SFD_INTEGER_CHECK("", (real_T)c7_h_ix), 1, 2, 1, 0) - 1];
        }
      }
    }

    c7_f_mtmp = c7_e_mtmp;
    c7_b_minval = c7_f_mtmp;
    c7_varargin_1[0] = c7_b_minval;
    c7_varargin_1[1] = -c7_phi_lim;
    c7_d_ixstart = 1;
    c7_g_mtmp = c7_varargin_1[0];
    c7_j_x = c7_g_mtmp;
    c7_n_b = muDoubleScalarIsNaN(c7_j_x);
    if (c7_n_b) {
      c7_j_ix = 2;
      exitg1 = FALSE;
      while ((exitg1 == FALSE) && (c7_j_ix < 3)) {
        c7_k_ix = c7_j_ix;
        c7_d_ixstart = c7_k_ix;
        c7_k_x = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c7_k_ix), 1, 2, 1, 0) - 1];
        c7_o_b = muDoubleScalarIsNaN(c7_k_x);
        if (!c7_o_b) {
          c7_g_mtmp = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
            _SFD_INTEGER_CHECK("", (real_T)c7_k_ix), 1, 2, 1, 0) - 1];
          exitg1 = TRUE;
        } else {
          c7_j_ix++;
        }
      }
    }

    if (c7_d_ixstart < 2) {
      c7_g_a = c7_d_ixstart;
      c7_i5 = c7_g_a;
      c7_d_overflow = FALSE;
      if (c7_d_overflow) {
        c7_check_forloop_overflow_error(chartInstance, c7_d_overflow);
      }

      for (c7_l_ix = c7_i5 + 1; c7_l_ix < 3; c7_l_ix++) {
        c7_k_ix = c7_l_ix;
        c7_h_a = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
          _SFD_INTEGER_CHECK("", (real_T)c7_k_ix), 1, 2, 1, 0) - 1];
        c7_p_b = c7_g_mtmp;
        c7_d_p = (c7_h_a > c7_p_b);
        if (c7_d_p) {
          c7_g_mtmp = c7_varargin_1[_SFD_EML_ARRAY_BOUNDS_CHECK("", (int32_T)
            _SFD_INTEGER_CHECK("", (real_T)c7_k_ix), 1, 2, 1, 0) - 1];
        }
      }
    }

    c7_h_mtmp = c7_g_mtmp;
    c7_steering = c7_h_mtmp;
  }

  _SFD_EML_CALL(0U, chartInstance->c7_sfEvent, -27);
  _SFD_SYMBOL_SCOPE_POP();
  *c7_b_steering = c7_steering;
  *c7_b_speed = c7_speed;
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 2U, chartInstance->c7_sfEvent);
}

static void initSimStructsc7_driver(SFc7_driverInstanceStruct *chartInstance)
{
}

static void registerMessagesc7_driver(SFc7_driverInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c7_machineNumber, uint32_T
  c7_chartNumber)
{
}

static const mxArray *c7_sf_marshallOut(void *chartInstanceVoid, void *c7_inData)
{
  const mxArray *c7_mxArrayOutData = NULL;
  real_T c7_u;
  const mxArray *c7_y = NULL;
  SFc7_driverInstanceStruct *chartInstance;
  chartInstance = (SFc7_driverInstanceStruct *)chartInstanceVoid;
  c7_mxArrayOutData = NULL;
  c7_u = *(real_T *)c7_inData;
  c7_y = NULL;
  sf_mex_assign(&c7_y, sf_mex_create("y", &c7_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c7_mxArrayOutData, c7_y, FALSE);
  return c7_mxArrayOutData;
}

static real_T c7_emlrt_marshallIn(SFc7_driverInstanceStruct *chartInstance,
  const mxArray *c7_speed, const char_T *c7_identifier)
{
  real_T c7_y;
  emlrtMsgIdentifier c7_thisId;
  c7_thisId.fIdentifier = c7_identifier;
  c7_thisId.fParent = NULL;
  c7_y = c7_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c7_speed), &c7_thisId);
  sf_mex_destroy(&c7_speed);
  return c7_y;
}

static real_T c7_b_emlrt_marshallIn(SFc7_driverInstanceStruct *chartInstance,
  const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId)
{
  real_T c7_y;
  real_T c7_d0;
  sf_mex_import(c7_parentId, sf_mex_dup(c7_u), &c7_d0, 1, 0, 0U, 0, 0U, 0);
  c7_y = c7_d0;
  sf_mex_destroy(&c7_u);
  return c7_y;
}

static void c7_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c7_mxArrayInData, const char_T *c7_varName, void *c7_outData)
{
  const mxArray *c7_speed;
  const char_T *c7_identifier;
  emlrtMsgIdentifier c7_thisId;
  real_T c7_y;
  SFc7_driverInstanceStruct *chartInstance;
  chartInstance = (SFc7_driverInstanceStruct *)chartInstanceVoid;
  c7_speed = sf_mex_dup(c7_mxArrayInData);
  c7_identifier = c7_varName;
  c7_thisId.fIdentifier = c7_identifier;
  c7_thisId.fParent = NULL;
  c7_y = c7_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c7_speed), &c7_thisId);
  sf_mex_destroy(&c7_speed);
  *(real_T *)c7_outData = c7_y;
  sf_mex_destroy(&c7_mxArrayInData);
}

static const mxArray *c7_b_sf_marshallOut(void *chartInstanceVoid, void
  *c7_inData)
{
  const mxArray *c7_mxArrayOutData = NULL;
  int32_T c7_i6;
  real_T c7_b_inData[4];
  int32_T c7_i7;
  real_T c7_u[4];
  const mxArray *c7_y = NULL;
  SFc7_driverInstanceStruct *chartInstance;
  chartInstance = (SFc7_driverInstanceStruct *)chartInstanceVoid;
  c7_mxArrayOutData = NULL;
  for (c7_i6 = 0; c7_i6 < 4; c7_i6++) {
    c7_b_inData[c7_i6] = (*(real_T (*)[4])c7_inData)[c7_i6];
  }

  for (c7_i7 = 0; c7_i7 < 4; c7_i7++) {
    c7_u[c7_i7] = c7_b_inData[c7_i7];
  }

  c7_y = NULL;
  sf_mex_assign(&c7_y, sf_mex_create("y", c7_u, 0, 0U, 1U, 0U, 1, 4), FALSE);
  sf_mex_assign(&c7_mxArrayOutData, c7_y, FALSE);
  return c7_mxArrayOutData;
}

const mxArray *sf_c7_driver_get_eml_resolved_functions_info(void)
{
  const mxArray *c7_nameCaptureInfo;
  c7_ResolvedFunctionInfo c7_info[36];
  const mxArray *c7_m0 = NULL;
  int32_T c7_i8;
  c7_ResolvedFunctionInfo *c7_r0;
  c7_nameCaptureInfo = NULL;
  c7_nameCaptureInfo = NULL;
  c7_info_helper(c7_info);
  sf_mex_assign(&c7_m0, sf_mex_createstruct("nameCaptureInfo", 1, 36), FALSE);
  for (c7_i8 = 0; c7_i8 < 36; c7_i8++) {
    c7_r0 = &c7_info[c7_i8];
    sf_mex_addfield(c7_m0, sf_mex_create("nameCaptureInfo", c7_r0->context, 15,
      0U, 0U, 0U, 2, 1, strlen(c7_r0->context)), "context", "nameCaptureInfo",
                    c7_i8);
    sf_mex_addfield(c7_m0, sf_mex_create("nameCaptureInfo", c7_r0->name, 15, 0U,
      0U, 0U, 2, 1, strlen(c7_r0->name)), "name", "nameCaptureInfo", c7_i8);
    sf_mex_addfield(c7_m0, sf_mex_create("nameCaptureInfo", c7_r0->dominantType,
      15, 0U, 0U, 0U, 2, 1, strlen(c7_r0->dominantType)), "dominantType",
                    "nameCaptureInfo", c7_i8);
    sf_mex_addfield(c7_m0, sf_mex_create("nameCaptureInfo", c7_r0->resolved, 15,
      0U, 0U, 0U, 2, 1, strlen(c7_r0->resolved)), "resolved", "nameCaptureInfo",
                    c7_i8);
    sf_mex_addfield(c7_m0, sf_mex_create("nameCaptureInfo", &c7_r0->fileTimeLo,
      7, 0U, 0U, 0U, 0), "fileTimeLo", "nameCaptureInfo", c7_i8);
    sf_mex_addfield(c7_m0, sf_mex_create("nameCaptureInfo", &c7_r0->fileTimeHi,
      7, 0U, 0U, 0U, 0), "fileTimeHi", "nameCaptureInfo", c7_i8);
    sf_mex_addfield(c7_m0, sf_mex_create("nameCaptureInfo", &c7_r0->mFileTimeLo,
      7, 0U, 0U, 0U, 0), "mFileTimeLo", "nameCaptureInfo", c7_i8);
    sf_mex_addfield(c7_m0, sf_mex_create("nameCaptureInfo", &c7_r0->mFileTimeHi,
      7, 0U, 0U, 0U, 0), "mFileTimeHi", "nameCaptureInfo", c7_i8);
  }

  sf_mex_assign(&c7_nameCaptureInfo, c7_m0, FALSE);
  sf_mex_emlrtNameCapturePostProcessR2012a(&c7_nameCaptureInfo);
  return c7_nameCaptureInfo;
}

static void c7_info_helper(c7_ResolvedFunctionInfo c7_info[36])
{
  c7_info[0].context = "";
  c7_info[0].name = "mpower";
  c7_info[0].dominantType = "double";
  c7_info[0].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mpower.m";
  c7_info[0].fileTimeLo = 1286818842U;
  c7_info[0].fileTimeHi = 0U;
  c7_info[0].mFileTimeLo = 0U;
  c7_info[0].mFileTimeHi = 0U;
  c7_info[1].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mpower.m";
  c7_info[1].name = "power";
  c7_info[1].dominantType = "double";
  c7_info[1].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m";
  c7_info[1].fileTimeLo = 1348188330U;
  c7_info[1].fileTimeHi = 0U;
  c7_info[1].mFileTimeLo = 0U;
  c7_info[1].mFileTimeHi = 0U;
  c7_info[2].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
  c7_info[2].name = "eml_scalar_eg";
  c7_info[2].dominantType = "double";
  c7_info[2].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c7_info[2].fileTimeLo = 1286818796U;
  c7_info[2].fileTimeHi = 0U;
  c7_info[2].mFileTimeLo = 0U;
  c7_info[2].mFileTimeHi = 0U;
  c7_info[3].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
  c7_info[3].name = "eml_scalexp_alloc";
  c7_info[3].dominantType = "double";
  c7_info[3].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
  c7_info[3].fileTimeLo = 1352421260U;
  c7_info[3].fileTimeHi = 0U;
  c7_info[3].mFileTimeLo = 0U;
  c7_info[3].mFileTimeHi = 0U;
  c7_info[4].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!fltpower";
  c7_info[4].name = "floor";
  c7_info[4].dominantType = "double";
  c7_info[4].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c7_info[4].fileTimeLo = 1343826780U;
  c7_info[4].fileTimeHi = 0U;
  c7_info[4].mFileTimeLo = 0U;
  c7_info[4].mFileTimeHi = 0U;
  c7_info[5].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/floor.m";
  c7_info[5].name = "eml_scalar_floor";
  c7_info[5].dominantType = "double";
  c7_info[5].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_floor.m";
  c7_info[5].fileTimeLo = 1286818726U;
  c7_info[5].fileTimeHi = 0U;
  c7_info[5].mFileTimeLo = 0U;
  c7_info[5].mFileTimeHi = 0U;
  c7_info[6].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!scalar_float_power";
  c7_info[6].name = "eml_scalar_eg";
  c7_info[6].dominantType = "double";
  c7_info[6].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c7_info[6].fileTimeLo = 1286818796U;
  c7_info[6].fileTimeHi = 0U;
  c7_info[6].mFileTimeLo = 0U;
  c7_info[6].mFileTimeHi = 0U;
  c7_info[7].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/power.m!scalar_float_power";
  c7_info[7].name = "mtimes";
  c7_info[7].dominantType = "double";
  c7_info[7].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c7_info[7].fileTimeLo = 1289516092U;
  c7_info[7].fileTimeHi = 0U;
  c7_info[7].mFileTimeLo = 0U;
  c7_info[7].mFileTimeHi = 0U;
  c7_info[8].context = "";
  c7_info[8].name = "sqrt";
  c7_info[8].dominantType = "double";
  c7_info[8].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sqrt.m";
  c7_info[8].fileTimeLo = 1343826786U;
  c7_info[8].fileTimeHi = 0U;
  c7_info[8].mFileTimeLo = 0U;
  c7_info[8].mFileTimeHi = 0U;
  c7_info[9].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sqrt.m";
  c7_info[9].name = "eml_error";
  c7_info[9].dominantType = "char";
  c7_info[9].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_error.m";
  c7_info[9].fileTimeLo = 1343826758U;
  c7_info[9].fileTimeHi = 0U;
  c7_info[9].mFileTimeLo = 0U;
  c7_info[9].mFileTimeHi = 0U;
  c7_info[10].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/sqrt.m";
  c7_info[10].name = "eml_scalar_sqrt";
  c7_info[10].dominantType = "double";
  c7_info[10].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_sqrt.m";
  c7_info[10].fileTimeLo = 1286818738U;
  c7_info[10].fileTimeHi = 0U;
  c7_info[10].mFileTimeLo = 0U;
  c7_info[10].mFileTimeHi = 0U;
  c7_info[11].context = "";
  c7_info[11].name = "atan2";
  c7_info[11].dominantType = "double";
  c7_info[11].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/atan2.m";
  c7_info[11].fileTimeLo = 1343826772U;
  c7_info[11].fileTimeHi = 0U;
  c7_info[11].mFileTimeLo = 0U;
  c7_info[11].mFileTimeHi = 0U;
  c7_info[12].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/atan2.m";
  c7_info[12].name = "eml_scalar_eg";
  c7_info[12].dominantType = "double";
  c7_info[12].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c7_info[12].fileTimeLo = 1286818796U;
  c7_info[12].fileTimeHi = 0U;
  c7_info[12].mFileTimeLo = 0U;
  c7_info[12].mFileTimeHi = 0U;
  c7_info[13].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/atan2.m";
  c7_info[13].name = "eml_scalexp_alloc";
  c7_info[13].dominantType = "double";
  c7_info[13].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_alloc.m";
  c7_info[13].fileTimeLo = 1352421260U;
  c7_info[13].fileTimeHi = 0U;
  c7_info[13].mFileTimeLo = 0U;
  c7_info[13].mFileTimeHi = 0U;
  c7_info[14].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/atan2.m";
  c7_info[14].name = "eml_scalar_atan2";
  c7_info[14].dominantType = "double";
  c7_info[14].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_atan2.m";
  c7_info[14].fileTimeLo = 1286818720U;
  c7_info[14].fileTimeHi = 0U;
  c7_info[14].mFileTimeLo = 0U;
  c7_info[14].mFileTimeHi = 0U;
  c7_info[15].context = "";
  c7_info[15].name = "mtimes";
  c7_info[15].dominantType = "double";
  c7_info[15].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mtimes.m";
  c7_info[15].fileTimeLo = 1289516092U;
  c7_info[15].fileTimeHi = 0U;
  c7_info[15].mFileTimeLo = 0U;
  c7_info[15].mFileTimeHi = 0U;
  c7_info[16].context = "";
  c7_info[16].name = "min";
  c7_info[16].dominantType = "double";
  c7_info[16].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/min.m";
  c7_info[16].fileTimeLo = 1311251718U;
  c7_info[16].fileTimeHi = 0U;
  c7_info[16].mFileTimeLo = 0U;
  c7_info[16].mFileTimeHi = 0U;
  c7_info[17].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/min.m";
  c7_info[17].name = "eml_min_or_max";
  c7_info[17].dominantType = "char";
  c7_info[17].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m";
  c7_info[17].fileTimeLo = 1334067890U;
  c7_info[17].fileTimeHi = 0U;
  c7_info[17].mFileTimeLo = 0U;
  c7_info[17].mFileTimeHi = 0U;
  c7_info[18].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum";
  c7_info[18].name = "eml_const_nonsingleton_dim";
  c7_info[18].dominantType = "double";
  c7_info[18].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_const_nonsingleton_dim.m";
  c7_info[18].fileTimeLo = 1286818696U;
  c7_info[18].fileTimeHi = 0U;
  c7_info[18].mFileTimeLo = 0U;
  c7_info[18].mFileTimeHi = 0U;
  c7_info[19].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum";
  c7_info[19].name = "eml_scalar_eg";
  c7_info[19].dominantType = "double";
  c7_info[19].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalar_eg.m";
  c7_info[19].fileTimeLo = 1286818796U;
  c7_info[19].fileTimeHi = 0U;
  c7_info[19].mFileTimeLo = 0U;
  c7_info[19].mFileTimeHi = 0U;
  c7_info[20].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum";
  c7_info[20].name = "eml_index_class";
  c7_info[20].dominantType = "";
  c7_info[20].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c7_info[20].fileTimeLo = 1323166978U;
  c7_info[20].fileTimeHi = 0U;
  c7_info[20].mFileTimeLo = 0U;
  c7_info[20].mFileTimeHi = 0U;
  c7_info[21].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum_sub";
  c7_info[21].name = "eml_index_class";
  c7_info[21].dominantType = "";
  c7_info[21].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c7_info[21].fileTimeLo = 1323166978U;
  c7_info[21].fileTimeHi = 0U;
  c7_info[21].mFileTimeLo = 0U;
  c7_info[21].mFileTimeHi = 0U;
  c7_info[22].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum_sub";
  c7_info[22].name = "isnan";
  c7_info[22].dominantType = "double";
  c7_info[22].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/isnan.m";
  c7_info[22].fileTimeLo = 1286818760U;
  c7_info[22].fileTimeHi = 0U;
  c7_info[22].mFileTimeLo = 0U;
  c7_info[22].mFileTimeHi = 0U;
  c7_info[23].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum_sub";
  c7_info[23].name = "eml_index_plus";
  c7_info[23].dominantType = "coder.internal.indexInt";
  c7_info[23].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  c7_info[23].fileTimeLo = 1286818778U;
  c7_info[23].fileTimeHi = 0U;
  c7_info[23].mFileTimeLo = 0U;
  c7_info[23].mFileTimeHi = 0U;
  c7_info[24].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_plus.m";
  c7_info[24].name = "eml_index_class";
  c7_info[24].dominantType = "";
  c7_info[24].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_index_class.m";
  c7_info[24].fileTimeLo = 1323166978U;
  c7_info[24].fileTimeHi = 0U;
  c7_info[24].mFileTimeLo = 0U;
  c7_info[24].mFileTimeHi = 0U;
  c7_info[25].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum_sub";
  c7_info[25].name = "eml_int_forloop_overflow_check";
  c7_info[25].dominantType = "";
  c7_info[25].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m";
  c7_info[25].fileTimeLo = 1346506740U;
  c7_info[25].fileTimeHi = 0U;
  c7_info[25].mFileTimeLo = 0U;
  c7_info[25].mFileTimeHi = 0U;
  c7_info[26].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_int_forloop_overflow_check.m!eml_int_forloop_overflow_check_helper";
  c7_info[26].name = "intmax";
  c7_info[26].dominantType = "char";
  c7_info[26].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elmat/intmax.m";
  c7_info[26].fileTimeLo = 1311251716U;
  c7_info[26].fileTimeHi = 0U;
  c7_info[26].mFileTimeLo = 0U;
  c7_info[26].mFileTimeHi = 0U;
  c7_info[27].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m!eml_extremum_sub";
  c7_info[27].name = "eml_relop";
  c7_info[27].dominantType = "function_handle";
  c7_info[27].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_relop.m";
  c7_info[27].fileTimeLo = 1342447582U;
  c7_info[27].fileTimeHi = 0U;
  c7_info[27].mFileTimeLo = 0U;
  c7_info[27].mFileTimeHi = 0U;
  c7_info[28].context = "";
  c7_info[28].name = "max";
  c7_info[28].dominantType = "double";
  c7_info[28].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/max.m";
  c7_info[28].fileTimeLo = 1311251716U;
  c7_info[28].fileTimeHi = 0U;
  c7_info[28].mFileTimeLo = 0U;
  c7_info[28].mFileTimeHi = 0U;
  c7_info[29].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/datafun/max.m";
  c7_info[29].name = "eml_min_or_max";
  c7_info[29].dominantType = "char";
  c7_info[29].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_min_or_max.m";
  c7_info[29].fileTimeLo = 1334067890U;
  c7_info[29].fileTimeHi = 0U;
  c7_info[29].mFileTimeLo = 0U;
  c7_info[29].mFileTimeHi = 0U;
  c7_info[30].context = "";
  c7_info[30].name = "abs";
  c7_info[30].dominantType = "double";
  c7_info[30].resolved = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c7_info[30].fileTimeLo = 1343826766U;
  c7_info[30].fileTimeHi = 0U;
  c7_info[30].mFileTimeLo = 0U;
  c7_info[30].mFileTimeHi = 0U;
  c7_info[31].context = "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/abs.m";
  c7_info[31].name = "eml_scalar_abs";
  c7_info[31].dominantType = "double";
  c7_info[31].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/elfun/eml_scalar_abs.m";
  c7_info[31].fileTimeLo = 1286818712U;
  c7_info[31].fileTimeHi = 0U;
  c7_info[31].mFileTimeLo = 0U;
  c7_info[31].mFileTimeHi = 0U;
  c7_info[32].context = "";
  c7_info[32].name = "mrdivide";
  c7_info[32].dominantType = "double";
  c7_info[32].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c7_info[32].fileTimeLo = 1357947948U;
  c7_info[32].fileTimeHi = 0U;
  c7_info[32].mFileTimeLo = 1319729966U;
  c7_info[32].mFileTimeHi = 0U;
  c7_info[33].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/mrdivide.p";
  c7_info[33].name = "rdivide";
  c7_info[33].dominantType = "double";
  c7_info[33].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c7_info[33].fileTimeLo = 1346506788U;
  c7_info[33].fileTimeHi = 0U;
  c7_info[33].mFileTimeLo = 0U;
  c7_info[33].mFileTimeHi = 0U;
  c7_info[34].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c7_info[34].name = "eml_scalexp_compatible";
  c7_info[34].dominantType = "double";
  c7_info[34].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_scalexp_compatible.m";
  c7_info[34].fileTimeLo = 1286818796U;
  c7_info[34].fileTimeHi = 0U;
  c7_info[34].mFileTimeLo = 0U;
  c7_info[34].mFileTimeHi = 0U;
  c7_info[35].context =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/ops/rdivide.m";
  c7_info[35].name = "eml_div";
  c7_info[35].dominantType = "double";
  c7_info[35].resolved =
    "[ILXE]$matlabroot$/toolbox/eml/lib/matlab/eml/eml_div.m";
  c7_info[35].fileTimeLo = 1313344210U;
  c7_info[35].fileTimeHi = 0U;
  c7_info[35].mFileTimeLo = 0U;
  c7_info[35].mFileTimeHi = 0U;
}

static real_T c7_mpower(SFc7_driverInstanceStruct *chartInstance, real_T c7_a)
{
  real_T c7_b_a;
  real_T c7_c_a;
  real_T c7_ak;
  real_T c7_d_a;
  real_T c7_e_a;
  real_T c7_b;
  c7_b_a = c7_a;
  c7_c_a = c7_b_a;
  c7_eml_scalar_eg(chartInstance);
  c7_ak = c7_c_a;
  c7_d_a = c7_ak;
  c7_eml_scalar_eg(chartInstance);
  c7_e_a = c7_d_a;
  c7_b = c7_d_a;
  return c7_e_a * c7_b;
}

static void c7_eml_scalar_eg(SFc7_driverInstanceStruct *chartInstance)
{
}

static real_T c7_sqrt(SFc7_driverInstanceStruct *chartInstance, real_T c7_x)
{
  real_T c7_b_x;
  c7_b_x = c7_x;
  c7_b_sqrt(chartInstance, &c7_b_x);
  return c7_b_x;
}

static void c7_eml_error(SFc7_driverInstanceStruct *chartInstance)
{
  int32_T c7_i9;
  static char_T c7_cv0[30] = { 'C', 'o', 'd', 'e', 'r', ':', 't', 'o', 'o', 'l',
    'b', 'o', 'x', ':', 'E', 'l', 'F', 'u', 'n', 'D', 'o', 'm', 'a', 'i', 'n',
    'E', 'r', 'r', 'o', 'r' };

  char_T c7_u[30];
  const mxArray *c7_y = NULL;
  int32_T c7_i10;
  static char_T c7_cv1[4] = { 's', 'q', 'r', 't' };

  char_T c7_b_u[4];
  const mxArray *c7_b_y = NULL;
  for (c7_i9 = 0; c7_i9 < 30; c7_i9++) {
    c7_u[c7_i9] = c7_cv0[c7_i9];
  }

  c7_y = NULL;
  sf_mex_assign(&c7_y, sf_mex_create("y", c7_u, 10, 0U, 1U, 0U, 2, 1, 30), FALSE);
  for (c7_i10 = 0; c7_i10 < 4; c7_i10++) {
    c7_b_u[c7_i10] = c7_cv1[c7_i10];
  }

  c7_b_y = NULL;
  sf_mex_assign(&c7_b_y, sf_mex_create("y", c7_b_u, 10, 0U, 1U, 0U, 2, 1, 4),
                FALSE);
  sf_mex_call_debug("error", 0U, 1U, 14, sf_mex_call_debug("message", 1U, 2U, 14,
    c7_y, 14, c7_b_y));
}

static real_T c7_atan2(SFc7_driverInstanceStruct *chartInstance, real_T c7_y,
  real_T c7_x)
{
  real_T c7_b_y;
  real_T c7_b_x;
  c7_eml_scalar_eg(chartInstance);
  c7_b_y = c7_y;
  c7_b_x = c7_x;
  return muDoubleScalarAtan2(c7_b_y, c7_b_x);
}

static void c7_check_forloop_overflow_error(SFc7_driverInstanceStruct
  *chartInstance, boolean_T c7_overflow)
{
  int32_T c7_i11;
  static char_T c7_cv2[34] = { 'C', 'o', 'd', 'e', 'r', ':', 't', 'o', 'o', 'l',
    'b', 'o', 'x', ':', 'i', 'n', 't', '_', 'f', 'o', 'r', 'l', 'o', 'o', 'p',
    '_', 'o', 'v', 'e', 'r', 'f', 'l', 'o', 'w' };

  char_T c7_u[34];
  const mxArray *c7_y = NULL;
  int32_T c7_i12;
  static char_T c7_cv3[23] = { 'c', 'o', 'd', 'e', 'r', '.', 'i', 'n', 't', 'e',
    'r', 'n', 'a', 'l', '.', 'i', 'n', 'd', 'e', 'x', 'I', 'n', 't' };

  char_T c7_b_u[23];
  const mxArray *c7_b_y = NULL;
  if (!c7_overflow) {
  } else {
    for (c7_i11 = 0; c7_i11 < 34; c7_i11++) {
      c7_u[c7_i11] = c7_cv2[c7_i11];
    }

    c7_y = NULL;
    sf_mex_assign(&c7_y, sf_mex_create("y", c7_u, 10, 0U, 1U, 0U, 2, 1, 34),
                  FALSE);
    for (c7_i12 = 0; c7_i12 < 23; c7_i12++) {
      c7_b_u[c7_i12] = c7_cv3[c7_i12];
    }

    c7_b_y = NULL;
    sf_mex_assign(&c7_b_y, sf_mex_create("y", c7_b_u, 10, 0U, 1U, 0U, 2, 1, 23),
                  FALSE);
    sf_mex_call_debug("error", 0U, 1U, 14, sf_mex_call_debug("message", 1U, 2U,
      14, c7_y, 14, c7_b_y));
  }
}

static real_T c7_abs(SFc7_driverInstanceStruct *chartInstance, real_T c7_x)
{
  real_T c7_b_x;
  c7_b_x = c7_x;
  return muDoubleScalarAbs(c7_b_x);
}

static const mxArray *c7_c_sf_marshallOut(void *chartInstanceVoid, void
  *c7_inData)
{
  const mxArray *c7_mxArrayOutData = NULL;
  int32_T c7_u;
  const mxArray *c7_y = NULL;
  SFc7_driverInstanceStruct *chartInstance;
  chartInstance = (SFc7_driverInstanceStruct *)chartInstanceVoid;
  c7_mxArrayOutData = NULL;
  c7_u = *(int32_T *)c7_inData;
  c7_y = NULL;
  sf_mex_assign(&c7_y, sf_mex_create("y", &c7_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c7_mxArrayOutData, c7_y, FALSE);
  return c7_mxArrayOutData;
}

static int32_T c7_c_emlrt_marshallIn(SFc7_driverInstanceStruct *chartInstance,
  const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId)
{
  int32_T c7_y;
  int32_T c7_i13;
  sf_mex_import(c7_parentId, sf_mex_dup(c7_u), &c7_i13, 1, 6, 0U, 0, 0U, 0);
  c7_y = c7_i13;
  sf_mex_destroy(&c7_u);
  return c7_y;
}

static void c7_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c7_mxArrayInData, const char_T *c7_varName, void *c7_outData)
{
  const mxArray *c7_b_sfEvent;
  const char_T *c7_identifier;
  emlrtMsgIdentifier c7_thisId;
  int32_T c7_y;
  SFc7_driverInstanceStruct *chartInstance;
  chartInstance = (SFc7_driverInstanceStruct *)chartInstanceVoid;
  c7_b_sfEvent = sf_mex_dup(c7_mxArrayInData);
  c7_identifier = c7_varName;
  c7_thisId.fIdentifier = c7_identifier;
  c7_thisId.fParent = NULL;
  c7_y = c7_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c7_b_sfEvent),
    &c7_thisId);
  sf_mex_destroy(&c7_b_sfEvent);
  *(int32_T *)c7_outData = c7_y;
  sf_mex_destroy(&c7_mxArrayInData);
}

static uint8_T c7_d_emlrt_marshallIn(SFc7_driverInstanceStruct *chartInstance,
  const mxArray *c7_b_is_active_c7_driver, const char_T *c7_identifier)
{
  uint8_T c7_y;
  emlrtMsgIdentifier c7_thisId;
  c7_thisId.fIdentifier = c7_identifier;
  c7_thisId.fParent = NULL;
  c7_y = c7_e_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c7_b_is_active_c7_driver), &c7_thisId);
  sf_mex_destroy(&c7_b_is_active_c7_driver);
  return c7_y;
}

static uint8_T c7_e_emlrt_marshallIn(SFc7_driverInstanceStruct *chartInstance,
  const mxArray *c7_u, const emlrtMsgIdentifier *c7_parentId)
{
  uint8_T c7_y;
  uint8_T c7_u0;
  sf_mex_import(c7_parentId, sf_mex_dup(c7_u), &c7_u0, 1, 3, 0U, 0, 0U, 0);
  c7_y = c7_u0;
  sf_mex_destroy(&c7_u);
  return c7_y;
}

static void c7_b_sqrt(SFc7_driverInstanceStruct *chartInstance, real_T *c7_x)
{
  if (*c7_x < 0.0) {
    c7_eml_error(chartInstance);
  }

  *c7_x = muDoubleScalarSqrt(*c7_x);
}

static void init_dsm_address_info(SFc7_driverInstanceStruct *chartInstance)
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

void sf_c7_driver_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(778939130U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(1869878101U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(2079955089U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2762963587U);
}

mxArray *sf_c7_driver_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("nXIu5KYu62NUuOWaLx6ZbF");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,2,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(4);
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

mxArray *sf_c7_driver_third_party_uses_info(void)
{
  mxArray * mxcell3p = mxCreateCellMatrix(1,0);
  return(mxcell3p);
}

static const mxArray *sf_get_sim_state_info_c7_driver(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x3'type','srcId','name','auxInfo'{{M[1],M[5],T\"speed\",},{M[1],M[6],T\"steering\",},{M[8],M[0],T\"is_active_c7_driver\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 3, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c7_driver_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc7_driverInstanceStruct *chartInstance;
    chartInstance = (SFc7_driverInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (sfGlobalDebugInstanceStruct,
           _driverMachineNumber_,
           7,
           1,
           1,
           4,
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
          _SFD_SET_DATA_PROPS(0,2,0,1,"steering");
          _SFD_SET_DATA_PROPS(1,1,1,0,"pose");
          _SFD_SET_DATA_PROPS(2,2,0,1,"speed");
          _SFD_SET_DATA_PROPS(3,1,1,0,"exec_path");
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
        _SFD_CV_INIT_EML(0,1,1,1,0,0,0,0,0,1,1);
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,1608);
        _SFD_CV_INIT_EML_IF(0,1,0,57,70,116,761);

        {
          static int condStart[] = { 61 };

          static int condEnd[] = { 70 };

          static int pfixExpr[] = { 0, -1 };

          _SFD_CV_INIT_EML_MCDC(0,1,0,60,70,1,0,&(condStart[0]),&(condEnd[0]),2,
                                &(pfixExpr[0]));
        }

        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c7_sf_marshallOut,(MexInFcnForType)c7_sf_marshallIn);

        {
          unsigned int dimVector[1];
          dimVector[0]= 4;
          _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,1,&(dimVector[0]),0,0,0,0.0,
            1.0,0,0,(MexFcnForType)c7_b_sf_marshallOut,(MexInFcnForType)NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c7_sf_marshallOut,(MexInFcnForType)c7_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(3,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c7_sf_marshallOut,(MexInFcnForType)NULL);

        {
          real_T *c7_steering;
          real_T *c7_speed;
          real_T *c7_exec_path;
          real_T (*c7_pose)[4];
          c7_exec_path = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
          c7_speed = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
          c7_pose = (real_T (*)[4])ssGetInputPortSignal(chartInstance->S, 0);
          c7_steering = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
          _SFD_SET_DATA_VALUE_PTR(0U, c7_steering);
          _SFD_SET_DATA_VALUE_PTR(1U, *c7_pose);
          _SFD_SET_DATA_VALUE_PTR(2U, c7_speed);
          _SFD_SET_DATA_VALUE_PTR(3U, c7_exec_path);
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
  return "HR2O1IqzBbriOnAJy2aepG";
}

static void sf_opaque_initialize_c7_driver(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc7_driverInstanceStruct*) chartInstanceVar)->S,
    0);
  initialize_params_c7_driver((SFc7_driverInstanceStruct*) chartInstanceVar);
  initialize_c7_driver((SFc7_driverInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_enable_c7_driver(void *chartInstanceVar)
{
  enable_c7_driver((SFc7_driverInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_disable_c7_driver(void *chartInstanceVar)
{
  disable_c7_driver((SFc7_driverInstanceStruct*) chartInstanceVar);
}

static void sf_opaque_gateway_c7_driver(void *chartInstanceVar)
{
  sf_c7_driver((SFc7_driverInstanceStruct*) chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c7_driver(SimStruct* S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c7_driver((SFc7_driverInstanceStruct*)
    chartInfo->chartInstance);         /* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c7_driver();/* state var info */
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

extern void sf_internal_set_sim_state_c7_driver(SimStruct* S, const mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c7_driver();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c7_driver((SFc7_driverInstanceStruct*)chartInfo->chartInstance,
    mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c7_driver(SimStruct* S)
{
  return sf_internal_get_sim_state_c7_driver(S);
}

static void sf_opaque_set_sim_state_c7_driver(SimStruct* S, const mxArray *st)
{
  sf_internal_set_sim_state_c7_driver(S, st);
}

static void sf_opaque_terminate_c7_driver(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc7_driverInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
      unload_driver_optimization_info();
    }

    finalize_c7_driver((SFc7_driverInstanceStruct*) chartInstanceVar);
    utFree((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc7_driver((SFc7_driverInstanceStruct*) chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c7_driver(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c7_driver((SFc7_driverInstanceStruct*)(((ChartInfoStruct *)
      ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c7_driver(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_driver_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      7);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,7,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,7,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_update_buildInfo(S,sf_get_instance_specialization(),infoStruct,7);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,7,2);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,7,2);
    }

    {
      unsigned int outPortIdx;
      for (outPortIdx=1; outPortIdx<=2; ++outPortIdx) {
        ssSetOutputPortOptimizeInIR(S, outPortIdx, 1U);
      }
    }

    {
      unsigned int inPortIdx;
      for (inPortIdx=0; inPortIdx < 2; ++inPortIdx) {
        ssSetInputPortOptimizeInIR(S, inPortIdx, 1U);
      }
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,7);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(3299811462U));
  ssSetChecksum1(S,(3557994636U));
  ssSetChecksum2(S,(981909399U));
  ssSetChecksum3(S,(3020749225U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSupportsMultipleExecInstances(S,1);
}

static void mdlRTW_c7_driver(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c7_driver(SimStruct *S)
{
  SFc7_driverInstanceStruct *chartInstance;
  chartInstance = (SFc7_driverInstanceStruct *)utMalloc(sizeof
    (SFc7_driverInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc7_driverInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway = sf_opaque_gateway_c7_driver;
  chartInstance->chartInfo.initializeChart = sf_opaque_initialize_c7_driver;
  chartInstance->chartInfo.terminateChart = sf_opaque_terminate_c7_driver;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c7_driver;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c7_driver;
  chartInstance->chartInfo.getSimState = sf_opaque_get_sim_state_c7_driver;
  chartInstance->chartInfo.setSimState = sf_opaque_set_sim_state_c7_driver;
  chartInstance->chartInfo.getSimStateInfo = sf_get_sim_state_info_c7_driver;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c7_driver;
  chartInstance->chartInfo.mdlStart = mdlStart_c7_driver;
  chartInstance->chartInfo.mdlSetWorkWidths = mdlSetWorkWidths_c7_driver;
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

void c7_driver_method_dispatcher(SimStruct *S, int_T method, void *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c7_driver(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c7_driver(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c7_driver(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c7_driver_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
