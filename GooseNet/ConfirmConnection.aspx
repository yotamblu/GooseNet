<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ConfirmConnection.aspx.cs" Inherits="GooseNet.ConfirmConnection" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Confirm Connection</title>
    <%-- The inline style block has been removed to use the main stylesheet --%>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-6 text-center">
        <div class="max-w-xl mx-auto">
            <!-- Confirmation Panel -->
            <div class="glass-panel p-8 md:p-12 rounded-3xl shadow-2xl">
                <div class="mb-6">
                    <div class="bg-blue-400/20 w-16 h-16 rounded-2xl flex items-center justify-center mx-auto">
                        <svg class="w-8 h-8 text-blue-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1"></path></svg>
                    </div>
                </div>

                <h2 class="text-3xl font-bold text-white mb-4">Confirm Connection</h2>

                <p class="text-lg text-gray-200 mb-8">
                    Do you wish to connect with coach <strong class="text-white font-semibold"><%=GetCoachName()%></strong>?
                </p>

                <div class="flex justify-center items-center space-x-4">
                    <!-- The href contains the dynamic C# call to get the coach's name -->
                    <a href="HandleConnection.aspx?CoachName=<%=GetCoachName() %>" 
                       class="bg-white text-blue-600 font-bold px-8 py-3 rounded-full text-lg hover:bg-opacity-90 transform hover:scale-105 transition-all duration-300 shadow-xl">
                        Confirm Connection
                    </a>
                    <!-- A cancel button to go back to the previous page -->
                    <a href="javascript:history.back()" 
                       class="bg-white/20 border border-white/30 text-white font-medium px-8 py-3 rounded-full text-lg hover:bg-white/30 transform hover:scale-105 transition-all duration-300">
                        Cancel
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>