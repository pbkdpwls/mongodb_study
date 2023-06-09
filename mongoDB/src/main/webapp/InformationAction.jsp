<%--
  Created by IntelliJ IDEA.
  User: holid
  Date: 2023-06-08
  Time: 오후 4:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.mongodb.client.MongoClients" %>
<%@ page import="com.mongodb.client.MongoClient" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="org.bson.Document" %>
<%@ page import="com.mongodb.MongoException" %>

<%
    // MongoDB 연결 설정
    String connectionString = "mongodb://localhost:27017";  // MongoDB 연결 문자열
    String databaseName = "db01";  // 사용할 데이터베이스 이름
    String collectionName = "people";  // 사용할 컬렉션 이름

    // MongoDB 클라이언트 및 데이터베이스 생성
    MongoClient mongoClient = MongoClients.create(connectionString);
    MongoDatabase database = mongoClient.getDatabase(databaseName);

    // 컬렉션 가져오기 또는 생성
    MongoCollection<Document> collection = database.getCollection(collectionName);

    // 폼 데이터 가져오기
    String name = request.getParameter("name");
    int age = Integer.parseInt(request.getParameter("age"));
    int salary = Integer.parseInt(request.getParameter("salary"));

    // 사용자 정보를 Document 객체로 생성
    Document user = new Document();
    user.append("name", name)
            .append("age", age)
            .append("salary", salary);

    try {
        // MongoDB에 사용자 정보 추가

        collection.insertOne(user);
        System.out.println("사용자 정보가 MongoDB에 저장되었습니다.");
        response.sendRedirect("showInformation.jsp");
    } catch (MongoException e) {
        System.out.println("MongoDB에 사용자 정보를 저장하는 중 오류가 발생했습니다: " + e.getMessage());
    } finally {
        // MongoDB 클라이언트 닫기
        mongoClient.close();
    }
%>
