test_that("test get parameter vector", {
  # Create selectivity
  selectivity <- methods::new(LogisticSelectivity)
  selectivity$inflection_point[1]$value <- 10.0
  selectivity$inflection_point[1]$min <- 8.0
  selectivity$inflection_point[1]$max <- 12.0
  selectivity$inflection_point[1]$is_random_effect <- FALSE
  selectivity$inflection_point[1]$estimated <- TRUE
  selectivity$slope[1]$value <- 0.2
  selectivity$slope[1]$is_random_effect <- FALSE
  selectivity$slope[1]$estimated <- TRUE

  CreateTMBModel()
  p <- get_fixed()
  sel_parm <- c(selectivity$inflection_point[1]$value, selectivity$slope[1]$value)
  expect_equal(sel_parm, p)

  # test fims clear
  clear()
  p <- get_fixed()
  expect_equal(numeric(0), p)
  CreateTMBModel()
  p <- get_fixed()
  expect_equal(numeric(0), p)

  ## Not working - fims2::CreateTMBModel() retains the defined module from fims?
  # test multiple modules
  clear()
  p <- get_fixed()
  expect_equal(numeric(0), p)
  selectivity <- methods::new(LogisticSelectivity)
  selectivity$inflection_point[1]$value <- 11.0
  selectivity$inflection_point[1]$min <- 8.0
  selectivity$inflection_point[1]$max <- 12.0
  selectivity$inflection_point[1]$is_random_effect <- FALSE
  selectivity$inflection_point[1]$estimated <- TRUE
  selectivity$slope[1]$value <- 0.5
  selectivity$slope[1]$is_random_effect <- FALSE
  selectivity$slope[1]$estimated <- TRUE
  sel_parm <- c(selectivity$inflection_point[1]$value, selectivity$slope[1]$value)
  recruitment <- methods::new(BevertonHoltRecruitment)
  h <- 0.75
  r0 <- 1000000.0
  spawns <- 9.55784 * 10^6
  ssb0 <- 0.0102562
  recruitment$logit_steep[1]$value <- -log(1.0 - h) + log(h - 0.2)
  recruitment$logit_steep[1]$min <- 0.21
  recruitment$logit_steep[1]$max <- 1.0
  recruitment$logit_steep[1]$is_random_effect <- FALSE
  recruitment$logit_steep[1]$estimated <- TRUE
  recruitment$log_rzero[1]$value <- log(r0)
  recruitment$log_rzero[1]$is_random_effect <- FALSE
  recruitment$log_rzero[1]$estimated <- TRUE
  rec_parm <- c(-log(1.0 - h) + log(h - 0.2), log(r0))

  CreateTMBModel()
  p2 <- get_fixed()

  expect_equal(c(sel_parm, rec_parm), p2)
  clear()
})
test_that("get_fixed() works when estimated is set to FALSE", {
  clear()
  selectivity <- methods::new(LogisticSelectivity)
  selectivity$inflection_point[1]$value <- 10.0
  selectivity$inflection_point[1]$min <- 8.0
  selectivity$inflection_point[1]$max <- 12.0
  selectivity$inflection_point[1]$estimated <- FALSE
  selectivity$slope[1]$value <- 0.2
  selectivity$slope[1]$estimated <- TRUE

  CreateTMBModel()
  p <- get_fixed()
  sel_parm <- c(
    selectivity$slope[1]$value
  )
  expect_equal(sel_parm, p)

  clear()

  fish_selex <- methods::new(DoubleLogisticSelectivity)
  fish_selex$inflection_point_asc[1]$value <- 2
  fish_selex$inflection_point_asc[1]$estimated <- TRUE
  fish_selex$inflection_point_desc[1]$value <- 3
  fish_selex$inflection_point_desc[1]$estimated <- TRUE
  fish_selex$slope_asc[1]$value <- 1
  fish_selex$slope_asc[1]$estimated <- FALSE
  fish_selex$slope_desc[1]$value <- 1.5
  fish_selex$slope_desc[1]$estimated <- TRUE

  CreateTMBModel()
  p <- get_fixed()
  sel_parm <- c(
    fish_selex$inflection_point_asc[1]$value,
    fish_selex$inflection_point_desc[1]$value,
    fish_selex$slope_desc[1]$value
  )
  expect_equal(p, sel_parm)

  clear()
})
