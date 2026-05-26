<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/index_style.css">
<link rel="stylesheet" type="text/css" href="/form_style.css">
<link rel="stylesheet" type="text/css" href="/other.css">
<link rel="stylesheet" type="text/css" href="/merlin_flow.css">
<script>
function initial(){
	var xmlhttp;
	try{
		if (window.XMLHttpRequest)
			xmlhttp=new XMLHttpRequest();
		else
			xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}catch (e){
		xmlhttp=null;
	}
	if (xmlhttp != null){
		xmlhttp.open("HEAD","logout",true,"logout","");
		xmlhttp.send(null);
	}
}
</script>
</head>
<body onload="initial()">
<div class="merlin-flow-wrap">
	<table border="0" cellpadding="5" cellspacing="0" class="FormTitle">
		<thead>
			<tr>
				<td><#Web_Title#></td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="merlin-flow-body">
					<h1 class="merlin-flow-title"><#logoutmessage#></h1>
					<div class="merlin-flow-desc"><#Not_authpage_login_again#></div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</body>
</html>
