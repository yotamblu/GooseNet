<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AddComplexWorkoutToFlock.aspx.cs" Inherits="GooseNet.AddComplexWorkoutToFlock" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Add Complex Workout to Flock</title>
    <%-- Removed original inline style block --%>
    <script>
        let stepCounter = 1;
        // intervalCount is now managed by the hidden input field directly

        function addInterval(containerId) {
            let intervalCountInput = document.getElementById("intervalCountInput");
            intervalCountInput.value = parseInt(intervalCountInput.value) + 1;

            document.getElementById("submitBtn").style.display = "block";
            let container = document.getElementById(containerId);
            let stepId = stepCounter++;

            let intervalDiv = document.createElement("div");
            // Applied liquid glass and spacing classes to the main interval div
            intervalDiv.className = "interval glass-panel rounded-xl p-6 mb-6 relative shadow-lg";
            intervalDiv.setAttribute("id", `interval-${stepId}`);
            intervalDiv.innerHTML = `
                <button type="button" class="remove-btn absolute top-3 right-3 bg-red-600 text-white rounded-full w-8 h-8 flex items-center justify-center text-lg font-bold hover:bg-red-700 transition-colors" onclick="removeInterval('${stepId}')">X</button>
                <div class="mb-4">
                    <label class="block text-white text-lg font-semibold mb-2">Interval Type:</label>
                    <select name="step-${stepId}-type" onchange="toggleIntervalType(this, '${stepId}')"
                            class="w-full p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
                        <option value="repeat" class="bg-gray-700 text-white">Workout Step</option>
                        <option value="rest" class="bg-gray-700 text-white">Rest</option>
                    </select>
                </div>
                
                <div class="repeat-step">
                    <div class="mb-4">
                        <label class="block text-white text-lg font-semibold mb-2">Step Count:</label>
                        <input type="number" name="step-${stepId}-steps" min="1" value="1" onchange="generateSubIntervals('${stepId}')"
                               class="w-full p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
                    </div>
                    <div class="mb-4">
                        <label class="block text-white text-lg font-semibold mb-2">Step Repeat Count:</label>
                        <input type="number" name="step-${stepId}-repeat" min="1" value="1"
                               class="w-full p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
                    </div>
                    <div id="sub-${stepId}" class="sub-intervals space-y-4 mt-4"></div>
                </div>
                
                <div class="rest-step" style="display: none;">
                    <div class="mb-4">
                        <label class="block text-white text-lg font-semibold mb-2">Duration Type:</label>
                        <select name="step-${stepId}-duration-type"
                                class="w-full p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
                            <option value="Kilometers" class="bg-gray-700 text-white">Kilometers</option>
                            <option value="Meters" class="bg-gray-700 text-white">Meters</option>
                            <option value="Minutes" class="bg-gray-700 text-white">Minutes</option>
                            <option value="Seconds" class="bg-gray-700 text-white">Seconds</option>
                        </select>
                    </div>
                    <div class="mb-4">
                        <label class="block text-white text-lg font-semibold mb-2">Duration Value:</label>
                        <input type="number" name="step-${stepId}-duration" min="1"
                               class="w-full p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
                    </div>
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
            let intervalCountInput = document.getElementById("intervalCountInput");
            intervalCountInput.value = parseInt(intervalCountInput.value) - 1;

            if (parseInt(intervalCountInput.value) === 0) {
                document.getElementById("submitBtn").style.display = "none";
            }
        }

        function toggleIntervalType(select, stepId) {
            let intervalDiv = select.parentElement.parentElement; // Corrected to target the parent interval div
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
            let stepsInput = document.querySelector(`input[name='step-${stepId}-steps']`);
            let stepsValue = stepsInput ? stepsInput.value : 1;
            let subContainer = document.getElementById(`sub-${stepId}`);
            if (!subContainer) return; // Ensure subContainer exists
            subContainer.innerHTML = "";

            for (let i = 0; i < stepsValue; i++) {
                let subStepId = `${stepId}-${i + 1}`;
                let subIntervalDiv = document.createElement("div");
                // Applied Tailwind classes to sub-interval div
                subIntervalDiv.className = "sub-interval border-l-4 border-blue-500 pl-4 py-2 space-y-2 bg-white bg-opacity-5 rounded-md";
                subIntervalDiv.innerHTML = `
                    <label class="block text-white text-md font-medium">Sub Interval ${i + 1} Type:</label>
                    <select name="step-${subStepId}-type"
                            class="w-full p-2 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
                        <option value="run" selected class="bg-gray-700 text-white">Run</option>
                        <option value="rest" class="bg-gray-700 text-white">Rest</option>
                    </select>
                    <label class="block text-white text-md font-medium">Duration Type:</label>
                    <select name="step-${subStepId}-duration-type"
                            class="w-full p-2 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
                        <option value="Kilometers" class="bg-gray-700 text-white">Kilometers</option>
                        <option value="Meters" class="bg-gray-700 text-white">Meters</option>
                        <option value="Minutes" class="bg-gray-700 text-white">Minutes</option>
                        <option value="Seconds" class="bg-gray-700 text-white">Seconds</option>
                    </select>
                    <label class="block text-white text-md font-medium">Duration Value:</label>
                    <input placeholder="Duration of the interval" type="number" name="step-${subStepId}-duration" min="1"
                           class="w-full p-2 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
                    <label class="block text-white text-md font-medium">Pace (mm:ss min/km):</label>
                    <input type="text" placeholder="e.g., 05:30" name="step-${subStepId}-pace"
                           class="w-full p-2 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
                `;
                subContainer.appendChild(subIntervalDiv);
            }
        }

        function loadWorkoutFromJson(json) {
            const workout = typeof json === "string" ? JSON.parse(json) : json;
            const containerId = "interval-container";

            // Clear existing intervals
            const container = document.getElementById(containerId);
            container.innerHTML = "";
            document.getElementById("intervalCountInput").value = 0;
            stepCounter = 1;

            workout.steps.forEach((step) => {
                addInterval(containerId);
                const currentStepId = stepCounter - 1;

                // Set interval type
                const typeSelect = document.querySelector(`select[name='step-${currentStepId}-type']`);
                if (step.type === "WorkoutStep" && step.intensity === "REST") {
                    typeSelect.value = "rest";
                } else {
                    typeSelect.value = "repeat";
                }
                toggleIntervalType(typeSelect, currentStepId);

                if (typeSelect.value === "rest") {
                    const durationInput = document.querySelector(`input[name='step-${currentStepId}-duration']`);
                    const durationTypeSelect = document.querySelector(`select[name='step-${currentStepId}-duration-type']`);

                    // Convert seconds → minutes if whole number divisible by 60
                    if (step.durationType === "TIME") {
                        if (step.durationValue % 60 === 0) {
                            durationTypeSelect.value = "Minutes";
                            durationInput.value = step.durationValue / 60; // convert to minutes
                        } else {
                            durationTypeSelect.value = "Seconds";
                            durationInput.value = step.durationValue; // keep as seconds
                        }
                    }
                    // For distance rest (rare)
                    else if (step.durationType === "DISTANCE") {
                        if (step.durationValue % 1000 === 0) {
                            durationTypeSelect.value = "Kilometers";
                            durationInput.value = step.durationValue / 1000;
                        } else {
                            durationTypeSelect.value = "Meters";
                            durationInput.value = step.durationValue;
                        }
                    }
                } else {
                    // Handle repeat steps
                    const stepsInput = document.querySelector(`input[name='step-${currentStepId}-steps']`);
                    stepsInput.value = step.steps ? step.steps.length : 1;
                    generateSubIntervals(currentStepId);

                    const repeatInput = document.querySelector(`input[name='step-${currentStepId}-repeat']`);
                    repeatInput.value = step.repeatValue || 1;

                    if (step.steps) {
                        step.steps.forEach((sub, index) => {
                            const subId = `${currentStepId}-${index + 1}`;
                            const subTypeSelect = document.querySelector(`select[name='step-${subId}-type']`);
                            subTypeSelect.value = sub.intensity === "INTERVAL" ? "run" : "rest";

                            const subDurationTypeSelect = document.querySelector(`select[name='step-${subId}-duration-type']`);
                            const subDurationInput = document.querySelector(`input[name='step-${subId}-duration']`);

                            // Convert duration
                            if (sub.durationType === "DISTANCE") {
                                if (sub.durationValue % 1000 === 0) {
                                    subDurationTypeSelect.value = "Kilometers";
                                    subDurationInput.value = sub.durationValue / 1000;
                                } else {
                                    subDurationTypeSelect.value = "Meters";
                                    subDurationInput.value = sub.durationValue;
                                }
                            } else if (sub.durationType === "TIME") {
                                if (sub.durationValue % 60 === 0) {
                                    subDurationTypeSelect.value = "Minutes";
                                    subDurationInput.value = sub.durationValue / 60;
                                } else {
                                    subDurationTypeSelect.value = "Seconds";
                                    subDurationInput.value = sub.durationValue;
                                }
                            }

                            // Pace conversion (m/s → min/km)
                            const subPaceInput = document.querySelector(`input[name='step-${subId}-pace']`);
                            if (sub.targetValueLow) {
                                const paceMinutes = Math.floor(1000 / sub.targetValueLow / 60);
                                const paceSeconds = Math.round((1000 / sub.targetValueLow / 60 - paceMinutes) * 60);
                                subPaceInput.value = `${String(paceMinutes).padStart(2, "0")}:${String(paceSeconds).padStart(2, "0")}`;
                            }
                        });
                    }
                }
            });
        }



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-4 py-8 max-w-3xl">
        <h1 class="text-4xl font-extrabold text-white mb-8 text-center">Add Complex Workout to Flock</h1>

        <form <%=$"action=\"parseData.aspx?flockName={Request.QueryString["flockName"]}\"" %> method="post"
              class="glass-panel rounded-xl p-8 md:p-12 shadow-2xl space-y-6">
            
            <div>
                <label for="workoutName" class="block text-white text-lg font-semibold mb-2">Workout Name (Emojis are Highly Recommended 🪿):</label>
                <input type="text" id="workoutName" placeholder="e.g., Long Run 🦢" name="workoutName"
                       class="w-full p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
            </div>

            <div>
                <label for="workoutDescription" class="block text-white text-lg font-semibold mb-2">A short Description of the Workout:</label>
                <textarea id="workoutDescription" placeholder="Describe the workout details, goals, or any special notes." rows="5" name="workoutDescription"
                          class="w-full p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400 resize-y"></textarea>
            </div>

            <div>
                <label for="workoutDate" class="block text-white text-lg font-semibold mb-2">Workout Date:</label>
                <input type="date" id="workoutDate" name="workoutDate"
                       class="w-full p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
            </div>

            <button type="button" onclick="addInterval('interval-container')"
                    class="w-full bg-blue-600 text-white font-semibold px-6 py-3 rounded-full shadow-md hover:bg-blue-700 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-75">
                Add Interval
            </button>
            
            <div id="interval-container" class="space-y-6"></div>

            <input type="number" name="intervalCount" value="0" class="hidden" id="intervalCountInput" />
            
            <button id="submitBtn" style="display:none;" type="submit"
                    class="w-full bg-green-600 text-white font-semibold px-6 py-3 rounded-full shadow-md hover:bg-green-700 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-opacity-75">
                Submit Workout
            </button>
        </form>
    </div>
    <script>        <%=GetWorkoutImportScript()%>

        const today = new Date();
        const formatted = today.toISOString().split("T")[0]; // yyyy-mm-dd
        document.getElementById('workoutDate').value = formatted;

    </script>
</asp:Content>
