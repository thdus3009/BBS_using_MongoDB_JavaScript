package com.test.test1;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.bson.types.ObjectId;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import com.mongodb.WriteConcern;

@WebServlet("/Reply.gu")

public class Reply extends HttpServlet{

	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		req.setCharacterEncoding("UTF-8");
		resp.setCharacterEncoding("UTF-8"); 
		resp.setContentType("text/html; charset=UTF-8");
		
        //DB
        MongoClient mongoClient = null;
        DBCollection coll = null;
        PrintWriter out = resp.getWriter();
        
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

        //내용입력
		String id = req.getParameter("id").toString();
		String reply = req.getParameter("reply").toString();
		String nick_name = req.getParameter("nick_name").toString();
		

		BasicDBObject query = new BasicDBObject();
		query.put("_id", new ObjectId(id));
		
		//"배열" > "nick_name,reply", "nick_name,reply", s"nick_name,reply"...
		//db.test.update({"title":"wwww"}, {$push: {"reply": ["내용","두개이상"] }});
		
		DBObject rdata = new BasicDBObject("reply",new BasicDBObject("nick_name",nick_name).append("reply_contents",reply));
		
		DBObject se = new BasicDBObject("$push", rdata);
		
		coll.update(query, se);
		
/*		List<BasicDBObject> list = new ArrayList<>();
		list.add(new BasicDBObject(nick_name,reply));
		
		BasicDBObject rdata = new BasicDBObject();
		rdata.put("reply",list);
		
		BasicDBObject se = new BasicDBObject();
		se.put("$push", rdata);
		
		coll.update(query, se);*/
		
		
		
		//json형태로 success부분에 받고 싶은 정보 입력

		query.put("_id", new ObjectId(id));
		
		DBObject dboj = coll.findOne(query);
		
		out.println(dboj);
		
/*		JsonObject res = new JsonObject();
		res.addProperty("result", "OK"); //json형태 (res.result)
		
		//PrintWriter에 관련한 변수명 : out //서버에서 정보를 받고 내려오는 부분(String으로)
		out.println(res.getAsJsonObject());*/
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
