<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="PlannedStrengthWorkout.aspx.cs" Inherits="GooseNet.PlannedStrengthWorkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Planned Strength Workout</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* Shared Design Styles */
        body {
            font-family: 'Inter', sans-serif;
        }

        .glass-panel {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1), 0 1px 3px rgba(0, 0, 0, 0.08);
        }
        
    

        /* Custom style for the submit button */
        .submit-button {
            transition: all 0.3s ease;
        }

        .submit-button:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(59, 130, 246, 0.5);
        }

        /* Style for the range slider */
        input[type=range] {
            width: 100%;
            -webkit-appearance: none;
            height: 8px;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 4px;
            margin-top: 8px;
                        <%=Session["role"].ToString() == "coach" ? "pointer-events:none;" : ""%>

        }

        input[type=range]::-webkit-slider-thumb {
            -webkit-appearance: none;
            width: 20px;
            height: 20px;
            background: #3b82f6;
            border-radius: 50%;
            cursor: pointer;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.3);
        }

        input[type=range]:disabled::-webkit-slider-thumb {
            background: #60a5fa; /* Lighter shade when disabled */
            cursor: not-allowed;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Full Screen Fixed Background -->
    <div class="fixed top-0 left-0 w-full h-full page-background -z-10"></div>

    <!-- Main Content Container - Centered Flexbox -->
    <div class="min-h-[90vh] flex flex-col items-center p-6 text-white overflow-y-auto pt-10 pb-10">

        <!-- Matches the reference page's structure and max-width -->
        <div class="container mx-auto px-6 max-w-4xl">
            <h1 class="text-3xl md:text-4xl font-extrabold mb-8 text-center drop-shadow-lg" style="text-shadow: 0 4px 20px rgba(0,0,0,0.2);">
                Planned Strength Workout
            </h1>

            <!-- Workout Details Section -->
            <div class="glass-panel p-6 md:p-8 rounded-3xl shadow-2xl mb-8">
                <h2 class="text-2xl font-bold mb-4 text-cyan-200">Workout Details</h2>
                
                <!-- Detail Grid -->
                <div class="space-y-4">
                    <!-- Workout Name -->
                    <div>
                        <p class="text-sm font-medium text-white/70">Workout Name</p>
                        <p class="text-xl font-semibold"><%=GetWorkoutName() %></p>
                    </div>

                    <!-- Coach Name -->
                    <div>
                        <p class="text-sm font-medium text-white/70">Assigned By</p>
                        <p class="text-xl font-semibold"><%=GetCoachName() %></p>
                    </div>

                    <!-- Workout Description -->
                    <div>
                        <p class="text-sm font-medium text-white/70 mb-1">Description</p>
                        <div class="bg-white/10 p-3 rounded-lg border border-white/20 text-white/90">
                            <!-- Placeholder method for description content -->
                            <p class="text-base"><%=GetWorkoutDescription() %></p>
                        </div>
                    </div>
                    
                    <!-- Placeholder for actual strength workout steps (e.g., sets, reps, exercises) -->
                    <div class="pt-4">
                        <p style="text-align:center" class="text-lg font-bold text-white/80">Workout Structure </p>
                        <ul class="list-disc list-inside text-white/70 ml-4 space-y-1">
                            <%=GetWorkoutStructure() %>
                        </ul>
                    </div>
                </div>
            </div>

    <div class="glass-panel p-4 md:p-6 rounded-3xl shadow-2xl space-y-4">
    
    <!-- B: Title Panel - Separated into its own liquid glass rectangle -->
    <div class="glass-panel p-4 rounded-xl border border-white/30 shadow-lg"> 
        <h2 class="text-2xl font-bold text-purple-200 m-0">Athlete Review & Submission</h2>
    </div>
        <%GetReviews(); %>
    </div>
</div>
        </div>
    </div>

    <!-- Client-Side Locking Logic -->
    <script>
        let locked = false;
        <%=hasSubmitted  ? "InitialLock();" : ""%>
        function lockTextarea() {
            const textArea = document.getElementById("athleteReview");
            const slider = document.getElementById("difficulty");
            const btn = document.getElementById("submitBtn");

            textArea.setAttribute("disabled", "true");
            slider.setAttribute("disabled", "true");
            btn.textContent = "Edit Submission";
            btn.classList.add('bg-gray-600', 'hover:bg-gray-700');
            btn.classList.remove('bg-blue-600', 'hover:bg-blue-700');
        }

        function unlockTextarea() {
            const textArea = document.getElementById("athleteReview");
            const slider = document.getElementById("difficulty");
            const btn = document.getElementById("submitBtn");

            textArea.removeAttribute("disabled");
            slider.removeAttribute("disabled");
            btn.textContent = "Submit Workout";
            btn.classList.add('bg-blue-600', 'hover:bg-blue-700');
            btn.classList.remove('bg-gray-600', 'hover:bg-gray-700');
        }

        function submitForm() {
            const reviewText = document.getElementById("athleteReview").value;
            const difficulty = document.getElementById("difficulty").value;


            const apiKey = '<%=GooseNet.GooseNetUtils.GetApiKey(Session["userName"].ToString()) %>';
const workoutId = new URLSearchParams(window.location.search).get('workoutId');


const url = `https://gooseapi.ddns.net/api/strength/reviews?apiKey=${apiKey}&workoutId=${workoutId}`;


const body = {
              AthleteName: '<%= Session["userName"].ToString() %>',
              reviewContent: reviewText,
              difficultyLevel: difficulty
          };


          fetch(url, {
              method: "POST",
              headers: {
                  "Content-Type": "application/json"
              },
              body: JSON.stringify(body)
          })
              .then(res => {
                  if (!res.ok) throw new Error("Submission failed");
                  showToast("Workout submitted successfully!");
              })
              .catch(err => {
                  showToast("Error submitting workout: " + err.message);
                  toggleLock();
              });
      }

        function toggleLock() {
            if (!locked) {
                // 1. Submit the form data (simulated)
                submitForm();
                // 2. Lock the fields
                lockTextarea();
                locked = true;
                
                // Use a non-blocking message box for feedback
            } else {
                // Unlock the fields for editing
                unlockTextarea();
                locked = false;
                showToast("Editing mode enabled.");
            }
        }

        function InitialLock() {
            lockTextarea();
            locked = true;
        }
        
        function showToast(message) {
             // Reusing the toast concept from the previous file for non-blocking feedback
            const toast = document.createElement('div');
            toast.className = 'fixed bottom-10 left-1/2 transform -translate-x-1/2 bg-white text-blue-900 px-6 py-3 rounded-full shadow-2xl font-bold z-50 transition-all duration-500 opacity-0 translate-y-10';
            toast.innerText = message;
            document.body.appendChild(toast);
            
            // Animate in
            setTimeout(() => {
                toast.classList.remove('opacity-0', 'translate-y-10');
            }, 10);

            // Animate out
            setTimeout(() => {
                toast.classList.add('opacity-0', 'translate-y-10');
                setTimeout(() => toast.remove(), 500);
            }, 3000);
        }

        // Initialize state on load
        window.onload = function() {
            // Check if data is already submitted (if you were using server-side logic)
            // If submitted, call lockTextarea() here.
        };
    </script>
</asp:Content>