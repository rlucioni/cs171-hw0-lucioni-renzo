### Mike Bostock's margin convention ###
margin = 
    top:    10, 
    right:  10, 
    bottom: 10, 
    left:   10

canvasWidth = 600 - margin.left - margin.right
canvasHeight = 400 - margin.top - margin.bottom

### create shifted SVG element ###
svg = d3.select("body")
    .append("svg")
    .attr("width", canvasWidth + margin.left + margin.right)
    .attr("height", canvasHeight + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(#{margin.left}, #{margin.top})")

projection = d3.geo.albersUsa()
    .translate([canvasWidth/2, canvasHeight/2])
    .scale([500])

path = d3.geo.path()
    .projection(projection)

colors = d3.scale.quantize()
    .range(colorbrewer.YlGn[5])

d3.csv("us-ag-productivity-2004.csv", (data) ->
    colors.domain([d3.min(data, (d) -> d.value), d3.max(data, (d) -> d.value)])

    d3.json("us-states.json", (json) ->
        for entry in data
            dataState = entry.state
            dataValue = +entry.value

            for el in json.features
                jsonState = el.properties.name

                if dataState == jsonState
                    el.properties.value = dataValue
                    break

        svg.selectAll("path")
            .data(json.features)
            .enter()
            .append("path")
            .attr("d", path)
            .style("fill", (d) ->
                value = d.properties.value
                if value
                    colors(value)
                else
                    return "#ccc"
            )

        d3.csv("us-cities.csv", (data) ->
            svg.selectAll("circle")
                .data(data)
                .enter()
                .append("circle")
                .attr("cx", (d) -> projection([d.lon, d.lat])[0])
                .attr("cy", (d) -> projection([d.lon, d.lat])[1])
                .attr("r", (d) -> Math.sqrt(+d.population * 0.00004))
                .style("fill", "blue")
                .style("opacity", 0.75)
        )
    )
)
