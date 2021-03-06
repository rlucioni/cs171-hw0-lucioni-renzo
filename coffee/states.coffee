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

# projection = d3.geo.albersUsa()
projection = d3.geo.mercator()
    .translate([canvasWidth/2, canvasHeight/2])
    .scale([100])

path = d3.geo.path()
    .projection(projection)

colors = d3.scale.ordinal()
    .domain(d3.range(10))
    .range(colorbrewer.Set3[9])

# d3.json("us-states.json", (json) ->
d3.json("oceans.json", (json) ->
    svg.selectAll("path")
        .data(json.features)
        .enter()
        .append("path")
        .attr("d", path)
        .style("fill", colors(2))
)

