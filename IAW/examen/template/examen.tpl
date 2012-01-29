<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>{titulo}</title>
<style type="text/css">
	html, body {
		margin: 15px 15px 15px 15px;
		font-size: 12px;
		font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
		background-color: #CCC;
		color: #000;
		padding: 15px 15px 15px 15px;
	}
	.cabecera {
		text-align: center;
		margin-bottom: 50px;	
	}
	.errors {
		width: auto;
		border: 4px solid #F00;
		color: #000;
		background-color: #0F0;
		padding: 10px 10px 10px 10px;
		margin: 15px 15px 15px 15px;
		font-size: 18px;
	}
	.contenido {
		width: auto;
		height: auto;
		border: 4px solid #000;
		background-color: #9CF;
		padding: 5px 25px 15px 25px;
		margin-bottom: 50px;
	}
	.pie {
		width: 50%;
		margin: 0 auto;
		height: auto;
		border: 1px solid #000;
		background-color: #9CF;
		padding: 5px 5px 5px 5px;
		text-align: center;
	}
	form {
		width: auto;
		border: 2px dotted #000;
		padding: 15px 15px 15px 15px;
	}
	label {
		font-weight: bold;
		margin-right: 15px;
	}
	input {
		padding: 5px 5px 5px 5px;
		min-width: 120px;
	}
	input[type=text] {
		width: 200px;	
	}
	table {
		border: 2px dotted #999;	
	}
	table td {
		border: 1px solid #000;
		padding: 5px 5px 5px 5px;	
	}
	pre {
		width: auto;
		border: 2px solid #000;
		color: #CCC;
		background-color: #069; 	
		padding: 10px 10px 10px 10px;
	}
	{css}
</style>
</head>
<body>
<div class="cabecera">
	<h1>{titulo}</h1>
    {subtitulo}
</div>
{errors}
<div class="contenido">
	{contenido}
    {code}
    {request}
</div>
<div class="pie">
	{pie}
</div>
</body>
</html>