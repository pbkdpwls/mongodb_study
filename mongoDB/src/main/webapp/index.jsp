<%@ page import="com.mongodb.client.MongoClients" %>
<%@ page import="com.mongodb.client.MongoClient" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="org.bson.Document" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<%
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("name");
    System.out.println(name);
    int age = Integer.parseInt(request.getParameter("age"));
    double salary = Double.parseDouble(request.getParameter("salary"));

    // MongoDB 연결 정보 설정
    String mongoURI = "mongodb://localhost:27017";  // MongoDB URI
    String dbName = "db01";  // 데이터베이스 이름
    String collectionName = "tiger";  // 컬렉션 이름

    // MongoDB 클라이언트 초기화
    MongoClient mongoClient = MongoClients.create(mongoURI);

    // MongoDB 데이터베이스 선택
    MongoDatabase database = mongoClient.getDatabase(dbName);

    // MongoDB 컬렉션 선택
    MongoCollection<Document> collection = database.getCollection(collectionName);

    // 새 문서 생성
    Document document = new Document("name", name)
            .append("age", age)
            .append("salary", salary);

    // 문서를 컬렉션에 삽입
    collection.insertOne(document);

    // MongoDB 연결 종료
    mongoClient.close();

    response.sendRedirect("list.jsp");
%>

