<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="/resource/js/jquery.js"></script>
<link  href="/resource/css/bootstrap.css" rel="stylesheet">
<link href="/resource/css/bbs.css" rel="stylesheet" type="text/css">
</head>
<body>

	<% 
		request.setCharacterEncoding("UTF-8");
		String title = (String) request.getParameter("title");
		String contents = (String) request.getParameter("contents");
		String date = (String) request.getParameter("date");
	%>
	
<!-- <form action="http://localhost:8080/test.mon" method="post"> -->

<div class="cscenter">
	<div class="sub_visual">
		<img alt="dd_img" src="<%=request.getContextPath()%>/img/sub_visual_cscenter.jpg" width="100%" height="100%" >
		<p class="img_txt">안녕하세요 고객님.<br>갤러리360 고객센터 입니다.</p>
	</div>
	
	<div class="sub_wrap">	
		<h2>공지 게시판</h2>
		<div class="notice">
<!-- _id값 hidden? -->
 			<br>
			제목 : <span id="title"><%=title %></span>
			<br><br>
			날짜 : <span id="date"><%=date %></span>			
			<br><br>
			내용 : <div id="contents"><%=contents %></div>
			<!-- <input type="submit" value="저장"> -->
			<br><br> 
		</div>
		
		<br>
		<a href="bbs.jsp" class="btn">목록</a>
		<div onclick="delete11()" class="btn">삭제</div>
	</div>


</div>

<script type="text/javascript">
	var title = <%=title %>;
	alert(title);
	
	
	function delete11(){
		
	}
</script>

</body>
</html>