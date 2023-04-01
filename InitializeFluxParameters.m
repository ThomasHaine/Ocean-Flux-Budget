function tmp = InitializeFluxParameters()
tmp.T_ref =  0.0 ;      % Default reference temperature,   oC
tmp.S_ref = 34.8 ;      % Default reference salinity,      g/kg
tmp.C_p   = gsw_cp0 ;   % Seawater specific heat capacity, J/kg/K
end