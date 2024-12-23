<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.io.*, javax.servlet.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<!DOCTYPE html>
<html>
<head>
    <title>Image Upload Result</title>
</head>
<body>
<%
    String userEmail = (String) session.getAttribute("email");
    String username = userEmail.substring(0, userEmail.indexOf("@"));

    try {
        // Check if the request is a multi-part form data
        if (ServletFileUpload.isMultipartContent(request)) {
            // Create a factory for disk-based file items
            DiskFileItemFactory factory = new DiskFileItemFactory();

            // Set the maximum size threshold beyond which files are written directly to disk
            factory.setSizeThreshold(1024 * 1024); // 1MB

            // Create a new file upload handler
            ServletFileUpload upload = new ServletFileUpload(factory);

            // Parse the request
            List<FileItem> items = upload.parseRequest(request);

            // Process each file item
            for (FileItem item : items) {
                if (!item.isFormField()) { // Handle only file fields
                    // Get the input stream of the uploaded image file
                    InputStream imageStream = item.getInputStream();

                    // Establish the database connection
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "tiger");

                    // Prepare the SQL statement
                    String sql = "UPDATE USERS SET LICENSE = ? WHERE EMAIL = ?";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setBinaryStream(1, imageStream);
                    pstmt.setString(2, userEmail); // Replace with the appropriate email

                    // Execute the SQL statement
                    int rowsAffected = pstmt.executeUpdate();

                    // Close the resources
                    pstmt.close();
                    imageStream.close();
                    conn.close();

                    // Check the number of affected rows to verify if the image was stored successfully
                    if (rowsAffected > 0) {
                        %>
                        <h1>Image stored successfully</h1>
                        <%
                    } else {
                        %>
                        <h1>Failed to store the image</h1>
                        <%
                    }
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        %>
        <h1>Error occurred: <%= e.getMessage() %></h1>
        <%
    }
%>
</body>
</html>
