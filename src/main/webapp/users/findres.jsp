<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %><%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 26.01.2021
  Time: 20:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="head.jsp" %>

<head>
    <title>Zadání rezervace</title>
</head>
<%
    DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    Date d = Calendar.getInstance().getTime();
    Calendar c = Calendar.getInstance();
    c.setTime(d);
    c.add(Calendar.DAY_OF_MONTH, 30);
    String date = df.format(d);
    String date2 = df.format(c.getTime());
    String err = request.getParameter("err");
    if (err == null) {
        err = "";
    } else if (err.equals("1")) {
        err = "Na daný termín nelze vytvořit rezervaci";
    }
%>
<br><br>
<form action="resout.jsp" method="post">
    <div class="d-flex justify-content-center">
        <div class="border border-dark rounded d-flex flex-column"
             style="background-color: #DA5151; padding: 5%; color: white">
            <h3>Kde Vám můžeme uvařit?</h3>
            <div class="d-flex flex-row">
                <label for="number" class="p-2">Počet hostů: <b style="color: white">*</b> </label>
                <input type="number" class="p-2 form-control-sm" max="50" min="1" id="number" name="number" required>
                <label for="city" class="p-2">Obec: </label>
                <input type="text" class="p-2 form-control-sm" minlength="2" maxlength="30" id="city" name="city">

            </div>
            <div class="d-flex flex-row">
                <label for="date" class="p-2">Datum rezervace: <b style="color: white">*</b></label>
                <input type="date" class="p-2 form-control-sm" value="<%=date%>" min="<%=date%>" max="<%=date2%>"
                       id="date" name="date" required>
                <label for="time" class="p-2">Čas rezervace: <b style="color: white">*</b></label>
                <input type="time" class="p-2 form-control-sm" id="time" name="time" required>

            </div>
            <br>
            <div class="d-flex flex-row align-items-baseline ">
                <input type="checkbox" class="p-2" id="0" name="0" value="0">
                <label class="p-2" for="0">Česká a tradiční kuchyně</label><br>
                <input type="checkbox" class="p-2" id="1" name="0" value="1">
                <label class="p-2" for="1">Evropská kuchyně</label><br>
                <input type="checkbox" class="p-2" id="2" name="0" value="2">
                <label class="p-2" for="2">Americká kuchyně</label><br>
                <input type="checkbox" class="p-2" id="3" name="0" value="3">
                <label class="p-2" for="3">Asijská kuchyně</label><br>
            </div>
            <label class="p-2">* - povinné údaje</label>
            <%
                if (request.getParameter("id") != null) {
            %>
            <input type="hidden" name="id" value="<%=request.getParameter("id")%>"
            <%
                }
            %>
            <label><%=err%>
            </label>
            <button type="submit" class="btn btn-warning">Vyhledat</button>

        </div>
    </div>
</form>


</body>
</html>
