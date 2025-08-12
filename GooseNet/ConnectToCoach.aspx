<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ConnectToCoach.aspx.cs" Inherits="GooseNet.ConnectToCoach" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%-- Removed inline style block. All styles are now handled by Tailwind classes. --%>
    <title>Connect to Coach</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-4 py-8 flex items-center justify-center min-h-[calc(100vh-100px)]"> <%-- Adjusted min-height to account for navbar --%>
        <%if (Session["alreadyConnectedToCoach"] != null && (bool)Session["alreadyConnectedToCoach"] == true) { %>
            <div class="glass-panel rounded-xl p-6 mb-6 shadow-lg text-center max-w-md mx-auto bg-red-800 bg-opacity-30 border border-red-500">
                <p class="text-red-300 font-semibold text-lg">Already Connected To this Coach, Try Again!</p>
            </div>
            <% Session["alreadyConnectedToCoach"] = null; %>
        <% } %>
        <form action="ConfirmConnection.aspx" method="get"
              class="glass-panel rounded-xl p-8 md:p-12 shadow-2xl text-center max-w-lg w-full space-y-6">
            
            <h3 class="text-3xl md:text-4xl font-extrabold text-white mb-6">Enter Coach ID Here!</h3>
            
            <div>
                <label for="coachId" class="block text-white text-lg font-semibold mb-2">Coach ID</label>
                <input type="text" name="CoachId" id="coachId" placeholder="Enter Coach ID"
                       class="w-full p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400" />
            </div>
            
            <button type="submit"
                    class="w-full bg-blue-600 text-white font-semibold px-6 py-3 rounded-full shadow-md hover:bg-blue-700 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-75">
                Connect
            </button>
        </form>
    </div>
</asp:Content>
