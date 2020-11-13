<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>bbs test ver.</title>
<script src="${pageContext.request.contextPath}/resource/js/jquery.js"></script>


<link href="${pageContext.request.contextPath}/resource/css/bbs.css" rel="stylesheet">
<link  href="${pageContext.request.contextPath}/resource/css/bootstrap.css" rel="stylesheet">
<link  href="${pageContext.request.contextPath}/resource/css/custom.css" rel="stylesheet">

<!-- dropzone.js -->
<script src="${pageContext.request.contextPath}/resource/dropzone/dropzone.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/dropzone/dropzone.min.css" />


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
					<tbody class="paginated">
						<!-- loadAll.mon 자바스크립트 -->
					</tbody>
				</table>
			</div>
			
			<br>
			<div onclick="write11()" class="btn">글쓰기</div>
			<!-- <a href="write.jsp" class="btn">글쓰기</a> -->
		
			<!-- 페이지 -->
			<div id="paging">
			
			</div>		
		
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
				파일 업로드 :	<form action="${pageContext.request.contextPath}/test" method="post" enctype="multipart/form-data"
				class="dropzone" id="myDropzone" style="width: 93%;" name="file1"></form> 
				<!-- <div class="dropzone" id="myDropzone" style="width: 93%;" name="file1"></div> -->
				<br><br>
				<button onclick="write_save()" id="submit-all">저장</button>
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
function BBS(){
	this.curPage = 0; //현재페이지 (현재위치 : 3페이지)
	this.perPage = 10; //한페이지당 출력할 글 갯수(1페이지10개)
	
	this.curBlock = 0; //현재 블록(1블록:1~10페이지 2블록:11~20페이지 3블록:21~30페이지 ..)
	this.perBlock = 10; //한 블록당 몇페이지 보여줄건지(1블록10페이지)
	
	this.totalCount = 0; //글 전체 갯수(ex. 62개)
	this.totalPage = 0; //전체 페이지 수 (ex. 7페이지)
	this.totalBlock = 0; //1블럭
	
	this.startRow = 0; //0 10 20 (한 페이지에서 시작번호와 끝번호)
	this.lastRow = 0; //9 19 29
	
	this.startNum = 0; //1 11 21 (한 블록에서 시작페이지와 끝페이지)
	this.lastNum = 0; //10 20 30
	
	
}

// ------- 첫화면 or 새로고침 
$().ready(function(){
	
	$('#one_page_bbs').show();
	$('#one_page_write').hide();
	$('#one_page_view').hide();
	$('#one_page_update').hide();
	
	first_page();	
	
	cur_page();

});

// ------- pagination 클릭했을때
function p_click(i){

	BBS.curPage=i;
	
	BBS.startRow = (BBS.curPage-1)*BBS.perPage; //해당 페이지에서 시작번호(0 10 20)
	BBS.lastRow = BBS.curPage * BBS.perPage -1; //해당 페이지에서 끝번호(9 19 29)
	
	cur_page(); 
}

//====================== pagination =============================
 

//페이징 처리 //즉시실행
function first_page(){

	BBS.curPage=1;
	
	BBS.perPage = 10;
	BBS.perBlock = 10;
	
	BBS.startRow = 0;
	BBS.lastRow = 9;
}

 
 //현재 페이지
 function cur_page(){
		//1=0, 2=10, 3=20, 4=30 >> (현재페이지-1)*perpage // 
		var url = "/loadAll.mon?start="+BBS.startRow+"&perpage="+BBS.perPage;
		
		$.ajax({
			type : "GET",
			dataType : "json",
			url : url,
			contentType : "application/json; charset=utf-8",
			success : function(res){
				
				var html = "";
				html += "<table>";
				
				//페이지 할 때 사용할 총 갯수
				BBS.totalCount = res[0].totalcount;	
				
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
				
				navigator();	
			},
			error : function(e){
				alert("ERROR!(bbs) : " + e)
			}
		})
 }
 
 function navigator(){

		if(BBS.totalCount%BBS.perPage!=0){ //전체 페이지
			BBS.totalPage = parseInt(BBS.totalCount/BBS.perPage)+1; 		
		}else{
			BBS.totalPage = parseInt(BBS.totalCount/BBS.perPage);
		}

		if(BBS.totalPage%BBS.perBlock!=0){ //전체 블럭
			BBS.totalBlock = parseInt(BBS.totalPage/BBS.perBlock)+1;		
		}else{
			BBS.totalBlock = parseInt(BBS.totalPage/BBS.perBlock);
		}
		
		/* 현재 블록 */
		BBS.curBlock = parseInt(BBS.curPage/BBS.perBlock)+1; 
		
		/* 해당 블럭의 시작 페이지번호 */
		BBS.startNum = parseInt((BBS.curBlock-1)*BBS.perBlock)+1;
		
		/* 해당 블럭의 끝 페이지번호 */
		BBS.lastNum = parseInt(BBS.curBlock*BBS.perBlock);
		if(BBS.totalPage<=BBS.lastNum){
			BBS.lastNum = BBS.totalPage;
		}
		

		
		//만일 새로고침한 상태라 curPage가 null이라면 1적용
/* 		console.log("현재 누른 페이지: "+BBS.curPage);
		console.log("시작번호: "+BBS.startRow);
		console.log("끝번호: "+BBS.lastRow);
		console.log("전체 글 갯수 : "+BBS.totalCount);
		console.log("전체 페이지 수 : "+BBS.totalPage);
		console.log("전체 블록: "+BBS.totalBlock);
		console.log("현재 블록: "+BBS.curBlock);
		console.log("시작페이지: "+BBS.startNum);
		console.log("끝페이지: "+BBS.lastNum); */
		
		

		var html ="";
		
		//이전, 다음 버튼은 ....나중에 만들자 ㅎ
		for (var i = BBS.startNum ; i <= BBS.lastNum; i++){
				html+= "<span style=\"cursor:pointer;\" onclick=\"p_click('"+i+"');\">"+i+"</span>";
				html+= "&nbsp;&nbsp;";
		 }
		
		$("#paging").html(html); 
		 
		 
	 }

//===================================================

//view(상세보기)클릭했을때의 해당 key(_id)값 과 json형태
var key;
var data;

//클릭했을때(상세페이지)
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

//작성 페이지 (write)
function write11(){
	$('#one_page_bbs').hide();
	$('#one_page_write').show();
	$('#one_page_view').hide();
	$('#one_page_update').hide();

}

	
	/* 파일+데이터 */
/* Dropzone.options.myDropzone= {
	    url: '/test.mon',
	    autoProcessQueue: false,
	    uploadMultiple: true,
	    parallelUploads: 5,
	    maxFiles: 5,
	    maxFilesize: 1,
	    //acceptedFiles: 'image/*',
	    addRemoveLinks: true,
	    init: function() {
	        dzClosure = this; 

	        $("#").click(function(e) {
	            //location.href = "/";
	            //e.preventDefault();//동작중지
	            e.stopPropagation();//상위엘리먼트에 이벤트 전달 막아주기
	            dzClosure.processQueue();
	        });

	        this.on("sendingmultiple", function(data, xhr, formData) {
	            formData.append("title", jQuery("#title").val());
	            formData.append("contents", jQuery("#contents").val());
	        });
	    }
	} */
	
	/* only 파일 >>여기정보를 어떻게 파라미터로 넘기는지 모르겠음 */ 
      Dropzone.options.myDropzone = {

	        autoProcessQueue: false,    // 자동업로드 여부 (true일 경우, 바로 업로드 되어지며, false일 경우, 서버에는 올라가지 않은 상태임 processQueue() 호출시 올라간다.)
	        clickable: true,            // 클릭가능여부
	        maxFiles: 5,                // 업로드 파일수
	        maxFilesize: 300,           // 최대업로드용량 : 300MB
	        parallelUploads: 99,        // 동시파일업로드 수(이걸 지정한 수 만큼 여러파일을 한번에 컨트롤러에 넘긴다.)
	        addRemoveLinks: true,       // 삭제버튼 표시 여부
	        dictRemoveFile: '삭제',      // 삭제버튼 표시 텍스트
	        uploadMultiple: true,       // 다중업로드 기능
	        dictFileTooBig: "파일의 용량이 너무 큽니다.",
	        
	        renameFile: function(file){ //중복이름 방지
	        	var dt = new Date();
	        	var time = dt.getTime();
	        	return time+file.name;
	        },
	        
	        dictDefaultMessage: "파일 선택 (클릭해 주세요.)<br>Max size : 300MB",
	        accept: function(file, done){
	        	done();
	        }, 
	        
	        url: '/FileUpload.gu',          //업로드할 url (ex)컨트롤러)
	        init: function () {
	            /* 최초 dropzone 설정시 init을 통해 호출 */
	            //var submitButton = document.querySelector("#submit-all");
	            myDropzone = this; //closure

	         //   submitButton.addEventListener("click", function () {
	        //        
	         //       console.log("업로드");
	                //tell Dropzone to process all queued files
	         //       myDropzone.processQueue(); 

	         ///   });
	            
	            //정보 넘김을 전부 완료했을때
	            this.on("complete",function(file){
	            	alert("파일 업로드_complete");
	            	//location.href = "/";
	            }); 
	            //파일 보낼때 (제목,내용 보내지는게 문제가 아니고 일단 파일이 저장되고 불러와지는지가 중요)
	            this.on("sending",function(data, xhr, formData){ 
	            	debugger;
	            	//formData.append("title", $("#title").val());
	            	//formData.append("body", $("#contents").val());
	            });
	            //정보 하나씩넘길때마다 작동
	            this.on("success",function(file, response){
	            	alert("파일 업로드_success");
	            	debugger;
	            });

	        }


	}; 


	function write_save(){

		myDropzone.processQueue(); 
//		return false;


    var title = $("#title").val();
	var content = $("#contents").val();
	
	//alert(title+" "+content);
	
	var url = "/insert.mon";
	
	console.log("aa: "+title);
	if(title==""||content==""){
		alert("제목과 내용을 입력해 주세요.");
	}else{

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

	
}     



</script>

</body>
</html>