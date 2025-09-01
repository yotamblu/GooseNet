<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="PlannedWorkouts.aspx.cs" Inherits="GooseNet.PlannedWorkouts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://d3js.org/d3.v7.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    <script src="https://cdn.plot.ly/plotly-2.27.0.min.js" charset="utf-8"></script>
    <%-- Removed inline style block. All styles will be handled by Style.css or Tailwind classes. --%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-4 py-8 max-w-4xl">
        <h1 class="text-4xl font-extrabold text-white mb-8 text-center">Your Planned Workouts</h1>

        <div class="flex flex-col items-center mb-8">
            <label for="dateInput" class="text-lg font-semibold text-white mb-2">Select a Date:</label>
            <input id="dateInput" type="date"
                   class="w-full max-w-xs p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400 transition-all duration-200" />
        </div>

        <div id="workoutContainer" class="grid grid-cols-1 gap-6">
            <span id="initialMessage" class="text-center text-xl font-bold text-gray-300 p-8 rounded-lg glass-panel">
                Select a date to view your planned workouts!
            </span>
        </div>
    </div>
    
    <%-- Script is moved to the end of Content2 to ensure DOM elements are loaded --%>
    <script src="PlannedWorkoutsScript.js"></script>
</asp:Content>
