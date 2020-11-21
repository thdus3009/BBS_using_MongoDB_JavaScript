<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="${pageContext.request.contextPath}/resource/js/jquery.js"></script>
<title>Insert title here</title>
</head>
<body>

<input type="text" id="asd" value="테스트">
<button onclick="reply()">등록</button>

	<input type="text" id="id1"/>
	<input type="file" id="file1"/>
	<button onclick="aa()">클릭</button>


<script type="text/javascript">

	function reply(){
		
	}
	
	function aa() {
		var id = $("#id1").val();
		var file = $("#file1").val();

		//alert("title: "+title+" content: "+contents);
		
		var url = "/test.mon";
		var data = JSON.stringify({
			"id" : id,	
			"file" : file,
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
					//location.href = "/view.jsp?id="+key;
					location.href = "/";
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