<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/resource/js/jquery.js"></script>
<link  href="${pageContext.request.contextPath}/resource/css/bootstrap.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/resource/css/bbs.css" rel="stylesheet" type="text/css">
</head>
<body>
	<% 
		request.setCharacterEncoding("UTF-8");
		String id = (String) request.getParameter("id");
	%>
<div class="cscenter">
	<div class="sub_visual">
		<img alt="dd_img" src="<%=request.getContextPath()%>/img/sub_visual_cscenter.jpg" width="100%" height="100%" >
		<p class="img_txt">안녕하세요 고객님.<br>갤러리360 고객센터 입니다.</p>
	</div>
	
	<div class="sub_wrap">	
		<h2>공지 게시판</h2>
		
		<div class="notice">
			<!-- //내용출력 -->
		</div>
		
		<br>
		<a href="bbs.jsp" class="btn">목록</a>
		<div onclick="delete11()" class="btn">삭제</div>
		<div onclick="update11()" class="btn">수정</div>
		
	</div>


</div>

<script type="text/javascript">

	//parameter값 javascript로 받기
	function getParameterByName(name) {
	    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
	        results = regex.exec(location.search);
	    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	}

	
	var key = getParameterByName("id");
	var url;
	var data= JSON.stringify({ // JSON.stringify : json 객체를 String 객체로 변환
		"key" : key
	})
	
	//수정
	function update11(){

		window.location.href = "/update.jsp?id="+key;
		
		
	}
	
	//삭제
	function delete11(){
		var result = confirm("정말 삭제하시겠습니까?");
		if(result){

			url = "/delete11.mon";
			
			$.ajax({
				type: "POST",
				dataType: "json",
				contentType: "application/json; charset=utf-8",
				data: data,
				url: url,
				success: function(res){
					if(res.result == "OK"){
						alert("삭제가 완료되었습니다.")
						location.href = "/bbs.jsp";
					}
				},
				error: function(e){
					alert("ERROR : "+e);
				}
			}); 
			
		}
	}//function delete11 끝
	
	
	//내용출력
	$().ready(function(){
		url="/load.mon";		
		
		$.ajax({
			type: "POST",
			dataType: "json",
			contentType: "application/json; charset=utf-8",	
			data: data,
			url: url,
			success: function(res){
		
				var html ="";
				html+= "<br>";
				html+= "제목 : <span id=\"title\">"+res.title+"</span>";
				html+= "<br><br>";
				html+= "날짜 : <span id=\"date\">"+res.date+"</span>";
				html+= "<br><br>";
				html+= "내용 : <span id=\"contents\">"+res.contents+"</span>";
				html+= "<br><br>";

				$(".notice").html(html); 
			},
			error: function(e){
				alert("ERROR(view) : "+ e);
			}
				
		});
	});


	
</script>

</body>
</html>