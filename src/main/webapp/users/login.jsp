<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 12:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="head.jsp" %>
<head>

    <title>Přihlášení uživatele</title>
</head>
<%
    String err = request.getParameter("err");
    if (err == null) {
        err = "";
    } else if (err.equals("1")) {
        err = "Špatné přihlašovací údaje";
    }
    session.setAttribute("refreshcount", 1);
%>


<div class="d-flex justify-content-center flex-column">
    <div class="d-flex justify-content-center">

        <form action="menu.jsp" method="post">
            <div class="form-group ">
                <label for="name">Zadejte uživatelské jméno:</label>
                <input type="text" class="form-control" id="name" name="username" placeholder="VelkyHladovec"
                       maxlength="20"
                       pattern="[A-Za-z0-9]{3,}">
            </div>

            <%
                //https://www.w3schools.com/tags/att_input_pattern.asp
            %>
            <div class="form-group ">
                <label for="pass">Zadejte heslo:</label>
                <input type="password" class="form-control" id="pass" name="password" minlength="8" maxlength="15"
                       pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}">
            </div>
            <%=err%><br>
            <button type="submit" class="btn btn-primary">Přihlásit se</button>
        </form>
    </div>
    <div class="d-flex justify-content-center">
        <form action="registration.jsp" method="post">
            <button type="submit" class="btn btn-primary">Jěště nemám účet</button>
        </form>
    </div>
</div>
</body>
</html>
