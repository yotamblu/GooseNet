<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="GooseNet.HomePage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>GooseNet - Connect, Train, Achieve</title>
    <%-- Custom styles for fade-in animation --%>
    <style>
        .fade-in-up {
            opacity: 0;
            transform: translateY(20px);
            transition: opacity 0.6s ease-out, transform 0.6s ease-out;
        }

        .fade-in-up.visible {
            opacity: 1;
            transform: translateY(0);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <%-- Further reduced pt-16 to pt-12 and pb-10 to pb-8 --%>
    <main class="flex-grow flex items-center pt-12 pb-8">
        <div class="container mx-auto px-6 text-center">
            <div class="max-w-4xl mx-auto">
                <%-- Reduced mb-3 to mb-2 --%>
                <h1 class="text-4xl md:text-6xl lg:text-7xl font-extrabold leading-tight mb-2 text-white" style="text-shadow: 0 4px 20px rgba(0,0,0,0.2);">
                    Connect. Train. Achieve.
                </h1>
                <%-- Reduced mb-6 to mb-4 --%>
                <p class="text-lg md:text-xl max-w-2xl mx-auto mb-4 text-gray-200 fade-in-up">
                    The ultimate platform for runners. Sync your Garmin data, get detailed analytics, and connect with a community of athletes and coaches dedicated to pushing the limits.
                </p>
                <div class="flex justify-center items-center space-x-4 fade-in-up" style="transition-delay: 200ms;">
                    <%if (Session["userName"] == null) { %>
                        <a href="Register.aspx" class="bg-white text-blue-600 font-bold px-8 py-4 rounded-full text-lg hover:bg-opacity-90 transform hover:scale-105 transition-all duration-300 shadow-2xl">
                            Join the Flock
                        </a>
                    <% } else if (Session["role"].ToString() == "athlete") { %>
                        <a href="AthleteWorkouts.aspx?athleteName=<%=Session["userName"].ToString() %>" class="inline-block px-10 py-5 bg-blue-600 text-white font-bold text-xl rounded-full shadow-lg hover:bg-blue-700 transition-colors duration-300 transform hover:scale-105">
                            Go to Your Workouts
                        </a>
                    <% } else { %> <%-- Corrected placement of else block --%>
                        <a href="MyAthletes.aspx" class="bg-white text-blue-600 font-bold px-8 py-4 rounded-full text-lg hover:bg-opacity-90 transform hover:scale-105 transition-all duration-300 shadow-2xl">
                            Go to Your athletes
                        </a>
                    <%} %>
                    <a href="#features" class="bg-white/20 border border-white/30 text-white font-medium px-8 py-4 rounded-full text-lg hover:bg-white/30 transform hover:scale-105 transition-all duration-300">
                        Learn More
                    </a>
                </div>
            </div>
        </div>
    </main>

    <!-- Features Section -->
    <%-- Reduced py-8 to py-6 --%>
    <section id="features" class="py-6">
        <div class="container mx-auto px-6">
            <%-- Reduced mb-8 to mb-6 --%>
            <div class="text-center mb-6 fade-in-up">
                <h2 class="text-4xl font-bold text-white">Your Running, Supercharged</h2>
                <p class="text-lg text-gray-300 mt-2">Everything you need to elevate your performance.</p>
            </div>
            <div class="grid md:grid-cols-3 gap-8">
                <!-- Feature 1: Sync & Analyze -->
                <div class="glass-panel p-8 rounded-3xl shadow-2xl fade-in-up">
                    <div class="bg-cyan-400/20 w-16 h-16 rounded-2xl flex items-center justify-center mb-6">
                        <svg class="w-8 h-8 text-cyan-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                    </div>
                    <h3 class="text-2xl font-bold mb-3 text-white">Sync & Analyze</h3>
                    <p class="text-gray-300">Effortlessly sync your Garmin workouts. Dive deep into your performance with detailed analytics on pace, heart rate, elevation, and more.</p>
                </div>
                <!-- Feature 2: Plan & Share -->
                <div class="glass-panel p-8 rounded-3xl shadow-2xl fade-in-up" style="transition-delay: 200ms;">
                    <div class="bg-blue-400/20 w-16 h-16 rounded-2xl flex items-center justify-center mb-6">
                        <svg class="w-8 h-8 text-blue-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                    </div>
                    <h3 class="text-2xl font-bold mb-3 text-white">Plan & Share</h3>
                    <p class="text-gray-300">Build custom workout plans or get guidance from expert coaches. Share your achievements and workout summaries with your network in a single click.</p>
                </div>
                <!-- Feature 3: Connect & Grow -->
                <div class="glass-panel p-8 rounded-3xl shadow-2xl fade-in-up" style="transition-delay: 400ms;">
                    <div class="bg-purple-400/20 w-16 h-16 rounded-2xl flex items-center justify-center mb-6">
                        <svg class="w-8 h-8 text-purple-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                    </div>
                    <h3 class="text-2xl font-bold mb-3 text-white">Connect & Grow</h3>
                    <p class="text-gray-300">Find training partners, join running groups, and connect with coaches. GooseNet is your community to grow as an athlete.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Final Call to Action Section -->
    <%-- Reduced py-8 to py-6 --%>
    <section class="container mx-auto px-4 py-6 text-center">
        <div class="glass-panel rounded-xl p-8 md:p-12 shadow-2xl fade-in-up">
            <h2 class="text-4xl md:text-5xl font-extrabold text-white mb-6">
                Ready to Elevate Your Running?
            </h2>
            <%-- Reduced mb-10 to mb-6 --%>
            <p class="text-lg md:text-xl text-gray-300 max-w-2xl mx-auto mb-6">
                Join thousands of runners who are already improving their performance and connecting with the GooseNet community.
            </p>
            <%if (Session["userName"] == null) { %>
                <a href="Register.aspx" class="inline-block px-10 py-5 bg-blue-600 text-white font-bold text-xl rounded-full shadow-lg hover:bg-blue-700 transition-colors duration-300 transform hover:scale-105">
                    Start Your Free Journey
                </a>
            <% } else if (Session["role"].ToString() == "athlete") { %>
                <a href="AthleteWorkouts.aspx?athleteName=<%=Session["userName"].ToString() %>" class="inline-block px-10 py-5 bg-blue-600 text-white font-bold text-xl rounded-full shadow-lg hover:bg-blue-700 transition-colors duration-300 transform hover:scale-105">
                    Go to Your Workouts
                </a>
            <% } else { %>
                <a href="MyAthletes.aspx" class="inline-block px-10 py-5 bg-blue-600 text-white font-bold text-xl rounded-full shadow-lg hover:bg-blue-700 transition-colors duration-300 transform hover:scale-105">
                    Go to Your athletes
                </a>
            <%} %>
        </div>
    </section>

    <!-- JavaScript for scroll animations -->
    <script>
        // --- Scroll animations for fade-in effect ---
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                }
            });
        }, {
            threshold: 0.1 // Trigger when 10% of the element is visible
        });

        // Observe all elements with the 'fade-in-up' class
        document.querySelectorAll('.fade-in-up').forEach(el => {
            observer.observe(el);
        });
    </script>
</asp:Content>
