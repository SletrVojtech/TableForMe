<%--
  Created by IntelliJ IDEA.
  User: vojte
  Date: 25.01.2021
  Time: 22:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Nastavení restaurace</title>
</head>
<%
    String uid = (String) session.getAttribute("owner");
    if (uid == null) {
        response.sendRedirect("login.jsp");
    } else {


%>
<body>
<div style="align-content: center; text-align: center">
    <form action="savesetup.jsp" method="post">
        <h1>Nastavte prosím informace o restauraci</h1><br>
        <h3>Poloha</h3>
        <input type="text" placeholder="Město" name="city" pattern="^\\p{L}*$" required>
        <input type="text" placeholder="Ulice a č.p." name="adress" required>
        <br>
        <h3>Otevírací doba</h3>

        <label for="01">Pondělí: od</label>
        <input type="time" id="01" name="01" placeholder="Otevírací doba" value="10:00"/>
        <label for="02">do</label>
        <input type="time" name="02" id="02" placeholder="Zavírací doba" value="20:00"/> <br>

        <label for="01">Úterý: od</label>
        <input type="time" id="11" name="11" placeholder="Otevírací doba" value="10:00"/>
        <label for="02">do</label>
        <input type="time" name="12" id="12" placeholder="Zavírací doba" value="20:00"/> <br>

        <label for="01">Středa: od</label>
        <input type="time" id="21" name="21" placeholder="Otevírací doba" value="10:00"/>
        <label for="02">do</label>
        <input type="time" name="22" id="22" placeholder="Zavírací doba" value="20:00"/> <br>

        <label for="01">Čtvrtek: od</label>
        <input type="time" id="31" name="31" placeholder="Otevírací doba" value="10:00"/>
        <label for="02">do</label>
        <input type="time" name="32" id="32" placeholder="Zavírací doba" value="20:00"/> <br>

        <label for="01">Pátek: od</label>
        <input type="time" id="41" name="41" placeholder="Otevírací doba" value="10:00"/>
        <label for="02">do</label>
        <input type="time" name="42" id="42" placeholder="Zavírací doba" value="20:00"/> <br>

        <label for="01">Sobota: od</label>
        <input type="time" id="51" name="51" placeholder="Otevírací doba" value="10:00"/>
        <label for="02">do</label>
        <input type="time" name="52" id="52" placeholder="Zavírací doba" value="20:00"/> <br>

        <label for="01">Neděle: od</label>
        <input type="time" id="61" name="61" placeholder="Otevírací doba" value="10:00"/>
        <label for="02">do</label>
        <input type="time" name="62" id="62" placeholder="Zavírací doba" value="20:00"/> <br> <br>

        <h3>Kapacity restaurace</h3>
        <p>Kapacitu zadávejte prosím do následujícího pole ve formátu: kapacita stolu/počet stolů,kapacita stolu...</p>
        <input type="text" name="capacity" placeholder="2/6,4/5,8/2" pattern="[0-9/,].{3,}" required><br><br>
        <button type="submit">Založit restauraci</button>


    </form>
</div>
</body>
</html>
<%
    }
%>