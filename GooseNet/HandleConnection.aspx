<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="HandleConnection.aspx.cs" Inherits="GooseNet.HandleConnection" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Connection Successful</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-6 text-center">
        <div class="max-w-xl mx-auto">
            <div class="glass-panel p-8 md:p-12 rounded-3xl shadow-2xl">
                <div class="mb-6">
                    <div class="bg-green-500/20 w-16 h-16 rounded-2xl flex items-center justify-center mx-auto">
                        <svg class="w-8 h-8 text-green-300" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                    </div>
                </div>

                <h2 class="text-3xl font-bold text-white mb-4">Connection Successful!</h2>

                <p class="text-lg text-gray-200 mb-8">
                    You are now connected with coach <strong class="text-white font-semibold"><%= Request.QueryString["CoachName"] %></strong>.
                </p>

                <div class="flex justify-center">
                    <a href="HomePage.aspx" 
                       class="bg-white text-blue-600 font-bold px-8 py-3 rounded-full text-lg hover:bg-opacity-90 transform hover:scale-105 transition-all duration-300 shadow-xl">
                        Back to Home
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
