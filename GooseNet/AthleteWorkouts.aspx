<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AthleteWorkouts.aspx.cs" Inherits="GooseNet.AthleteWorkouts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
    <%-- AthleteWorkoutScript.js will be loaded at the end of Content2 --%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-4 py-8 max-w-4xl">
        <h1 class="text-4xl font-extrabold text-white mb-8 text-center">Your Workouts</h1>

        <div class="flex flex-col items-center mb-8">
            <label for="WorkoutDataDatePicker" class="text-lg font-semibold text-white mb-2">Select a Date:</label>
            <input type="date" id="WorkoutDataDatePicker" onchange="getWorkouts()"
                   class="w-full max-w-xs p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400 transition-all duration-200" />
        </div>
        
        <div id="workoutsContainer" class="grid grid-cols-1 gap-6">
            <span id="initialMessage" class="text-center text-xl font-bold text-gray-300 p-8 rounded-lg glass-panel">
                Pick a date to show workouts from!
            </span>
        </div>
    </div>
    
    <%-- Moved AthleteWorkoutScript.js here to ensure it loads after DOM elements and can initialize variables --%>
    <script src="AthleteWorkoutScript.js"></script>
</asp:Content>
