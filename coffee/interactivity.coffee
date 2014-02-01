### Mike Bostock's margin convention ###
margin = 
    top:    10, 
    right:  10, 
    bottom: 10, 
    left:   10

canvasWidth = 600 - margin.left - margin.right
canvasHeight = 250 - margin.top - margin.bottom

### create shifted SVG element ###
svg = d3.select("body")
    .append("svg")
    .attr("width", canvasWidth + margin.left + margin.right)
    .attr("height", canvasHeight + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(#{margin.left}, #{margin.top})")

dataset = [
    5, 
    10, 
    13, 
    19, 
    21, 
    25, 
    22, 
    18, 
    15, 
    13, 
    11, 
    12, 
    15, 
    20, 
    18, 
    17, 
    16, 
    18, 
    23, 
    25
]

xScale = d3.scale.ordinal()
    .domain(d3.range(dataset.length))
    .rangeRoundBands([0, canvasWidth], 0.05)

yScale = d3.scale.linear()
    .domain([0, d3.max(dataset)])
    .range([0, canvasHeight])

### create bars ###
svg.selectAll("rect")
    .data(dataset)
    .enter()
    .append("rect")
    .attr(
        "x": (d, i) -> xScale(i),
        "y": (d) -> canvasHeight - yScale(d),
        "width": xScale.rangeBand(),
        "height": (d) -> yScale(d),
        fill: (d) -> "rgb(127, 201, #{d * 10})"
    )
    # # SVG element tooltip
    .on("mouseover", (d) ->
        xPosition = parseFloat(d3.select(this).attr("x")) + xScale.rangeBand() / 2
        yPosition = parseFloat(d3.select(this).attr("y")) / 2 + canvasHeight / 2

        # svg.append("text")
        #     .attr(
        #         id: "tooltip",
        #         x: xPosition,
        #         y: yPosition,
        #         "text-anchor": "middle",
        #         "font-family": "sans-serif",
        #         "font-size": "11px",
        #         "font-weight": "bold",
        #         fill: "black"
        #     )
        #     .text(d)

        d3.select("#tooltip")
            .style("left", xPosition + "px")
            .style("top", yPosition + "px")
            .select("#value")
            .text(d)

        d3.select("#tooltip").classed("hidden", false)
    )
    .on("mouseout", () -> d3.select("#tooltip").classed("hidden", true))
    # .on("mouseover", () -> 
    #     d3.select(this)
    #         .attr("fill", "orange")
    # )
    # # silky-smooth orange fade-out
    # .on("mouseout", (d) -> 
    #     d3.select(this)
    #         .transition()
    #         .duration(250)
    #         .attr("fill", "rgb(127, 201, #{d * 10})")
    # )
    .on("click", () -> 
        sortBars()
    )
    # ugly tooltip
    # .append("title")
    # .text((d) -> "Value is #{d}")

### create labels ###
svg.selectAll("text")
    .data(dataset)
    .enter()
    .append("text")
    .text((d) -> d)
    # .style("pointer-events", "none")
    .attr(
        x: (d, i) -> xScale(i) + xScale.rangeBand() / 2,
        y: (d) -> canvasHeight - yScale(d) + 14,
        "font-family": "sans-serif",
        "font-size": "11px",
        fill: "white",
        "text-anchor": "middle"
    )

sortOrder = false

sortBars = () ->
    sortOrder = !sortOrder

    svg.selectAll("rect")
        .sort((a, b) -> 
            if sortOrder
                d3.ascending(a, b)
            else
                d3.descending(a, b)
        )
        .transition()
        .delay((d, i) -> i * 50)
        .duration(1000)
        .attr("x", (d, i) -> xScale(i))

    svg.selectAll("text")
        .sort((a, b) -> 
            if sortOrder
                d3.ascending(a, b)
            else
                d3.descending(a, b)
        )
        .transition()
        .delay((d, i) -> i * 50)
        .duration(1000)
        .attr("x", (d, i) -> xScale(i) + xScale.rangeBand() / 2)
