<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AthleteSummary.aspx.cs" Inherits="GooseNet.AthleteSummary" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%-- Removed inline style block. All styles are now handled by Tailwind classes. --%>
    <title>Training Summary - <%=Request.QueryString["athleteName"] %></title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mx-auto px-4 py-8 max-w-4xl">
        <h1 class="text-4xl font-extrabold text-white mb-8 text-center">Training Summary for <%=Request.QueryString["athleteName"] %></h1>

        <div class="glass-panel rounded-xl p-6 md:p-8 mb-8 shadow-lg">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 items-end">
                <div>
                    <label for="startDate" class="block text-white text-lg font-semibold mb-2">Summary Start Date:</label>
                    <input id="startDate" type="date"
                           class="w-full p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
                </div>
                <div>
                    <label for="endDate" class="block text-white text-lg font-semibold mb-2">Summary End Date:</label>
                    <input id="endDate" type="date"
                           class="w-full p-3 rounded-lg bg-white bg-opacity-10 border border-white border-opacity-20 text-white focus:outline-none focus:ring-2 focus:ring-blue-400">
                </div>
            </div>
            <button id="getDataBtn"
                    class="mt-6 w-full bg-blue-600 text-white font-semibold px-6 py-3 rounded-full shadow-md hover:bg-blue-700 transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-75">
                Get Summary
            </button>
        </div>

        <div id="container">
            <div id="placeholder" class="glass-panel rounded-xl p-8 text-center text-gray-300 font-semibold text-xl border-2 border-dashed border-white/30 shadow-inner">
                📅 Data will appear here once you pick a date.
            </div>
        </div>
    </div>

    <script>
        const container = document.getElementById('container');
        const startDateInput = document.getElementById('startDate');
        const endDateInput = document.getElementById('endDate');
        const getDateBtn = document.getElementById('getDataBtn');

        getDateBtn.addEventListener('click', () => {
            const summaryRequest = new XMLHttpRequest();

            // Show a loading state
            container.innerHTML = `
                <div class="glass-panel rounded-xl p-8 text-center text-gray-300 font-semibold text-xl shadow-lg">
                    Loading summary data...
                </div>
            `;

            summaryRequest.onload = () => {
                container.innerHTML = summaryRequest.responseText;
            };

            summaryRequest.onerror = () => {
                container.innerHTML = `
                    <div class="glass-panel rounded-xl p-8 text-center text-red-400 font-semibold text-xl shadow-lg">
                        Error loading data. Please try again.
                    </div>
                `;
            };

            const reqUrl = "GetTrainingSummaryByDate.aspx?athleteName=<%=Request.QueryString["athleteName"]%>&startDate=" + startDateInput.value + "&endDate=" + endDateInput.value;
            summaryRequest.open("GET", reqUrl, true); // Changed to asynchronous for better UX
            summaryRequest.send();
        });

        // Set default dates to a reasonable range (e.g., last 30 days)
        document.addEventListener('DOMContentLoaded', () => {
            const today = new Date();
            const endDate = today.toISOString().split('T')[0];

            const thirtyDaysAgo = new Date(today);
            thirtyDaysAgo.setDate(today.getDate() - 30);
            const startDate = thirtyDaysAgo.toISOString().split('T')[0];

            startDateInput.value = startDate;
            endDateInput.value = endDate;

            
        });
    </script>
</asp:Content>
