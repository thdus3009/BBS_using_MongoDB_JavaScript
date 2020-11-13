




Dropzone.options.upMydropzone1 = {
			
		
		maxFilesize: 300,  //100M
		maxFiles: 1,
		renameFile: function(file){
			var dt = new Date();
			var time = dt.getTime();
			return time+file.name;
		},
		acceptedFiles: ".jpeg,.jpg,.png,.tif,.tiff",
		addRemoveLinks: true,
		timeout: 500000,
		uploadMultiple: true,
		autoProcessQueue: false,
		clickable: true,
		// 병렬처리 WebConfig도 같이 수정해줘야함.
        parallelUploads: 1,
     //   dictDefaultMessage: "작품 파일 이미지를 선택해 주세요.<br>Max size:300M(.jpg,&nbsp;.png,&nbsp;.tif)",
        dictDefaultMessage: "작품 이미지 선택.<br>Max size : 300M<br>(.jpg,&nbsp;.png,&nbsp;.tif)",
		accept : function(file, done){
			done();
		},
		
		fallback: function(){
			g360.gAlert("Error", "지원하지 않는 브라우저 입니다. 브라우저를 업그레이드 하세요" , "red", "left");
		},
		
		init: function(){
			this.on("maxfilesexceeded", function(file){
				this.removeFile(file);
				g360.gAlert("Error", "하나의 파일만 업로드 할 수 있습니다. 기존 업로드 파일을 삭제 하고 다시 업로드 하세요" , "red", "left");
			});
			
			this.on("addedfile", function (file) {
                var _this = this;
                gArtistInfo_Rental.file1 = file;
                if ($.inArray(file.type, ['image/jpeg', 'image/jpg', 'image/png', 'image/tif', 'image/tiff']) == -1) {
                   	g360.gAlert("Error", "업로드 가능 파일 형식이 아닙니다." , "red", "left");
                    _this.removeFile(file);
            }
                
                var ms = parseFloat((file.size / (1024*1024)).toFixed(2));
                if (ms > this.options.maxFilesize){	                    	
                	g360.gAlert("Error", "업로드 가능 사이즈를 초과하였습니다." , "red", "left");
                    _this.removeFile(file);
                }
            });
			
			
			upMydropzone1 = this; //Closer
			
		},				
		
		removedfile : function(file)
		{
			
             //   var name = file.upload.filename;
                var name = file.name;
                var email = file.email;
                var type = "art";
                var dockey = file.dockey;
                $.ajax({
                    headers: {
                                'X-CSRF-TOKEN': $('meta[name="_token"]').attr('content')
                            },
                    type: 'POST',
                    url: '/removefile_dropzone.gu',
                    data: {filename: name, email : file.email , type : type, dockey : dockey},
                    success: function (data){
                        console.log("File has been successfully removed!!");
                    },
                    error: function(e) {
                        console.log(e);
                }});
                var fileRef;
                return (fileRef = file.previewElement) != null ? 
                fileRef.parentNode.removeChild(file.previewElement) : void 0;
        },
		success : function(file, response){
			
			
			
			var isOK = JSON.parse(response).result;
			if (isOK == "OK"){
				var res = JSON.parse(response);
				
				
		
				gArtistInfo_Rental.img_filename = res.filename;
				
				gArtistInfo_Rental.file_width = res.file_width;
				gArtistInfo_Rental.file_height = res.file_height;
				gArtistInfo_Rental.file_size  = res.file_size;
				gArtistInfo_Rental.file_type = res.file_type;
				gArtistInfo_Rental.MD5Value = res.MD5Value;
				gArtistInfo_Rental.file_dpi = res.file_dpi;
			
				if (Mydropzone3.files.length > 0){
					Mydropzone3.processQueue();
				}else if (xxMydropzone2.files.length > 0){
					xxMydropzone2.processQueue();
				}else if (Mydropzone4.files.length > 0){
					Mydropzone4.processQueue();
				}else if (xxMydropzone5.files.length > 0){
					xxMydropzone5.processQueue();
				}else{
					gArtistInfo_Rental.uploadForm();
				}
						
			}else if (isOk = "fileexist"){
				
				this.removeFile(file);
				g360.gAlert("Error", "동일한 파일이 이미 존재합니다. 다른 작품 파일을 선택해 주세요." , "red", "left");
				g360.loadingbar_close();
			}else{
				this.removeFile(file);
				g360.gAlert("Error", "파일 업로드 중 오류가 발생하였습니다." , "red", "left");
				g360.loadingbar_close();
			}			
			
			
		},
		error : function(file, response){
			return false;
		}
		}




		$("#upMydropzone1").dropzone();	
