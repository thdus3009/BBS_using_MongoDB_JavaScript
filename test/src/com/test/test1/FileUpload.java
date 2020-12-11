package com.test.test1;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import com.mongodb.WriteConcern;
import com.sun.javafx.scene.web.Debugger;
import com.sun.org.apache.xml.internal.resolver.helpers.Debug;

@WebServlet("/FileUpload.gu")
//어노테이션 설정하면 web.xml 작성을 생략할 수 있다.

public class FileUpload extends HttpServlet{

//	private static final long serialVersionUID = 1L;
//	private static final String UPLOAD_DIRECTORY = "upload";
	private static String SAVE_DIR = "uploadFiles";
	
	// upload settings
    private static final int MEMORY_THRESHOLD   = 1024 * 1024 * 3;  // 3MB
    
    private static final int MAX_FILE_SIZE      = 1024 * 1024 * 400; // 40MB
    private static final int MAX_REQUEST_SIZE   = 1024 * 1024 * 500; // 50MB
 
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		
		
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8"); 
		response.setContentType("text/html; charset=UTF-8");
				
		SAVE_DIR = "C:/file/File_Attached";

		/////////////////////////////////////////////////////////////////////////////////////////////////
		PrintWriter out = response.getWriter();
		JsonObject result = new JsonObject();
		// checks if the request actually contains upload file
/*        if (!ServletFileUpload.isMultipartContent(request)) {
            // if not, we stop here
            result.addProperty("result", "ERROR");
            out.println(result.getAsJsonObject());
            out.close();
            return;
        }*/
       
		//임시저장공간 생성 (FileItem오브젝트를 생성)
        DiskFileItemFactory factory = new DiskFileItemFactory();
        factory.setSizeThreshold(MEMORY_THRESHOLD);  //메모리에 저장할 최대 사이즈
        factory.setRepository(new File(System.getProperty("java.io.tmpdir"))); //지정한 버퍼최대값을 넘었을 경우 어디에 보존할것인지
        
        //업로드 핸들러 생성 (Servlet프로그램을 경유하고, 파일데이터를 취득하는 클래스)
        ServletFileUpload upload = new ServletFileUpload(factory);   
        upload.setHeaderEncoding("utf-8");   //데이터을 수신할 경우의 엔코딩방식을 지정한다.
        upload.setFileSizeMax(MAX_FILE_SIZE);
        upload.setSizeMax(MAX_REQUEST_SIZE); //업로드할수있는 데이터용량의 최대값을 bytes로 지정
        
        String appPath = request.getServletContext().getRealPath("");
//		String uploadPath = appPath +  SAVE_DIR + File.separator + "test";
        String uploadPath = SAVE_DIR + File.separator + "test";

		System.out.println("uploadPath : " + uploadPath);
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
		
		String title = "";
		String contents = "";
		String sfileName = "";
		
        try {
        
            @SuppressWarnings("unchecked") //노란색 경고를 없애준다.
            List<FileItem> formItems = upload.parseRequest(request);
            System.out.println(formItems);
       //     System.out.println("formItems.size() : " + formItems.size());
 
            
            
            if (formItems != null && formItems.size() > 0) {
                // iterates over form's fields
                for (FileItem item : formItems) {
                		System.out.println(item.getFieldName());
                	
                    if (!item.isFormField()) { //파일데이터면 false , 그 외 데이터면 true 반환
                    	
                    	String fileName = new File(item.getName()).getName();
                    	if (sfileName == ""){
                    		sfileName = fileName;
                    	}else{
                    		sfileName += "-spl-" + fileName;
                    	}
                   //     System.out.println("uploadPath : " + uploadPath);
                   //     System.out.println("fileName ; " + fileName);
                        String filePath = uploadPath + File.separator + fileName;
                        File storeFile = new File(filePath);
                        
                        System.out.println("file upload Path : " + filePath);
                
                        if (!item.getContentType().equals("") && !item.getName().equals("")){
                        	
                        	//File업로드 필드일 경우 파일을 저장한다.(파일이 저장되는 부분)
                        	item.write(storeFile);
                        	
                        	//업로드된 파일을 몽고 DB에 추가한다.
							System.out.println("title : " + title);
							System.out.println("contents : " + contents);
							System.out.println("file : "+sfileName);
                        	
                        	///////////////////////////////////////////
                        }
                        
                        request.setAttribute("message", "Upload has been done successfully!");
                    }else{
                    	 // 그 외 데이터
                    	System.out.println("필드 저장용");
                        System.out.println(item.getFieldName());
                        System.out.println(item.getString("UTF-8"));
						 if (item.getFieldName().equals("title")){
                        	title = item.getString("UTF-8");
                        }
                        
                        if (item.getFieldName().equals("contents")) {
                        	contents = item.getString("UTF-8");
                        }
						
                    }
                }             
                
                
                //업로드 파일 이외에 필드들을 몽고DB에 저장한다.
                //DB
                MongoClient mongoClient = null;
                DBCollection coll = null;
                
                try {
                	String MongoDB_IP="localhost";
                	int MongoDB_Port=27017;
                	mongoClient = new MongoClient(MongoDB_IP,MongoDB_Port);
                	
                	System.out.println("server 접속 성공");
                	
                	//쓰기권한 부여
                	WriteConcern w = new WriteConcern(1,2000);//쓰게 락 갯수, 연결 시간 2000 //쓰레드 쓰게되면 2개 동시에 쓸 경우도 생기니까
                	mongoClient.setWriteConcern(w);
                	//데이터베이스 연결
                	DB db = mongoClient.getDB("test");
                	//컬렉션 가져오기
                	coll = db.getCollection("test");
                	System.out.println("db,collection 접속 성공");
                	System.out.println();
                	
                } catch (Exception e) {
                	System.out.println(e.getMessage());
                }
                
                //Date
                SimpleDateFormat format1 = new  SimpleDateFormat("yyyy-MM-dd");			
                Date time = new Date();			
                String date1 = format1.format(time);
                
                //mongoDB로 정보 보내기
                DBObject doc = new BasicDBObject();
                doc.put("title", title);
                doc.put("contents", contents);
                doc.put("date", date1);
                doc.put("file", sfileName);
                
                coll.insert(doc);
                
                //json형태로 success부분에 받고 싶은 정보 입력
                JsonObject res = new JsonObject();
                res.addProperty("result", "OK"); //json형태
                
                //PrintWriter에 관련한 변수명 : out //서버에서 정보를 받고 내려오는 부분(String으로)
                out.println(res.getAsJsonObject());
                
                ///////////////////////////////////////////////////////////
                
                result.addProperty("result", "OK");
                result.addProperty("filename", sfileName);
            }
            
            
            
        } catch (Exception ex) {
            request.setAttribute("message", "There was an error: " + ex.getMessage());
        }
		
       System.out.println("result : " + result);
        out.println(result.getAsJsonObject());
		out.close();
	}


	private String getBody(HttpServletRequest request) {
		// TODO Auto-generated method stub
		return null;
	}
	
}
