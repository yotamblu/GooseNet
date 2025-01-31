<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AthleteWorkouts.aspx.cs" Inherits="GooseNet.AthleteWorkouts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    


     <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css" />
    <script src="AthleteWorkoutScript.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="date" id="WorkoutDataDatePicker" onchange="getWorkouts()" /> 
      <div id="workoutsContainer" onchange="setMaps()">
          <span style="color:white;font-weight:bold;font-size:4vw;">Pick A date to Show Workouts From!</span>
      </div>
   
    <script>
        datePicker = document.getElementById('WorkoutDataDatePicker')
        workoutContainer = document.getElementById("workoutsContainer")
    </script>
   
</asp:Content>
