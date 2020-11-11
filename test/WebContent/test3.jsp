<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script src="${pageContext.request.contextPath}/resource/js/jquery.js"></script>

<script src="${pageContext.request.contextPath}/resource/dropzone/dropzone.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resource/dropzone/dropzone.min.css" />

</head>
<body>

<!-- 파일+다른 데이터  -->

<!-- <form action="/file-upload"
      class="dropzone"
      id="my-awesome-dropzone" style="width: 50%"></form> -->
 
    <input type="text" id ="firstname" name ="firstname" />
    <input type="text" id ="lastname" name ="lastname" />
    <div class="dropzone" id="myDropzone"></div>
   
    <button type="submit" id="submit-all"> upload </button>

 
<script type="text/javascript">
	Dropzone.options.myDropzone= {
	    url: '/test.mon',
	    autoProcessQueue: false,
	    uploadMultiple: true,
	    parallelUploads: 5,
	    maxFiles: 5,
	    maxFilesize: 1,
	    //acceptedFiles: 'image/*',
	    addRemoveLinks: true,
	    init: function() {
	        dzClosure = this; // Makes sure that 'this' is understood inside the functions below.

	        // for Dropzone to process the queue (instead of default form behavior):
	        $("#submit-all").click(function(e) {
	            // Make sure that the form isn't actually being sent.
	            e.preventDefault();
	            e.stopPropagation();
	            dzClosure.processQueue();
	        });

	        //send all the form data along with the files:
	        this.on("sendingmultiple", function(data, xhr, formData) {
	            formData.append("firstname", jQuery("#firstname").val());
	            formData.append("lastname", jQuery("#lastname").val());
	        });
	    }
	}

</script> 
      
</body>
</html>