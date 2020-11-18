<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>bbs test ver.</title>
<script src="${pageContext.request.contextPath}/resource/js/jquery.js"></script>


<link href="${pageContext.request.contextPath}/resource/css/bbs.css"
	rel="stylesheet">
<link
	href="${pageContext.request.contextPath}/resource/css/bootstrap.css"
	rel="stylesheet">
<link href="${pageContext.request.contextPath}/resource/css/custom.css"
	rel="stylesheet">

<!-- dropzone.js -->
<script
	src="${pageContext.request.contextPath}/resource/dropzone/dropzone.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resource/dropzone/dropzone.min.css" />


<style type="text/css">
ul.mylist li {
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
			<img alt="dd_img"
				src="<%=request.getContextPath()%>/img/sub_visual_cscenter.jpg"
				width="100%" height="100%">
			<p class="img_txt">
				안녕하세요 고객님.<br>갤러리360 고객센터 입니다.
			</p>
		</div>

		<div class="sub_wrap">
			<!-- css때문에 잡아놓은 div -->
			<h2>공지 게시판</h2>

			<!------------------ 원페이지 작동 구간 (목록) ----------------------->
			<div id="one_page_bbs">

				<div class="notice notice1">
					<table class="table-striped"
						style="text-align: center; border: 1px solid #dddddd; width: 100%;">
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
				<div id="paging"></div>

			</div>

			<!------------------------ 선택한 글보기 -------------------------->
			<div id="one_page_view">
				<div class="notice notice2">
					<!-- ** 내용출력 ** -->
				</div>

				<br> <a href="/" class="btn">목록</a>
				<div onclick="delete11()" class="btn">삭제</div>
				<div onclick="update11()" class="btn">수정</div>
				
				<br><br>
					<!-- ** 댓글출력  ** -->
				<div class="notice">
					<!-- 댓글쓰기  -->
					<br>
					<div>
						등록 / 나중에...ㅎㅎ
						<div class="reply1"></div>
					</div>
					
					<!-- 댓글보기 -->
					<br>
					<div>
						&lt; 댓글 &gt; 
						<br>댓글 출력, 댓글 삭제*수정 기능...(동록,수정,삭제하고 현재 페이지 유지 어떻게 하지? 주소값이 없잖아 ㅜㅜㅜ)	
						
						<div class="reply2"></div>					
					</div>
				</div>
			</div>


			<!------------------------ 글쓰기 --------------------------------->
			<div id="one_page_write">
				<div class="notice notice3">
					<br> 제목 : <input type="text" name="title" id="title">
					<br>
					<br> 내용 :
					<textarea rows="5" cols="22" name="contents" id="contents"></textarea>
					<!-- <input type="submit" value="저장"> -->
					<br>
					<br> 파일 업로드 :
					<form action="${pageContext.request.contextPath}/test"
						method="post" enctype="multipart/form-data" class="dropzone"
						id="myDropzone" style="width: 93%;" name="file1"></form>
					<!-- <div class="dropzone" id="myDropzone" style="width: 93%;" name="file1"></div> -->
					<br>
					<br>
					<button onclick="write_save(myDropzone.files.length)" id="submit-all">저장</button>
				</div>

				<a href="/" class="btn">목록</a>
			</div>


			<!------------------------ 수정 --------------------------------->
			<div id="one_page_update">
				<div class="notice notice4">
					<br> 제목 : <input type="text" id="up_title"> <br>
					<br> 날짜 : <input type="text" id="up_date" readonly="readonly">
					<br>
					<br> 내용 :
					<textarea rows="5" cols="22" id="up_contents"></textarea>
					<!-- <input type="submit" value="저장"> -->
					<br>
					<br>
					<button onclick="update_save()">저장</button>

				</div>

				<a href="/" class="btn">목록</a>
			</div>

		</div>


	</div>

	<!-- jquery.js와 동시에 실행이 되서 아래로 빼놓았음-->
	<script type="text/javascript">

	var curPage = 1; //현재페이지 (현재위치 : 3페이지)
	var perPage = 10; //한페이지당 출력할 글 갯수(1페이지10개)
	
	var curBlock = 1; //현재 블록(1블록:1~10페이지 2블록:11~20페이지 3블록:21~30페이지 ..)
	var perBlock = 10; //한 블록당 몇페이지 보여줄건지(1블록10페이지)
	
	var totalCount = 0; //글 전체 갯수(ex. 62개)
	var totalPage = 0; //전체 페이지 수 (ex. 7페이지)
	var totalBlock = 0; //1블럭
	
	var startRow = 0; //0 10 20 (한 페이지에서 시작번호와 끝번호)
	var lastRow = 9; //9 19 29
	
	var startNum = 0; //1 11 21 (한 블록에서 시작페이지와 끝페이지)
	var lastNum = 0; //10 20 30
	

// ------- 첫화면 or 새로고침 
$().ready(function(){
	
	$('#one_page_bbs').show();
	$('#one_page_write').hide();
	$('#one_page_view').hide();
	$('#one_page_update').hide();

	cur_page();

});

// ------- pagination 클릭했을때

//한블럭에서 시작페이지: startNum //한블럭에서 끝페이지: lastNum

function b_click(){/* 이전 */
	
	curPage=(startNum-1);
//	console.log("curPage****"+curPage);
	startRow = (curPage-1)*perPage;
	lastRow = curPage * perPage -1;
	
	cur_page(); 
}

function p_click(i){ //ajax로 페이지 바꾸기
	
	curPage=i;
//	console.log("curPage****"+curPage);
	startRow = (curPage-1)*perPage; //해당 페이지에서 시작번호(0 10 20)
	lastRow = curPage * perPage -1; //해당 페이지에서 끝번호(9 19 29)
	
	cur_page(); 
}

function n_click(){ /* 다음 */
	
	curPage=(lastNum+1); 
//	console.log("curPage****"+curPage);
	startRow = (curPage-1)*perPage;
	lastRow = curPage * perPage -1;
	
	cur_page(); 
}
//====================== pagination =============================
 

//페이징 처리 //즉시실행
/* function first_page(){

	BBS.curPage=1;
	
	BBS.perPage = 10;
	BBS.perBlock = 10;
	
	BBS.startRow = 0;
	BBS.lastRow = 9;
} */

 
 //현재 페이지
 function cur_page(){
		//1=0, 2=10, 3=20, 4=30 >> (현재페이지-1)*perpage // 

		var url = "/loadAll.mon?start="+startRow+"&perpage="+perPage;
		
		$.ajax({
			type : "GET",
			dataType : "json",
			url : url,
			contentType : "application/json; charset=utf-8",
			success : function(res){
				
				var html = "";
				html += "<table>";
				
				//페이지 할 때 사용할 총 갯수
				totalCount = res[0].totalcount;	
				
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

		if(totalCount%perPage!=0){ //전체 페이지
			totalPage = parseInt(totalCount/perPage)+1; 		
		}else{
			totalPage = parseInt(totalCount/perPage);
		}

		if(totalPage%perBlock!=0){ //전체 블럭
			totalBlock = parseInt(totalPage/perBlock)+1;		
		}else{
			totalBlock = parseInt(totalPage/perBlock);
		}
		
		/* 현재 블록 */
		if(curPage%perBlock!=0){
			curBlock = parseInt(curPage/perBlock)+1; 
		}else{
			curBlock = parseInt(curPage/perBlock);
		} 
		
		/* 해당 블럭의 시작 페이지번호 */
		startNum = parseInt((curBlock-1)*perBlock)+1;
		
		/* 해당 블럭의 끝 페이지번호 */
		lastNum = parseInt(curBlock*perBlock);
		if(totalPage<=lastNum){
			lastNum = totalPage;
		}
		

		
		//만일 새로고침한 상태라 curPage가 null이라면 1적용
/*  		console.log(" ");
		console.log("현재 누른 페이지: "+curPage);
		console.log("시작번호: "+startRow);
		console.log("끝번호: "+lastRow);
		console.log("전체 글 갯수 : "+totalCount);
		console.log("전체 페이지 수 : "+totalPage);
		console.log("전체 블록: "+totalBlock);
		console.log("현재 블록: "+curBlock);
		console.log("시작페이지: "+startNum);
		console.log("끝페이지: "+lastNum); 
		 */
		 
	
		var html ="";
		
		if(curBlock!=1){
			html+= "<span style=\"cursor:pointer;\" onclick=\"b_click();\">이전</span>"
			html+= "&nbsp;&nbsp;";						
		}
		
		for (var i = startNum ; i <= lastNum; i++){
				html+= "<span style=\"cursor:pointer;\" onclick=\"p_click('"+i+"');\">"+i+"</span>";
				html+= "&nbsp;&nbsp;";
		 }
		
		if(curBlock!=totalBlock){
			html+= "<span style=\"cursor:pointer;\" onclick=\"n_click();\">다음</span>"
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
			
			if(res.file!=null){
				var file = res.file;
				var file_split = file.split("-spl-");
				
				html+="\<업로드 파일\><br>"
				
				for(var i in file_split){
					html+= "<div onclick=\"file_download('"+file_split[i]+"')\" style=\"cursor:pointer;\" >"
							+file_split[i]+"</div>";
				} 
					
				html+= "<br>";				
			}
			
			$(".notice2").html(html); 
			
			/* ---------------------------댓글 입력--------------------------------- */
			var id = res._id.$oid.toString();
			
			var html2 = "";
			html2+= "<input type=\"hidden\" id=\"id\" value=\""+id+"\">";
			html2+= "닉네임 : <input type=\"text\" id=\"nick_name\"><br><br>"
			html2+= "댓글 : <input type=\"text\" name=\"reply\" id=\"reply\" style=\"width:90%;\">";
			html2+= "&emsp; <button onclick=\"reply_save()\">등록</button>"
			$(".reply1").html(html2);
			
			/* ---------------------------댓글 출력--------------------------------- */
			var html3 = "";
			
			
		},
		error: function(e){
			alert("ERROR(view) : "+ e);
		}
			
	});
	
}

//댓글(reply) 저장 
function reply_save(){
	var nick_name = $("#nick_name").val();
	var reply = $("#reply").val();
	var id = $("#id").val();
	
 	var url = "/Reply.gu?id="+id+"&reply="+reply+"&nick_name="+nick_name;

  	if(reply==""||nick_name==""){
 		alert("닉네임과 댓글을 둘 다 입력해 주세요~!");
 	}else{
	 	/* 	var data = JSON.stringify({
			"id" : id,
			"reply" : reply,
		}); */
		
		$.ajax({
			type : "GET",
			dataType : "json",
			contentType : "application/json; charset=utf-8",
	/* 		data : data, */
			url : url,
			success : function(res){
				alert("dddd");
			},
			error : function(e){
				alert("ERROR!(reply) : " + e);
			}
		}) 
 		
 	} 
 	
	
}

//파일 다운로드
function file_download(file_name){
	//var url = "/loadAll.mon?start="+startRow+"&perpage="+perPage;
	var url = "/FileDownload.gu?filename="+file_name;

	//파일다운로드는 주소값으로(경로 이동)
	location.href = url;
	
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
	            this.on("queuecomplete", function (file) {
	                alert("모든 파일 업로드 완료!");
	              	location.href = "/";
	           });
	            
	      
	            //파일 보낼때 (파일을 보내야지 이게 작동된다.)
 	            this.on("sending",function(data, xhr, formData){ 
	            	//debugger;
	            	formData.append("title", $("#title").val());
	            	formData.append("contents", $("#contents").val());
	            }); 
	            
	            
	            //정보 하나씩넘길때마다 작동 (success, complete 둘 다 비슷한 기능)
/*	            this.on("success",function(file, response){
	            	alert("파일 업로드_success");
	            	//debugger;
	            });
	            
 	            this.on("complete",function(file){
	            	alert("파일 업로드_complete");	            	
	            });  */

	        }


	}; 

/*   	function write_save(aa){
 		
  		console.log(aa);
 		
 		//myDropzone.processQueue(); 
		//location.reload();
	}   
 */
 
	function write_save(file){
	
			if(file!=0){
				
				myDropzone.processQueue(); 	
				//return false;
	
			}else{
				
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
								alert("글쓰기 저장 완료");
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
	
		
	}    



</script>

</body>
</html>