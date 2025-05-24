<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AthleteSummary.aspx.cs" Inherits="GooseNet.AthleteSummary" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        input,label{
            display:inline;
        }
         .summary-container {
             color:black;
      max-width: 800px;
      margin: auto;
    }

    .summary-header {
        color:black;
      background-color: #ffffff;
      padding: 1.5rem 2rem;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      margin-bottom: 2rem;
    }

    .summary-header h2 {
      margin-top: 0;
      font-size: 1.5rem;
      border-bottom: 1px solid #e0e0e0;
      padding-bottom: 0.5rem;
    }

        .summary-grid *,.summary-header * {
         color:black
        }
    .summary-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 0.75rem 2rem;
      font-size: 0.95rem;
    }

    .workouts-section {
      display: flex;
      flex-direction: column;
      gap: 1rem;
    }

    .workout-card {
        color:black;
      background-color: #ffffff;
      border-radius: 12px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      padding: 1rem 1.25rem;
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .workout-card:hover {
      transform: translateY(-4px) scale(1.02);
      box-shadow: 0 8px 16px rgba(0,0,0,0.15);
    }

    .workout-title {
      font-size: 1.15rem;
      font-weight: bold;
      color: #2a2a2a;
    }

    .workout-date {
      font-size: 0.9rem;
      color: #777;
    }

    .workout-details {
      font-size: 1rem;
      color: #444;
    }

    .detail-label {
      color: #888;
      font-weight: 500;
    }

    .placeholder {
     margin-top: 30px;
     padding: 20px;
     background-color: #ffffff;
     border: 2px dashed #bbb;
     border-radius: 10px;
     color: #888;
     font-size: 18px;
     transition: all 0.3s ease;
     box-shadow: 0 4px 10px rgba(0,0,0,0.05);
   }
    </style>

    <title>Training Summary - <%=Request.QueryString["athleteName"] %></title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <label for="startDate">Summary Start Date:</label>
    <label for="startDate" style="margin-left:150px">Summary End Date:</label><br />
    <input id="startDate" type="date"/>
    <input id="endDate" type="date"/><br /><br />
    <button id="getDataBtn">Get Summary</button>
    <div style="margin-top:2vh" id="container">
                <div id="placeholder" class="placeholder">📅 Data will appear here once you pick a date.</div>

    </div>
    <script>
        const container = document.getElementById('container');
        const startDateInput = document.getElementById('startDate');
        const endDateInput = document.getElementById('endDate');
        const getDateBtn = document.getElementById('getDataBtn');

        getDateBtn.addEventListener('click', () => {
            const summaryRequest = new XMLHttpRequest();

            summaryRequest.onload = () => {
                container.innerHTML = summaryRequest.responseText;
            };

            const reqUrl = "GetTrainingSummaryByDate.aspx?athleteName=<%=Request.QueryString["athleteName"]%>&startDate=" + startDateInput.value + "&endDate=" + endDateInput.value;
            summaryRequest.open("GET", reqUrl,false)
            summaryRequest.send();
        });
        
    </script>
</asp:Content>
