<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="WorkoutSourceSelection.aspx.cs" Inherits="GooseNet.WorkoutSourceSelection" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>GooseNet - Plan a Workout</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-6">
        <h1 class="text-4xl md:text-5xl font-extrabold mb-8 text-center" style="text-shadow: 0 4px 20px rgba(0,0,0,0.2);">
            Plan a Workout
        </h1>

        <div class="max-w-2xl mx-auto">
            <!-- Selection Panel -->
            <div class="glass-panel p-6 md:p-8 rounded-3xl shadow-2xl">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    
                    <!-- Create New Workout Option -->
                    <a href="AddComplexWorkout<%=(Request.QueryString["flockName"] != null ? "ToFlock" : "")%>.aspx<%=GetTargetParam() %>" class="flex flex-col items-center justify-center p-8 rounded-2xl hover:bg-white/10 transition-all duration-300 text-center group">
                        <div class="bg-green-400/20 w-16 h-16 rounded-full flex items-center justify-center mb-4 transform group-hover:scale-110 transition-transform">
                            <svg class="w-8 h-8 text-green-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
                        </div>
                        <span class="text-xl font-semibold text-white">Create New</span>
                        <p class="text-sm text-gray-300 mt-1">Design a workout from scratch.</p>
                    </a>

                    <!-- Choose From Library Option -->
                    <a href="WorkoutLibrary.aspx<%=GetTargetParam() %>" class="flex flex-col items-center justify-center p-8 rounded-2xl hover:bg-white/10 transition-all duration-300 text-center group">
                        <div class="bg-indigo-400/20 w-16 h-16 rounded-full flex items-center justify-center mb-4 transform group-hover:scale-110 transition-transform">
                             <svg class="w-8 h-8 text-indigo-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h7"></path></svg>
                        </div>
                        <span class="text-xl font-semibold text-white">Choose From Library</span>
                        <p class="text-sm text-gray-300 mt-1">Select a Previously-Built Workout.</p>
                    </a>

                </div>
            </div>
        </div>
    </div>
</asp:Content>
