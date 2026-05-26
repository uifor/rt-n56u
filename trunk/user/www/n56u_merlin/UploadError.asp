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
</head>
<body>
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
					<h1 class="merlin-flow-title"><#SET_fail_desc#></h1>
					<div class="merlin-flow-action">
						<input type="button" class="button_gen" value="<#CTL_ok#>" onclick="history.back();">
					</div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<script>
	alert("<#SET_fail_desc#>");
</script>
</body>
</html>
