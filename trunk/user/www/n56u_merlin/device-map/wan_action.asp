<!DOCTYPE html>
<html>
<head>
<title></title>
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

var restart_time = 3;

function restart_needed_time(second){
	restart_time = second;
}

function Callback(){
	parent.showLoading(restart_time);
	setTimeout("document.redirectForm.submit();", restart_time*1000);
}

</script>
</head>

<body onLoad="Callback();">
<div class="merlin-flow-wrap">
	<table border="0" cellpadding="5" cellspacing="0" class="FormTitle">
		<thead><tr><td><#Web_Title#></td></tr></thead>
		<tbody><tr><td class="merlin-flow-body">
			<h1 class="merlin-flow-title"><#Main_alert_proceeding_desc1#></h1>
			<div class="merlin-flow-desc"><#Main_alert_proceeding_desc4#></div>
		</td></tr></tbody>
	</table>
</div>
<% wan_action(); %>

<form method="post" name="redirectForm" action="/" target="_parent">
<input type="hidden" name="flag" value="Internet">
</form>
</body>
</html>
