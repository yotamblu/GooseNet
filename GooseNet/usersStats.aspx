<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="usersStats.aspx.cs" Inherits="GooseNet.usersStats" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>GooseNet - User Statistics</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-6">
        <h1 class="text-4xl md:text-5xl font-extrabold mb-8 text-center" style="text-shadow: 0 4px 20px rgba(0,0,0,0.2);">
            Admin Dashboard
        </h1>

        <div class="max-w-md mx-auto">
            <!-- User Counter Stat Panel -->
            <div class="glass-panel p-8 rounded-3xl shadow-2xl text-center">
                <div class="mb-4">
                    <svg class="w-12 h-12 mx-auto text-cyan-300" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                </div>
                <h2 class="text-xl font-semibold text-gray-300 mb-2">Total Registered Users</h2>
                <%-- 
                    This is where you would call your backend C# function to get the user count.
                    For example: <span id="user-count" data-target="<%= GetUserCount() %>">0</span>
                    For this design example, a static number is used.
                --%>
                <span id="user-count" data-target="<%=new GooseNet.FirebaseService().GetData<Dictionary<string,GooseNet.User>>("/Users").Count %>" class="text-6xl font-bold text-white block">0</span>
            </div>
        </div>
    </div>

    <script>
        // Simple number counting animation
        document.addEventListener('DOMContentLoaded', () => {
            const counter = document.getElementById('user-count');
            const target = +counter.getAttribute('data-target');
            const duration = 1500; // Animation duration in milliseconds
            const frameDuration = 1000 / 60; // 60fps
            const totalFrames = Math.round(duration / frameDuration);
            let frame = 0;

            const countUp = () => {
                frame++;
                const progress = frame / totalFrames;
                // Ease-out function for a smoother animation
                const easedProgress = 1 - Math.pow(1 - progress, 3); 
                const currentCount = Math.round(target * easedProgress);
                
                counter.innerText = currentCount.toLocaleString();

                if (frame < totalFrames) {
                    requestAnimationFrame(countUp);
                } else {
                    counter.innerText = target.toLocaleString();
                }
            };

            requestAnimationFrame(countUp);
        });
    </script>
</asp:Content>
