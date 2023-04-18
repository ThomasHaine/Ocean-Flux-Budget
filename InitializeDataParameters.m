function tmp = InitializeDataParameters(N)
% Define data parameters.
tmp.N           = N ;                       % Number of entries in the timeseries
tmp.start_date  = datetime(1990,1,1) ;      % Default start date.
tmp.end_date    = datetime(2020,1,1) ;      % Default end date.
tmp.c           = 0.9 ;                     % Constant    parameter in AR(1) process
tmp.phi         = 0.8 ;                     % Persistence parameter in AR(1) process
tmp.p_ref       = 0.0 ;                     % Reference pressure [N/m^2]
tmp.massBalance = 'On' ;                    % Default flag for overall mass balance, or not.
tmp.ctrlVolTemp = 0.0 ;                     % Average starting temperature [C]
tmp.ctrlVolSal  = 34.8 ;                    % Average starting salinity [g/kg]
tmp.ctrlVolMass = (18.07 + 0.542 + 0.0028)*1e6*1e9*gsw_rho(tmp.ctrlVolSal,tmp.ctrlVolTemp,0) ;
end