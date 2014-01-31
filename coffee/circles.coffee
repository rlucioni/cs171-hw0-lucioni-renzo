svgWidth = 500
svgHeight = 100

svg = d3.select("body")
    .append("svg")
    .attr("width", svgWidth)
    .attr("height", svgHeight)

dataset = [5, 10, 15, 20, 25]

circles = svg.selectAll("circle")
    .data(dataset)
    .enter()
    .append("circle")

circles.attr("cx", (d, i) -> (i * 50) + 25)
    .attr("cy", svgHeight/2)
    .attr("r", (d) -> d)
    .attr("fill", "green")
    .attr("stroke", "orange")
    .attr("stroke-width", (d) -> d/2)