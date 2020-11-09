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
		
		<div id="one_page_bbs"><!-- 원페이지 작동 구간 (목록) -->
			
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
		
	
		<div id="one_page_view"><!-- 선택한 글보기 -->
			ㅇㅇㅇ
		</div>
		<div id="one_page_write"><!-- 글쓰기 -->
			ㅇㅇㅇ
		</div>

	</div>


</div>

<!-- jquery.js와 동시에 실행이 되서 아래로 빼놓았음-->
<script type="text/javascript">

$().ready(function(){
	
	
	$('#one_page_bbs').show();
	$('#one_page_write').hide();
	$('#one_page_view').hide();
	
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

//클릭했을때
function open11(key){
	var key = key;
	//console.log(key); //해당 "_id" 값

	window.location.href = "/view.jsp?id="+key;
	
}

</script>

<script type="text/javascript">
	$().ready(function(){
		//paging
		
	});
</script>

</body>
</html>