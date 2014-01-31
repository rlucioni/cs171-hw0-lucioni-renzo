margin = 
    top:    20, 
    right:  20, 
    bottom: 20, 
    left:   30
canvasWidth = 500 - margin.left - margin.right
canvasHeight = 300 - margin.top - margin.bottom

svg = d3.select("body")
    .append("svg")
    .attr("width", canvasWidth + margin.left + margin.right)
    .attr("height", canvasHeight + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(#{margin.left}, #{margin.top})")

svg.append("clipPath")
    .attr("id", "chart-area")
    .append("rect")
    .attr(
        x: 0,
        y: 0,
        width: canvasWidth,
        height: canvasHeight
    )

dataset = []
numDataPoints = 50
maxRange = Math.random() * 1000
i = 0
while i < numDataPoints
    newNumber1 = Math.floor(Math.random() * maxRange)
    newNumber2 = Math.floor(Math.random() * maxRange)
    dataset.push([newNumber1, newNumber2])
    i += 1

# d3.max(dataset, (d) -> d[0])

# padding = 30;

xScale = d3.scale.linear()
    .domain([0, d3.max(dataset, (d) -> d[0])])
    .range([0, canvasWidth])

yScale = d3.scale.linear()
    .domain([0, d3.max(dataset, (d) -> d[1])])
    .range([canvasHeight, 0])

xAxis = d3.svg.axis()
    .scale(xScale)
    .orient("bottom")
    .ticks(5)
    # .tickFormat(d3.format(".1%"))

yAxis = d3.svg.axis()
    .scale(yScale)
    .orient("left")
    .ticks(5)

svg.append("g")
    .attr(
        id: "circles",
        "clip-path": "url(#chart-area)"
    )
    .selectAll("circle")
    .data(dataset)
    .enter()
    .append("circle")
    .attr(
        cx: (d) -> xScale(d[0]),
        cy: (d) -> yScale(d[1]),
        # r: (d) -> rScale(d[1]),
        r: 2
    )

# svg.selectAll("text")
#     .data(dataset)
#     .enter()
#     .append("text")
#     .text((d) -> "#{d[0]}, #{d[1]}"
#     .attr({
#         x: (d) -> xScale(d[0]),
#         y: (d) -> yScale(d[1]),
#         "font-family": "sans-serif",
#         "font-size": "11px",
#         "fill": "#7ec97e"
#     )

svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0, #{canvasHeight})")
    .call(xAxis)

svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)

d3.select("p")
    .on("click", () ->
        numValues = dataset.length
        maxRange = Math.random() * 1000
        dataset = []
        i = 0
        while i < numValues
            newNumber1 = Math.floor(Math.random() * maxRange)
            newNumber2 = Math.floor(Math.random() * maxRange)
            dataset.push([newNumber1, newNumber2])
            i += 1

        xScale.domain([0, d3.max(dataset, (d) -> d[0])])
        yScale.domain([0, d3.max(dataset, (d) -> d[1])])

        svg.selectAll("circle")
            .data(dataset)
            .transition()
            # .delay((d, i) -> i/dataset.length * 1000)
            .duration(1000)
            .each("start", () ->
                d3.select(this)
                    .attr(
                        fill: "orange",
                        r: 4
                    )
            )
            .attr(
                cx: (d) -> xScale(d[0]),
                cy: (d) -> yScale(d[1])
            )
            .transition()
            .duration(1000)
            .attr(
                fill: "black",
                r: 2
            )
            # .each("end", () ->
            #     d3.select(this)
            #         .transition()
            #         .duration(1000)
            #         .attr({
            #             fill: "black",
            #             r: 2
            #         )
            # )

        svg.select(".x.axis")
            .transition()
            .duration(1000)
            .call(xAxis)

        svg.select(".y.axis")
            .transition()
            .duration(1000)
            .call(yAxis)
    )