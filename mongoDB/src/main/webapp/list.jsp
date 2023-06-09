<%@ page import="com.mongodb.client.MongoClients" %>
<%@ page import="com.mongodb.client.MongoClient" %>
<%@ page import="com.mongodb.client.MongoCollection" %>
<%@ page import="com.mongodb.client.MongoDatabase" %>
<%@ page import="org.bson.Document" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
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

    // 컬렉션에서 모든 문서 조회
    List<Document> documents = collection.find().into(new ArrayList<>());


    // MongoDB 연결 종료
    mongoClient.close();

    // 페이징 관련 변수 설정
    int currentPage = 1; // 현재 페이지 번호
    int pageSize = 5; // 한 페이지에 표시할 문서 개수
    int totalDocuments = documents.size(); // 전체 문서 개수
    int totalPages = (int) Math.ceil((double) totalDocuments / pageSize); // 전체 페이지 수

    // 요청으로부터 페이지 번호를 전달받아 현재 페이지 설정
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        currentPage = Integer.parseInt(pageParam);
        if (currentPage < 1) {
            currentPage = 1;
        } else if (currentPage > totalPages) {
            currentPage = totalPages;
        }
    }

    // 현재 페이지에 해당하는 문서 범위 계산
    int startIndex = (currentPage - 1) * pageSize;
    int endIndex = Math.min(startIndex + pageSize, totalDocuments);

    // 현재 페이지에 표시할 문서들을 새로운 List에 복사
    List<Document> currentPageDocuments = documents.subList(startIndex, endIndex);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>조회 결과</title>
    <style>
        h1 {
            font-size: 30px;
            color: #fff;
            text-transform: uppercase;
            font-weight: 300;
            text-align: center;
            margin-bottom: 15px;
        }

        table {
            width: 100%;
            table-layout: fixed;
        }

        .tbl-header {
            background-color: rgba(255, 255, 255, 0.3);
        }

        .tbl-content {
            height: 300px;
            overflow-x: auto;
            margin-top: 0px;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        th {
            padding: 20px 15px;
            text-align: left;
            font-weight: 500;
            font-size: 12px;
            color: #fff;
            text-transform: uppercase;
        }

        td {
            padding: 15px;
            text-align: left;
            vertical-align: middle;
            font-weight: 300;
            font-size: 12px;
            color: #fff;
            border-bottom: solid 1px rgba(255, 255, 255, 0.1);
        }

        /* Pagination */
        .pagination {
            text-align: center;
            margin-top: 20px;
        }

        .pagination a {
            display: inline-block;
            padding: 8px 16px;
            text-decoration: none;
            color: #fff;
            background-color: #0A3D6B;
            border-radius: 5px;
            margin-right: 5px;
        }

        .pagination a.active {
            background-color: #052E51;
        }

        /* demo styles */
        @import url(https://fonts.googleapis.com/css?family=Roboto:400,500,300,700);

        body {
            background: -webkit-linear-gradient(left, #0A3D6B, #052E51);
            background: linear-gradient(to right, #0A3D6B, #052E51);
            font-family: 'Roboto', sans-serif;
        }

        section {
            margin: 50px;
        }

        /* follow me template */
        .made-with-love {
            margin-top: 40px;
            padding: 10px;
            clear: left;
            text-align: center;
            font-size: 10px;
            font-family: arial;
            color: #fff;
        }

        .made-with-love i {
            font-style: normal;
            color: #F50057;
            font-size: 14px;
            position: relative;
            top: 2px;
        }

        .made-with-love a {
            color: #fff;
            text-decoration: none;
        }

        .made-with-love a:hover {
            text-decoration: underline;
        }

        /* for custom scrollbar for webkit browser */
        ::-webkit-scrollbar {
            width: 6px;
        }

        ::-webkit-scrollbar-track {
            -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
        }

        ::-webkit-scrollbar-thumb {
            -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
        }
    </style>
</head>
<body>
<h1>개인 정보 조회 결과</h1>

<table>
    <tr>
        <th>이름</th>
        <th>나이</th>
        <th>연봉</th>
    </tr>
    <% for (Document document : currentPageDocuments) { %>
    <tr>
        <td><%= document.get("name") %></td>
        <td><%= document.get("age") %></td>
        <td><%= document.get("salary") %></td>
    </tr>
    <% } %>
</table>
<div class="pagination">
    <% if (currentPage > 1) { %>
    <a href="?page=<%= currentPage - 1 %>">이전</a>
    <% } %>
    <% for (int i = 1; i <= totalPages; i++) { %>
    <a href="?page=<%= i %>" <%= i == currentPage ? "class=\"active\"" : "" %>><%= i %></a>
    <% } %>
    <% if (currentPage < totalPages) { %>
    <a href="?page=<%= currentPage + 1 %>">다음</a>
    <% } %>
</div>

</body>
</html>
