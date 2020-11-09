<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="/resource/js/jquery.js"></script>

<style type="text/css">
	/* .light{
		color: blue;
	} */
	.light_1{
		color: aqua;
	}
	.light_2{
		color: gray;
	}
	.light_3{
		color: green;
	}
	.light_0{
		color: orange;
	}
</style>
</head>
<body>

<h1>11</h1>
<h1>22</h1>
<h1>33</h1>
<h1>44</h1>


<script type="text/javascript">

 $().ready(function(){
	//$('h1').addClass('light');
	$('h1').each(function(index,item){
		//$(this)==$(item)
		$(item).addClass('light_'+index);
	});
}); 

</script>

</body>
</html>