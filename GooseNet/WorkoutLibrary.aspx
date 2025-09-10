<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="WorkoutLibrary.aspx.cs" Inherits="GooseNet.WorkoutLibrary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>GooseNet - Workout Library</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-6">
        <h1 class="text-4xl md:text-5xl font-extrabold mb-4 text-center" style="text-shadow: 0 4px 20px rgba(0,0,0,0.2);">
            Workout Library
        </h1>
        <p class="text-lg text-gray-300 text-center mb-8">Choose the workout you want to assign from the library.</p>

        <!-- Mode Switcher -->
        <div class="flex justify-center mb-6">
            <div class="glass-panel p-1 rounded-full flex items-center space-x-2">
                <button id="feedBtn" class="px-6 py-2 rounded-full text-lg font-semibold transition-colors duration-300 bg-white text-gray-900">Feed</button>
                <button id="searchBtn" class="px-6 py-2 rounded-full text-lg font-semibold transition-colors duration-300 text-white">Search</button>
            </div>
        </div>

        <!-- Search Bar (Initially Hidden) -->
        <div id="searchContainer" class="hidden max-w-2xl mx-auto mb-8">
            <div class="relative">
                <input id="searchBar" type="text" placeholder="Search by workout name..." class="w-full pl-5 pr-12 py-4 rounded-full bg-white/10 border-2 border-transparent focus:border-white/30 focus:bg-white/5 focus:outline-none text-white text-lg transition-all duration-300" />
                <div class="absolute inset-y-0 right-0 flex items-center pr-5">
                    <button id="searchBarBtn">
                    <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                </button>
               </div>
            </div>
        </div>

        <!-- Main Content Area -->
        <div id="workoutsContainer">
            <!-- Search Placeholder (Initially Hidden) -->
            <div id="searchPlaceholder" class="hidden text-center glass-panel p-12 rounded-3xl max-w-2xl mx-auto">
                <div class="flex justify-center mb-4">
                    <div class="bg-blue-400/20 w-16 h-16 rounded-2xl flex items-center justify-center">
                         <svg class="w-8 h-8 text-blue-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                    </div>
                </div>
                <h3 class="text-2xl font-bold text-white">Find a Workout</h3>
                <p id="searchPlaceholderText" class="text-gray-300 mt-2">Type the workout name you're looking for above.</p>
            </div>

            <!-- Workout Feed (Initially Visible) -->
            
      <div id="workoutFeed" class="grid grid-cols-1 gap-6">
    <!-- workouts here -->
</div>
      <div id="searchWorkoutFeed" class="grid grid-cols-1 gap-6"></div>

<!-- Loader always stays below the feed -->
<div id="loader" class="hidden text-center py-6">
    <div class="spinner"></div>
</div>

<!-- Sentinel goes after the loader -->
<div id="sentinel"></div>

        </div>
    </div>

    <script>
        
        const feedBtn = document.getElementById('feedBtn');
        const searchBtn = document.getElementById('searchBtn');
        const searchContainer = document.getElementById('searchContainer');
        const searchBar = document.getElementById('searchBar');
        const searchPlaceholder = document.getElementById('searchPlaceholder');
        const searchPlaceholderText = document.getElementById('searchPlaceholderText');
        const workoutFeed = document.getElementById('workoutFeed');
        const workoutContainer = document.getElementById('workoutsContainer');
        const searchBarBtn = document.getElementById('searchBarBtn');
        const searchWorkoutFeed = document.getElementById('searchWorkoutFeed');
        searchBarBtn.addEventListener("click", () => {
            if (mode === "search" && searchBar.value != "") {
                searchForWorkout();
            }
        });
        let coachName = "<%=Session["userName"].ToString()%>";
        let mode = "feed";
        const loader = document.getElementById("loader");
        let isLoading = false;
        
        
        let currentIndex = 0;
        
        showFeedMode();
        const sentinel = document.getElementById("sentinel");
        const observer = new IntersectionObserver(entries => {
            if (entries[0].isIntersecting && mode == "feed") {
                console.log("Reached end of workout container!");
                fillFeedData();
            }
        }, { root: null });
        observer.observe(sentinel);
        function showFeedMode() {
            if (isLoading) return;

            mode = "feed";
            searchWorkoutFeed.classList.add('hidden');
            workoutFeed.classList.add('hidden');
            fillFeedData();

            feedBtn.classList.add('bg-white', 'text-gray-900');
            feedBtn.classList.remove('text-white');

            searchBtn.classList.remove('bg-white', 'text-gray-900');
            searchBtn.classList.add('text-white');

            searchContainer.classList.add('hidden');
            searchPlaceholder.classList.add('hidden');
            workoutFeed.classList.remove('hidden');
        }

        function searchForWorkout() {
            if (isLoading) return;
            isLoading = true;
            searchWorkoutFeed.classList.add('hidden');
            searchPlaceholder.classList.add('hidden');
            loader.classList.remove("hidden");

            const request = new XMLHttpRequest();
            request.onload = () => {
                if (request.responseText.trim().length > 0) {
                    searchWorkoutFeed.innerHTML = request.responseText;
                    searchWorkoutFeed.classList.remove('hidden');


                } else {
                        searchPlaceholder.classList.remove('hidden');

                    
                    searchPlaceholder.innerHTML = "There are no workouts fitting to your search."
                }
                loader.classList.add("hidden");
                isLoading = false;
            };

            request.open("GET", "SearchForPlannedWorkout.aspx?coachName=" + coachName + "&q=" + searchBar.value + '<%=GetTargetParam()%>');
            request.send();
        }

        function fillFeedData() {
            if (isLoading) return;
            isLoading = true;
            loader.classList.remove("hidden");

            const request = new XMLHttpRequest();
            request.onload = () => {
                if (request.responseText.trim().length > 0) {
                    workoutFeed.innerHTML += request.responseText;
                }
                loader.classList.add("hidden");
                isLoading = false;
            };

            request.open("GET", "GetPlannedWorkoutsForFeed.aspx?coachName=" + coachName + "&index=" + currentIndex + '<%=GetTargetParam()%>');
            request.send();
            currentIndex++;
        }

        function showSearchMode() {
            if (isLoading) return;

            mode = "search";
            searchWorkoutFeed.classList.remove('hidden');
            searchBtn.classList.add('bg-white', 'text-gray-900');
            searchBtn.classList.remove('text-white');

            feedBtn.classList.remove('bg-white', 'text-gray-900');
            feedBtn.classList.add('text-white');

            searchContainer.classList.remove('hidden');
            workoutFeed.classList.add('hidden');
            if (searchWorkoutFeed.innerHTML == "") {
                searchPlaceholder.classList.remove('hidden');

            }
        }

        feedBtn.addEventListener('click', showFeedMode);
        searchBtn.addEventListener('click', showSearchMode);
    </script>
</asp:Content>

