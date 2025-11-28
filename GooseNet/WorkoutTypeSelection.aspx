<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="WorkoutTypeSelection.aspx.cs" Inherits="GooseNet.WorkoutTypeSelection" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Add Workout</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* Simplified Liquid Glass Design Styles */
        body {
            font-family: 'Inter', sans-serif;
        }

        /* Simplified glass panel styling based on reference */
        .glass-panel {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
      
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Full Screen Fixed Background -->
    <!-- Removed animated gradient for simpler look, using fixed blend of the original colors -->
    <div class="fixed top-0 left-0 w-full h-full page-background -z-10"></div>

    <!-- Main Content Container - Centered Flexbox -->
    <div class="min-h-[85vh] flex flex-col items-center justify-center p-6 text-white">

        <!-- Matches the reference page's structure and max-width -->
        <div class="container mx-auto px-6">
            <h1 class="text-4xl md:text-5xl font-extrabold mb-8 text-center drop-shadow-lg" style="text-shadow: 0 4px 20px rgba(0,0,0,0.2);">
                Add Workout
            </h1>

            <div class="max-w-2xl mx-auto">
                <!-- Selection Panel -->
                <div class="glass-panel p-6 md:p-8 rounded-3xl shadow-2xl">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        
                        <!-- Option 1: Running Workout (Now an <a> tag) -->
                        <!-- NOTE: Update the 'href' attribute to the correct destination URL (e.g., RunningWorkout.aspx) -->
                        <a href="AddComplexWorkout<%=(Request.QueryString["flockName"] != null ? "ToFlock" : "")%>.aspx<%=GetTargetParam() %>" 
                            class="flex flex-col items-center justify-center p-6 rounded-2xl hover:bg-white/10 transition-all duration-300 text-center group cursor-pointer border border-transparent hover:border-white/30">
                            
                            <!-- Icon Holder - Cyan Theme -->
                            <div class="bg-cyan-400/20 w-16 h-16 rounded-full flex items-center justify-center mb-4 transform group-hover:scale-110 transition-transform shadow-lg">
                                <svg class="w-8 h-8 text-cyan-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                                </svg>
                            </div>
                            
                            <!-- Text Content -->
                            <span class="text-xl font-semibold text-white">Running Workout</span>
                            <p class="text-sm text-gray-300 mt-1">Track miles, pace, and route.</p>
                        </a>

                        <!-- Option 2: Strength Workout (Now an <a> tag) -->
                        <!-- NOTE: Update the 'href' attribute to the correct destination URL (e.g., StrengthWorkout.aspx) -->
                        <a href="AddStrengthWorkout.aspx<%=GetTargetParam() %>" 
                            class="flex flex-col items-center justify-center p-6 rounded-2xl hover:bg-white/10 transition-all duration-300 text-center group cursor-pointer border border-transparent hover:border-white/30">
                            
                            <!-- Icon Holder - Purple/Indigo Theme -->
                            <div class="bg-purple-400/20 w-16 h-16 rounded-full flex items-center justify-center mb-4 transform group-hover:scale-110 transition-transform shadow-lg">
                                <svg class="w-8 h-8 text-purple-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16m-7 6h7"></path>
                                </svg>
                            </div>
                            
                            <!-- Text Content -->
                            <span class="text-xl font-semibold text-white">Strength Workout</span>
                            <p class="text-sm text-gray-300 mt-1">Log reps, sets, and weight.</p>
                        </a>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>