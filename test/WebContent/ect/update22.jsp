<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="/resource/js/jquery.js"></script>
<script src="/resource/js/write.js"></script>

<link href="/resource/css/bbs.css" rel="stylesheet" type="text/css">
<link  href="/resource/css/bootstrap.css" rel="stylesheet">
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
			날짜 : <input type="text" name="date" id="date" readonly="readonly">
			<br><br>
			내용 : <textarea rows="5" cols="22" name="contents" id="contents"></textarea>
			<!-- <input type="submit" value="저장"> -->
			<br><br>
			<button onclick="save()" >저장</button>
		
		</div>
		
		<a href="bbs.jsp" class="btn">목록</a>
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
	
	$().ready(function(){
		var url = "/load.mon";
		var data= JSON.stringify({ // JSON.stringify : json 객체를 String 객체로 변환
			"key" : key
		})
		
		$.ajax({
			type: "POST",
			dataType: "json",
			contentType: "application/json; charset=utf-8",	
			data: data,
			url: url,
			success: function(res){
		
		 		$('#title').val(res.title);
				$('#date').val(res.date);
				$('#contents').val(res.contents);			
 
			},
			error: function(e){
				alert("ERROR(update) : "+ e);
			}
				
		});
		
	});
	
	function save(){
		//alert("확인: "+key);
		var title = $("#title").val();
		var contents = $("#contents").val();
	
		//alert("title: "+title+" content: "+contents);
		
 		var url = "/update11.mon";
		var data = JSON.stringify({
			"key" : key,	
			"title" : title,
			"contents" : contents
		}) 
		
		$.ajax({
			type: "POST",
			dataType: "json",
			contentType: "application/json; charset=utf-8",
			data: data,
			url: url,
			success: function(res){
				if (res.result == "OK"){
					alert("수정이 완료되었습니다.");
					location.href = "/view.jsp?id="+key;
				}else{
					alert("저장 에러");
				}
			},
			error: function(e){
				alert("ERROR : "+e);
			}
		});  
	}

</script>

</body>
</html>