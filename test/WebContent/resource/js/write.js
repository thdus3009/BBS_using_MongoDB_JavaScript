
//post
function save(){
	
	var title = $("#title").val();
	var content = $("#contents").val();
	
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
				alert("정상적으로 저장되었습니다.");
				location.href = "/bbs.jsp";
			}else{
				alert("저장 에러");
			}
		},
		error : function(e){
			alert("ERROR!(write) : " + e);
		}
	})
	
}
