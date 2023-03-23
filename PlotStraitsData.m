function objects = PlotStraitsData(strait)

ph = plot(strait.time,strait.normal_speed,'-') ;
ax = gca ;
ax.Title.String = 'speed [m/s]' ;
ax.YLim = [-1 1] ;
ax.XLim = [datetime(1990,1,1) datetime(2024,1,1)] ;
xlabel('Time') ;
ylabel('speed [m/s]') ;
grid on
objects.p_speed = ph ;


% 
% p0b = Plot(
% scatter(
% x=strait["time"],
% y=ustrip(strait["temperature"]["value"]) .- 273.15,
% mode="lines",
% ),
% Layout(
% font_family="Courier New",
% font_color="blue",
% title=attr(
% text="temperature [C]",
% x=0.5,
% y=0.8,
% xanchor="center"),
% hovermode="closest",
% yaxis_range=[-2, 10],
% xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
% )
% )
% 
% p0c = Plot(
% scatter(
% x=strait["time"],
% y=ustrip(strait["salinity"]["value"]),
% mode="lines",
% ),
% Layout(
% xaxis_title="Time",
% title=attr(
% text="salinity [g/kg]",
% x=0.5,
% y=0.8,
% xanchor="center"),
% hovermode="closest",
% yaxis_range=[0, 40],
% xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
% )
% )
% 
% p0c2 = Plot(
% scatter(
% x=strait["time"],
% y=ustrip(strait["density"]["value"]) .- 1000,
% mode="lines",
% ),
% Layout(
% xaxis_title="Time",
% title=attr(
% text="density anomaly [kg/m^3]",
% x=0.5,
% y=0.8,
% xanchor="center"),
% hovermode="closest",
% yaxis_range=[0, 30],
% xaxis_range=[Date(1990, 1, 1), Date(2023, 1, 1)]
% )
% )
end