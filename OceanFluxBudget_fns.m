% module OceanFluxes
% 
% # Used Dict type for primary data structure, but should probably have used a mutable struct instead.
% # See: https://stackoverflow.com/questions/56980348/julia-is-a-function-that-receives-a-dict-as-input-and-output-a-dict-type-stable
% # 
% 
% export InitializeStraits, UpdateStraits, ComputeBudgets, PlotStraitsData, PlotStraitsFluxesBudgets
% 
% using PlotlyJS
% using Statistics
% using Unitful
% @unit S_A "g/kg" absolute_salinity 1u"g/kg" true
% include("AR1.jl")
% using .AR1
% using Dates
% using GibbsSeaWater
% using Infiltrator
% using Printf
% 
% const yearinseconds = 86400.0*365.0
% const kmcubedinmeterscubed = 1.0e9
% const sverdrupinmcubedpersecond = 1.0e6
% const kging = 1.0e3
% 
function tmp = DefineDataParameters(N)
% Define data parameters.
tmp.N     = N ;     % Number of ??
tmp.c     = 0.9 ;   % Nu
tmp.phi   = 0.8 ;
tmp.p_ref = 0.0 ;   % Reference pressure [N/m^2]
end

% function DefineFluxParameters()
%     tmp = Dict("T_ref" => 273.15u"K", "S_ref" => 34.8u"g/kg", "C_p" => 3991.86795711963u"J/kg/K")
%     return tmp
% end
% 
% function ComputeDensity(DataParams,strait)
%     N = length(strait["salinity"]["value"])
%     density = fill(0.0, N)
%     for ii = 1:N
%         density[ii] = gsw_rho(ustrip(strait["salinity"]["value"])[ii], ustrip(strait["temperature"]["value"])[ii] - 273.15, ustrip(DataParams["p_ref"]))
%     end
%     density = density .* 1u"kg/m^3"
%     out = Dict("value" => density, "long name" => "seawater density", "symbol" => "ρ")
%     return out
% end
% 
% function DefineSpeed(DataParams,straitParams)
%     speeds = ar1(DataParams["N"], DataParams["c"], DataParams["ϕ"], ustrip(straitParams["speed_σ"])) .* 1u"m/s"
%     speeds = speeds .- mean(speeds) .+ straitParams["speed_mean"]
%     out = Dict("value" => speeds, "long name" => "normal speed", "symbol" => "u")
%     return out
% end
% 
% function DefineTemperature(DataParams,straitParams)
%     temps = ar1(DataParams["N"], DataParams["c"], DataParams["ϕ"], ustrip(straitParams["temp_σ"])) .* 1u"K"
%     temps = temps .- mean(temps) .+ straitParams["temp_mean"]
%     temps = max.(temps,271.35*1u"K")
%     out = Dict("value" => temps, "long name" => "conservative temperature", "symbol" => "Θ")
%     return out
% end
% 
% function DefineSalinity(DataParams,straitParams)
%     salts = ar1(DataParams["N"], DataParams["c"], DataParams["ϕ"], ustrip(straitParams["salinity_σ"])) .* 1u"g/kg"
%     salts = salts .- mean(salts) .+ straitParams["salinity_mean"]
%     salts = max.(salts,0.0*1u"g/kg")
%     out = Dict("value" => salts, "long name" => "absolute salinity", "symbol" => "S_A")
%     return out
% end
% 
% function DefineStrait(DataParams,straitParams,name)
%     # times are at mid points and of duration timePeriods
%     N = DataParams["N"]
%     timePeriods = fill(Year(1), N)
%     timeEdges = DateTime(1990) .+ [Year(0); cumsum(timePeriods)]
%     timePeriods = diff(timeEdges)
%     timeMidpoints = fill(DateTime(2022, 12, 30, 14, 32, 0), N)
%     timeMidpoints[1] = timeEdges[1] + timePeriods[1] / 2
%     for tt = 2:N
%         timeMidpoints[tt] = timeEdges[1] + sum(timePeriods[1:tt-1]) + timePeriods[tt] / 2
%     end # tt
% 
%     local strait = Dict(
%         "name" => name,
%         "normal speed" => DefineSpeed(DataParams,straitParams),
%         "temperature" => DefineTemperature(DataParams,straitParams),
%         "salinity" => DefineSalinity(DataParams,straitParams),
%         "time" => timeMidpoints,
%         "time periods" => timePeriods,
%         "parameters" => straitParams)
%     strait["density"] = ComputeDensity(DataParams,strait)
%     return strait
% end
% 
% function ComputeFluxes(strait, FluxParams)
%     vol_flux = Dict(
%         "long name" => "volume flux",
%         "value" => strait["parameters"]["area"] .* strait["normal speed"]["value"])
%     mass_flux = Dict(
%         "long name" => "mass flux",
%         "value" => strait["density"]["value"] .* strait["parameters"]["area"] .* strait["normal speed"]["value"])
%     heat_flux = Dict(
%         "long name" => "heat flux",
%         "value" => strait["density"]["value"] .* FluxParams["C_p"] .* strait["parameters"]["area"] .* strait["normal speed"]["value"] .* (strait["temperature"]["value"] .- FluxParams["T_ref"]))
%     LFC_flux = Dict(
%         "long name" => "liquid freshwater flux",
%         "value" => strait["parameters"]["area"] .* strait["normal speed"]["value"] .* (strait["salinity"]["value"] .- FluxParams["S_ref"]) ./ FluxParams["S_ref"])
%     salt_flux = Dict(
%         "long name" => "salt flux",
%         "value" => strait["density"]["value"] .* strait["parameters"]["area"] .* strait["normal speed"]["value"] .* strait["salinity"]["value"])
%     fluxes = Dict(
%         "volume flux" => vol_flux,
%         "heat flux" => heat_flux,
%         "LFC flux" => LFC_flux,
%         "salt flux" => salt_flux,
%         "mass flux" => mass_flux)
%     return fluxes
% end
% 
% function ComputeBudgets(straits)
% 
%     function accumulateBudget(straits, keyName)
%         flag = true
%         for strait in keys(straits)
%             tmp = uconvert.(u"s", straits[strait]["time periods"]) .* straits[strait][keyName]["value"]
%             if (flag || !@isdefined budget)
%                 global budget = similar(tmp)
%                 flag = false
%             end
%             if (!@isdefined times)
%                 global times = straits[strait]["time"]
%             end
%             global budget .+= cumsum(tmp)
%         end
%         return budget
%     end
% 
%     budgets = Dict(
%         "time" => straits[first(keys(straits))]["time"],
%         "mass" => accumulateBudget(straits, "mass flux"),
%         "salt" => accumulateBudget(straits, "salt flux"),
%         "volume" => accumulateBudget(straits, "volume flux"),
%         "heat" => accumulateBudget(straits, "heat flux"),
%         "LFC" => accumulateBudget(straits, "LFC flux"),
%     )
% 
%     return budgets
% end
% 
% function ComputeMassConverg(straits)
%     flag = true
%     straitNames = keys(straits)
%     for strait in straitNames
%         tmp = straits[strait]["mass flux"]["value"]
%         if (flag || !@isdefined massConverg)
%             global massConverg = similar(tmp)
%             flag = false
%         end
%         global massConverg .+= tmp
%     end
%     return massConverg
% end
% 
% function BalanceMass(straits)
%     println("balancing...")
%     massConverg = ComputeMassConverg(straits)
%     straitNames = keys(straits)
%     for strait in straitNames
%         straits[strait]["normal speed"]["value"] .-= (massConverg ./ length(straitNames)) ./ (straits[strait]["density"]["value"] .* straits[strait]["parameters"]["area"])
%     end
%     return straits
% end
% 
% function InitializeStraits(balanceFlag::Bool)
%     local DataParams = DefineDataParameters(32)
%     local FluxParams = DefineFluxParameters()
% 
%     # Define cross-sectional area of each strait here. See Tsubouchi et al. (2018) Fig 1 for these rough estimates
%     # Also define statistical properties of timeseries for each strait. See Tsubouchi et al. (2018) Table 3 and Figs. 2 and 4.
% 
%     # Fram Strait
%     straitParams = Dict(
%         "speed_σ" => 0.0004u"m/s", "speed_Delta" => 0.0u"m/s", "speed_mean" => -0.0037u"m/s",
%         "temp_σ" => 0.2u"K", "temp_Delta" => 0.0u"K", "temp_mean" => 274.0u"K",
%         "salinity_σ" => 0.1u"g/kg", "salinity_Delta" => 0.0u"g/kg", "salinity_mean" => 34.0u"g/kg",
%         "area" => 3e8u"m^2")
%     FramStrait = DefineStrait(DataParams,straitParams,"Fram Strait")
% 
%     # Davis Strait
%     straitParams = Dict(
%         "speed_σ" => 0.0002u"m/s", "speed_Delta" => 0.0u"m/s", "speed_mean" => -0.01u"m/s",
%         "temp_σ" => 1u"K", "temp_Delta" => 0.0u"K", "temp_mean" => 273.15u"K",
%         "salinity_σ" => 1u"g/kg", "salinity_Delta" => 0.0u"g/kg", "salinity_mean" => 33.0u"g/kg",
%         "area" => 2e8u"m^2")
%     DavisStrait = DefineStrait(DataParams,straitParams,"Davis Strait")
% 
%     # Bering Strait
%     straitParams = Dict(
%         "speed_σ" => 0.018u"m/s", "speed_Delta" => 0.0u"m/s", "speed_mean" => 0.18u"m/s",
%         "temp_σ" => 2u"K", "temp_Delta" => 0.0u"K", "temp_mean" => 273.15u"K",
%         "salinity_σ" => 0.5u"g/kg", "salinity_Delta" => 0.0u"g/kg", "salinity_mean" => 32.0u"g/kg",
%         "area" => 3.8e6u"m^2")
%     BeringStrait = DefineStrait(DataParams,straitParams,"Bering Strait")
% 
%     # BSO
%     straitParams = Dict(
%         "speed_σ" => 0.0005u"m/s", "speed_Delta" => 0.0u"m/s", "speed_mean" => 0.0096u"m/s",
%         "temp_σ" => 1u"K", "temp_Delta" => 0.0u"K", "temp_mean" => 277.0u"K",
%         "salinity_σ" => 0.2u"g/kg", "salinity_Delta" => 0.0u"g/kg", "salinity_mean" => 34.8u"g/kg",
%         "area" => 2.4e8u"m^2")
%     BSO = DefineStrait(DataParams,straitParams,"BSO")
% 
%     # R+P-E
%     # Assumes a mean speed of 0.6m/s and a total flux of 6000km^3/yr from H et al. (2015) Table 1.
%     straitParams = Dict(
%         "speed_σ" => 0.05u"m/s", "speed_Delta" => 0.0u"m/s", "speed_mean" => 0.6u"m/s",
%         "temp_σ" => 0.2u"K", "temp_Delta" => 0.0u"K", "temp_mean" => 273.15u"K",
%         "salinity_σ" => 0.1u"g/kg", "salinity_Delta" => 0.0u"g/kg", "salinity_mean" => 0.0u"g/kg",
%         "area" => 3.2e5u"m^2")
%     PmEmR = DefineStrait(DataParams,straitParams,"Runoff + precipitation - evapouration")
% 
%     straits = Dict(
%         "Fram Strait" => FramStrait,
%         "Davis Strait" => DavisStrait,
%         # "Bering Strait" => BeringStrait,
%         # "BSO" => BSO,
%         # "Runoff + precipitation - evapouration" => PmEmR
%     )
% 
%     local straits = UpdateStraits(FluxParams, straits)
%     if (balanceFlag)
%         straits = BalanceMass(straits)
%         straits = UpdateStraits(FluxParams, straits)
%     end
% 
%     return straits, DataParams, FluxParams
% end
% 
% function UpdateStraits(FluxParams, straits)
% 
%     for strait in keys(straits)
%         straits[strait] = merge(straits[strait], ComputeFluxes(straits[strait], FluxParams))
%     end
% 
%     return straits
% end
% 
% function PlotStraitsData(strait)
% 
%     strait_tit = strait["name"]
%     p0a = Plot(
%         scatter(
%             x=strait["time"],
%             y=ustrip(strait["normal speed"]["value"]),
%             mode="lines",
%         ),
%         Layout(
%             title=attr(
%                 text="speed [m/s]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             yaxis_range=[-1, 1],
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         )
%     )
% 
%     p0b = Plot(
%         scatter(
%             x=strait["time"],
%             y=ustrip(strait["temperature"]["value"]) .- 273.15,
%             mode="lines",
%         ),
%         Layout(
%             font_family="Courier New",
%             font_color="blue",
%             title=attr(
%                 text="temperature [C]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             yaxis_range=[-2, 10],
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         )
%     )
% 
%     p0c = Plot(
%         scatter(
%             x=strait["time"],
%             y=ustrip(strait["salinity"]["value"]),
%             mode="lines",
%         ),
%         Layout(
%             xaxis_title="Time",
%             title=attr(
%                 text="salinity [g/kg]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             yaxis_range=[0, 40],
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         )
%     )
% 
%     p0c2 = Plot(
%         scatter(
%             x=strait["time"],
%             y=ustrip(strait["density"]["value"]) .- 1000,
%             mode="lines",
%         ),
%         Layout(
%             xaxis_title="Time",
%             title=attr(
%                 text="density anomaly [kg/m^3]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             yaxis_range=[0, 30],
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         )
%     )
%     return strait_tit, p0a, p0b, p0c, p0c2
% end
% 
%     function PlotStraitsFluxesBudgets(strait, budget)
% 
%     p0d = Plot(
%         scatter(
%             x=strait["time"],
%             y=ustrip(strait["mass flux"]["value"]),
%             mode="lines",
%         ),
%         Layout(
%             title=attr(
%                 text="mass [kg/s]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         )
%     )
% 
%     p1 = Plot(
%         scatter(
%             x=strait["time"],
%             y=ustrip(strait["volume flux"]["value"]) ./ sverdrupinmcubedpersecond,
%             mode="lines",
%         ),
%         Layout(
%             title=attr(
%                 text="volume [Sv]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             yaxis_range=[-4, 4],
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         )
%     )
% 
%     p2 = Plot(
%         scatter(
%             x=strait["time"],
%             y=ustrip(strait["heat flux"]["value"]) ./1.0e12,
%             mode="lines",
%         ),
%         Layout(
%             title=attr(
%                 text="heat [TW]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         )
%     )
% 
%     p3 = Plot(
%         scatter(
%             x=strait["time"],
%             y=ustrip(strait["LFC flux"]["value"]) .* yearinseconds/kmcubedinmeterscubed,
%             mode="lines",
%         ),
%         Layout(
%             title=attr(
%                 text="liquid freshwater [km^3/yr]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             yaxis_range=[-8000 8000],
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         )
%     )
% 
%     p4 = Plot(
%         scatter(
%             x=strait["time"],
%             y=ustrip(strait["salt flux"]["value"]) ./ kging,
%             mode="lines",
%         ),
%         Layout(
%             xaxis_title="Time",
%             title=attr(
%                 text="salt [kg/s]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         ),
%         config=PlotConfig(staticPlot=true)
%     )
% 
%     pb0a = Plot(
%         scatter(
%             x=budget["time"],
%             y=ustrip(budget["mass"]) ./ 1.0e15,
%             mode="lines",
%         ),
%         Layout(
%             title=attr(
%                 text="mass [x 10^15 kg]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         ),
%         config=PlotConfig(staticPlot=true),
%     )
% 
%     pb0b = Plot(
%         scatter(
%             x=budget["time"],
%             y=ustrip(budget["volume"]) ./ kmcubedinmeterscubed,
%             mode="lines",
%         ),
%         Layout(
%             title=attr(
%                 text="volume [km^3]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         ),
%         config=PlotConfig(staticPlot=true),
%     )
% 
%     pb0c = Plot(
%         scatter(
%             x=budget["time"],
%             y=ustrip(budget["heat"]),
%             mode="lines",
%         ),
%         Layout(
%             title=attr(
%                 text="heat [J]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         ),
%         config=PlotConfig(staticPlot=true),
%     )
% 
%     pb0d = Plot(
%         scatter(
%             x=budget["time"],
%             y=ustrip(budget["LFC"]) ./  kmcubedinmeterscubed,
%             mode="lines",
%         ),
%         Layout(
%             title=attr(
%                 text="liquid freshwater [km^3]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         ),
%         config=PlotConfig(staticPlot=true),
%     )
% 
%     pb0e = Plot(
%         scatter(
%             x=budget["time"],
%             y=ustrip(budget["salt"]) .* 1e3,
%             mode="lines",
%         ),
%         Layout(
%             title=attr(
%                 text="salt [kg]",
%                 x=0.5,
%                 y=0.8,
%                 xanchor="center"),
%             hovermode="closest",
%             xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
%         ),
%         config=PlotConfig(staticPlot=true),
%     )
% 
%     return p0d, p1, p2, p3, p4, pb0a, pb0b, pb0c, pb0d, pb0e
%     # return pb0a, pb0b, pb0c, pb0d, pb0e
% end
% 
% end  # module