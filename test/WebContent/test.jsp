<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script src="${pageContext.request.contextPath}/resource/js/jquery.js"></script>

<link rel="stylesheet" type="text/css" href="/resource/dropzone/dropzone.min.css"/>
<script type="text/javascript" src="/resource/dropzone/dropzone.js"></script> 


</head>
<body>

<!-- only 파일 -->

 <h2>dropzone 테스트</h2>

    <div class="dropzone-area">

        <form name="fname">
            <label for="fld">필드</label>
            <div class="dropzone" id="myDropzone"></div>
            <button id="btn-upload-file">서버전송</button>
        </form>

    </div>


    <script>

        //fileDropzone dropzone 설정할 태그의 id로 지정
        Dropzone.options.myDropzone = {

        url: '/test.mon',          //업로드할 url (ex)컨트롤러)
        init: function () {
            /* 최초 dropzone 설정시 init을 통해 호출 */
            var submitButton = document.querySelector("#btn-upload-file");
            var myDropzone = this; //closure

            submitButton.addEventListener("click", function () {
                
                console.log("업로드");
                //tell Dropzone to process all queued files
                myDropzone.processQueue(); 

            });
            
/*             //기존에 업로드된 서버파일이 있는 경우,
            $.ajax({
                url: 'upload.php',
                type: 'post',
                data: {request: 2},
                dataType: 'json',
                success: function(response){

                    $.each(response, function(key,value) {
                        var mockFile = { name: value.name, size: value.size };

                        myDropzone.emit("addedfile", mockFile);
                        myDropzone.emit("thumbnail", mockFile, value.path);
                        myDropzone.emit("complete", mockFile);

                    });

                }
            }); */

        },
        autoProcessQueue: false,    // 자동업로드 여부 (true일 경우, 바로 업로드 되어지며, false일 경우, 서버에는 올라가지 않은 상태임 processQueue() 호출시 올라간다.)
        clickable: true,            // 클릭가능여부
        thumbnailHeight: 90,        // Upload icon size
        thumbnailWidth: 90,         // Upload icon size
        maxFiles: 5,                // 업로드 파일수
        maxFilesize: 10,            // 최대업로드용량 : 10MB
        parallelUploads: 99,        // 동시파일업로드 수(이걸 지정한 수 만큼 여러파일을 한번에 컨트롤러에 넘긴다.)
        addRemoveLinks: true,       // 삭제버튼 표시 여부
        dictRemoveFile: '삭제',     // 삭제버튼 표시 텍스트
        uploadMultiple: true,       // 다중업로드 기능

        };

    </script>

</body>
</html>