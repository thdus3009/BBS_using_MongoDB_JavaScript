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
	
	<div class="sub_wrap">
	
	<h2>공지 게시판</h2>
	<div class="notice">
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
	<a href="write.jsp" class="btn">글쓰기</a>

	<!-- 페이지 -->
	<div id="paging"></div>
	</div>


</div>

<!-- jquery.js와 동시에 실행이 되서 아래로 빼놓았음-->
<script type="text/javascript">


$().ready(function(){

	var url = "/loadAll.mon";
	$.ajax({
		type : "GET",
		dataType : "json",
		url : url,
		contentType : "application/json; charset=utf-8",
		success : function(res){
			
			var html = "";
			html += "<table>";
			
			for (var i = 0 ; i < res.length; i++){
			   var item = res[i];
			   
			   var title = item.title;
			   var date = item.date;
			   
			   //var id = item._id;
			   var id = item._id.$oid.toString();
			   //console.log(id);
			   
			   html += "<tr>";
			   html += "<td style=\"cursor:pointer;\" onclick=\"open11('"+id+"');\">"+title+"</td>";
			   //html += "<td style=\"cursor:pointer;\" id=\""+id+"\">"+title+"</td>";
			   html += "<td>"+date+"</td>";
			   html += "</tr>";
			}
			
			html += "</table>";

			$("tbody").html(html);
			
			

/* 			for (var i = 0 ; i < res.length; i++){
				
				var item = res[i];

				var title = "<td>"+item.title+"</td>";
				var date = "<td>"+item.date+"</td>";

				$("tbody").append("<tr>"+title+date+"<tr>");
				//$("tbody").append("<tr data-id=\""+item._id+"\">"+title+date+"<tr>"); //append 뒤에추가 //prepend 앞에추가
				//$("tbody").append("<tr data-id=\""+item._id+"\"><a href="#" onclick="move();">"+title+"</a>"+date+"<tr>"); //append 뒤에추가 //prepend 앞에추가
				
				//클릭이벤트 > _id가 오브젝트 타입,,, for문에  append로 추가하는부분 안에 title만 a태그로 감싸려고 했는데 안됨
			} */
				
				
		},
		error : function(e){
			alert("ERROR!(bbs) : " + e)
		}
	})

});

//해당 아이디 값을 가지고 페이지 꾸리기
function open11(key){
	var key = key;
	//console.log(key); //해당 "_id" 값
	//console.log(typeof key); 
	
	window.location.href = "/view.jsp?id="+key;
	
}

</script>


</body>
</html>