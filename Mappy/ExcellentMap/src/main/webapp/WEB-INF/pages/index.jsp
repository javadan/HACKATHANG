<html>
<body>
<h1>Maven + Spring MVC Web Project Example</h1>
 
<h3>Message : ${message}</h3>
<h3>Counter : ${counter}</h3>	


	<form method="POST" enctype="multipart/form-data"
		action="/MapApp/upload">
		File to upload: <input type="file" name="file"><br /> Name: <input
			type="text" name="name"><br /> <br /> <input type="submit"
			value="Upload"> Press here to upload the file!
	</form>

</body>
</html>