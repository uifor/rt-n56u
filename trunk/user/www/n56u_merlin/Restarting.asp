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
var action_mode = '<% get_parameter("action_mode"); %>';
var boot_time = parent.board_boot_time();

function redirect(){
	setTimeout("redirect1();", (boot_time+2)*1000);
}

function redirect1(){
	if(action_mode == " RestoreNVRAM ")
		parent.location.href = "http://192.168.2.1/";
	else
		parent.location.href = "/";
}
</script>
</head>
<body onLoad="redirect();">
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
					<h1 class="merlin-flow-title"><#Main_alert_proceeding_desc1#></h1>
					<div class="merlin-flow-desc"><#Main_alert_proceeding_desc4#></div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<script>
	parent.hideLoading();
	parent.showLoading(boot_time, "waiting");
</script>
</body>
</html>
