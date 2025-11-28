<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AddStrengthWorkout.aspx.cs" Inherits="GooseNet.AddStrengthWorkout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .container {
            max-width: 700px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            font-size:1.75em;
        }

       *{
                       font-weight: bold;

       }
        label {
            font-weight: bold;
            color: #333;
        }
       
        input, textarea {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 15px;
            border-radius: 8px;
            border: 1px solid #b0c4de;
            font-size: 20px !important;
        }

        .drill {
            border: 2px solid #9ea3bf;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 15px;
            background: #4d5999;
        }


       
        button:not(#mobileMenuToggle){
            
            display: block;
 width: 100%;
 margin: 16px auto;
 padding: 18px;
 font-size: 1.25rem;
 background-color: #03cbe8 !important;
 color: white;
 border: none;
 border-radius: 14px;
 cursor: pointer;
 transition: background-color 0.3s ease, transform 0.2s ease;
 font-weight: 600;
 box-shadow: 0 5px 10px rgba(0, 170, 255, 0.4); 
        }

        button:hover {
            background: #0d47a1;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container">
    <h2>GooseNet Strength Workout Builder</h2>

    <label>Workout Name</label>
    <input id="workoutName" <%=isFromLibrary ? $"value={strengthWorkout.WorkoutName}" : "" %> placeholder="Leg Day, Push Day, Upper Body...">

    <label>Workout Description</label>
    <textarea id="workoutDesc" <%=isFromLibrary ? $"value={strengthWorkout.WorkoutDescription}" : "" %>  rows="3" placeholder="Short explanation of the workout"><%=isFromLibrary ? strengthWorkout.WorkoutDescription : "" %></textarea>

    <label>Workout Date</label>
    <input id="workoutDate" type="date">

    <h3>Drills</h3>
    <div id="drillsContainer">
        <%=isFromLibrary ? GetDrillsHtml() : "" %>

    </div>
    <center>
    <button  onclick="addDrill()">Add Drill</button>
        <button style="margin-top:2vh" onclick="submitWorkout()" type="submit">Submit</button>
        </center>
    </div >


  

<script>

    
    function addDrill() {
        const container = document.getElementById("drillsContainer");

        const div = document.createElement("div");
        div.className = "drill";

        div.innerHTML = `
            <label>Drill Name</label>
            <input class="drill-name" placeholder="Bench Press, Squats, etc">

            <label>Number of Sets</label>
            <input class="drill-sets" type="number" min="1" placeholder="3">

            <label>Reps Per Set</label>
            <input class="drill-reps" type="number" min="1" placeholder="10">
        `;

        container.appendChild(div);
    }

    function generateJSON() {
        const workout = {
            WorkoutName: document.getElementById("workoutName").value,
            WorkoutDescription: document.getElementById("workoutDesc").value,
            WorkoutDate: document.getElementById("workoutDate").value,
            WorkoutDrills: []
        };

        const drills = document.querySelectorAll(".drill");

        drills.forEach(d => {
            workout.WorkoutDrills.push({
                DrillName: d.querySelector(".drill-name").value,
                DrillSets: parseInt(d.querySelector(".drill-sets").value),
                DrillReps: parseInt(d.querySelector(".drill-reps").value)
            });
        });

        return JSON.stringify(workout, null, 4);
    }

    function hasValidationErrors() {

        // 1. Check if there are NO drills
        const drills = document.querySelectorAll(".drill");
        if (drills.length === 0) {
            alert("You must add at least one drill.");
            return true;
        }

        // 2. Check all regular inputs + textarea EXCEPT the JSON output
        const fields = document.querySelectorAll("input:not(.drill-name):not(.drill-sets):not(.drill-reps), textarea:not(#jsonOutput)");
        for (let f of fields) {
            if (f.value.trim() === "") {
                alert("Please fill all workout fields.");
                f.focus();
                return true;
            }
        }

        // 3. Check ALL drill inputs
        const drillInputs = document.querySelectorAll(".drill input");
        for (let d of drillInputs) {
            if (d.value.trim() === "") {
                alert("Please fill all drill fields.");
                d.focus();
                return true;
            }
        }

        return false; // all good
    }





    function submitWorkout() {
        if (!hasValidationErrors()) {
            console.log("submitting workout...")

            window.location.href = "HandleStrengthWorkout.aspx<%=GetTargetParam()%>&json="  + generateJSON()  ;
           
        }
      
    }
</script>
</asp:Content>
