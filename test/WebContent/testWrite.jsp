<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="${pageContext.request.contextPath}/resource/js/jquery.js"></script>
<!-- dropzone.js -->
<script src="${pageContext.request.contextPath}/resource/dropzone/dropzone.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/dropzone/dropzone.min.css" />

<title>Insert title here</title>
</head>
<body>
<div onclick="aa();">test</div>
<script type="text/javascript">
	function aa(){
		
		for(var i=1; i<=100; i++){
			
		    var title = "test"+i;
			var content = "test"+i;
			
			//alert(title+" "+content);
			
			var url = "/insert.mon";
			
				//post타입일 경우 사용 (json 타입으로 바꾸기)
				var data = JSON.stringify({
					"title" : title,
					"content" : content
				});
				
				$.ajax({
					type : "POST",
					dataType : "json",
					contentType : "application/json; charset=utf-8",
					data : data,
					url : url,
					success : function(res){
						//debugger;
						if (res.result == "OK"){
							//alert("정상적으로 저장되었습니다.");
							location.href = "/";
						}else{
							alert("저장 에러");
						}
					},
					error : function(e){
						alert("ERROR!(write) : " + e);
					}
				})
				
			
			
		}
	}
</script>
</body>
</html>