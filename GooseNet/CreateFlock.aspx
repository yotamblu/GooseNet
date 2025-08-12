<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="CreateFlock.aspx.cs" Inherits="GooseNet.CreateFlock" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%-- Removed inline style block. All styles are now handled by Tailwind classes. --%>
    <title>Create Flock</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-4 py-8 flex items-center justify-center min-h-[calc(100vh-100px)]"> <%-- Adjusted min-height to account for navbar --%>
        <%HandleFlockExistsError(); %>
        <form method="post" action="HandleFlockCreation.aspx"
              class="glass-panel rounded-xl p-8 md:p-12 shadow-2xl text-center max-w-lg w-full space-y-6">
            
            <h1 class="text-4xl md:text-5xl font-extrabold text-white mb-6">Create Flock</h1>
            
            <div>
                <label for="flockNameInput" class="block text-white text-lg font-semibold mb-2">Flock Name</label>
                <input type="text" id="flockNameInput" name="FlockName" placeholder="Enter flock name"
                       class="w-full p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400" />
            </div>
            
            <button type="submit"
                    class="w-full bg-blue-600 text-white font-semibold px-6 py-3 rounded-full shadow-md hover:bg-blue-700 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-75">
                Submit
            </button>
        </form>
    </div>
</asp:Content>
