package com.test.test1;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.mongodb.MongoClient;

@WebServlet("/FileDownload.gu")

public class FileDownload extends HttpServlet{
	//이미지 판매된 파일을 실제 다운로드할 수 있게 하는 소스
	//file key값과 확장자명을 입력하면 작품원본 사진을 다운로드하게 한다.
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//저장 경로 (모델2방식)
		//String path = request.getSession().getServletContext().getRealPath("/");		
		//파일 이름
		String filename = request.getParameter("filename").toString();
		System.out.println("파일명: "+filename);
		String dir = "";	
		dir = "C:/File_Attached/test/";
				
        String filePath = dir + filename;  // <== 다운로드 받을 파일명 (예시: C:\File_Attached\test\1605512188551hello.txt)                   
       
        File downloadFile = new File(filePath);
        
        System.out.println("filepath****"+filePath);

        //현재 위치에 파일 유무 확인
        if(downloadFile.isFile()){
        	System.out.println("존재 한다.");
        }else{
        	System.out.println("존재 안한다.");
        }
        
        /* 파일을 읽어오기 위해서:FileInputStream  내보내기:HttpServletResponse의 getOutputStream 함수사용 */
        FileInputStream inStream = new FileInputStream(downloadFile);
        
        //서버 물리경로 구하기
        String relativePath = getServletContext().getRealPath("");  
        //System.out.println("relativePath = "+relativePath);
        
        ServletContext context = getServletContext();
         
       String mimeType = context.getMimeType(filePath);
        if (mimeType == null) {        
            mimeType = "application/octet-stream";
        }      
         
        //파일 형식(img,text,zip...)
        System.out.println("mime type: "+mimeType);
        
        response.setContentType(mimeType);        
        response.setContentLength((int) downloadFile.length());
        
        
        //한글 깨짐 방지
        String downName = "";
        
        String browser = request.getHeader("User-Agent"); //파일 인코딩 (유저정보)

    	if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")){ 
    		downName = URLEncoder.encode(filename ,"UTF-8").replaceAll("\\+", "%20"); 
    	} else { 
    		downName = new String(filename.getBytes("UTF-8"), "ISO-8859-1"); 
    	}
       
        // forces download
        String headerKey = "Content-Disposition";
        String headerValue = String.format("attachment; filename=\"%s\"", downloadFile.getName());
        //다른이름으로 저장
        response.setHeader(headerKey, headerValue);
         
        
        
        // obtains response's output stream
        OutputStream outStream = null;
        try{
        	 outStream = response.getOutputStream();
        	 byte[] buffer = new byte[4096];
             int bytesRead = -1;
              
             while ((bytesRead = inStream.read(buffer)) != -1) {
                 outStream.write(buffer, 0, bytesRead);
             }
        }catch(Exception e){
        	e.printStackTrace();
        }finally{        	
        	if (inStream != null) inStream.close();
        	outStream.flush();
        	if (outStream != null) outStream.close(); 
        }
       
        
        
    }
	
	
}
