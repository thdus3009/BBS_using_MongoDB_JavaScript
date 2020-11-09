<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/resource/js/jquery.js"></script>


<link href="${pageContext.request.contextPath}/resource/css/bbs.css" rel="stylesheet">
<link  href="${pageContext.request.contextPath}/resource/css/bootstrap.css" rel="stylesheet">
<link  href="${pageContext.request.contextPath}/resource/css/custom.css" rel="stylesheet">

<style type="text/css">
ul.mylist li{
	list-style: none;
    margin: 0px;
    padding: 0px;
    max-width: 80%;
    width: 100%;
    padding: 5px 0px 5px 5px;
    margin-bottom: 5px;
    border-bottom: 1px solid black;
    font-size: 12px;
}
</style>
</head>
<body>


<div class="cscenter">
	<div class="sub_visual">
		<img alt="dd_img" src="<%=request.getContextPath()%>/img/sub_visual_cscenter.jpg" width="100%" height="100%" >
		<p class="img_txt">안녕하세요 고객님.<br>갤러리360 고객센터 입니다.</p>
	</div>
	
	<div class="sub_wrap"><!-- css때문에 잡아놓은 div -->
		<h2>공지 게시판</h2>
		
		<!------------------ 원페이지 작동 구간 (목록) ----------------------->
		<div id="one_page_bbs">
			
			<div class="notice1">
				<table class="table-striped" style="text-align:center; border:1px solid #dddddd; width: 100%;">
					<thead>
						<tr>
							<th class="th_title">title</th>
							<th class="th_date">date</th>
						</tr>
					</thead>
					<tbody>
						<!-- loadAll.mon 자바스크립트 -->
					</tbody>
				</table>
			</div>
			
			<br>
			<div onclick="write11()" class="btn">글쓰기</div>
			<!-- <a href="write.jsp" class="btn">글쓰기</a> -->
		
			<!-- 페이지 -->
			<div id="paging"></div>		
		
		</div>
		
		<!------------------------ 선택한 글보기 -------------------------->
		<div id="one_page_view">
			<div class="notice2">
				<!-- //내용출력 -->
			</div>
			
			<br>
			<a href="/" class="btn">목록</a>
			<div onclick="delete11()" class="btn">삭제</div>
			<div onclick="update11()" class="btn">수정</div>
		</div>
		
		
		<!------------------------ 글쓰기 --------------------------------->
		<div id="one_page_write">			
			<div class="notice3">
				<br>
				제목 : <input type="text" name="title" id="title">
				<br><br>
				내용 : <textarea rows="5" cols="22" name="contents" id="contents"></textarea>
				<!-- <input type="submit" value="저장"> -->
				<br><br>
				<button onclick="write_save()" >저장</button>
			
			</div>
			
			<a href="/" class="btn">목록</a>
		</div>
		
		
		<!------------------------ 수정 --------------------------------->
		<div id="one_page_update">
			<div class="notice4">
				<br>
				제목 : <input type="text" id="up_title">
				<br><br>
				날짜 : <input type="text" id="up_date" readonly="readonly">
				<br><br>
				내용 : <textarea rows="5" cols="22" id="up_contents"></textarea>
				<!-- <input type="submit" value="저장"> -->
				<br><br>
				<button onclick="update_save()" >저장</button>
			
			</div>
			
			<a href="/" class="btn">목록</a>
		</div>

	</div>


</div>

<!-- jquery.js와 동시에 실행이 되서 아래로 빼놓았음-->
<script type="text/javascript">

$().ready(function(){
	
	
	$('#one_page_bbs').show();
	$('#one_page_write').hide();
	$('#one_page_view').hide();
	$('#one_page_update').hide();
	
	var url = "/loadAll.mon";
	$.ajax({
		type : "GET",
		dataType : "json",
		url : url,
		contentType : "application/json; charset=utf-8",
		success : function(res){
			
			var html = "";
			html += "<table>";
			
			//페이지 할 때 사용할 총 갯수
			var totalcount = res[0].totalcount;			
			
			for (var i = 1 ; i < res.length; i++){
			   var item = res[i];
			   
			   var title = item.title;
			   var date = item.date;
			   
			   //var id = item._id;
			   var id = item._id.$oid.toString();
			   //console.log(id);
			   
			   html += "<tr>";
			   html += "<td style=\"cursor:pointer;\" onclick=\"open11('"+id+"');\">"+title+"</td>";
			   html += "<td>"+date+"</td>";
			   html += "</tr>";
			}
			
			html += "</table>";

			$("tbody").html(html);

				
		},
		error : function(e){
			alert("ERROR!(bbs) : " + e)
		}
	})

});

//view(상세보기)클릭했을때의 해당 key(_id)값 과 json형태
var key;
var data;

//클릭했을때
function open11(id){
	$('#one_page_bbs').hide();
	$('#one_page_write').hide();
	$('#one_page_view').show();
	$('#one_page_update').hide();
	
	key = id;
	data= JSON.stringify({ // JSON.stringify : json 객체를 String 객체로 변환
		"key" : key
	})
	//console.log(key); //해당 "_id" 값
	//window.location.href = "/view.jsp?id="+key;
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

			$(".notice2").html(html); 
		},
		error: function(e){
			alert("ERROR(view) : "+ e);
		}
			
	});
	
}

//수정
function update11(){
/* 	console.log(key);
	console.log(data); */
	
	$('#one_page_bbs').hide();
	$('#one_page_write').hide();
	$('#one_page_view').hide();
	$('#one_page_update').show();

	$.ajax({
		type: "POST",
		dataType: "json",
		contentType: "application/json; charset=utf-8",	
		data: data,
		url: url,
		success: function(res){
			//console.log(res);
	 		$('#up_title').val(res.title);
			$('#up_date').val(res.date);
			$('#up_contents').val(res.contents);			

		},
		error: function(e){
			alert("ERROR(update) : "+ e);
		}
			
	});
}

function update_save(){
	//alert("확인: "+key);
	var title = $("#up_title").val();
	var contents = $("#up_contents").val();

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
					location.href = "/";
				}
			},
			error: function(e){
				alert("ERROR : "+e);
			}
		}); 
		
	}
}

//작성 페이지
function write11(){
	$('#one_page_bbs').hide();
	$('#one_page_write').show();
	$('#one_page_view').hide();
	$('#one_page_update').hide();
}

function write_save(){
	
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



</script>





<script type="text/javascript">
	$().ready(function(){
		//paging
		
	});
</script>

</body>
</html>