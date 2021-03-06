package com.test.home;

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
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;

import org.apache.tomcat.util.http.fileupload.FileItem;
import org.apache.tomcat.util.http.fileupload.FileUpload;
import org.apache.tomcat.util.http.fileupload.RequestContext;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;
import org.apache.tomcat.util.http.fileupload.servlet.ServletFileUpload;
import org.bson.types.ObjectId;
import org.eclipse.jdt.internal.compiler.ast.ThrowStatement;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import com.mongodb.WriteConcern;
import com.mongodb.util.JSON;

public class controller extends HttpServlet {

	
	MongoFileDownload MD = new MongoFileDownload();
	
//	MongoService
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(req, resp);
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		String title = request.getParameter("title").toString();
//		String contents = request.getParameter("contents").toString();
//		System.out.println(title);
//		System.out.println(contents);

		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8"); 
		response.setContentType("text/html; charset=UTF-8");
		
		MongoClient mongoClient = null;
		DBCollection coll = null;
		
        try{
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
		

			
        }catch(Exception e){
            System.out.println(e.getMessage());
        }
        
        PrintWriter out = response.getWriter();
        
		
		
        //조회 (bbs)
        if (request.getRequestURI().endsWith("loadAll.mon")){
			JsonArray list = new JsonArray();
			
				//DBCursor cursor = coll.find();
			
				//페이지 
				int start = Integer.valueOf(request.getParameter("start").toString());
				int perpage = Integer.valueOf(request.getParameter("perpage").toString());
//				System.out.println("test!!!!: "+start);	
//				System.out.println("test!!!!: "+perpage);
			
				
				
				BasicDBObject projection = new BasicDBObject();
				projection.put("title", 1);
				projection.put("contents",1);
				projection.put("date", 1);
				
				BasicDBObject query = new BasicDBObject();
				
				BasicDBObject sort = new BasicDBObject();
				sort.put("date", -1);
				
				int totalcount = 0;
				
				DBCursor cursor2 = coll.find(query);
				totalcount = cursor2.count();
				JsonObject tc = new JsonObject();
				tc.addProperty("totalcount", totalcount);
				
				list.add(tc);
			
				//1=0, 2=10, 3=20, 4=30 >> (현재페이지-1)*10 // 
				//DBCursor cursor = coll.find(query, projection).limit(10).skip(0).sort(sort); //limit : 갯수(10개) skip : 처음시작되는 부분(1,10..)
				DBCursor cursor = coll.find(query, projection).limit(perpage).skip(start).sort(sort);
				while(cursor.hasNext()){
	            	DBObject doc = cursor.next();
	            	System.out.println(doc);
	            	
	            	JsonObject sdoc = DBObjectConvertJsonObject(doc);
	            			
	            	
	            	list.add(sdoc);
	            	
	            	//전체출력
	            	//System.out.println(cursor.next());
	            }        
			
			System.out.println("공지사항 메인");
			
			out.println(list.getAsJsonArray());
			
			
		//추가 (insert)	
		}else if (request.getRequestURI().endsWith("insert.mon")){
			
			String data = getBody(request); //받은 json > String
			JsonParser parser = new JsonParser(); 
			JsonElement xjson = parser.parse(data); //String > json		
			JsonObject reg = xjson.getAsJsonObject(); //json > jsonObject
			
			//console창에 출력되는 부분- 정보가 잘 넘어왔는지 확인
			System.out.println("insert: "+reg.get("title").getAsString());
			System.out.println("insert: "+reg.get("content").getAsString());
			
			//Date
			SimpleDateFormat format1 = new  SimpleDateFormat("yyyy-MM-dd");			
			Date time = new Date();			
			String date1 = format1.format(time);
			
			//mongoDB로 정보 보내기
			DBObject doc = new BasicDBObject();
			doc.put("title", reg.get("title").getAsString());
			doc.put("contents", reg.get("content").getAsString());
			doc.put("date", date1);
			
			coll.insert(doc);
			
			//json형태로 success부분에 받고 싶은 정보 입력
			JsonObject res = new JsonObject();
			res.addProperty("result", "OK"); //json형태
			
			//PrintWriter에 관련한 변수명 : out //서버에서 정보를 받고 내려오는 부분(String으로)
			out.println(res.getAsJsonObject());
		
		
		//상세페이지 (view)
		}else if(request.getRequestURI().endsWith("load.mon")){
			String data = getBody(request);
			//System.out.println(data);
			JsonParser parser = new JsonParser();
			JsonElement xjson = parser.parse(data);
			JsonObject reg = xjson.getAsJsonObject();
			
			System.out.println("상세페이지 : "+reg.get("key").getAsString());
			
			//mongoDB >>_id를 이용해 title, contents, date정보 받아오기
			
			BasicDBObject query = new BasicDBObject();
			query.put("_id", new ObjectId(reg.get("key").getAsString()));
			
			DBObject dboj = coll.findOne(query);
			
			System.out.println(dboj);			
			out.println(dboj);
			
		
		//삭제 (delete)	
		}else if(request.getRequestURI().endsWith("delete11.mon")){
			String data = getBody(request);
			//System.out.println(data);
			JsonParser parser = new JsonParser();
			JsonElement xjson = parser.parse(data);
			JsonObject reg = xjson.getAsJsonObject();
			
			System.out.println("삭제완료 : "+reg.get("key").getAsString());
			
			//mongoDB 
			BasicDBObject query = new BasicDBObject();
			query.put("_id", new ObjectId(reg.get("key").getAsString()));
			
			coll.remove(query);
			
			JsonObject res = new JsonObject();
			res.addProperty("result", "OK");
			out.println(res.getAsJsonObject());
		
			
		//수정 (update)
		}else if(request.getRequestURI().endsWith("update11.mon")){
			
			String data = getBody(request);
			JsonParser parser = new JsonParser();
			JsonElement xjson = parser.parse(data);
			JsonObject reg = xjson.getAsJsonObject();
			
			//System.out.println(reg.get("key").getAsString());
			//System.out.println(reg.get("title").getAsString());
			//System.out.println(reg.get("contents").getAsString());
			
			//mongoDB
//			DBObject id = new BasicDBObject("_id", new ObjectId(reg.get("key").getAsString()));
//			DBObject title = new BasicDBObject("$set",new BasicDBObject("title", reg.get("title").getAsString()));
//			DBObject contents = new BasicDBObject("$set",new BasicDBObject("contents", reg.get("contents").getAsString()));
//			coll.update(id, title);
//			coll.update(id, contents);
			
			BasicDBObject query = new BasicDBObject();
			query.put("_id", new ObjectId(reg.get("key").getAsString()));
			
			//System.out.println("query : " + query);
			
			BasicDBObject rdata = new BasicDBObject();
			rdata.put("title", reg.get("title").getAsString());
			rdata.put("contents", reg.get("contents").getAsString());
			
			BasicDBObject se = new BasicDBObject();
			se.put("$set", rdata);
			
			coll.update(query, se);
			
			
			
			//json형태로 success부분에 받고 싶은 정보 입력
			JsonObject res = new JsonObject();
			res.addProperty("result", "OK"); //json형태
			
			//PrintWriter에 관련한 변수명 : out //서버에서 정보를 받고 내려오는 부분(String으로)
			out.println(res.getAsJsonObject());
			
		
		}else if(request.getRequestURI().endsWith("test.mon")){
			String data = getBody(request);
	
//			System.out.println("file data: "+data);
//			System.out.println(request.getServletContext());
//			System.out.println(request.getContentType());
			
			
			String CHARSET = "utf-8";
			String ATTACHES_DIR = "C:\\File_Attached";
			
	        response.setContentType("text/html; charset=UTF-8");
	        request.setCharacterEncoding(CHARSET);
	        PrintWriter out1 = response.getWriter();
	 
	 
	        File attachesDir = new File(ATTACHES_DIR);
	 
	        DiskFileItemFactory fileItemFactory = new DiskFileItemFactory();
	        fileItemFactory.setRepository(attachesDir);
	        ServletFileUpload fileUpload = new ServletFileUpload(fileItemFactory);

	        
	        try {
	            List<FileItem> items = fileUpload.parseRequest((RequestContext) request);
	            for (FileItem item : items) {
	                if (item.isFormField()) {
	                    System.out.printf("파라미터 명 : %s, 파라미터 값 :  %s \n", item.getFieldName(), item.getString(CHARSET));
	                } else {
	                    System.out.printf("파라미터 명 : %s, 파일 명 : %s,  파일 크기 : %s bytes \n", item.getFieldName(),
	                            item.getName(), item.getSize());
	                    if (item.getSize() > 0) {
	                        String separator = File.separator;
	                        int index =  item.getName().lastIndexOf(separator);
	                        String fileName = item.getName().substring(index  + 1);
	                        File uploadFile = new File(ATTACHES_DIR +  separator + fileName);
	                        item.write(uploadFile);
	                    }
	                }
	            }
	 
	 
	            out.println("<h1>파일 업로드 완료</h1>");
	 
	 
	        } catch (Exception e) {
	            // 파일 업로드 처리 중 오류가 발생하는 경우
	            e.printStackTrace();
	            out.println("<h1>파일 업로드 중 오류가  발생하였습니다.</h1>");
	        }

		}
        

	}
	
	
	
	//-----------------------------------------------------------------------------------
	
	
	private DBObject JsonConvertDBObject(JsonObject doc){
		Object o = JSON.parse(doc.toString());
		DBObject oo = (DBObject) o;
		return oo;
	}
	
	
	private JsonObject DBObjectConvertJsonObject(DBObject doc){
		JsonParser jp = new JsonParser();
		JsonElement je = jp.parse(doc.toString());
		
		return je.getAsJsonObject();
	}
	
	
	public static String getBody(HttpServletRequest request) throws IOException {
		 
        String body = null;
        StringBuilder stringBuilder = new StringBuilder();
        BufferedReader bufferedReader = null;
 
        try {
            InputStream inputStream = request.getInputStream();
            if (inputStream != null) {
                bufferedReader = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
                char[] charBuffer = new char[128];
                int bytesRead = -1;
                while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {     	
                	
                	
                    stringBuilder.append(charBuffer, 0, bytesRead);
                  
                }
            }
        } catch (IOException ex) {
            throw ex;
        } finally {
            if (bufferedReader != null) {
                try {
                    bufferedReader.close();
                } catch (IOException ex) {
                    throw ex;
                }
            }
        }
 
        body = stringBuilder.toString();
        body =  cleanXSS(body);    
        return body;
    }
	
	
	private static String cleanXSS(String value) {      

		  //You'll need to remove the spaces from the html entities below    
		  
		  value = value.replaceAll("<", "&lt;").replaceAll(">", "&gt;");         
		  
		  value = value.replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");         
		  
		  value = value.replaceAll("'", "&#39;");        
		  
		  value = value.replaceAll("eval\\((.*)\\)", "");         
		  
		  value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");         
		  
		  value = value.replaceAll("script", "");         
		  
		  return value;     
		  
	} 
	
}
