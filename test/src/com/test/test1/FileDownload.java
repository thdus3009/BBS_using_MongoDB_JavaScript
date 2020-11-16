package com.test.test1;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
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
		
		

		//String path = request.getSession().getServletContext().getRealPath("/");		
		String filename = request.getParameter("filename").toString();
		
		String dir = "";	
		dir = "C:/File_Attached/test/";
				
        String filePath = dir + filename;  // <== 다운로드 받을 파일명 (예시: C:\File_Attached\test\1605512188551hello.txt)                   
        System.out.println("filepath****"+filePath);
       
        File downloadFile = new File(filePath);
        FileInputStream inStream = new FileInputStream(downloadFile);
        

       // String relativePath = getServletContext().getRealPath("");         
        ServletContext context = getServletContext();
         
/*        String mimeType = context.getMimeType(filePath);
        if (mimeType == null) {        
            mimeType = "application/octet-stream";
        }      
         
        response.setContentType(mimeType);*/
        response.setContentLength((int) downloadFile.length());
        
        String downName = "";
        String browser = request.getHeader("User-Agent"); //파일 인코딩 (유저정보)

    	if(browser.contains("MSIE") || browser.contains("Trident") || browser.contains("Chrome")){ 
    		downName = URLEncoder.encode(filename ,"UTF-8").replaceAll("\\+", "%20"); 
    	} else { 
    		downName = new String(filename.getBytes("UTF-8"), "ISO-8859-1"); 
    	}
       
        // forces download
        String headerKey = "Content-Disposition";
        String headerValue = String.format("attachment; filename=\"%s\"", downName);
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
