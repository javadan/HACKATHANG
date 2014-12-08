<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF8">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no"/>
    <meta charset="UTF8">


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
        Please choose an XLS or XLSX file to upload.  
        The first column should be an ID column, and it must have headers, and a Longitude, Latitude, and Data column.<br/>
        You will be able to select these columns in the next step.
	<form method="POST" enctype="multipart/form-data" accept-charset=utf-8
		action="${pageContext.request.contextPath}/upload">
		File to upload: <input type="file" name="file"><br />  
                <input type="submit" value="Upload"> Press here to upload the file!
	</form>
    </div>

    <div id="longitude" class="slider"></div>
    <div id="latitude" class="slider"></div>
    <div id="datatude" class="slider"></div>

    <div id="data"></div>


    <div id="map"></div>

    

			


    <script type="text/javascript">

    $(document).ready(function(){
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

        var exceldata = JSON.parse(${exceljson});

        $("#data").flexAddData(exceldata);
    });

    </script>




  </body>

</html>
