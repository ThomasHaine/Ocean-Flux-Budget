
% 
% 
[straits, DataParams, FluxParams] = InitializeStraits(false) ;
straits = UpdateStraits(FluxParams, straits) ;
budgets = ComputeBudgets(straits) ;
PlotStraitsData(straits.FramStrait)

% 
% function buildDropdown(straits)
%     labelNames = keys(straits)
%     labelValues = labelNames
%     local tmp = Array{NamedTuple}(undef, length(straits))
%     for (ii, (nn, vv)) in enumerate(zip(labelNames, labelValues))
%         tmp[ii] = (label=nn, value=vv)      # Named tuple
%     end
%     return tmp
% end
% dropdownOptions = buildDropdown(straits)
% 
% 
% # Useful for style tips: https://github.com/plotly/Dash.jl/issues/50
% # external_stylesheets = ["https://codepen.io/chriddyp/pen/bWLwgP.css"]
% # app = dash(external_stylesheets=external_stylesheets)
% app = dash(external_stylesheets=[dbc_themes.BOOTSTRAP])
% # app = dash(external_stylesheets=[dbc_themes.SANDSTONE])
% 
% function graphLayout(strait)
%     local graphDict = Dict("height" => 200, "marginBottom" => -25)
%     tmp = dbc_row([
%         dbc_col(
%             html_div([
%                 html_h5(id="strait_id " * strait,
%                     style=Dict("textAlign" => "center"),
%                 ),
%                 dcc_graph(id="normal speed graph " * strait, style=graphDict),
%                 dcc_graph(id="temperature graph " * strait, style=graphDict),
%                 dcc_graph(id="salinity graph " * strait, style=graphDict),
%                 dcc_graph(id="density graph " * strait, style=graphDict)
%             ]
%             )
%         ),
%         dbc_col(
%             html_div([
%                 html_h5("Fluxes", style=Dict("textAlign" => "center")),
%                 dcc_graph(id="mass flux graph " * strait, style=graphDict),
%                 dcc_graph(id="volume flux graph " * strait, style=graphDict),
%                 dcc_graph(id="heat flux graph " * strait, style=graphDict),
%                 dcc_graph(id="LFC graph " * strait, style=graphDict),
%                 dcc_graph(id="salt flux graph " * strait, style=graphDict)]
%             )),
%     ])
%     return tmp
% end
% 
% straitLayout = graphLayout(straitName)
% 
% graphDict = Dict("height" => 200, "marginBottom" => -25)
% budgetLayout = dbc_row([
%     dbc_col(
%         html_div([
%             html_h5("Budgets",
%                 style=Dict("textAlign" => "center"),
%             ),
%             dcc_graph(id="mass budget graph", style=graphDict),
%             dcc_graph(id="volume budget graph", style=graphDict),
%             dcc_graph(id="salt budget graph", style=graphDict),
%             dcc_graph(id="heat budget graph", style=graphDict),
%             dcc_graph(id="LFC budget graph", style=graphDict),
%         ]
%         )
%     )
% ])
% 
% app.layout = html_div() do
%     dbc_container(style=Dict("fluid" => true), [
%         html_div(html_h1(
%                 "Ocean Flux Calculator",
%                 style=Dict("textAlign" => "center"),
%             ),
%         ),
%         dbc_row([
%             dbc_col(html_div("Select a strait")),
%             dbc_col(html_div("")),
%             dbc_col(html_button("Compute", id="compute button")),
%             dbc_col(html_div("Reference temperature [C]", style=Dict("textAlign" => "center"))),
%             dbc_col(html_div("Reference salinity [g/kg]", style=Dict("textAlign" => "center"))),
%         ]),
%         dbc_row([
%             dbc_col([
%                 dcc_dropdown(
%                     id="straitdropdown",
%                     options=dropdownOptions,
%                     value=straitName,
%                     placeholder="Select a strait"
%                 ),
%                 html_div(id="dd-output-container")
%             ]),
%             dbc_col(html_button("Re-initialize", id="reinit button")),
%             dbc_col(html_button("Re-initialize and balance mass", id="reinit balance button")),
%             dbc_col(
%                 html_div(
%                     dcc_slider(
%                         id="T_ref slider",
%                         min=-2.0,
%                         max=8.0,
%                         step=0.1,
%                         value=1.0,
%                         marks=Dict([Symbol(v) => Symbol(v) for v in -2:8]),
%                         tooltip=Dict("placement" => "bottom", "always_visible" => true)
%                     )
%                 )),
%             dbc_col(
%                 html_div([
%                     dcc_slider(
%                         id="S_ref slider",
%                         min=0.1,        # Can't be zero to avoid divide by zero
%                         max=40.0,
%                         step=0.1,
%                         value=34.8,
%                         marks=Dict([Symbol(v) => Symbol(v) for v in 0:5:40]),
%                         tooltip=Dict("placement" => "bottom", "always_visible" => true)
%                     )
%                 ])),
%         ]),
%         dbc_row([
%             dbc_col(html_div(straitLayout)),
%             dbc_col(html_div(budgetLayout))
%         ])
%     ])
% end
% 
% app_in = [
%     Input("reinit button", "n_clicks"),
%     Input("reinit balance button", "n_clicks"),
%     Input("T_ref slider", "value"),
%     Input("S_ref slider", "value"),
%     Input("straitdropdown", "value"),
%     Input("compute button", "n_clicks")
% ]
% 
% app_out = []
% app_out = [app_out
%     [Output("strait_id " * straitName, "children"),
%         Output("normal speed graph " * straitName, "figure"),
%         Output("temperature graph " * straitName, "figure"),
%         Output("salinity graph " * straitName, "figure"),
%         Output("density graph " * straitName, "figure"),
%         Output("mass flux graph " * straitName, "figure"),
%         Output("volume flux graph " * straitName, "figure"),
%         Output("heat flux graph " * straitName, "figure"),
%         Output("LFC graph " * straitName, "figure"),
%         Output("salt flux graph " * straitName, "figure")]
% ]
% 
% app_out = [app_out
%     [Output("mass budget graph", "figure"),
%         Output("volume budget graph", "figure"),
%         Output("salt budget graph", "figure"),
%         Output("heat budget graph", "figure"),
%         Output("LFC budget graph", "figure")]
% ]
% 
% # Initialize figures
% strait_tit, p0a, p0b, p0c, p0c2 = PlotStraitsData(straits[straitName])
% p0d, p1, p2, p3, p4, pb0a, pb0b, pb0c, pb0d, pb0e = PlotStraitsFluxesBudgets(straits[straitName], budgets)
% 
% callback!(app, app_out..., app_in...) do btn1, btn2, T_ref, S_ref, input_1, btn3
% 
%     ctx = callback_context()
%     if length(ctx.triggered) == 0
%         button_id = "No clicks yet"
%     else
%         button_id = split(ctx.triggered[1].prop_id, ".")[1]
%     end
%     println("callback event: ", button_id)
%     if (button_id == "reinit button")
%         global straits, DataParams, FluxParams = InitializeStraits(false)
%         global strait_tit, p0a, p0b, p0c, p0c2 = PlotStraitsData(straits[straitName])
%     elseif (button_id == "reinit balance button")
%         global straits, DataParams, FluxParams = InitializeStraits(true)
%         global strait_tit, p0a, p0b, p0c, p0c2 = PlotStraitsData(straits[straitName])
%     elseif (button_id == "T_ref slider")
%         global FluxParams["T_ref"] = (T_ref + 273.15) * 1u"K"
%     elseif (button_id == "S_ref slider")
%         global FluxParams["S_ref"] = S_ref * 1u"g/kg"
%     elseif (button_id == "straitdropdown")
%         global straitName = input_1
%         global strait_tit, p0a, p0b, p0c, p0c2 = PlotStraitsData(straits[straitName])
%         global     p0d, p1, p2, p3, p4, pb0a, pb0b, pb0c, pb0d, pb0e = PlotStraitsFluxesBudgets(straits[straitName], budgets)
%     elseif (button_id == "compute button")
%         global straits = UpdateStraits(FluxParams, straits)
%         global budgets = ComputeBudgets(straits)   
%         global     p0d, p1, p2, p3, p4, pb0a, pb0b, pb0c, pb0d, pb0e = PlotStraitsFluxesBudgets(straits[straitName], budgets)
%     end # if
% 
% 
%     # global straits = UpdateStraits(FluxParams, straits)
%     # budgets = ComputeBudgets(straits)
%     # 
% # if()
% #     global straits, DataParams, FluxParams = InitializeStraits(false)
% #     global strait_tit, p0a, p0b, p0c, p0c2 = PlotStraitsData(straits[straitName])
% 
% 
%     println("T_ref = $(FluxParams["T_ref"])")
%     println("S_ref = $(FluxParams["S_ref"])")
% println("density value = $(straits["Fram Strait"]["density"]["value"][1])")
% println("volume budget value = $(budgets["volume"][1])")
% 
%     return strait_tit, p0a, p0b, p0c, p0c2, p0d, p1, p2, p3, p4, pb0a, pb0b, pb0c, pb0d, pb0e
% end
% 
% # run_server(app, "0.0.0.0", debug=true)
