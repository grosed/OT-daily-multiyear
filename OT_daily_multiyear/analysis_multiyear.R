    #####################################################################
    ## start by choosing a species and year (The UKBMS website can be checked to determine species codes for each species)
    species <-  "4"
    
    ##### Need this for the spatial
   # cmn_nm <- "Marbled White"
    year <- c("1994":"2018")
    
    #either "spring" or "summer"
    season <- "spring"
    
    ## either "daily" or "weekly"
    setup_level <- "daily"
    
    ## either "doubleslope","slope", "variable" or "fixed"
    phi_type <- "doubleslope"
    
    # either "yes" or "no", if want fully time-dependent then set to "yes", if you want a covariate
    # or fixed set to "no"
    vary_mu <- "yes"
    
    #either "yes" or "no"
    vary_r <- "no"
    
    #either "fixed" or "variable"
    sigma_type <- "variable"
    
    # either "common","cov" or "double", if you want a covariate on mu set to "cov". If mu is either
    # fully time-dependent or fixed then set to "common". If you want a covariate then "vary_mu"
    # should be set to "no",
    # adding "double" for temp and time on mu (always set mu.cov.type to "temp" in this case)
    mu.type <- "common"
    
    ## This can be "temp" or "time", used if "mu.type" is set to "cov":if mu.type is "double"
    ## then set to "temp"
    mu.cov.type <- "temp"
    
    # either "lin", "quad" or "none"
    env_cov.type <- "none"
    
    #####################################################################
    #if (setup_level=="daily"){
   #   source("analysis/Multiyear/setup_daily_multiyear.R")
   # } else {
   #   source("analysis/Multiyear/setup_multiyear.R")
   # }
    #####################################################################
    
   # mean(ukbms_sp$TEMP,na.rm=T)
   # mean(ukbms_sp$minaftten,na.rm=T)
    
    load("ot_multiyear_data.rda")
    load("tempdat_ot.rda")

    nS <- vector(mode="integer",length=length(year))
    n.years <- split(ukbms_sp,ukbms_sp$YEAR)
    for (i in 1:length(n.years)){
      nS[[i]] <- length(unique(n.years[[i]]$SITENO))
    }
    
                if (setup_level== "daily") {
                  nT <- 183
                } else {
                  nT <-  26
                }
                
              
              # Set up the values needed by the GAI
              nY <- length(unique(ukbms_sp$YEAR))
              
             
              # create matrix of values of nS and nT (which will be my value of y)
              y <-  vector(mode = "list", length = length(n.years))
              for (i in 1:length(n.years)){
                y[[i]] <- counts <- matrix(n.years[[i]]$COUNT, nrow=nS[[i]], ncol=nT, byrow=TRUE)
              }
              
          
             y <-  simplify2array(y)
             
            # save(y,file="y_78_daily_94_18.rda")
          
            # y_t <- unlist(y)
             
            # hist(y_t)
              
            #  cov.p <- matrix(ukbms_sp$TEMP, nrow=nS, ncol=nT, byrow=TRUE)
           #   cov.p <- reshape2::melt(cov.p)
           #   cov.p <- scale(cov.p$value)
           #   cov.p <- matrix(cov.p, nrow=nS, ncol=nT, byrow = FALSE)
              
              ##########################################
              # Model fitting code-  derived from the Biometrics paper
              ##########################################
              # either "lin", "quad" or "none"
              env_cov.type <- "none"
              # optimisation method either "SANN" or "Nelder-Mead", can also use "CG","L-BFGS-B","BFGS"
              # L-BFGS-B seems to be best for the multiyear stuff
              meth <- "L-BFGS-B"
              # do I want to convert from the daily to the weekly format. Either "yes" or "no"
              convert_weekly <- "no"
              # do I want phi to vary over the season. Either "yes" or "no"
              vary_phi <- "no"
              # dist.type can be "P", "NB" or "ZIP"
              dist.type <- "NB" 
              # a.type can be "N", "SO" or "S"
              a.type <- "SO"  
              # If a.type is "N" or "SO"
              B <- 1  ## no. of broods
              
              
              #We'll put a time covariate on mu
              time <- scale(as.integer(1:length(year)))
              
              ## If you want to input an annual temperature covariate
             # antemp <- tempdat filter(Year %in% year)
              
             # if (season=="spring"){
             #   antemp <- scale(antemp$spr)
             # } else if (season=="summer"){
             #   antemp <- scale(antemp$sum)
            #  }
              
              #cor(antemp,scale(year), method = "pearson", use="complete.obs")
              #mu covariate either time or antemp
              #if (mu.cov.type=="temp"){
             #   mu.cov <- antemp
             # } else {
             #   mu.cov <- time
             # }
            #  mu.cov2 <- time
              
              if (phi_type=="slope"){
                phi.cov <- time
              } else if(phi_type=="doubleslope") {
                phi.cov <- time
                phi.cov2 <- time^2#antemp
              }else{
                phi.cov <- NULL
              }
              
              mu.diff.type <- "common"
              sigma.type <- "hom"
              w.type <- "common"
              # If a.type is "S"
              #degf <- 10
              #deg <- 3
              
             # output <- vector(mode = "list", length = n.iter)
            #  set.seed(0)
            #  for (i in 1:n.iter){
              # Specify number of random starts 
              nstart <- 1

            load("ot_multiyear_data.rda")

              output <- NA
              ## To determine which model is being run
              if (env_cov.type=="lin"){
                source("analysis/model_code_linear.R")
              } else if (env_cov.type =="quad"){
                source("analysis/model_code_quadratic.R")
              } else if (env_cov.type == "none"){
                    source("model_code_multiyear.R")
                } 
              
              
              # Output is a list of length 3: the best model of multiple starts, output from the multiple starts, and the log-likelihood values for the multiple starts
              
              output <- fit_it_model()
     #       }
            

      save(output, file="multiyear_daily_SO_NB_4_1994_2018_L_BFGS_B_varymu_quadtimephicov_varysigma.rda")
  
 
      
      
      

      
      