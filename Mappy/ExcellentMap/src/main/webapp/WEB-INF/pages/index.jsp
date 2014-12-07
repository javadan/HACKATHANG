<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF8">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no"/>
    <meta charset="UTF8">

    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>

    <script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/resources/js/d3.js"></script>
    <script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/resources/js/d3.slider.js"></script>
    <script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/resources/js/jquery-2.1.1.js"></script>
    <script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/resources/js/jquery.browser.js"></script>
    <script type="text/javascript" charset="utf-8" src="${pageContext.request.contextPath}/resources/js/flexigrid.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/d3.slider.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/flexigrid.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/web.css" />
  </head>

  <body>
    <div id="fileuploadform">
        Please choose an XLS or XLSX file to upload.  It must have a Longitude, Latitude, and Data column.
	<form method="POST" enctype="multipart/form-data"
		action="${pageContext.request.contextPath}/upload">
		File to upload: <input type="file" name="file"><br />  <input type="submit"
			value="Upload"> Press here to upload the file!
	</form>
    </div>

    <div id="longitude" class="slider"></div>
    <div id="latitude" class="slider"></div>
    <div id="datatude" class="slider"></div>

    <div id="data"></div>


    <div id="map"></div>


			


    <script type="text/javascript">
    // Create the Google Map�
    var map = new google.maps.Map(d3.select("#map").node(), {
      zoom: 8,
      center: new google.maps.LatLng(37.76487, -122.41948),
      mapTypeId: google.maps.MapTypeId.TERRAIN
    });

    // Load the station data. When the data comes back, create an overlay.
    d3.json("${pageContext.request.contextPath}/resources/data/data.json", function(data) {
      var overlay = new google.maps.OverlayView();

      // Add the container when the overlay is added to the map.
      overlay.onAdd = function() {
        var layer = d3.select(this.getPanes().overlayLayer).append("div")
            .attr("class", "stations");

        // Draw each marker as a separate SVG element.
        // We could use a single SVG, but what size would it have?
        overlay.draw = function() {
          var projection = this.getProjection(),
              padding = 15;

          var marker = layer.selectAll("svg")
              .data(d3.entries(data))
              .each(transform) // update existing markers
            .enter().append("svg:svg")
              .each(transform)
              .attr("class", "marker");

          // Add a circle.
          marker.append("svg:circle")
              .attr("cx", padding)
              .attr("cy", padding)
              .attr("r", function(d) { return (10 * d.value["score"]); });

          // Add a label.
          marker.append("svg:text")
              .attr("x", padding + 15)
              .attr("y", padding)
              .attr("dy", ".31em")
              .text(function(d) { return d.value["name"]; });

          function transform(d) {
            d = new google.maps.LatLng(d.value["lat"], d.value["lng"]);
            d = projection.fromLatLngToDivPixel(d);
            return d3.select(this)
                .style("left", (d.x - padding) + "px")
                .style("top", (d.y - padding) + "px");
          }
        };
      };

      // Bind our overlay to the map�
      overlay.setMap(map);
    });

    d3.select('#longitude').call(
      d3.slider("er").axis(d3.svg.axis().ticks(6))
    );

    d3.select('#latitude').call(
      d3.slider().axis(d3.svg.axis().ticks(6))
    );

    d3.select('#datatude').call(
      d3.slider().axis(d3.svg.axis().ticks(6))
    );

    d3.select('#longitude .d3-slider-handle').text("longitude");
    d3.select('#latitude .d3-slider-handle').text("latitude");
    d3.select('#datatude .d3-slider-handle').text("data");

    // // map sqrt-rooted population ( 0 ~ 5000 ) into circle radius ( 0 ~ 70px )
    // radiusMap = d3.scale.linear()
    // .domain([0,5000])
    // .range([0,70]);


    // d3.json("data/data.json", function(data) {

    // // create circles
    // dorling = d3.select("svg#map").selectAll("circle").data(data).enter()
    // .append("circle")
    // .each(function(it) {
    // // use sqrt root to correct map value into area
    // it.r = radiusMap(Math.sqrt(it.score));
    // it.properties.c = path.centroid(it);
    // it.properties.x = 400;
    // it.properties.y = 300;
    // })
    // .attr("cx",function(it) { return it.xx + it.c[0] - 400; })
    // .attr("cy",function(it) { return it.yy + it.c[1] - 300; })
    // .attr("r", function(it) { return it.r;})


    // }
    // );
    // $("#data").flexigrid({
    //   url: 'data/griddata.json',
    //   dataType: 'json',
    //   colModel : [
    //     {display: 'Longitude', name : 'lng', width : 140, sortable : true, align: 'center'},
    //     {display: 'Latitude', name : 'lat', width : 140, sortable : true, align: 'left'},
    //     {display: 'Data stuff', name : 'name', width : 140, sortable : true, align: 'left'}
    //     ],
    //   title: 'Yourexcelfile',
    //   useRp: true,
    //   rp: 15,
    //   showTableToggleBtn: true,
    //   width: 700,
    //   height: 200
    // });
    $("#data").flexigrid({
      url: 'data/griddata.json',
      dataType: 'json',
      colModel : [
        {display: 'ISO', name : 'iso', width : 40, sortable : true, align: 'center'},
        {display: 'Name', name : 'name', width : 180, sortable : true, align: 'left'},
        {display: 'Printable Name', name : 'printable_name', width : 120, sortable : true, align: 'left'},
        {display: 'ISO3', name : 'iso3', width : 130, sortable : true, align: 'left', hide: true},
        {display: 'Number Code', name : 'numcode', width : 80, sortable : true, align: 'right'}
        ],
      searchitems : [
        {display: 'ISO', name : 'iso'},
        {display: 'Name', name : 'name', isdefault: true}
        ],
      sortname: "iso",
      sortorder: "asc",
      usepager: true,
      title: 'Countries',
      useRp: true,
      rp: 15,
      showTableToggleBtn: true,
      width: 700,
      height: 200
    });
    </script>




  </body>

</html>
