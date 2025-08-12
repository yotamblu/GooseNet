<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="FlocksMenu.aspx.cs" Inherits="GooseNet.FlocksMenu" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Flocks Menu</title>
    <%-- Removed original inline style block. All styles are now handled by Tailwind classes or Style.css. --%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-4 py-8 flex flex-col items-center justify-center min-h-[calc(100vh-100px)]"> <%-- Adjusted min-height to account for navbar --%>
        <h1 class="text-4xl font-extrabold text-white mb-12 text-center">Manage Your Flocks</h1>

        <div class="flex flex-col md:flex-row items-center justify-center gap-8">
            <a href="MyFlocks.aspx" class="block">
                <button class="glass-panel px-10 py-5 bg-blue-600 text-white font-bold text-xl rounded-full shadow-lg hover:bg-blue-700 transition-colors duration-300 transform hover:scale-105">
                    My Flocks
                </button>
            </a>
            <a href="CreateFlock.aspx" class="block">
                <button class="glass-panel px-10 py-5 bg-green-600 text-white font-bold text-xl rounded-full shadow-lg hover:bg-green-700 transition-colors duration-300 transform hover:scale-105">
                    Create Flock
                </button>
            </a>
        </div>
    </div>
</asp:Content>
