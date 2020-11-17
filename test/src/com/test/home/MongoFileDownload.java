package com.test.home;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/MongoFileDownload.gu")

public class MongoFileDownload extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//저장 경로 (모델2방식)
		//String path = request.getSession().getServletContext().getRealPath("/");		
		//파일 이름
		String filename = request.getParameter("filename").toString();
		
		String dir = "";	
		dir = "C:/File_Attached/test/";
				
        String filePath = dir + filename;  // <== 다운로드 받을 파일명 (예시: C:\File_Attached\test\1605512188551hello.txt)                   
        //System.out.println("filepath****"+filePath);
       
        //파일찾기(파일 유무)
        File downloadFile = new File(filePath);
        
        if(downloadFile.isFile()){
        	System.out.println("존재 한다.");
        }else{
        	System.out.println("존재 안한다.");
        }

        /* 파일을 읽어오기 위해서:FileInputStream  내보내기:HttpServletResponse의 getOutputStream 함수사용 */
        //return an application file instead of html page
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition","attachment;filename="+filePath);
        
       
        try {
			System.out.println("??");
        	FileInputStream in = new FileInputStream(downloadFile);
        	
        	ServletOutputStream out = response.getOutputStream();
        	
        	 byte[] outputByte = new byte[4096];
             //copy binary content to output stream
             while(in.read(outputByte, 0, 4096) != -1){
             	out.write(outputByte, 0, 4096);
             }
        
             in.close();
             out.flush();
             out.close();
             
        } catch (Exception e) {
        	System.out.println("???");
			e.printStackTrace();
		}
        

     }
	
}
