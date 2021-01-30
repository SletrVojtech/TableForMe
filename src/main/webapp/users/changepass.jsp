<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 19:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="head.jsp" %>

<head>
    <title>Změna hesla</title>
</head>


<%
    if (uid == null) {
        response.sendRedirect("menu.jsp");
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
<div class="d-flex justify-content-center">


    <form action="savepass.jsp" method="post">
        <div class="form-group ">
            <label for="oldpass">Zadejte staré heslo:</label>
            <input type="password" class="form-control" id="oldpass" name="oldpass" minlength="8" maxlength="15"
                   pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}">
        </div>

        <%
            //https://www.w3schools.com/tags/att_input_pattern.asp
        %>
        <div class="form-group ">
            <p>Heslo musí obsahovat 8-15 znaků včetně alespoň jedné číslice, malého a velkého písmene</p>
            <label for="pass">Zadejte heslo:</label>
            <input type="password" class="form-control" id="pass" name="pass" minlength="8" maxlength="15"
                   pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}">
        </div>
        <div class="form-group ">
            <label for="pass2">Zadejte heslo znovu:</label>
            <input type="password" class="form-control" id="pass2" name="pass2" minlength="8" maxlength="15"
                   pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}">
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
