### Mike Bostock's margin convention ###
margin = 
    top:    10, 
    right:  10, 
    bottom: 10, 
    left:   10

canvasWidth = 400 - margin.left - margin.right
canvasHeight = 400 - margin.top - margin.bottom

### create shifted SVG element ###
svg = d3.select("body")
    .append("svg")
    .attr("width", canvasWidth + margin.left + margin.right)
    .attr("height", canvasHeight + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(#{margin.left}, #{margin.top})")

dataset = [5, 10, 20, 45, 6, 25]

color = d3.scale.category10()

pie = d3.layout.pie()

outerRadius = canvasWidth / 2
innerRadius = 0
# innerRadius = canvasWidth / 7

arc = d3.svg.arc()
    .innerRadius(innerRadius)
    .outerRadius(outerRadius)

arcs = svg.selectAll("g.arc")
    .data(pie(dataset))
    .enter()
    .append("g")
    .attr("class", "arc")
    .attr("transform", "translate(#{outerRadius}, #{outerRadius})")

arcs.append("path")
    .attr("fill", (d, i) -> color(i))
    .attr("d", arc)

arcs.append("text")
    .attr("transform", (d) -> "translate(#{arc.centroid(d)})")
    .attr(
        "text-anchor": "middle",
        "font-family": "sans-serif",
        "font-size": "12px",
        "fill": "white"
    )
    .text((d) -> d.value)