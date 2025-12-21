package com.voting.servlet;

import com.voting.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Enumeration;

@WebServlet("/UpdateScheduleServlet")
public class UpdateScheduleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection con = DBConnection.getConnection()) {

            Enumeration<String> params = request.getParameterNames();
            while(params.hasMoreElements()) {
                String paramName = params.nextElement();
                if(paramName.startsWith("slot_")) {
                    int id = Integer.parseInt(paramName.split("_")[1]);
                    String slot = request.getParameter(paramName);

                    String sql = "UPDATE PerformanceSchedule SET slot=? WHERE id=?";
                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, slot);
                        ps.setInt(2, id);
                        ps.executeUpdate();
                    }
                }
            }

            response.sendRedirect("schedule.jsp");

        } catch(Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error updating schedule: " + e.getMessage());
        }
    }
}

