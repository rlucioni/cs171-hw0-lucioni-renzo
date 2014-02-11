### Mike Bostock's margin convention ###
margin = 
    top:    10, 
    right:  10, 
    bottom: 10, 
    left:   10

canvasWidth = 500 - margin.left - margin.right
canvasHeight = 300 - margin.top - margin.bottom

### create shifted SVG element ###
svg = d3.select("body")
    .append("svg")
    .attr("width", canvasWidth + margin.left + margin.right)
    .attr("height", canvasHeight + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(#{margin.left}, #{margin.top})")

dataset = [
    [
        { x: 0, y: 5 },
        { x: 1, y: 4 },
        { x: 2, y: 2 },
        { x: 3, y: 7 },
        { x: 4, y: 23 }
    ],
    [
        { x: 0, y: 10 },
        { x: 1, y: 12 },
        { x: 2, y: 19 },
        { x: 3, y: 23 },
        { x: 4, y: 17 }
    ],
    [
        { x: 0, y: 22 },
        { x: 1, y: 28 },
        { x: 2, y: 32 },
        { x: 3, y: 35 },
        { x: 4, y: 43 }
    ]
]

stack = d3.layout.stack()
stack(dataset)

colors = d3.scale.category10()

xScale = d3.scale.ordinal()
    .domain(d3.range(dataset[0].length))
    .rangeRoundBands([0, canvasWidth], 0.05)

yScale = d3.scale.linear()
    .domain([0, d3.max(dataset, (d) -> d3.max(d, (d) -> d.y0 + d.y))])
    .range([0, canvasHeight])

groups = svg.selectAll("g")
    .data(dataset)
    .enter()
    .append("g")
    .style("fill", (d, i) -> colors(i))

rects = groups.selectAll("rect")
    .data((d) -> d)
    .enter()
    .append("rect")
    .attr(
        x: (d, i) -> xScale(i),
        # y: (d) -> canvasHeight - yScale(d.y0),
        y: (d) -> yScale(d.y0),
        height: (d) -> yScale(d.y),
        width: xScale.rangeBand()
    )
