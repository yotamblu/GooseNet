<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AccMgmtMenu.aspx.cs" Inherits="GooseNet.AccMgmtMenu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>GooseNet - Account Management</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-6">
        <h1 class="text-4xl md:text-5xl font-extrabold mb-8 text-center" style="text-shadow: 0 4px 20px rgba(0,0,0,0.2);">
            Account Management
        </h1>

        <div class="max-w-lg mx-auto">
            <!-- Settings Panel -->
            <div class="glass-panel p-6 md:p-8 rounded-3xl shadow-2xl">
                <div class="space-y-4">
                    <!-- Change Profile Picture Link -->
                    <a href="ChangeProfilePic.aspx" class="flex items-center p-4 rounded-2xl hover:bg-white/10 transition-all duration-300">
                        <div class="bg-cyan-400/20 w-12 h-12 rounded-lg flex items-center justify-center mr-4">
                            <svg class="w-6 h-6 text-cyan-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                        </div>
                        <div>
                            <span class="text-lg font-semibold text-white">Change Profile Picture</span>
                            <p class="text-sm text-gray-300">Update your avatar</p>
                        </div>
                        <div class="ml-auto">
                            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
                        </div>
                    </a>

                    <!-- Change Password Link -->
                    <a href="ChangePassword.aspx" class="flex items-center p-4 rounded-2xl hover:bg-white/10 transition-all duration-300">
                        <div class="bg-purple-400/20 w-12 h-12 rounded-lg flex items-center justify-center mr-4">
                            <svg class="w-6 h-6 text-purple-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                        </div>
                        <div>
                            <span class="text-lg font-semibold text-white">Change Password</span>
                            <p class="text-sm text-gray-300">Update your security credentials</p>
                        </div>
                        <div class="ml-auto">
                            <svg class="w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
