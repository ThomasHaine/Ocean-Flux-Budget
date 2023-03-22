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
% 
% 

% 
% 
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
 
 

% 
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