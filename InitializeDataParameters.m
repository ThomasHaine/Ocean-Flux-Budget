function tmp = InitializeDataParameters(N)
% Define data parameters.
tmp.N               = N ;                       % Number of entries in the timeseries
tmp.c               = 0.9 ;                     % Constant    parameter in AR(1) process
tmp.phi             = 0.8 ;                     % Persistence parameter in AR(1) process
tmp.p_ref           = 0.0 ;                     % Reference pressure [N/m^2]
tmp.massBalance     = 'On' ;                    % Default flag for overall mass balance, or not.
tmp.C_p             = gsw_cp0 ;                 % Seawater specific heat capacity, J/kg/K

% Times are at mid points and of duration time_periods. They're evenly
% spaced.
tmp.secs_in_a_yr    = 86400*365.24 ;
tmp.start_date      = datetime(1990,1,1) ;      % Default start date.
tmp.end_date        = datetime(2020,1,1) ;      % Default end date.
timeEdges           = linspace(tmp.start_date,tmp.end_date,tmp.N+1) ;
tmp.time_periods    = diff(timeEdges) ;
tmp.time            = timeEdges(1:end-1) + tmp.time_periods/2 ;       % Notice weird datetime arithmetic and syntax!

% Control volume properties
tmp.InitCtrlVolTemp = 0.0 ;                                                   % Average starting temperature [C]
tmp.InitCtrlVolSal  = 34.8 ;                                                  % Average starting salinity [g/kg]
tmp.InitCtrlVolDens = gsw_rho(tmp.InitCtrlVolSal,tmp.InitCtrlVolTemp,0) ;     % Average starting density [kg/m^3]
tmp.InitCtrlVolVol  = (18.07 + 0.542 + 0.0028)*1e6*1e9 ;                      % Starting volume [m^3]. From wiki for Arctic Ocean+Barents Sea+Baffin Bay
tmp.InitCtrlVolMass = tmp.InitCtrlVolVol*tmp.InitCtrlVolDens ;                % Starting mass [kg]
tmp.InitCtrlVolSalt = tmp.InitCtrlVolSal*tmp.InitCtrlVolMass*1e-3 ;           % Starting salt mass [kg]
tmp.CtrlVolArea     = (14.056 + 1.4 + 0.689)*1e6*1e6 ;                        % Surface area [m^2]. From wiki for Arctic Ocean+Barents Sea+Baffin Bay
end