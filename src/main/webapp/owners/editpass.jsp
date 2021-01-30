<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 8:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="menu.jsp" %>
<head>
    <title>Změna hesla</title>
</head>
<%
    /*
    Zde si může restauratér změnit heslo k restauraci.
     */
    if (uid == null) {
        response.sendRedirect("login.jsp");
    } else {


        String err = request.getParameter("err");
        if (err == null) {
            err = "";
        } else if (err.equals("1")) {
            err = "Zadaná hesla se neshodují";
        } else if (err.equals("2")) {
            err = "Špatné původní heslo";
        }
%>
<br><br>
<h2>Změna hesla</h2><br>
<div class="d-flex justify-content-center">


    <form action="savepass.jsp" method="post">
        <div class="form-group ">
            <label for="oldpass">Zadejte staré heslo:</label>
            <input type="password" class="form-control" id="oldpass" name="oldpass">
        </div>
        <div class="form-group ">
            <label for="pass">Zadejte heslo:</label>
            <input type="password" class="form-control" id="pass" name="newpass">
        </div>
        <div class="form-group ">
            <label for="pass2">Zadejte heslo znovu:</label>
            <input type="password" class="form-control" id="pass2" name="newpass2">
        </div>
        <%=err%><br>
        <button type="submit" class="btn btn-primary">Změnit heslo</button>
    </form>

</div>
</body>
</html>
<%
    }
%>