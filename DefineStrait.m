function strait = DefineStrait(DataParams,straitParams,name)
strait.name         = name ;
strait.normal_speed = DefineSpeed(DataParams,straitParams) ;
strait.temperature  = DefineTemperature(DataParams,straitParams) ;
strait.salinity     = DefineSalinity(DataParams,straitParams) ;
strait.parameters   = straitParams ;
strait.density      = ComputeDensity(DataParams,strait) ;
end

%% Local functions
function speeds = DefineSpeed(DataParams,straitParams)
speeds = ar1(DataParams.N,DataParams.c,DataParams.phi,straitParams.speed_std) ;
speeds = speeds - mean(speeds) + straitParams.speed_mean + linspace(-straitParams.speed_Delta/2,straitParams.speed_Delta/2,DataParams.N)' ;
end

function temps = DefineTemperature(DataParams,straitParams)
temps = ar1(DataParams.N,DataParams.c,DataParams.phi,straitParams.temp_std) ;
temps = temps - mean(temps) + straitParams.temp_mean + linspace(-straitParams.temp_Delta/2,straitParams.temp_Delta/2,DataParams.N)' ;
temps = max(temps,-1.9) ;      % Clip temperatures so they're above freezing.
end

function salts = DefineSalinity(DataParams,straitParams)
salts = ar1(DataParams.N,DataParams.c,DataParams.phi,straitParams.salinity_std) ;
salts = salts - mean(salts) + straitParams.salinity_mean + linspace(-straitParams.salinity_Delta,straitParams.salinity_Delta/2,DataParams.N)' ;
salts = max(salts,0.0) ;              % Clip salinities so they're positive
end

function out = ComputeDensity(DataParams,strait)
out = gsw_rho(strait.salinity,strait.temperature,DataParams.p_ref) ;
end