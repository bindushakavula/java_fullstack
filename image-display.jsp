<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, javax.servlet.*" %>
<%
    String userEmail = request.getParameter("userEmail");

    try {
        // Establish database connection
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "tiger");

        // Execute SELECT query
        String selectQuery = "SELECT LICENSE FROM USERS WHERE EMAIL = ?";
        PreparedStatement pstmt = conn.prepareStatement(selectQuery);
        pstmt.setString(1, userEmail);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            Blob licenseBlob = rs.getBlob("LICENSE");
            if (licenseBlob != null) {
                // Retrieve the image data as a byte array
                byte[] imageData = licenseBlob.getBytes(1, (int) licenseBlob.length());

                // Determine the image file extension based on the email
                String fileExtension = "jpg";
                if (userEmail.endsWith(".png")) {
                    fileExtension = "png";
                } else if (userEmail.endsWith(".jpeg") || userEmail.endsWith(".jpg")) {
                    fileExtension = "jpeg";
                }

                // Set the appropriate content type for the image
                String contentType = "image/" + fileExtension;

                // Set the appropriate content type for the response
                response.setContentType(contentType);

                // Write the image data to the response output stream
                OutputStream outputStream = response.getOutputStream();
                outputStream.write(imageData);
                outputStream.flush();
                outputStream.close();
            }
        }

        rs.close();
        pstmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
        // Handle the exception
    }
%>

<html>
<head>
    <title>Image Display</title>
</head>
<body>
    <h1>Image Display</h1>

    <% if (userEmail != null && !userEmail.isEmpty()) { %>
        <h2>Image for user: <%= userEmail %></h2>
        <img src="image-display.jsp?userEmail=<%= userEmail %>" alt="User Image" />
    <% } else { %>
        <p>No image found for the user.</p>
    <% } %>
</body>
</html>
