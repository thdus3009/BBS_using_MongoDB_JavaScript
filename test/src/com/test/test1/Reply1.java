package com.test.test1;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.bson.types.ObjectId;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import com.mongodb.WriteConcern;
import com.mongodb.util.JSON;

public class Reply1 extends HttpServlet{

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(req, resp);
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
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
        
        //댓글 삭제 
        if(request.getRequestURI().endsWith("reply_delete.rpl")){
    		
        	String id = request.getParameter("id").toString();
    		String index = request.getParameter("index").toString();
    		
    		//db.test.update({"_id" : ObjectId("5fb60806b0a63ff30c2a3565")}, {$unset : {"reply.1" : 1 }}) //reply에 대한 1번 인덱스값을 null로 만듬
    		//db.test.update({"_id" : ObjectId("5fb60806b0a63ff30c2a3565")}, {$pull : {"reply" : null}})  //reply에 대한 null값을 삭제

    		System.out.println("댓글 삭제 ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ");
    		System.out.println("삭제할 댓글 index : "+index);
    		
    		BasicDBObject query = new BasicDBObject();
    		query.put("_id", new ObjectId(id));
    		
    		//1 해당 index를 null값으로 만들기
    		BasicDBObject rdata1 = new BasicDBObject();
			rdata1.put("reply."+index, 1);
    		DBObject se1 = new BasicDBObject("$unset", rdata1);   		
    		coll.update(query, se1);
    		
    		//2 null인 부분을 삭제하기
    		BasicDBObject rdata2 = new BasicDBObject();
			rdata2.put("reply", null);
    		DBObject se2 = new BasicDBObject("$pull", rdata2);   		
    		coll.update(query, se2);
    		

    		
    		query.put("_id", new ObjectId(id));
    		
    		DBObject dboj = coll.findOne(query);
    		
    		out.println(dboj);
    		
/*    		JsonObject res = new JsonObject();
    		res.addProperty("result", "OK"); //json형태
    		
    		out.println(res.getAsJsonObject());*/
        
    	//댓글 수정		
        }else if(request.getRequestURI().endsWith("reply_update.rpl")){
        
			String data = getBody(request); //받은 json > String
			JsonParser parser = new JsonParser(); 
			JsonElement xjson = parser.parse(data); //String > json		
			JsonObject reg = xjson.getAsJsonObject(); //json > jsonObject
			
        	String id = reg.get("id").getAsString();
        	String index = reg.get("index").getAsString();
        	String nick_name = reg.get("reply1").getAsString(); //수정될 내용(닉네임)
        	String reply_contents = reg.get("reply2").getAsString(); //수정될 내용(댓글 내용)
        	
        	//db.test.update({"_id" : ObjectId("5fb60806b0a63ff30c2a3565")}, {$set : {"reply.2" : { "nick_name" : "aabb", "reply_contents" : "aaabbbb" } }}) 
        	
        	System.out.println("댓글 수정 ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ");
        	System.out.println("수정할 댓글 index : "+index);
        	
    		BasicDBObject query = new BasicDBObject();
    		query.put("_id", new ObjectId(id));
    		
    		BasicDBObject list = new BasicDBObject();
			list.put("nick_name", nick_name);
			list.put("reply_contents", reply_contents);
			
    		BasicDBObject rdata = new BasicDBObject();
			rdata.put("reply."+index, list);
    		
			DBObject se = new BasicDBObject("$set", rdata);   	
    		
    		coll.update(query, se);
    		
    		query.put("_id", new ObjectId(id));			
			DBObject dboj = coll.findOne(query);
			
			out.println(dboj);
    		
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
