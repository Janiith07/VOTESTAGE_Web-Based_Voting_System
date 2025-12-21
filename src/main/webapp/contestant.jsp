<%@ page import="java.util.List" %>
<%@ page import="com.voting.dao.CommentDAO" %>
<%@ page import="com.voting.model.Comment" %>

<%
    int contestantId = Integer.parseInt(request.getParameter("id"));
    List<Comment> comments = CommentDAO.getCommentsByContestant(contestantId);
%>

<h2>Comments</h2>
<form action="addComment" method="post">
    <input type="hidden" name="contestantId" value="<%= contestantId %>"/>
    <textarea name="commentText" required></textarea><br/>
    <button type="submit">Post Comment</button>
</form>

<% for (Comment c : comments) { %>
<div>
    <%= c.getCommentText() %> (<%= c.getCommentDate() %>)
</div>
<% } %>
