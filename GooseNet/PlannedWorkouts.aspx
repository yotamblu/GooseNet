<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="PlannedWorkouts.aspx.cs" Inherits="GooseNet.PlannedWorkouts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <script src="https://d3js.org/d3.v7.min.js"></script>
    <style>
   
     .container {
        max-width: 600px;
        margin: auto;
        background: white;
        padding: 16px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
        border: 1px solid #ddd;
        margin-top:30px;
      
        }
     p ,strong , h3,h2,span  {color:black;}

    .map {
        width: 100%;
        height: 300px;
        margin-bottom: 20px;
    }
    .bar-container {
        display: flex;
        margin-top:-100px;
       justify-content: center;
        width: 100%;
        padding-top: -100px;
        /* position: relative;
        right: 1%; */
        height: fit-content;
 
    }
    .bar {
        stroke: #000;
        stroke-width: 1px;
    }
    .tooltip {
        position: absolute;
        background: rgba(0, 0, 0, 0.7);
        color: white;
        padding: 5px;
        border-radius: 5px;
        font-size: 12px;
        display: none;
    }
  
    

</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input id="dateInput"type="date"/>

    


    <div id="workoutContainer">

        <h1>Select A date to view the Planned Workouts for it!</h1>

    </div>
    <script src="PlannedWorkoutsScript.js"></script>
    
</asp:Content>
