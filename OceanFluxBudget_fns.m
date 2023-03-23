
% export , , , PlotStraitsData, PlotStraitsFluxesBudgets
% 


% 
% 
% 
% 
 
 

% 
% 

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