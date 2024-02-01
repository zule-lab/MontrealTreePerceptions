all_fall_long <- read.csv(text = 'ResponseId,Duration_Seconds,Semester,SubjectID,SubjectStatus,SubjectVidID,BeforeAfter,SubjectSex,SubjectLang,SubjectDept,SubjectProgram,SubjectYear,SubjectPriorTrain,age,ScorerGender,ethnicity,ethnicity_7_TEXT,class,major,ScorerLang,question_code,score,question_category,pair_code,
R_09ybhj9BQkdYtNv,830,Fall17,UT_9_F17,0,UTA9_F17,1,0,1,EEB,MS,1,No,22.174,4,"White, non-Hispanic",NA,Senior,Actuarial Science,0,Clarity_2,2,Clarity,futile_drake
R_09ybhj9BQkdYtNv,830,Fall17,UT_9_F17,0,UTA9_F17,1,0,1,EEB,MS,1,No,22.174,4,"White, non-Hispanic",NA,Senior,Actuarial Science,0,Clarity_3,6,Clarity,futile_drake
R_09ybhj9BQkdYtNv,830,Fall17,UT_9_F17,0,UTA9_F17,1,0,1,EEB,MS,1,No,22.174,4,"White, non-Hispanic",NA,Senior,Actuarial Science,0,Clarity_4,2,Clarity,futile_drake
R_09ybhj9BQkdYtNv,830,Fall17,UT_9_F17,0,UTA9_F17,1,0,1,EEB,MS,1,No,22.174,4,"White, non-Hispanic",NA,Senior,Actuarial Science,0,Clarity_5,3,Clarity,futile_drake
R_09ybhj9BQkdYtNv,830,Fall17,UT_9_F17,0,UTA9_F17,1,0,1,EEB,MS,1,No,22.174,4,"White, non-Hispanic",NA,Senior,Actuarial Science,0,Clarity_6,1,Clarity,futile_drake
R_09ybhj9BQkdYtNv,830,Fall17,UT_9_F17,0,UTA9_F17,1,0,1,EEB,MS,1,No,22.174,4,"White, non-Hispanic",NA,Senior,Actuarial Science,0,enth_eng_1,1,enth_eng,futile_drake')


#all_fall_long <- read_csv("all_fall_long.csv")

# every subject has a BeforeAfter effect (they were all measured twice) but they
# don't all have an interaction (they were either in the class or not)
with_predictors_questions_change_bf <- bf(score ~
                                            1 + BeforeAfter + BeforeAfter:SubjectStatus +
                                            (1 + BeforeAfter|SubjectID) +
                                            (1|ResponseId) +
                                            (1 + BeforeAfter + BeforeAfter:SubjectStatus|question_code) +
                                            (1|question_category) +
                                            (1|Semester),
                                          family = cumulative())


get_prior(with_predictors_questions_change_bf, data = all_fall_long)


# set better priors?
with_predictors_questions_change_prior <- c(
  prior(normal(-2.5, 0.4),  class = "Intercept", coef = "1"),
  prior(normal(-1.5, 0.4),  class = "Intercept", coef = "2"),
  prior(normal(-0.5, 0.2),   class = "Intercept", coef = "3"),
  prior(normal(0.5, 0.4),   class = "Intercept", coef = "4"),
  prior(normal(1.5, 0.4), class = "Intercept", coef = "5"),
  prior(normal(2, 0.4),   class = "Intercept", coef = "6"),
  prior(exponential(4), class = "sd"),
  prior(normal(0,0.5), class = "b"),
  prior(lkj(3), class = "cor")
)
