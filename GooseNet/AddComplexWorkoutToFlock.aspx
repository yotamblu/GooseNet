<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AddComplexWorkoutToFlock.aspx.cs" Inherits="GooseNet.AddComplexWorkoutToFlock" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

 <title>Workout Interval Form</title>
 <style>
     body {
         font-family: Arial, sans-serif;
         margin: 20px;
     }
     .interval {
         border: 3px solid #ccc;
         padding: 10px;
         margin: 10px 0;
         border-radius: 5px;
         background-color:#323236;
         position: relative;
     }
     .sub-interval {
         margin-left: 20px;
         padding: 5px;
         border-left: 2px solid #007bff;
     }
     .repeat-step, .rest-step {
         margin-top: 10px;
     }
     .remove-btn {
         position: absolute;
         top: 5px;
         right: 5px;
         background: red;
         color: white;
         border: none;
         padding: 5px;
         cursor: pointer;
     }

     input{
         border:solid;
         color:black;
     }

     button {
     
     background-color:white;
     }

     .interval{
       
     }

     label {
     
     color:white;
        font-weight:bold;
     }

   input ,textarea{
  width: 100%;
  max-width: 400px;
  padding: 12px 16px;
  font-size: 16px;
  border: 2px solid #ddd;
  border-radius: 8px;
  outline: none;
  transition: all 0.3s ease-in-out;
  background-color: #5c5c5e;
  color: #333;
}

input:focus  ,textarea:focus {
  border-color: #007bff;
  background-color: #747478;
  box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
}

input::placeholder ,   textarea::placeholder{
  color: #aaa;
  opacity: 0.8;
}


textarea{
    max-width:1000px;
}

    form {
    position: relative;
    width: fit-content;
    background-color: rgba(255,255,255,0.13);
    margin: auto;
    top: initial;
    left: initial;
    transform: none;
    border-radius: 10px;
    backdrop-filter: blur(10px);
    border: 2px solid rgba(255,255,255,0.1);
    box-shadow: 0 0 40px rgba(8,7,16,0.6);
    padding: 5vw 20vh;
}

  

 </style>
 <script>
     let stepCounter = 1;
     let intervalCount = 0;
     function addInterval(containerId) {
         document.getElementById("intervalCountInput").value++;
         document.getElementById("submitBtn").style.display = "block";
         let container = document.getElementById(containerId);
         let stepId = stepCounter++;
         
         let intervalDiv = document.createElement("div");
         intervalDiv.className = "interval";
         intervalDiv.setAttribute("id", `interval-${stepId}`);
         intervalDiv.innerHTML = `
             <button class="remove-btn" onclick="removeInterval('${stepId}')">X</button>
             <label>Interval Type:</label>
             <select name="step-${stepId}-type" onchange="toggleIntervalType(this, '${stepId}')">
                 <option value="repeat">Workout Step</option>
                 <option value="rest">Rest</option>
             </select>
             
             <div class="repeat-step">
                 <label>Step Count:</label>
                 <input type="number" name="step-${stepId}-steps" min="1" value="1" onchange="generateSubIntervals('${stepId}')">
                 <label>Step Repeat Count:</label>
                 <input type="number" name="step-${stepId}-repeat" min="1" value="1">
                 <div id="sub-${stepId}" class="sub-intervals"></div>
             </div>
             
             <div class="rest-step" style="display: none;">
                 <label>Duration Type:</label>
                 <select name="step-${stepId}-duration-type">
                     <option value="Kilometers">Kilometers</option>
                     <option value="Meters">Meters</option>
                     <option value="Minutes">Minutes</option>
                     <option value="Seconds">Seconds</option>
                 </select>
                 <label>Duration Value:</label>
                 <input type="number" name="step-${stepId}-duration" min="1">
             </div>
         `;
         
         container.appendChild(intervalDiv);
         generateSubIntervals(stepId);
     }
     
     function removeInterval(stepId) {
         let intervalDiv = document.getElementById(`interval-${stepId}`);
         if (intervalDiv) {
             intervalDiv.remove();
         }
         document.getElementById("intervalCountInput").value--;
         if (document.getElementById("intervalCountInput").value == 0) {
             document.getElementById("submitBtn").style.display = "none";

         }
     }
     
     function toggleIntervalType(select, stepId) {
         let intervalDiv = select.parentElement;
         let repeatStep = intervalDiv.querySelector(".repeat-step");
         let restStep = intervalDiv.querySelector(".rest-step");
         
         if (select.value === "repeat") {
             repeatStep.style.display = "block";
             restStep.style.display = "none";
             generateSubIntervals(stepId);
         } else {
             repeatStep.style.display = "none";
             restStep.style.display = "block";
         }
     }
     
     function generateSubIntervals(stepId) {
         let stepsValue = document.querySelector(`input[name='step-${stepId}-steps']`).value || 1;
         let subContainer = document.getElementById(`sub-${stepId}`);
         subContainer.innerHTML = "";
         
         for (let i = 0; i < stepsValue; i++) {
             let subStepId = `${stepId}-${i + 1}`;
             let subIntervalDiv = document.createElement("div");
             subIntervalDiv.className = "sub-interval";
             subIntervalDiv.innerHTML = `
                 <label>Sub Interval ${i + 1} Type:</label>
                 <select name="step-${subStepId}-type">
                     <option value="run" selected>Run</option>
                     <option value="rest">Rest</option>
                 </select>
                 <label>Duration Type:</label>
                 <select name="step-${subStepId}-duration-type">
                     <option value="Kilometers">Kilometers</option>
                     <option value="Meters">Meters</option>
                     <option value="Minutes">Minutes</option>
                     <option value="Seconds">Seconds</option>
                 </select>
                 <label>Duration Value:</label>
                 <input placeholder="Duration of the interval" type="number" name="step-${subStepId}-duration" min="1">
                 <label>Pace:</label>
                 <input type="text" placeholder="Pace for this Interval(mm:ss min/km)" name="step-${subStepId}-pace">
             `;
             subContainer.appendChild(subIntervalDiv);
         }
     }
 </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
 
 <form <%=$"action=\"parseData.aspx?flockName={Request.QueryString["flockName"]}\"" %> method="post">  
     <input type="text" placeholder="Workout Name(Emojis are Highly Recommended 🪿)" name="workoutName"/><br /><br />
        <textarea placeholder="A short Description of the Workout" rows="20" cols="100" style="resize:none;" name="workoutDescription"></textarea><br /><br />
        <input type="date" name="workoutDate" /><br /><br />
        <button type="button" onclick="addInterval('interval-container')">Add Interval</button><br /><br />
         
      <div id="interval-container"></div>
     <input type="number" name="intervalCount" value="0" style="display:none" id="intervalCountInput" />
        
          <button id="submitBtn" style="display:none;">Submit Workout</button>

 </form>



</asp:Content>

