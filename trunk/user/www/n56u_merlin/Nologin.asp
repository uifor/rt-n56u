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

<style type="text/css">
#logined_ip_str {
	color: #ffcc00;
}
</style>

<script>
<% login_state_hook(); %>

function initial(){
  document.getElementById("logined_ip_str").innerHTML = login_ip_str();
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
					<h1 class="merlin-flow-title"><#Web_Title#></h1>
					<div class="merlin-flow-desc">
						<p><#login_hint1#> <span id="logined_ip_str"></span></p>
						<p><#login_hint2#></p>
					</div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
</body>
</html>
