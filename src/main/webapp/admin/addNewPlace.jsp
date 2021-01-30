<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 25.01.2021
  Time: 9:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Přidání restaurace</title>
</head>
<%
    String uid = (String) session.getAttribute("admin");
    if (uid == null) {
        response.sendRedirect("/TableForMe2/admin/adminLogin.jsp");
    } else {


%>
<body>
<div style="align-content: center">
    <h1>Vytvoření nové restaurace</h1>
    <form method="post" action="${pageContext.request.contextPath}/admin/processNewPlace.jsp" id="newForm"
          accept-charset="utf-8">
        <label for="name">Název restaurace:</label>
        <input type="text" id="name" name="name">
        <br>
        <label for="username">Přihlašovací jméno:</label>
        <input type="text" id="username" name="username">
        <br>
        <label for="password">Heslo pro přihlášení: </label>
        <input type="text" id="password" name="password">
        <br>
        <button type="submit">Založit</button>


    </form>


</div>
</body>
</html>
<%
    }
%>