margin = 
    top:    10, 
    right:  10, 
    bottom: 10, 
    left:   10
canvasWidth = 600 - margin.left - margin.right
canvasHeight = 250 - margin.top - margin.bottom

svg = d3.select("body")
    .append("svg")
    .attr("width", canvasWidth + margin.left + margin.right)
    .attr("height", canvasHeight + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(#{margin.left}, #{margin.top})")

dataset = [ 
    { key: 0,  value: 5 }, 
    { key: 1,  value: 10 }, 
    { key: 2,  value: 13 }, 
    { key: 3,  value: 19 }, 
    { key: 4,  value: 21 }, 
    { key: 5,  value: 25 }, 
    { key: 6,  value: 22 }, 
    { key: 7,  value: 18 }, 
    { key: 8,  value: 15 }, 
    { key: 9,  value: 13 },
    { key: 10, value: 11 },
    { key: 11, value: 12 },
    { key: 12, value: 15 },
    { key: 13, value: 20 },
    { key: 14, value: 18 },
    { key: 15, value: 17 },
    { key: 16, value: 16 },
    { key: 17, value: 18 },
    { key: 18, value: 23 },
    { key: 19, value: 25 } 
];

key = (d) -> d.key

xScale = d3.scale.ordinal()
    .domain(d3.range(dataset.length))
    .rangeRoundBands([0, canvasWidth], 0.05)

yScale = d3.scale.linear()
    .domain([0, d3.max(dataset, (d) -> d.value)])
    .range([0, canvasHeight])

svg.selectAll("rect")
    .data(dataset, key)
    .enter()
    .append("rect")
    .attr(
        x: (d, i) -> xScale(i),
        y: (d) -> canvasHeight - yScale(d.value)
        width: xScale.rangeBand(),
        height: (d) -> yScale(d.value),
        fill: (d) -> "rgb(127, 201, #{d.value * 10})"
    )

svg.selectAll("text")
    .data(dataset, key)
    .enter()
    .append("text")
    .text((d) -> d.value)
    .attr(
        x: (d, i) -> xScale(i) + xScale.rangeBand() / 2,
        y: (d) -> canvasHeight - yScale(d.value) + 14,
        "font-family": "sans-serif",
        "font-size": "11px",
        fill: "white",
        "text-anchor": "middle"
    )

d3.selectAll("p")
    .on("click", () ->
        paragraphID = d3.select(this).attr("id")

        if paragraphID == "randomize"
            numValues = dataset.length
            maxValue = 50
            i = 0
            
            while i < numValues
                newNumber = Math.floor(Math.random() * maxValue)

                if newNumber < Math.round(maxValue/15)
                    newNumber = Math.round(maxValue/15)

                dataset[i].value = newNumber
                i += 1

        else if paragraphID == "add"
            maxValue = 25
            newNumber = Math.floor(Math.random() * maxValue)
            highKey = dataset[dataset.length - 1].key
            dataset.push({key: highKey + 1, value: newNumber})

        else if paragraphID == "remove"
            dataset.shift()

        xScale.domain(d3.range(dataset.length))
        yScale.domain([0, d3.max(dataset, (d) -> d.value)])

        bars = svg.selectAll("rect")
            .data(dataset, key)

        labels = svg.selectAll("text")
            .data(dataset, key)

        bars.enter()
            .append("rect")
            .attr(
                x: canvasWidth + xScale.rangeBand() / 2,
                y: (d) -> canvasHeight - yScale(d.value)
                width: xScale.rangeBand(),
                height: (d) -> yScale(d.value)
                fill: (d) -> "rgb(127, 201, #{d.value * 10})"
            )

        labels.enter()
            .append("text")
            .text((d) -> d.value)
            .attr(
                x: canvasWidth + xScale.rangeBand() / 2,
                y: (d) -> canvasHeight - yScale(d.value) + 14,
                "font-family": "sans-serif",
                "font-size": "11px",
                fill: "white",
                "text-anchor": "middle"
            )

        bars.transition()
            .duration(500)
            .attr(
                x: (d, i) -> xScale(i),
                y: (d) -> canvasHeight - yScale(d.value),
                width: xScale.rangeBand(),
                height: (d) -> yScale(d.value)
            )

        labels.transition()
            .duration(500)
            .text((d) -> d.value)
            .attr(
                x: (d, i) -> xScale(i) + xScale.rangeBand() / 2,
                y: (d) -> canvasHeight - yScale(d.value) + 14
            )

        bars.exit()
            .transition()
            .duration(500)
            .attr("x", -xScale.rangeBand() - xScale.rangeBand() / 2)
            .remove()

        labels.exit()
            .transition()
            .duration(500)
            .attr("x", -xScale.rangeBand() - xScale.rangeBand() / 2)
            .remove()
    )