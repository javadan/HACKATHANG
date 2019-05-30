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
    <script src="http://malsup.github.com/jquery.form.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/d3.slider.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/flexigrid.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/web.css" />


    <script type="text/javascript">


        function uploadJqueryForm(){
            $('#result').html('');

           $("#form2").ajaxForm({
            success:function(datas) {
                
                if (typeof datas !== 'undefined') {

                    var jsondata2 = eval('(' + datas + ')');
   
                    $("#data").flexAddData(jsondata2);

                }

             },
             dataType:"text"
           }).submit();

        }

    </script>
  </head>

  <body>
    <div id="fileuploadform">
        Please choose an XLS or XLSX file to upload.  
        The first column should be an ID column, and it must have headers, and a Longitude, Latitude, and Data column.<br/>
        You will be able to select these columns in the next step.

        <form id="form2" method="post" action="${pageContext.request.contextPath}/upload" enctype="multipart/form-data">
          <input name="file" id="file" type="file" /><br/>
        </form>

        <button value="Submit" onclick="uploadJqueryForm()" >Upload</button><br/>

        <div id="result"></div>

    </div>

    <div id="longitude" class="slider"></div>
    <div id="latitude" class="slider"></div>
    <div id="datatude" class="slider"></div>

    <div id="data"></div>

    <div id="map"></div>

    

    <script type="text/javascript">


	
    // Create the Google Map…
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

      // Bind our overlay to the map…
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




        $("#data").flexigrid({
          dataType: 'json',
          colModel : [
            {display: 'ID', name : 'id', width : 100, sortable : true, align: 'center'},
            {display: 'Long', name : 'long', width : 100, sortable : true, align: 'left'},
            {display: 'Lat', name : 'lat', width : 100, sortable : true, align: 'left'},
            {display: 'Data', name : 'data', width : 100, sortable : true, align: 'left'}
            ],

            usepager: true,
            title: 'Excel file',
            useRp: true,
            rp: 15,
            showTableToggleBtn: true,

          width: 1000,
          height: 200
        });


    </script>


  </body>

</html>
