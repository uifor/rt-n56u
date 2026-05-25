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
<style>
.logout_shell {
	width: 520px;
	margin: 90px auto 0 auto;
	padding: 26px 32px;
	color: #FFF;
	background: #4D595D;
	border: 1px solid #6b8fa3;
	text-align: center;
}
.logout_shell h2 {
	margin: 0 0 16px 0;
	font-size: 22px;
	font-weight: normal;
}
</style>
</head>
<body onload="initial()" class="bg">
    <div class="logout_shell">
        <h2><#logoutmessage#></h2>
        <div><#Not_authpage_login_again#></div>
    </div>
</body>
</html>
