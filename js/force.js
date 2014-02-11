// Generated by CoffeeScript 1.7.1

/* Mike Bostock's margin convention */
var canvasHeight, canvasWidth, colors, dataset, edges, force, margin, nodes, svg;

margin = {
  top: 10,
  right: 10,
  bottom: 10,
  left: 10
};

canvasWidth = 500 - margin.left - margin.right;

canvasHeight = 300 - margin.top - margin.bottom;


/* create shifted SVG element */

svg = d3.select("body").append("svg").attr("width", canvasWidth + margin.left + margin.right).attr("height", canvasHeight + margin.top + margin.bottom).append("g").attr("transform", "translate(" + margin.left + ", " + margin.top + ")");

dataset = {
  nodes: [
    {
      name: "Adam"
    }, {
      name: "Bob"
    }, {
      name: "Carrie"
    }, {
      name: "Donovan"
    }, {
      name: "Edward"
    }, {
      name: "Felicity"
    }, {
      name: "George"
    }, {
      name: "Hannah"
    }, {
      name: "Iris"
    }, {
      name: "Jerry"
    }
  ],
  edges: [
    {
      source: 0,
      target: 1
    }, {
      source: 0,
      target: 2
    }, {
      source: 0,
      target: 3
    }, {
      source: 0,
      target: 4
    }, {
      source: 1,
      target: 5
    }, {
      source: 2,
      target: 5
    }, {
      source: 2,
      target: 5
    }, {
      source: 3,
      target: 4
    }, {
      source: 5,
      target: 8
    }, {
      source: 5,
      target: 9
    }, {
      source: 6,
      target: 7
    }, {
      source: 7,
      target: 8
    }, {
      source: 8,
      target: 9
    }
  ]
};

force = d3.layout.force().nodes(dataset.nodes).links(dataset.edges).size([canvasWidth, canvasHeight]).linkDistance([50]).charge([-100]).start();

colors = d3.scale.ordinal().domain(d3.range(10)).range(colorbrewer.Set1[9]);

edges = svg.selectAll("line").data(dataset.edges).enter().append("line").style("stroke", "#ccc").style("stroke-width", 1);

nodes = svg.selectAll("circle").data(dataset.nodes).enter().append("circle").attr("r", 10).style("fill", function(d, i) {
  return colors(i);
}).call(force.drag);

force.on("tick", function() {
  edges.attr({
    "x1": function(d) {
      return d.source.x;
    },
    "y1": function(d) {
      return d.source.y;
    },
    "x2": function(d) {
      return d.target.x;
    },
    "y2": function(d) {
      return d.target.y;
    }
  });
  return nodes.attr({
    "cx": function(d) {
      return d.x;
    },
    "cy": function(d) {
      return d.y;
    }
  });
});