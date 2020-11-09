<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/resource/js/jquery.js"></script>
<script src="${pageContext.request.contextPath}/resource/js/write.js"></script>

<link href="${pageContext.request.contextPath}/resource/css/bbs.css" rel="stylesheet" type="text/css">
<link  href="${pageContext.request.contextPath}/resource/css/bootstrap.css" rel="stylesheet">
</head>
<body>

<!-- <form action="http://localhost:8080/test.mon" method="post"> -->

<div class="cscenter">
	<div class="sub_visual">
		<img alt="dd_img" src="<%=request.getContextPath()%>/img/sub_visual_cscenter.jpg" width="100%" height="100%" >
		<p class="img_txt">안녕하세요 고객님.<br>갤러리360 고객센터 입니다.</p>
	</div>
	
	<div class="sub_wrap">	
		<h2>공지 게시판</h2>
		<div class="notice">
			<br>
			제목 : <input type="text" name="title" id="title">
			<br><br>
			내용 : <textarea rows="5" cols="22" name="contents" id="contents"></textarea>
			<!-- <input type="submit" value="저장"> -->
			<br><br>
			<button onclick="save()" >저장</button>
		
		</div>
		
		<a href="bbs.jsp" class="btn">목록</a>
	</div>


</div>

</body>
</html>